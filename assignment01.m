%% Definition of the test function and its derivative
test_func01 = @(x) (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2+6) -.7 - exp(x/6);
test_derivative01 = @(x) 3*(x.^2)/100 - 2*x/8 + 2 +(6/2)*cos(x/2+6) - exp(x/6)/6;

%% Bisection Method Demonstration

x = linspace(-15, 30, 1000);

% plotting numerical root finding results from bisection method
figure();
plot(x, test_func01(x));
hold on;
plot(x, zeros(size(x)), '--');

bisection_root = bisection_solver(test_func01, -25, 25, 10e-14, 1000);

plot(bisection_root, test_func01(bisection_root), '.', MarkerSize=20);
legend('Function', 'Y=0', 'Root Approx.');

hold off;
%% Newton's Method Demonstration

x = linspace(-15, 30, 1000);

% plotting numerical root finding results from bisection method
figure();
plot(x, test_func01(x));
hold on;
plot(x, zeros(size(x)), '--');

newton_root = newton_solver_jojo(@test_function, 10, 10e-14, 1000);

plot(newton_root, test_func01(newton_root), '.', MarkerSize=20);
legend('Function', 'Y=0', 'Root Approx.');

hold off;

%% Secant Method Demonstration

x = linspace(-15, 30, 1000);

% plotting numerical root finding results from bisection method
figure();
plot(x, test_func01(x));
hold on;
plot(x, zeros(size(x)), '--');

secant_root = secant_solver_jojo(test_func01, 0, 5, 10e-14, 1000);

plot(secant_root, test_func01(secant_root), '.', MarkerSize=20);
legend('Function', 'Y=0', 'Root Approx.');

hold off;