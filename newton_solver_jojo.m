function root_approx = newton_solver_jojo(fun, x0, convergence_threshold, max_iter)
    % basic implementation of Newton's method for numerical root finding

    status = 0; % convergence status
    x_n = x0; % initialize x_n for the first guess
    
    % loop until iterations reached the specified maximum number
    for i=1:max_iter
        
        % evaluate the function at the approximated root
        [f, dfdx] = fun(x_n);
        
        % break if df/dx is 0, which will result in an invalid operation
        if dfdx == 0
            warning('Derivative is 0, method failed.');
            break
        end

        % calculate the root approximation for the next iteration
        x_next = x_n - (f/dfdx);
        
        % break if the update step is too large
        if abs(x_next - x_n) > 1/convergence_threshold
            warning('Updated step size is too large, method failed.');
            break
        end
        
        % check for convergence
        if abs(x_next - x_n) < convergence_threshold && abs(f) < convergence_threshold
            status = 1; % set status to success
            break
        end

        x_n = x_next; % update x_n for next iteration

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