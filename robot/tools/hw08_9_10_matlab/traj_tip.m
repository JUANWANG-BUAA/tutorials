function [pd, dpd, ddpd] = traj_tip(t, pi_, pf, tf, tc)
% Task-space rectilinear path of Problem 9.3 with trapezoidal velocity
% profile: p(t) = pi + s(t)*(pf - pi), s: 0 -> 1 over [0, tf].

delta = pf - pi_;
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

pd = pi_ + s * delta;
dpd = ds * delta;
ddpd = dds * delta;
end
