%% Egg plot tests

% defining parameter struct
egg_params = struct();
egg_params.a = 4;
egg_params.b = 3;
egg_params.c = 0.125;

% initial position and orientation
x0 = 5;
y0 = 5;
theta = pi/2;

s_perimeter = linspace(0, 1, 1000);

[V_vals, G_vals] = egg_func(s_perimeter, x0, y0, theta, egg_params);

s_tangent = 0.3;

[V_tangent, G_tangent] = egg_func(s_tangent, x0, y0, theta, egg_params);

figure();
hold on
plot(V_vals(1,:), V_vals(2,:), 'k-', 'MarkerSize', 2);
plot(V_tangent(1), V_tangent(2), 'r.', 'MarkerSize', 10);
quiver(V_tangent(1), V_tangent(2), G_tangent(1), G_tangent(2), 1/norm(G_tangent));
axis equal;
hold off;



%% Bounding box test

%set the oval hyper-parameters
egg_params = struct();
egg_params.a = 0.04;
egg_params.b = 0.03;
egg_params.c = 12.5;

%specify the position and orientation of the egg
x0 = 5; y0 = 5; theta = pi/3;

s_perimeter = linspace(0, 1, 1000);

[V_vals, G_vals] = egg_func(s_perimeter, x0, y0, theta, egg_params);

[x_min, x_max, y_min, y_max] = compute_bounding_box(x0, y0, theta, egg_params);

figure();
hold on
plot(x0, y0, 'r.', 'MarkerSize', 20);
plot(V_vals(1,:), V_vals(2,:), 'k-', 'MarkerSize', 2);
plot([x_min, x_max, x_max, x_min, x_min], [y_min, y_min, y_max, y_max, y_min], 'r-', 'MarkerSize', 10);
axis equal;
hold off;

% Testing collision time calculations
[t_ground, t_wall] = collision_func(@egg_trajectory, egg_params, 0, 10);

disp(['Time the egg would hit the ground: ', num2str(t_ground)]);
disp(['Time the egg would hit the wall: ', num2str(t_wall)]);

%% Animated egg trajectory with termination on collision

% egg hyperparameters
egg_params = struct();
egg_params.a = 0.4;
egg_params.b = 0.3;
egg_params.c = 1.25;

% ground and wall positions
y_ground = 0;
x_wall = 15;

% compute collision times
[t_ground, t_wall] = collision_func(@egg_trajectory, egg_params, y_ground, x_wall);

% choose the earliest valid collision time
t_end = min([t_ground, t_wall]);

% prepare perimeter sampling
s_perimeter = linspace(0, 1, 200);

% figure setup
fig = figure('Color', 'w');
axis equal;
hold on;
grid on;
xlabel('x'); ylabel('y');
title('Tumbling Egg Trajectory');

% draw static ground and wall
xlim([0, 20]);
ylim([0, 15]);
plot([0, 15], [y_ground, y_ground], 'r-', 'LineWidth', 1.5); % ground
plot([x_wall, x_wall], [0, 15], 'b-', 'LineWidth', 1.5);    % wall

% initialize animated objects
traj_line = plot(NaN, NaN, 'g--'); % trajectory trace
egg_patch = plot(NaN, NaN, 'k-', 'LineWidth', 2); % egg outline

% trajectory storage for drawing trace
X_traj = [];
Y_traj = [];

% Video recording setup 
video_filename = 'tumbling_egg.mp4';
v = VideoWriter(video_filename, 'MPEG-4');
v.FrameRate = 1/0.02; % match simulation dt for real-time
open(v);

% animation loop
dt = 0.001; % frame step
for t = linspace(0, t_end, floor(t_end*60))
    % get egg trajectory state
    [x0, y0, theta] = egg_trajectory(t);

    % compute egg shape at current time
    [V_vals, ~] = egg_func(s_perimeter, x0, y0, theta, egg_params);

    % update trajectory history
    X_traj(end+1) = x0;
    Y_traj(end+1) = y0;

    % update plot
    set(traj_line, 'XData', X_traj, 'YData', Y_traj);
    set(egg_patch, 'XData', V_vals(1,:), 'YData', V_vals(2,:));
    drawnow;

    % record current frame
    frame = getframe(fig);
    writeVideo(v, frame);

    % pacing for real-time playback
    pause(1/60);
end

close(v);
disp('Animation finished: egg collided with ground or wall.');
