%% Homework 9-10: hybrid force/motion control on an elastically compliant
% inclined plane (Siciliano et al., Problem 9.10, Example 9.4 geometry).
%
% Arm: course §8.7 two-link data (m = 5 kg per link; the English original
% uses 50 kg — see homework07 parameter note). Environment: plane through
% (1,0) at pi/4 to x0, normal stiffness ky = 5e3 N/m (true), controller
% uses the estimate k_hat = 4e3 N/m -> Lf = 1.25 (Solution Manual value).
%
% Control: operational-space inverse dynamics inner loop (9.76) + hybrid
% decomposition (9.77) + velocity PI with feedforward (9.80) + force PD on
% estimated force rate (9.84), lambda_d = -50 N. Controller Ts = 1 ms (ZOH),
% plant integrated with RK4 over each sample.
%
% Outputs: figures (tools/figures + src/assets/ch08/hw08), metrics printout.

clear; close all; clc;
thisDir = fileparts(mfilename('fullpath'));
outDir  = fullfile(thisDir, '..', 'figures');
if ~exist(outDir, 'dir'); mkdir(outDir); end
assetDir = fullfile(thisDir, '..', '..', 'src', 'assets', 'ch08', 'hw08');
if ~exist(assetDir, 'dir'); mkdir(assetDir); end

%% ---- arm parameters (course §8.7) ----
p.a1 = 1;     p.a2 = 1;
p.l1 = 0.5;   p.l2 = 0.5;
p.m1 = 5;     p.m2 = 5;     p.mL = 0;    % no tip load in Problem 9.10
p.mm1 = 5;    p.mm2 = 5;
p.I1 = 10;    p.I2 = 10;
p.Im1 = 0.01; p.Im2 = 0.01;
p.kr1 = 100;  p.kr2 = 100;
p.Fm1 = 0.01; p.Fm2 = 0.01;
p.g = 9.81;

%% ---- environment / constraint frame ----
c45 = cos(pi/4); s45 = sin(pi/4);
Rc = [c45, -s45; s45, c45];      % columns: xc (on plane), yc (normal)
xc = Rc(:,1); yc = Rc(:,2);
ky    = 5e3;                      % N/m, true stiffness
k_hat = 4e3;                      % N/m, controller estimate -> Lf = 1.25
plane_pt = [1; 0];                % undeformed plane passes here
yc0 = dot(plane_pt, yc);          % rest position of plane along yc (= -1/sqrt2)

%% ---- task (Problem 9.3 path) ----
pi_ = [1; 0];
pf  = [1.2 + 0.1*sqrt(2); 0.2];
tf = 1.0; tc = tf/3;
lambda_d = -50;                   % N, press along yc
Ts = 1e-3; Tsim = 2.5;
t = 0:Ts:Tsim; N = numel(t);

%% ---- gains (Solution Manual) ----
Kp_nu = 16;  Ki_nu = 100;         % velocity loop (wn = 10 rad/s, zeta = 0.8)
Kd_l  = 16;  Kp_l  = 100;         % force loop; with Lf = 1.25:
Lf = ky / k_hat;                  % = 1.25 -> wn_l = sqrt(125) = 11.18, zeta = 0.715

