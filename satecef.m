% Compute CURRENT sat. ECEF coordinates [m] 
% Oe = Earth rotation angular velocity (rad/s) 
% Oo = longitude of AN at ToA [rad] (uncorrected) 
% dt = seconds elapsed after ToA (negative if ToA is in the future) 
% dO = Rate of Right Ascension of AN [rad/s] 
% io = orbit incliination [rad] 
% [xp, yp] = current cartesian orbital coordinates 
% ecef = (1x3) vector containing the current ecef coordinates of sat. 
function ecef = satecef(Oe, Oo, dO, dt, io, xp, yp) 

    % ===== STEP 6 ==== 
    
    % 1) Correct Oo at ToA for the secular drift of the ascending node
    %    (AN increases linearly with time at rate dO)
    Ocorr = Oo + dO * dt;

    % 2) Current longitude of ascending node decreases due to Earth rotation
    %    at rate Oe
    O = Ocorr - Oe * dt;

    % 3) Transform from orbital-plane coords (xp,yp) to ECEF
    %    Using rotations: R3(O) then R1(io)
    %    x = xp*cosO - yp*cos(i)*sinO
    %    y = xp*sinO + yp*cos(i)*cosO
    %    z = yp*sin(i)
    cO = cos(O);  sO = sin(O);
    ci = cos(io); si = sin(io);

    x = xp * cO - yp * ci * sO;
    y = xp * sO + yp * ci * cO;
    z = yp * si;

    ecef = [x, y, z]; 

    if ismember("fd", who("global")) 
        global fd; 
        fprintf(fd, "O = %f, x = %f, y = %f, z = %f\n", mod(O, 2 * pi), x, y, z); 
    end 
end