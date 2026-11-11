%% Homework 8-12: Inverse dynamics joint control (two-link planar arm)
% Textbook: Siciliano et al., Problem 8.12 (via 8.11 / Sect. 8.7 data)
% Discrete-time Ts = 1 ms. Gains match course §8.7 scheme G: wn=5, zeta=0.5.
%
% Outputs:
%   figures/*.png  — tracking / error / torque
%   results.mat    — logged time series + metrics

clear; close all; clc;
thisDir = fileparts(mfilename('fullpath'));
outDir  = fullfile(thisDir, '..', 'figures');
if ~exist(outDir, 'dir'); mkdir(outDir); end

%% ---- parameters (course slide §8.7; tip payload from Problem 8.11) ----
p.a1 = 1;     p.a2 = 1;
p.l1 = 0.5;   p.l2 = 0.5;
p.m1 = 5;     p.m2 = 5;     p.mL = 10;   % kg; concentrated tip mass
p.mm1 = 5;    p.mm2 = 5;
p.I1 = 10;    p.I2 = 10;                % kg·m^2 about CoM
p.Im1 = 0.01; p.Im2 = 0.01;
p.kr1 = 100;  p.kr2 = 100;
p.Fm1 = 0.01; p.Fm2 = 0.01;             % N·m·s/rad (motor side)
p.g = 9.81;

wn = 5; zeta = 0.5;                     % after feedback linearization, J=I
Kp = (wn^2) * eye(2);                   % = 25 I
Kd = (2*zeta*wn) * eye(2);              % = 5 I

%% ---- trajectory (Problem 8.11) ----
qi = [0; pi/4];
qf = [pi/2; pi/2];
tf = 1.0;
tc = tf/3;                              % accel / cruise / decel thirds
Ts = 1e-3;
Tsim = tf + 0.5;                        % settle a bit after arrival
t = 0:Ts:Tsim;
N = numel(t);

qd = zeros(2, N); dqd = zeros(2, N); ddqd = zeros(2, N);
for k = 1:N
    [qd(:,k), dqd(:,k), ddqd(:,k)] = traj_trap(t(k), qi, qf, tf, tc);
end

%% ---- discrete simulation (ZOH + RK4 over each sample) ----
x = [qi; zeros(2,1)];                   % start on desired posture, rest
q_log  = zeros(2, N);
dq_log = zeros(2, N);
u_log  = zeros(2, N);
e_log  = zeros(2, N);

for k = 1:N
    q  = x(1:2);
    dq = x(3:4);
    e  = qd(:,k) - q;
    de = dqd(:,k) - dq;

    [B, C, F, g] = plant_dyn(q, dq, p);
    % Inverse dynamics (7.3-9): u = B(ydd) + C dq + F dq + g
    y = ddqd(:,k) + Kd*de + Kp*e;
    u = B*y + C*dq + F*dq + g;

    q_log(:,k)  = q;
    dq_log(:,k) = dq;
    u_log(:,k)  = u;
    e_log(:,k)  = e;

    if k < N
        % RK4 plant step with constant u (1 ms ZOH)
        f = @(xx) plant_ode(xx, u, p);
        k1 = f(x);
        k2 = f(x + 0.5*Ts*k1);
        k3 = f(x + 0.5*Ts*k2);
        k4 = f(x + Ts*k3);
        x = x + (Ts/6)*(k1 + 2*k2 + 2*k3 + k4);
    end
end

%% ---- metrics ----
emax = max(abs(e_log), [], 2);
erms = sqrt(mean(e_log.^2, 2));
umax = max(abs(u_log), [], 2);
fprintf('=== Inverse dynamics (8-12) ===\n');
fprintf('max |e1|=%.3e rad, |e2|=%.3e rad\n', emax(1), emax(2));
fprintf('rms  e1=%.3e rad,  e2=%.3e rad\n', erms(1), erms(2));
fprintf('max |u1|=%.1f N·m, |u2|=%.1f N·m\n', umax(1), umax(2));

%% ---- figures (force light theme for submission) ----
set(0, 'DefaultAxesFontSize', 12, 'DefaultFigureColor', 'w', ...
    'DefaultAxesColor', 'w', 'DefaultAxesXColor', 'k', 'DefaultAxesYColor', 'k', ...
    'DefaultTextColor', 'k', 'DefaultAxesGridColor', [0.85 0.85 0.85]);

figure('Color','w','Position',[100 100 720 420]);
subplot(2,1,1);
plot(t, qd(1,:), 'k--', t, q_log(1,:), 'b-', 'LineWidth', 1.2); grid on;
ylabel('q_1 / rad'); legend('q_{d1}','q_1','Location','best');
title('Joint tracking (inverse dynamics)');
subplot(2,1,2);
plot(t, qd(2,:), 'k--', t, q_log(2,:), 'r-', 'LineWidth', 1.2); grid on;
ylabel('q_2 / rad'); xlabel('t / s'); legend('q_{d2}','q_2','Location','best');
exportgraphics(gcf, fullfile(outDir, 'fig1_tracking.png'), 'Resolution', 150);

figure('Color','w','Position',[100 100 720 360]);
plot(t, e_log(1,:), 'b-', t, e_log(2,:), 'r-', 'LineWidth', 1.2); grid on;
xlabel('t / s'); ylabel('e / rad');
legend('e_1','e_2','Location','best');
title(sprintf('Tracking error (max |e|=[%.2e, %.2e] rad)', emax(1), emax(2)));
exportgraphics(gcf, fullfile(outDir, 'fig2_error.png'), 'Resolution', 150);

figure('Color','w','Position',[100 100 720 360]);
plot(t, u_log(1,:), 'b-', t, u_log(2,:), 'r-', 'LineWidth', 1.0); grid on;
xlabel('t / s'); ylabel('\tau / N·m');
legend('\tau_1','\tau_2','Location','best');
title('Joint control torque');
exportgraphics(gcf, fullfile(outDir, 'fig3_torque.png'), 'Resolution', 150);

% Desired trajectory profiles
figure('Color','w','Position',[100 100 720 520]);
subplot(3,1,1); plot(t, qd', 'LineWidth', 1.2); grid on;
ylabel('q_d / rad'); legend('q_{d1}','q_{d2}'); title('Reference (trapezoidal velocity)');
subplot(3,1,2); plot(t, dqd', 'LineWidth', 1.2); grid on;
ylabel('dq_d / rad/s'); legend('dq_{d1}','dq_{d2}');
subplot(3,1,3); plot(t, ddqd', 'LineWidth', 1.2); grid on;
ylabel('ddq_d / rad/s^2'); xlabel('t / s'); legend('ddq_{d1}','ddq_{d2}');
exportgraphics(gcf, fullfile(outDir, 'fig0_reference.png'), 'Resolution', 150);

save(fullfile(thisDir, '..', 'results.mat'), ...
    't','qd','q_log','e_log','u_log','emax','erms','umax','p','Kp','Kd','Ts','tf','tc');
fprintf('Saved figures to %s\n', outDir);

function dx = plant_ode(x, u, p)
q = x(1:2); dq = x(3:4);
[B, C, F, g] = plant_dyn(q, dq, p);
ddq = B \ (u - C*dq - F*dq - g);
dx = [dq; ddq];
end
