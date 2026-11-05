function [B, C, F, g] = plant_dyn(q, dq, p)
% Two-link planar arm dynamics (Siciliano §7.3.2 / course 6.3.2)
% with tip payload mL and motor friction referred to joint side.
% Gravity: y upward, g0 = [0; -g; 0].

th1 = q(1); th2 = q(2);
dth1 = dq(1); dth2 = dq(2);
c1 = cos(th1); c12 = cos(th1 + th2); c2 = cos(th2); s2 = sin(th2);

a1 = p.a1; a2 = p.a2;
l1 = p.l1; l2 = p.l2;
m1 = p.m1; m2 = p.m2; mL = p.mL;
mm2 = p.mm2;
I1 = p.I1; I2 = p.I2;
Im1 = p.Im1; Im2 = p.Im2;
kr1 = p.kr1; kr2 = p.kr2;
Fm1 = p.Fm1; Fm2 = p.Fm2;
gg = p.g;

% Inertia (links + motors + tip mass)
b11 = I1 + m1*l1^2 + kr1^2*Im1 ...
    + I2 + m2*(a1^2 + l2^2 + 2*a1*l2*c2) + Im2 + mm2*a1^2 ...
    + mL*(a1^2 + a2^2 + 2*a1*a2*c2);
b12 = I2 + m2*(l2^2 + a1*l2*c2) + kr2*Im2 ...
    + mL*(a2^2 + a1*a2*c2);
b22 = I2 + m2*l2^2 + kr2^2*Im2 + mL*a2^2;
B = [b11, b12; b12, b22];

% Christoffel / Coriolis
h = -m2*a1*l2*s2 - mL*a1*a2*s2;
C = [h*dth2, h*(dth1 + dth2); -h*dth1, 0];

% Viscous friction (motor-side Fm referred by kr^2)
F = diag([Fm1*kr1^2, Fm2*kr2^2]);

% Gravity
g1 = (m1*l1 + mm2*a1 + m2*a1 + mL*a1)*gg*c1 ...
   + (m2*l2 + mL*a2)*gg*c12;
g2 = (m2*l2 + mL*a2)*gg*c12;
g = [g1; g2];
end
