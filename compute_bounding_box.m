% Function that computes the bounding box of an oval
% INPUTS:
% theta: rotation of the oval. theta is a number from 0 to 1.
% x0: horizontal offset of the oval
% y0: vertical offset of the oval
% egg_params: a struct describing the hyperparameters of the oval
%
% OUTPUTS:
% x_min, x_max: the x limits of the bounding box
% y_min, y_max: the y limits of the bounding box
function [x_min, x_max, y_min, y_max] = compute_bounding_box(x0, y0, theta, egg_params)
    
    % initialize guess list 
    guess_list = linspace(0, 1, 6);
    
    % initialize lists to hold all root guesses
    root_x = [];
    root_y = [];
    
    % define anonymous wrapper functions
    x_wrap = @(s) egg_wrapper_x(s, x0, y0, theta, egg_params);
    y_wrap = @(s) egg_wrapper_y(s, x0, y0, theta, egg_params);
    
    % iterate through guess list
    for i=1:length(guess_list)
        guess = guess_list(i);
        s_root_x = secant_solver(x_wrap, guess, guess+0.001, 10e-14, 100);
        s_root_y = secant_solver(y_wrap, guess, guess+0.001, 10e-14, 100);
        [V_root_x, ~] = egg_func(s_root_x, x0, y0, theta, egg_params);
        [V_root_y, ~] = egg_func(s_root_y, x0, y0, theta, egg_params);
        root_x(end+1) = V_root_x(1);
        root_y(end+1) = V_root_y(2);
    end

    x_min = min(root_x);
    x_max = max(root_x);
    y_min = min(root_y);
    y_max = max(root_y);
end

% wrapper function that calls egg_func and only returns the x component of
% the tangent line to the egg's surface
% utilizes dummy output as secant_solver_jojo expects 2 outputs
function x_out = egg_wrapper_x(s, x0, y0, theta, egg_params)
    [~, G] = egg_func(s, x0, y0, theta, egg_params);
    x_out = G(1);
end

% wrapper function that calls egg_func and only returns the y component of
% the tangent line to the egg's surface
% utilizes dummy output as secant_solver_jojo expects 2 outputs
function y_out = egg_wrapper_y(s, x0, y0, theta, egg_params)
    [~, G] = egg_func(s, x0, y0, theta, egg_params);
    y_out = G(2);
end