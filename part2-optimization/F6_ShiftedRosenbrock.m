function [y] = F6_ShiftedRosenbrock(x)
    % Define the shift vector
    D = length(x);
    o = zeros(1, D);
    
    % Calculate the shifted vector
    z = x - o + 1; % +1 is part of the Rosenbrock's function definition in CEC'2005
    
    % Calculate the function value
    sum_term = 0;
    for i = 1:(D-1)
        sum_term = sum_term + (100 * (z(i)^2 - z(i+1))^2 + (z(i) - 1)^2);
    end
    y = sum_term;
    
    % Add the bias value to make the global minimum value = 390
    y = y + 390;
end