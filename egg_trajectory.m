% Example parabolic trajectory
function [x0, y0, theta] = egg_trajectory(t)
    % uses basic kinematic equations to model trajectory
    x0 = 6.5*t;
    y0 = -0.5*9.81*t.^2 + 10*t + 5;
    theta = 10*t;
end