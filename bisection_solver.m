function root_approx = bisection_solver(func, L_bound_i, R_bound_i, convergence_threshold, max_iter)
    % basic implementation of the bisection method for numerical root finding

    % intialize left and right bounds, and other initial values
    L_bound = L_bound_i;
    R_bound = R_bound_i;
    midpoint = (L_bound + R_bound) / 2;
    current_iter = 0;
    status = 0;
    
    if ~(func(L_bound) < 0 && func(R_bound) > 0 || func(L_bound) > 0 && func(R_bound) < 0)
        warning("This interval does not contain a zero crossing. Pick a different interval.");
        root_approx = NaN;
        return
    end

    % repeat until the distance between the bounds reaches and output value of the root reach the threshold
    while (abs(L_bound - R_bound) > convergence_threshold) && abs(func(midpoint)) > convergence_threshold
        % if the initial conditions are bad and the solver does not
        % converge, throw an error message and break
        if current_iter == max_iter
            warning("Convergence failed, try different initial guesses.");
            status = 0;
            break
        end
    
        % computing the midpoint of the current bounds
        midpoint = (L_bound + R_bound) / 2;
        
        % updating left or right bounds to the midpoint based on values
        if (func(L_bound) > 0 && func(midpoint) < 0) || (func(L_bound) < 0 && func(midpoint) > 0)
            R_bound = midpoint;
        end
    
        if (func(midpoint) > 0 && func(R_bound) < 0) || (func(midpoint) < 0 && func(R_bound) > 0)
            L_bound = midpoint;
        end
        
        % count the iterations
        current_iter = current_iter + 1;

        % keep status successful as long as the loop runs
        status = 1;
    end 
       
    if status == 1
        % return the approximated root value
        root_approx = midpoint;
        final_disp = strcat("Root Found, Number of Iterations: ", num2str(current_iter));
        disp(final_disp);
    else
        warning("Convergence failed, try different initial guesses.");
        root_approx = NaN;
    end
end