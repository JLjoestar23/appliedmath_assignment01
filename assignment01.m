%% Definition of the test function and its derivative
test_func01 = @(x) (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2+6) -.7 - exp(x/6);
test_derivative01 = @(x) 3*(x.^2)/100 - 2*x/8 + 2 +(6/2)*cos(x/2+6) - exp(x/6)/6;

%% Bisection Method Demonstration

x = linspace(-15, 30, 1000);

% plotting numerical root finding results from bisection method
figure();
hold on;
plot(x, test_func01(x));
plot(x, zeros(size(x)), '--');

bisection_root = bisection_solver(@test_function, -25, 25, 10e-14, 1000);

plot(bisection_root, test_func01(bisection_root), '.', MarkerSize=20);
legend('Function', 'Y=0', 'Root Approx.');

hold off;
%% Newton's Method Demonstration

x = linspace(-15, 30, 1000);

% plotting numerical root finding results from bisection method
figure();
hold on;
plot(x, test_func01(x));
plot(x, zeros(size(x)), '--');

newton_root = newton_solver_jojo(@test_function, 10, 10e-14, 1000);

plot(newton_root, test_func01(newton_root), '.', MarkerSize=20);
legend('Function', 'Y=0', 'Root Approx.');

hold off;

%% Secant Method Demonstration

x = linspace(-15, 30, 1000);

% plotting numerical root finding results from bisection method
figure();
hold on;
plot(x, test_func01(x));
plot(x, zeros(size(x)), '--');

secant_root = secant_solver_jojo(@test_function, 5, 10, 10e-14, 1000);

plot(secant_root, test_func01(secant_root), '.', MarkerSize=20);
legend('Function', 'Y=0', 'Root Approx.');

hold off;

%% Testing convergence for Bisection method
% declare input_list as a global variable
global input_list;

% number of trials we would like to perform
num_iter = 100;

% list for the initial guesses that we would like to use each trial. These 
% guesses have all been chosen so that each trial will converge to the 
% same root because the root is somewhere between -3 and 3.
x0_list = linspace(-3, 3, num_iter);

%list of estimate at current iteration (x_{n}) compiled across all trials
x_current_list = [];

% list of estimate at next iteration (x_{n+1}) compiled across all trials
x_next_list = [];

%keeps track of which iteration (n) in a trial each data point was 
% collected from
index_list = [];

%loop through each trial
for n = 1:num_iter
    % pull out the left and right guess for the trial
    x0 = x0_list(n);
    x1 = -x0;
    % clear the input_list global variable
    input_list = [];
    % run the newton solver
    x_r = bisection_solver(@convergence_test_func, x0, x1, 10e-14, 1000);
    % at this point, input_list will be populated with the values that the 
    % solver called at each iteration. In other words, it is now 
    % [x_1,x_2,...x_n-1,x_n] append the collected data to the compilation
    x_current_list = [x_current_list,input_list(1:end-1)];
    x_next_list = [x_next_list,input_list(2:end)];
    index_list = [index_list,1:length(input_list)-1];
end

% computing error based on guesses and highly accurate root
error_current = abs(x_current_list - x_r);
error_next = abs(x_next_list - x_r);

figure('Color', 'w');
loglog(error_current, error_next, 'r.', 'markerfacecolor', 'r', 'markersize', 4);
hold on;
title('Convergence Analysis for Bisection Method', 'FontSize', 14);
xlabel('\epsilon_{n}', 'FontSize', 18);
ylabel('\epsilon_{n+1}', 'FontSize', 18);
xlim([10e-16, 10e1]);
ylim([10e-19, 10e1])
grid on;
hold off;


%% Testing convergence for Newton's method
% declare input_list as a global variable
global input_list;

% number of trials we would like to perform
num_iter = 1000;

% list for the initial guesses that we would like to use each trial. These 
% guesses have all been chosen so that each trial will converge to the 
% same root because the root is somewhere between -3 and 3.
x0_list = linspace(-3,3,num_iter);

%list of estimate at current iteration (x_{n}) compiled across all trials
x_current_list = [];

% list of estimate at next iteration (x_{n+1}) compiled across all trials
x_next_list = [];

%keeps track of which iteration (n) in a trial each data point was 
% collected from
index_list = [];

%loop through each trial
for n = 1:num_iter
    % pull out the left and right guess for the trial
    x0 = x0_list(n);
    % clear the input_list global variable
    input_list = [];
    % run the newton solver
    x_r = newton_solver_jojo(@convergence_test_func, x0, 10e-14, 1000);
    % at this point, input_list will be populated with the values that the 
    % solver called at each iteration. In other words, it is now 
    % [x_1,x_2,...x_n-1,x_n] append the collected data to the compilation
    x_current_list = [x_current_list,input_list(1:end-1)];
    x_next_list = [x_next_list,input_list(2:end)];
    index_list = [index_list,1:length(input_list)-1];
