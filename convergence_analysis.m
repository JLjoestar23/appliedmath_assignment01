function convergence_analysis(solver_flag, fun, x0_list, x_guess_list_0, x_guess_list_1)
    
   % declare input_list as a global variable
    global input_list;
    
    % number of trials we would like to perform
    num_iter = 1000;
    
    %list of estimate at current iteration (x_{n}) compiled across all trials
    x_current_list = [];
    
    % list of estimate at next iteration (x_{n+1}) compiled across all trials
    x_next_list = [];
    
    %keeps track of which iteration (n) in a trial each data point was 
    % collected from
    index_list = [];

    if solver_flag == "bisection"
        %loop through each trial
        for n = 1:num_iter
            % pull out the left and right guess for the trial
            x0 = x_guess_list_0(n);
            x1 = x_guess_list_1(n);
        
            % clear the input_list global variable
            input_list = [];
        
            % run the newton solver
            [x_r, return_list] = bisection_convergence_test(fun, x0, x1, 10e-14, 1000);

            % at this point, input_list will be populated with the values that the 
            % solver called at each iteration. In other words, it is now 
            % [x_1,x_2,...x_n-1,x_n] append the collected data to the compilation
            x_current_list = [x_current_list,return_list(1:end-1)];
            x_next_list = [x_next_list,return_list(2:end)];
            index_list = [index_list,1:length(return_list)-1];
        end

        % computing error based on guesses and highly accurate root
        error_current = abs(x_current_list - x_r);
        error_next = abs(x_next_list - x_r);

        % filter the data
        [x_regression, y_regression] = filter_data(error_current, error_next, index_list);

        % generate p and k values from linear regression
        [p, k] = generate_error_fit(x_regression, y_regression);
        
        % generate x data on a logarithmic range
        fit_line_x = 10.^(-16:0.1:1);
        % compute the corresponding y values
        fit_line_y = k*fit_line_x.^p;

        % calculate predicted k and p values
        k_pred = 0.5;
        p_pred = 1;

        disp1 = strcat("estimated p = ", num2str(p));
        disp2 = strcat("predicted p = ", num2str(p_pred));
        disp3 = strcat("estimated k = ", num2str(k));
        disp4 = strcat("predicted k = ", num2str(k_pred));
        disp(disp1);
        disp(disp2);
        disp(disp3);
        disp(disp4);
        
        % visualize processed data
        figure('Color', 'w');
        loglog(error_current, error_next, 'r.', 'markerfacecolor', 'r', 'markersize', 4);
        hold on;
        loglog(x_regression, y_regression, 'g.', 'markerfacecolor', 'g', 'markersize', 4);
        title('Convergence Analysis for Bisection Method', 'FontSize', 14);
        xlabel('\epsilon_{n}', 'FontSize', 18);
        ylabel('\epsilon_{n+1}', 'FontSize', 18);
        xlim([10e-16, 10e1]);
        ylim([10e-19, 10e1])
        grid on;
        loglog(fit_line_x, fit_line_y, 'k--', 'LineWidth', 2);
        legend('Raw', 'Processed', 'Fitted line');
        hold off;

    elseif solver_flag == "newton"
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

        % filter the data
        [x_regression, y_regression] = filter_data(error_current, error_next, index_list);

        % generate p and k values from linear regression
        [p, k] = generate_error_fit(x_regression, y_regression);
        
        % generate x data on a logarithmic range
        fit_line_x = 10.^(-16:0.1:1);
        % compute the corresponding y values
        fit_line_y = k*fit_line_x.^p;

        % calculate derivatives
        [dfdx, d2fdx2] = approx_derivatives(fun, x_r);

        % calculate predicted k value
        k_pred = abs(0.5*(d2fdx2/dfdx));

        disp1 = strcat("estimated p = ", num2str(p));
        disp3 = strcat("estimated k = ", num2str(k));
        disp4 = strcat("predicted k = ", num2str(k_pred));
        disp(disp1);
        disp(disp3);
        disp(disp4);
        
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
        loglog(fit_line_x, fit_line_y, 'k--', 'LineWidth', 2);
        legend('Raw', 'Processed', 'Fitted line');
        hold off;
    
    elseif solver_flag == "secant"
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
        
        % filter the data
        [x_regression, y_regression] = filter_data(error_current, error_next, index_list);

        % generate p and k values from linear regression
        [p, k] = generate_error_fit(x_regression, y_regression);
        
        % generate x data on a logarithmic range
        fit_line_x = 10.^(-16:0.1:1);
        % compute the corresponding y values
        fit_line_y = k*fit_line_x.^p;

        % calculate predicted k and p values
        p_pred = 1.618;

        disp1 = strcat("estimated p = ", num2str(p));
        disp2 = strcat("predicted p = ", num2str(p_pred));
        disp3 = strcat("estimated k = ", num2str(k));
        disp(disp1);
        disp(disp2);
        disp(disp3);
        
        % visualize processed data
        figure('Color', 'w');
        loglog(error_current, error_next, 'r.', 'markerfacecolor', 'r', 'markersize', 4);
        hold on;
        loglog(x_regression, y_regression, 'g.', 'markerfacecolor', 'g', 'markersize', 4);
        title('Convergence Analysis for Secant Method', 'FontSize', 14);
        xlabel('\epsilon_{n}', 'FontSize', 18);
        ylabel('\epsilon_{n+1}', 'FontSize', 18);
        xlim([10e-16, 10e1]);
        ylim([10e-19, 10e1])
        grid on;
        loglog(fit_line_x, fit_line_y, 'k--', 'LineWidth', 2);
        legend('Raw', 'Processed', 'Fitted line');
        hold off;
    
    elseif solver_flag == "fzero"
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
        
        % filter the data
        [x_regression, y_regression] = filter_data(error_current, error_next, index_list);

        % generate p and k values from linear regression
        [p, k] = generate_error_fit(x_regression, y_regression);
        
        % generate x data on a logarithmic range
        fit_line_x = 10.^(-16:0.1:1);
        % compute the corresponding y values
        fit_line_y = k*fit_line_x.^p;

        disp1 = strcat("estimated p = ", num2str(p));
        disp2 = strcat("estimated k = ", num2str(k));
        disp(disp1);
        disp(disp2);
        
        % visualize processed data
        figure('Color', 'w');
        loglog(error_current, error_next, 'r.', 'markerfacecolor', 'r', 'markersize', 4);
        hold on;
        loglog(x_regression, y_regression, 'g.', 'markerfacecolor', 'g', 'markersize', 4);
        title('Convergence Analysis for fzero', 'FontSize', 14);
        xlabel('\epsilon_{n}', 'FontSize', 18);
        ylabel('\epsilon_{n+1}', 'FontSize', 18);
        xlim([10e-16, 10e1]);
        ylim([10e-19, 10e1])
        grid on;
        loglog(fit_line_x, fit_line_y, 'k--', 'LineWidth', 2);
        legend('Raw', 'Processed', 'Fitted line');
        hold off;

    end
