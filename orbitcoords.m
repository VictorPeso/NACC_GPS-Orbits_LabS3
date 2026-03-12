% Compute cartesian coordinates of sat. within the orbital plane with  
% origin at Earth center and "x" axis pointing to the ascending node 
% v = true anomaly [rad] 
% w = argument of perigee [rad] 
% a = semi-major axis [m] 
% e = orbit eccentricity 
% E = Eccentric Anomaly [rad] 
% [xp, yp] = cartesian orbital coordinates [m] 
function [xp, yp] = orbitcoords(v, w, a, e, E)

    % ===== STEP 5 ==== 

    % Radius in the orbital plane (Earth-centered) using eccentric anomaly
    r = a * (1 - e * cos(E));

    % Argument of latitude: u = w + v
    u = w + v;
    
    % Cartesian coordinates in orbital plane with x toward ascending node
    xp = r * cos(u);
    yp = r * sin(u);

    if ismember("fd", who("global")) 
        global fd; 
        fprintf(fd, "xp = %f, yp = %f\n", xp, yp); 
    end 
end 