%% ---- initial configuration: oe(0) = (1,0) exactly on the plane ----
c2 = (pi_'*pi_) ;                 % |p|^2 = 1
c2 = (pi_(1)^2 + pi_(2)^2 - p.a1^2 - p.a2^2) / (2*p.a1*p.a2);   % = -0.5
q2_0 = 2*pi/3;
q1_0 = atan2(pi_(2), pi_(1)) - atan2(p.a2*sin(q2_0), p.a1 + p.a2*cos(q2_0));
x = [q1_0; q2_0; 0; 0];

%% ---- discrete simulation ----
nu_err_log = zeros(1, N); lam_log = zeros(1, N); o_log = zeros(2, N);
int_v = 0;

for k = 1:N
    q = x(1:2); dq = x(3:4);
    J  = [ -p.a1*sin(q(1)) - p.a2*sin(q(1)+q(2)), -p.a2*sin(q(1)+q(2));
            p.a1*cos(q(1)) + p.a2*cos(q(1)+q(2)),  p.a2*cos(q(1)+q(2)) ];
    dJ = [ -p.a1*cos(q(1))*dq(1) - p.a2*cos(q(1)+q(2))*(dq(1)+dq(2)), ...
           -p.a2*cos(q(1)+q(2))*(dq(1)+dq(2));
           -p.a1*sin(q(1))*dq(1) - p.a2*sin(q(1)+q(2))*(dq(1)+dq(2)), ...
           -p.a2*sin(q(1)+q(2))*(dq(1)+dq(2)) ];
    o  = [p.a1*cos(q(1)) + p.a2*cos(q(1)+q(2));
          p.a1*sin(q(1)) + p.a2*sin(q(1)+q(2))];
    v  = J*dq;

    % environment force on the arm (unilateral, normal direction only)
    delta = dot(o, yc) - yc0;
    if delta >= 0
        he_on_arm = [0; 0];
        lam = 0;
    else
        he_on_arm = -ky*delta*yc;   % pushes back along +yc
        lam = ky*delta;             % arm-on-environment yc component (<0)
    end

    % desired task
    [pd, dpd, ddpd] = traj_tip(t(k), pi_, pf, tf, tc);
    nu_d  = dot(xc, dpd);
    nu_dd = dot(xc, ddpd);
    nu    = dot(xc, v);

    % (9.84): force loop, estimated force rate from k_hat * normal velocity
    lam_dot_hat = k_hat * dot(yc, v);
    f_l = -Kd_l*lam_dot_hat + Kp_l*(lambda_d - lam);

    % (9.80): velocity loop with feedforward
    a_nu = nu_dd + Kp_nu*(nu_d - nu) + Ki_nu*int_v;

    % (9.77): alpha = xc*a_nu + yc*(1/k_hat)*f_l
    alpha = xc*a_nu + yc*(1/k_hat)*f_l;
    int_v = int_v + (nu_d - nu)*Ts;

    nu_err_log(k) = nu_d - nu;
    lam_log(k)    = lam;
    o_log(:,k)    = o;

    if k < N
        % RK4 plant step with constant alpha (1 ms ZOH)
        f = @(xx) plant_ode(xx, alpha, p, yc, ky, yc0);
        k1 = f(x);
        k2 = f(x + 0.5*Ts*k1);
        k3 = f(x + 0.5*Ts*k2);
        k4 = f(x + Ts*k3);
        x = x + (Ts/6)*(k1 + 2*k2 + 2*k3 + k4);
    end
end

%% ---- metrics ----
tail = t > Tsim - 0.2;
f_ss  = mean(lam_log(tail));
f_dev = max(abs(lam_log(tail) - lambda_d));
nu_ss = max(abs(nu_err_log(tail)));
motion = t > 0.15 & t < 1.0;
fprintf('=== Hybrid force/motion (9-10) ===\n');
fprintf('steady-state lambda = %.3f N (dev %.4f N)\n', f_ss, f_dev);
fprintf('steady-state |nu_err| = %.2e m/s\n', nu_ss);
fprintf('penetration = %.5f m (lambda/ky = %.5f m)\n', ...
    dot(o_log(:,end), yc) - yc0, lambda_d/ky);
fprintf('motion window max|nu_err| = %.3e m/s (rms %.3e)\n', ...
    max(abs(nu_err_log(motion))), sqrt(mean(nu_err_log(motion).^2)));
fprintf('force overshoot = %.2f N at t = %.3f s\n', ...
    min(lam_log), t(lam_log == min(lam_log)));

%% ---- figures ----
set(0, 'DefaultAxesFontSize', 12, 'DefaultFigureColor', 'w', ...
    'DefaultAxesXColor', 'k', 'DefaultAxesYColor', 'k', ...
    'DefaultTextColor', 'k', 'DefaultAxesGridColor', [0.85 0.85 0.85]);

figure('Color','w','Position',[100 100 900 340]);
subplot(1,2,1);
plot(t, nu_err_log, 'b-', 'LineWidth', 1.0); grid on;
xlabel('t / s'); ylabel('\nu_d - \nu / m·s^{-1}');
title('切向速度误差');
subplot(1,2,2);
plot(t, lam_log, 'b-', 'LineWidth', 1.0); hold on;
yline(lambda_d, 'r--', '\lambda_d', 'LineWidth', 1); grid on;
xlabel('t / s'); ylabel('\lambda / N'); title('法向接触力');
exportgraphics(gcf, fullfile(outDir, 'fig1_hybrid_response.png'), 'Resolution', 150);

figure('Color','w','Position',[100 100 430 400]);
plot(o_log(1,:), o_log(2,:), 'b-', 'LineWidth', 1.2); hold on; grid on;
xs = linspace(0.95, 1.45, 10);
plot(xs, xs - 1, 'k--', 'LineWidth', 1);       % undeformed plane
plot(pi_(1), pi_(2), 'ko', 'MarkerFaceColor', 'k');
plot(pf(1), pf(2), 'k^', 'MarkerFaceColor', 'k');
axis equal; xlabel('x_0 / m'); ylabel('y_0 / m');
legend('末端实际路径', '未变形平面', 'Location', 'northwest');
title('末端路径与平面');
exportgraphics(gcf, fullfile(outDir, 'fig2_path_plane.png'), 'Resolution', 150);

copyfile(fullfile(outDir, 'fig1_hybrid_response.png'), assetDir);
copyfile(fullfile(outDir, 'fig2_path_plane.png'), assetDir);
save(fullfile(thisDir, 'results.mat'), 't', 'nu_err_log', 'lam_log', 'o_log');
fprintf('Saved figures to %s and %s\n', outDir, assetDir);

function dx = plant_ode(x, alpha, p, yc, ky, yc0)
% Joint dynamics + unilateral elastic plane, written back through
% B qdd = tau - n - J' he  (he = force the arm exerts on the environment).
q = x(1:2); dq = x(3:4);
a1 = p.a1; a2 = p.a2;
J  = [ -a1*sin(q(1)) - a2*sin(q(1)+q(2)), -a2*sin(q(1)+q(2));
        a1*cos(q(1)) + a2*cos(q(1)+q(2)),  a2*cos(q(1)+q(2)) ];
dJ = [ -a1*cos(q(1))*dq(1) - a2*cos(q(1)+q(2))*(dq(1)+dq(2)), ...
       -a2*cos(q(1)+q(2))*(dq(1)+dq(2));
       -a1*sin(q(1))*dq(1) - a2*sin(q(1)+q(2))*(dq(1)+dq(2)), ...
       -a2*sin(q(1)+q(2))*(dq(1)+dq(2)) ];
o  = [a1*cos(q(1)) + a2*cos(q(1)+q(2));
      a1*sin(q(1)) + a2*sin(q(1)+q(2))];

delta = dot(o, yc) - yc0;
if delta >= 0
    he = [0; 0];
else
    he = -ky*delta*yc;   % environment pushes back along +yc
end

[B, C, F, g] = plant_dyn(q, dq, p);
n = C*dq + F*dq + g;
Ji = inv(J);
Be = Ji'*B*Ji;
ne = Ji'*n - Be*(dJ*dq);
gamma_e = Be*alpha + ne + he;
tau = J'*gamma_e;
ddq = B \ (tau - n - J'*he);
dx = [dq; ddq];
end
