function [f, dfdx] = convergence_test_func_2(x)
    %declare input_list as a global variable
    global input_list;
    % append the current input to input_list
    % formatted so this works even if x is a column vector instead of a scalar
    input_list(:,end+1) = x;
    % perform the rest of the computation to generate output
    f = (x.^3)/10 - 1/exp(x) - 10;
    dfdx = 3*(x.^2)/10 + exp(-x);
end