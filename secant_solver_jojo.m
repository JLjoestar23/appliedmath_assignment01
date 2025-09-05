function root_approx = secant_solver_jojo(fun, x0, x1, convergence_threshold, max_iter)
    % basic implementation of the secant method for numerical root finding

    status = 0; % convergence status
    
    % initialize x_n and x_prev for the first guess
    x_n = x1;
    x_prev = x0;
    
    % loop until iterations reached the specified maximum number
    for i=1:max_iter
        
        % evaluate the function at the current approximated root
        [f_n, ~] = fun(x_n);

        % evaluate the function at the previously approximated root
        [f_prev, ~] = fun(x_prev);
        
        % break if the update step is too large
        if abs(f_n - f_prev) > 1/convergence_threshold
            warning('Updated step size is too large, method failed.');
            break
        end

        % calculate the root approximation for the next iteration
        x_next = x_n - f_n*((x_n - x_prev)/(f_n - f_prev));
        
        % check for convergence
        if abs(x_next - x_n) < convergence_threshold && abs(f_n) < convergence_threshold
            status = 1; % set status to success
            break
        end
        
        % update x_n and x_prev for next iteration
        x_prev = x_n;
        x_n = x_next;

    end
    
    % if reached max number of iterations, status is failed
    if i == max_iter
        status = 0;
    end
    
    % if successful, return value of the approximated root
    if status == 1
        root_approx = x_n;
        final_disp = strcat("Root Found, Number of Iterations: ", num2str(i));
        disp(final_disp);
    else % warning flag if convergence failed
        warning("Convergence failed, try different initial guesses or reduce convergence threshold.");
        root_approx = NaN;
    end
end