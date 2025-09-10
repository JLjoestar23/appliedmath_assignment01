function [root_approx, guess_list] = bisection_convergence_test(fun, L_bound_i, R_bound_i, convergence_threshold, max_iter)

    guess_list = [];
    % basic implementation of the bisection method for numerical root finding

    % intialize left and right bounds, and other initial values
    L_bound = L_bound_i;
    R_bound = R_bound_i;
    midpoint = (L_bound + R_bound) / 2;
    current_iter = 0;
    status = 0;
    
    % evaluate the function at the initial L/R bounds and midpoint
    [f_L, ~] = fun(L_bound);
    [f_R, ~] = fun(R_bound);
    [f_n, ~] = fun(midpoint);

    % zero crossing check between bounds, exit function if there is none
    if ~(f_L < 0 && f_R > 0 || f_L > 0 && f_R < 0)
        %warning("This interval does not contain a zero crossing. Pick a different interval.");
        root_approx = NaN;
        return
    end

    % repeat until the distance between the bounds reaches and output value of the root reach the threshold
    while (abs(L_bound - R_bound) > convergence_threshold) && abs(f_n) > convergence_threshold
        % if the initial conditions are bad and the solver does not
        % converge, throw an error message and break
        if current_iter == max_iter
            warning("Convergence failed, try different initial guesses.");
            status = 0;
            break
        end
    
        % computing the midpoint of the current bounds
        midpoint = (L_bound + R_bound) / 2;
        
        % evaluate the function at the initial L/R bounds and midpoint
        [f_L, ~] = fun(L_bound);
        [f_R, ~] = fun(R_bound);
        [f_n, ~] = fun(midpoint);

        % updating left or right bounds to the midpoint based on values
        if (f_L > 0 && f_n < 0) || (f_L < 0 && f_n > 0)
            guess_list(end+1) = R_bound;
            R_bound = midpoint;
        end
    
        if (f_n > 0 && f_R < 0) || (f_n < 0 && f_R > 0)
            guess_list(end+1) = L_bound;
            L_bound = midpoint;
        end
        
        % count the iterations
        current_iter = current_iter + 1;

        % keep status successful as long as the loop runs
        status = 1;
    end 
       

    guess_list(end+1) = midpoint;

    if status == 1
        % return the approximated root value
        root_approx = midpoint;
        %final_disp = strcat("Root Found, Number of Iterations: ", num2str(current_iter));
        %disp(final_disp);
    else
        warning("Convergence failed, try different initial guesses.");
        root_approx = NaN;
    end
end