%% Definition of test function 01 and its derivative
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

%% Testing convergence for Bisection method (unsure if works)
% declare input_list as a global variable
global input_list;

% number of trials we would like to perform
num_iter = 100;

%list of estimate at current iteration (x_{n}) compiled across all trials
x_current_list = [];

% list of estimate at next iteration (x_{n+1}) compiled across all trials
x_next_list = [];

%keeps track of which iteration (n) in a trial each data point was 
% collected from
index_list = [];

% calculate root to base initial guesses off of
x_r_calc = bisection_solver(@convergence_test_func, -3, 3, 10e-14, 1000);

%loop through each trial
for n = 1:num_iter
    % pull out the left and right guess for the trial
    x0 = x_r_calc - 3*rand();
    x1 = x_r_calc + 3*rand();

    % clear the input_list global variable
    input_list = [];

    % run the newton solver
    [x_r, return_list] = bisection_convergence_test(@convergence_test_func, x0, x1, 10e-14, 1000);
    % at this point, input_list will be populated with the values that the 
    % solver called at each iteration. In other words, it is now 
    % [x_1,x_2,...x_n-1,x_n] append the collected data to the compilation
    x_current_list = [x_current_list,return_list(1:end-1)];
    x_next_list = [x_next_list,return_list(2:end)];
    %index_list = [index_list,1:length(input_list)-1];
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

%% Testing convergence for Secant method
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
xlim([10e-18, 10e1]);
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

%% Data processing for Newton's method

% data points to be used in the regression
x_regression = []; % e_n
y_regression = []; % e_{n+1}

% iterate through the collected data
for n=1:length(index_list)
    % if the error is not too big or too small and it was enough iterations
    % into the trial...
    if error_current(n)>1e-15 && error_current(n)<1e-2 && error_next(n)>1e-14 && error_next(n)<1e-2 && index_list(n)>2
        % then add it to the set of points for regression
        x_regression(end+1) = error_current(n);
        y_regression(end+1) = error_next(n);
    end
end

