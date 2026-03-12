% Compute the Mean Anomaly at "dt" seconds after ToA, given the Mean Anomaly at ToA and 
% the semi-major axis 
% G = gravitational constant - 5 -  
% Me = Earth mass 
% a = semi-major axis [m] 
% Mo = Mean Anomaly at ToA [rad] 
% dt = seconds elapsed after ToA (negative if ToA is in the future) 
% M = Mean Anomaly at ToA + dt [rad] 
function M = mean_anomaly(G, Me, a, Mo, dt)

 % ===== STEP 2 ====

    % Earth gravitational parameter
    mu = G * Me; % [m^3/s^2]

    % Mean motion (rad/s)
    n = sqrt(mu / (a^3));

    % Propagate mean anomaly
    M = Mo + n * dt;
    
    if ismember("fd", who("global")) 
        global fd; 
        fprintf(fd, "dt = %f, M = %f\n", dt, mod(M, 2 * pi)); 
    end 
end 