end

% computing error based on guesses and highly accurate root
error_current = abs(x_current_list - x_r);
error_next = abs(x_next_list - x_r);

figure('Color', 'w');
loglog(error_current, error_next, 'r.', 'markerfacecolor', 'r', 'markersize', 4);
hold on;
title('Convergence Analysis for Newton''s Method', 'FontSize', 14);
xlabel('\epsilon_{n}', 'FontSize', 18);
ylabel('\epsilon_{n+1}', 'FontSize', 18);
xlim([10e-16, 10e1]);
ylim([10e-19, 10e1])
grid on;
hold off;

%% Testing convergence for Secant method (does not work)
% declare input_list as a global variable
global input_list;

% number of trials we would like to perform
num_iter = 1000;

% list for the initial guesses that we would like to use each trial. These 
% guesses have all been chosen so that each trial will converge to the 
% same root because the root is somewhere between -3 and 3.
x0_list = linspace(-3, 3, num_iter);

%list of estimate at current iteration (x_{n}) compiled across all trials
x_current_list = [];

% list of estimate at next iteration (x_{n+1}) compiled across all trials
x_next_list = [];

%keeps track of which iteration (n) in a trial each data point was 
% collected from
index_list = [];

%loop through each trial
for n = 1:num_iter
    % pull out the left and right guess for the trial
    x0 = x0_list(n);
    % clear the input_list global variable
    input_list = [];
    % run the newton solver
    x_r = secant_solver_jojo(@convergence_test_func, x0, x0 + 0.1, 10e-14, 1000);
    % at this point, input_list will be populated with the values that the 
    % solver called at each iteration. In other words, it is now 
    % [x_1,x_2,...x_n-1,x_n] append the collected data to the compilation
    x_current_list = [x_current_list,input_list(1:end-1)];
    x_next_list = [x_next_list,input_list(2:end)];
    index_list = [index_list,1:length(input_list)-1];
end

% computing error based on guesses and highly accurate root
error_current = abs(x_current_list - x_r);
error_next = abs(x_next_list - x_r);

figure('Color', 'w');
loglog(error_current, error_next, 'r.', 'markerfacecolor', 'r', 'markersize', 4);
hold on;
title('Convergence Analysis for Secant Method', 'FontSize', 14);
xlabel('\epsilon_{n}', 'FontSize', 18);
ylabel('\epsilon_{n+1}', 'FontSize', 18);
xlim([10e-16, 10e1]);
ylim([10e-19, 10e1])
grid on;
hold off;

%% Testing convergence for fzero

% declare input_list as a global variable
global input_list;

% number of trials we would like to perform
num_iter = 1000;

% list for the initial guesses that we would like to use each trial. These 
% guesses have all been chosen so that each trial will converge to the 
% same root because the root is somewhere between -3 and 3.
x0_list = linspace(-3,3,num_iter);

%list of estimate at current iteration (x_{n}) compiled across all trials
x_current_list = [];

% list of estimate at next iteration (x_{n+1}) compiled across all trials
x_next_list = [];

%keeps track of which iteration (n) in a trial each data point was 
% collected from
index_list = [];

%loop through each trial
for n = 1:num_iter
    % pull out the left and right guess for the trial
    x0 = x0_list(n);
    % clear the input_list global variable
    input_list = [];
    % run the newton solver
    x_r = fzero(@convergence_test_func, x0);
    % at this point, input_list will be populated with the values that the 
    % solver called at each iteration. In other words, it is now 
    % [x_1,x_2,...x_n-1,x_n] append the collected data to the compilation
    x_current_list = [x_current_list,input_list(1:end-1)];
    x_next_list = [x_next_list,input_list(2:end)];
    index_list = [index_list,1:length(input_list)-1];
end

% computing error based on guesses and highly accurate root
error_current = abs(x_current_list - x_r);
error_next = abs(x_next_list - x_r);

figure('Color', 'w');
loglog(error_current, error_next, 'r.', 'markerfacecolor', 'r', 'markersize', 4);
hold on;
title('Convergence Analysis for fsolve', 'FontSize', 14);
xlabel('\epsilon_{n}', 'FontSize', 18);
ylabel('\epsilon_{n+1}', 'FontSize', 18);
xlim([10e-18, 10e1]);
ylim([10e-19, 10e1])
grid on;
hold off;