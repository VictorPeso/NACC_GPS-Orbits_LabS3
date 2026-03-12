% Compute (lat, long) [degrees] of sub-satellite point, given orbital 
% parameters, at time = ToA + dt 
% Oe = Earth rotation angular velocity (rad/s) 
% G = Gravitational constant 
% Me = Earth Mass 
% a = orbit semi-major axis [m] 
% Mo = Mean Anomaly at ToA [rad] 
% dt = seconds elapsed after ToA (negative if ToA is in the future) 
% e = orbit eccentricity 
% tol = tolerance for convergence 
% w = argument of perigee [rad] - 8 -  
% Oo = longitude of AN at ToA [rad] (uncorrected) 
% dO = Rate of Right Ascension of AN [rad/s] 
% io = orbit incliination [rad] 
% long = current sub-satellite long [deg] 
% lat = current sub-satellite lat [deg] 
function [lat, long] = subsatellite(Oe, G, Me, a, Mo, dt, e, tol, w, Oo, dO, io) 
    
    % ===== STEP 8 ==== 
    
    M = mean_anomaly(G, Me, a, Mo, dt);
    E = eccentric(e, tol, M);
    v = true_anomaly(e, E);
    [xp, yp] = orbitcoords(v, w, a, e, E);
    ecef = satecef(Oe, Oo, dO, dt, io, xp, yp);

    lla = ecef2lla(ecef);
    lat = lla(1);  % Longitude from LLA
    long = lla(2);   % Latitude from LLA

    if ismember("fd", who("global")) 
        global fd; 
        fprintf(fd, "long = %f, lat = %f\n\n", long, lat); 
    end 
end 