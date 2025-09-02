function root_approx = bisection_solver(func, L_bound_i, R_bound_i, convergence_threshold, max_iter)
    % basic implementation of the bisection numerical root finding
    % algorithm
    % 
    % Inputs:
    % func: the function to find the

    % intialize left and right bounds
    L_bound = L_bound_i;
    R_bound = R_bound_i;
    current_iter = 1;
    
    % repeat until the distance between the bounds reaches the threshold
    while (abs(L_bound - R_bound) > convergence_threshold)
        % if the initial conditions are bad and the solver does not
        % converge, throw an error message and break
        if current_iter > max_iter
            disp("Convergence failed, try different initial guesses");
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

    end
       
    % return the approximated root value
    root_approx = midpoint;
    

end