% Compute ECEF coordinates of Sat. at time = 'ToA + dt' given orbital parameters 
% Oe = Earth rotation angular velocity (rad/s) 
% G = Gravitational constant 
% Me = Earth Mass 
% a = orbit semi-major axis [m] 
% Mo = Mean Anomaly at ToA [rad] 
% dt = seconds elapsed after ToA (negative if ToA is in the future) 
% e = orbit eccentricity 
% tol = tolerance for convergence 
% w = argument of perigee [rad] 
% Oo = longitude of AN at ToA [rad] (uncorrected) 
% dO = Rate of Right Ascension of AN [rad/s] 
% io = orbit incliination [rad] 
% ecef (1x3) = cartesian ecef coordinates (x, y, z) [m] 
function ecef = kepler2ecef(Oe, G, Me, a, Mo, dt, e, tol, w, Oo, dO, io) 

    M = mean_anomaly(G, Me, a, Mo, dt);
    E = eccentric(e, tol, M);
    v = true_anomaly(e, E);
    [xp, yp] = orbitcoords(v, w, a, e, E);
    ecef = satecef(Oe, Oo, dO, dt, io, xp, yp);

    if ismember("fd", who("global")) 
        global fd; 
        fprintf(fd, "ecef = %f, %f, %f\n", ecef); 
    end 
end