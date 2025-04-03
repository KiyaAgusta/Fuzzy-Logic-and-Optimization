function [y] = F9_ShiftedRastrigin(x)
    % Define the shift vector
    D = length(x);
    o = -5 * ones(1, D);
    
    % Calculate the shifted vector
    z = x - o;
    
    % Calculate the function value
    y = sum(z.^2 - 10*cos(2*pi*z) + 10);
    
    % Add the bias value to make the global minimum value = -330
    y = y - 330;
end