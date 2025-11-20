function [Y_beta, Y_r, Y_delta, N_beta, N_r, N_delta, CF, CR] = stabilityDerivatives(V, a, b, tirOutputs)
    CS = tirOutputs(:, 26) ./ 4.44822 .* 2; % [lb/rad] cornering stiffness
    % Because cornering stiffness increases more slowly as vertical load
    % increases, it seems more accurate to model the single front/rear tire as
    % two tires with half static axle load and then combine their cornering
    % stiffnesses to return to the bicycle assumption.
    CF = CS(1); % [lb/rad] front cornering stiffness
    CR = CS(2); % [lb/rad] rear cornering stiffness
    % C = CF + CR; % [lb/rad] total cornering stiffness
    % 
    
    % [lb/rad] damping-in-sideslip derivative
    Y_beta = CF + CR;
    % [lb/(rad/sec)] lateral force/yaw coupling derivative
    Y_r = (1/V) * (a*CF - b*CR); 
    % [lb/rad] control force derivative
    Y_delta = -CF; 
    
    % [lb-ft/rad] static directional stability derivative
    % (+) is US, (-) is OS
    N_beta = a*CF - b*CR; 
    % [lb-ft/(rad/sec)] yaw damping derivative
    N_r = (1/V) * (a^2*CF + b^2*CR); 
    % [lb-ft/rad] control moment derivative
    N_delta = -a*CF; 
end