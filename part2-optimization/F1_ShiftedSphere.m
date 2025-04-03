function [y] = F1_ShiftedSphere(x)
    % Define the shift vector
    D = length(x);
    o = -100 * ones(1, D);
    
    % Calculate the shifted vector
    z = x - o;
    
    % Calculate the function value
    y = sum(z.^2);
    
    % Add the bias value to make the global minimum value = -450
    y = y - 450;
end