% data points to be used in the regression
% p and k are the output coefficients
% generate Y, X1, and X2
% note that I use the transpose operator (')
% to convert the result from a row vector to a column
% If you are copy-pasting, the ' character may not work correctly
Y = log(y_regression)';
X1 = log(x_regression)';
X2 = ones(length(X1),1);
%run the regression
coeff_vec = regress(Y,[X1,X2]);
%pull out the coefficients from the fit
p = coeff_vec(1);
k = exp(coeff_vec(2));

% generate x data on a logarithmic range
fit_line_x = 10.^(-16:0.1:1);
% compute the corresponding y values
fit_line_y = k*fit_line_x.^p;

% visualize processed data
figure('Color', 'w');
loglog(error_current, error_next, 'r.', 'markerfacecolor', 'r', 'markersize', 4);
hold on;
loglog(x_regression, y_regression, 'g.', 'markerfacecolor', 'g', 'markersize', 4);
title('Convergence Analysis for Newton''s Method', 'FontSize', 14);
xlabel('\epsilon_{n}', 'FontSize', 18);
ylabel('\epsilon_{n+1}', 'FontSize', 18);
xlim([10e-16, 10e1]);
ylim([10e-19, 10e1])
grid on;
loglog(fit_line_x,fit_line_y, 'k--', 'LineWidth', 2);
legend('Raw', 'Processed', 'Fitted line');
hold off;

%% Compare regression k value to predicted k value

% for the first and second derivative of a function

%set the step size to be tiny
delta_x = 1e-6;

% compute the function at different points near x
f_left = test_func01(x_r - delta_x);
f_0 = test_func01(x_r);
f_right = test_func01(x_r + delta_x);

% approximate the first derivative
dfdx = (f_right - f_left) / (2*delta_x);

% approximate the second derivative
d2fdx2 = (f_right - 2*f_0 + f_left) / (delta_x^2);

% calculate predicted k value
k_pred = abs(0.5*(d2fdx2/dfdx));


%% Testing generalized convergence analysis function for Bisection method

% initialize L and R bounds
x_guess_list_0 = zeros(1000, 1);
x_guess_list_1 = zeros(1000, 1);

% solve for a very good root approx to base L and R bounds off of
x_r_calc = bisection_solver(@convergence_test_func_2, 0, 50, 10e-14, 1000);

% assign random values that are shifted away from the root for the test
for i = 1:1000
    x_guess_list_0(i) = x_r_calc - 3*rand();
    x_guess_list_1(i) = x_r_calc + 3*rand();
end

convergence_analysis("bisection", @convergence_test_func_2, [], x_guess_list_0, x_guess_list_1);

%% Testing generalized convergence analysis function for Newton's method

% initialize list of intial guesses
x0_list = ones(1000, 1);

% assign random values from 0-3
for i = 1:1000
    x0_list(i) = 3*rand();
end

convergence_analysis("newton", @convergence_test_func_2, x0_list, [], []);

%% Testing generalized convergence analysis function for Secant method

% initialize list of intial guesses
x0_list = ones(1000, 1);

% assign random values from 0-3
for i = 1:1000
    x0_list(i) = 3*rand();
end

convergence_analysis("secant", @convergence_test_func_2, x0_list, [], []);

%% Testing generalized convergence analysis function for fzero

% initialize list of intial guesses
x0_list = ones(1000, 1);

% assign random values from 0-3
for i = 1:1000
    x0_list(i) = 3*rand();
end

convergence_analysis("fzero", @convergence_test_func_2, x0_list, [], []);

%% Testing edge cases where f'(x_root) = 0

% initialize list of intial guesses
x0_list = ones(1000, 1);

% assign random values from 0-3
for i = 1:1000
    x0_list(i) = 3*rand();
end

convergence_analysis("newton", @edge_case_function, x0_list, [], []);
convergence_analysis("secant", @edge_case_function, x0_list, [], []);

%% Testing sigmoid function with Newton's method

% initialize root test range
x_test_range = linspace(0, 50, 500);

% sort initial guesses into success or fail depending on convergence
success_list = [];
fail_list = [];

% find good root approx based on close initial guess
x_r = newton_solver_jojo(@sigmoid_test_function, 25, 10e-14, 1000);

% start testing initial guesses
for i=1:length(x_test_range)
    current_guess = x_test_range(i);
    root_approx = newton_solver_jojo(@sigmoid_test_function, current_guess, 10e-14, 1000);
    if isnan(root_approx)
        fail_list(end+1) = current_guess;
    else
        success_list(end+1) = current_guess;
    end
end

% initial guesses close to x_r are successful
figure('Color', 'w');
hold on;
plot(x_test_range, sigmoid_test_function(x_test_range));
plot(x_test_range, zeros(1, length(x_test_range)), '--');
plot(success_list, sigmoid_test_function(success_list), 'g.');
plot(fail_list, sigmoid_test_function(fail_list), 'r.');
plot(x_r, sigmoid_test_function(x_r), 'b.', 'MarkerSize', 15);
legend('', '', 'Successful x0', 'Failed x0', 'Zero');
title('Initial Guess Testing with Newton''s Method on a Shifted Sigmoid Function');
grid on;
hold off;

%% Testing sigmoid function with secant method

% initialize root test range
x_test_range = linspace(0, 50, 500);

% sort initial guesses into success or fail depending on convergence
success_list_x0 = [];
success_list_x1 = [];
fail_list_x0 = [];
fail_list_x1 = [];

% find good root approx based on close initial guess
x_r = secant_solver_jojo(@sigmoid_test_function, 25, 0.0001, 10e-14, 1000);

% start testing initial guesses
for i=1:length(x_test_range)
    for j=1:length(x_test_range)
        current_guess_0 = x_test_range(i);
        current_guess_1 = x_test_range(j);
        root_approx = secant_solver_jojo(@sigmoid_test_function, current_guess_0, current_guess_1, 10e-14, 1000);
        if isnan(root_approx)
            fail_list_x0(end+1) = current_guess_0;
            fail_list_x1(end+1) = current_guess_1;
        else
            success_list_x0(end+1) = current_guess_0;
            success_list_x1(end+1) = current_guess_1;
        end
    end
end

% most initial guesses failed
figure('Color', 'w');
hold on;
plot(success_list_x0, success_list_x1, 'g.');
plot(fail_list_x0, fail_list_x1, 'r.');
title('Initial Guess Testing with Secant Method on a Shifted Sigmoid Function');
xlabel('x0');
ylabel('x1')
grid on;
hold off;

%% Testing sigmoid function with fzero

% initialize root test range
x_test_range = linspace(0, 50, 500);

% sort initial guesses into success or fail depending on convergence
success_list = [];
fail_list = [];

% find good root approx based on close initial guess
x_r = fzero(@sigmoid_test_function, 25);

% start testing initial guesses
for i=1:length(x_test_range)
    current_guess = x_test_range(i);
    root_approx = fzero(@sigmoid_test_function, current_guess);
    if isnan(root_approx)
        fail_list(end+1) = current_guess;
    else
        success_list(end+1) = current_guess;
    end
end

% all initial guesses were successful
figure('Color', 'w');
hold on;
plot(x_test_range, sigmoid_test_function(x_test_range));
plot(x_test_range, zeros(1, length(x_test_range)), '--');
plot(success_list, sigmoid_test_function(success_list), 'g.');
plot(fail_list, sigmoid_test_function(fail_list), 'r.');
plot(x_r, sigmoid_test_function(x_r), 'b.', 'MarkerSize', 15);
legend('', '', 'Successful x0', 'Failed x0', 'Zero');
title('Testing fzero on a Shifted Sigmoid Function');
grid on;
hold off;

%% Testing sigmoid function with bisection method

% initialize root test range
x_test_range = linspace(0, 50, 200);

% sort initial guesses into success or fail depending on convergence
success_list_x0 = [];
success_list_x1 = [];
fail_list_x0 = [];
fail_list_x1 = [];

% find good root approx based on close initial guess
x_r = bisection_solver(@sigmoid_test_function, 25, 40, 10e-14, 1000);

% start testing initial guesses
for i=1:length(x_test_range)
    for j=1:length(x_test_range)
        current_guess_0 = x_test_range(i);
        current_guess_1 = x_test_range(j);
        root_approx = bisection_solver(@sigmoid_test_function, current_guess_0, current_guess_1, 10e-14, 1000);
        if isnan(root_approx)
            fail_list_x0(end+1) = current_guess_0;
            fail_list_x1(end+1) = current_guess_1;
        else
            success_list_x0(end+1) = current_guess_0;
            success_list_x1(end+1) = current_guess_1;
        end
    end
end

% most initial guesses failed
figure('Color', 'w');
hold on;
plot(success_list_x0, success_list_x1, 'g.');
plot(fail_list_x0, fail_list_x1, 'r.');
title('Initial Guess Testing with Bisection Method on a Shifted Sigmoid Function');
xlabel('x0');
ylabel('x1')
grid on;
hold off;