end

function [x_regression, y_regression] = filter_data(error_current, error_next, index_list)
    % data points to be used in the regression
    x_regression = []; % e_n
    y_regression = []; % e_{n+1}
    
    % iterate through the collected data
    for n=1:length(index_list)
        % if the error is not too big or too small and it was enough iterations
        % into the trial...
        if error_current(n) > 1e-12 && error_current(n) < 1e-2 && error_next(n) > 1e-12 && error_next(n) < 1e-2 && index_list(n) > 2
            % then add it to the set of points for regression
            x_regression(end+1) = error_current(n);
            y_regression(end+1) = error_next(n);
        end
    end
end


function [p,k] = generate_error_fit(x_regression, y_regression)
    % generate Y, X1, and X2
    % note that I use the transpose operator (') to convert the result 
    % from a row vector to a column
    % If you are copy-pasting, the ' character may not work correctly
    Y = log(y_regression)';
    X1 = log(x_regression)';
    X2 = ones(length(X1),1);
    
    %run the regression
    coeff_vec = regress(Y,[X1,X2]);
    
    %pull out the coefficients from the fit
    p = coeff_vec(1);
    k = exp(coeff_vec(2));
end

function [dfdx, d2fdx2] = approx_derivatives(fun, x)
    % approximates the first and second derivative of a function using
    % finite difference method
    
    %set the step size to be tiny
    delta_x = 1e-6;
    
    % compute the function at different points near x
    f_left = fun(x - delta_x);
    f_0 = fun(x);
    f_right = fun(x + delta_x);
    
    % approximate the first derivative
    dfdx = (f_right - f_left) / (2*delta_x);
    
    % approximate the second derivative
    d2fdx2 = (f_right - 2*f_0 + f_left) / (delta_x^2);
end