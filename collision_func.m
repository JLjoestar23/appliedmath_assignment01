%Function that computes the collision time for a thrown egg
% INPUTS:
% traj_fun: a function that describes the [x,y,theta] trajectory
% of the egg (takes time t as input)
% egg_params: a struct describing the hyperparameters of the oval
% y_ground: height of the ground
% x_wall: position of the wall
%
% OUTPUTS:
% t_ground: time that the egg would hit the ground
% t_wall: time that the egg would hit the wall
function [t_ground, t_wall] = collision_func(traj_fun, egg_params, y_ground, x_wall)
    
    wall_detect   = @(t) compute_x_max(traj_fun, t, egg_params) - x_wall;
    ground_detect = @(t) compute_y_min(traj_fun, t, egg_params) - y_ground;
    
    t_wall = secant_solver(wall_detect, x_wall, x_wall + 0.01, 10e-14, 100);
    t_ground = secant_solver(ground_detect, x_wall, x_wall + 0.01, 10e-14, 100);
end

function x_max = compute_x_max(traj_fun, t, egg_params)
    [x0, y0, theta] = traj_fun(t);
    [~, x_max, ~, ~] = compute_bounding_box(x0, y0, theta, egg_params);
end

function y_min = compute_y_min(traj_fun, t, egg_params)
    [x0, y0, theta] = traj_fun(t);
    [~, ~, y_min, ~] = compute_bounding_box(x0, y0, theta, egg_params);
end
