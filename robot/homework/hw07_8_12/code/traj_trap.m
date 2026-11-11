function [qd, dqd, ddqd] = traj_trap(t, qi, qf, tf, tc)
% Joint-space rectilinear path with scalar trapezoidal velocity profile.
% q(t) = qi + s(t)*(qf - qi), s: 0->1 over [0, tf], accel time tc.

delta = qf - qi;
if t <= 0
    s = 0; ds = 0; dds = 0;
elseif t >= tf
    s = 1; ds = 0; dds = 0;
else
    vmax = 1 / (tf - tc);
    a = vmax / tc;
    if t < tc
        dds = a; ds = a * t; s = 0.5 * a * t^2;
    elseif t <= tf - tc
        dds = 0; ds = vmax; s = 0.5 * a * tc^2 + vmax * (t - tc);
    else
        tau = t - (tf - tc);
        dds = -a; ds = vmax - a * tau;
        s = 1 - 0.5 * a * (tf - t)^2;
    end
end

qd = qi + s * delta;
dqd = ds * delta;
ddqd = dds * delta;
end
