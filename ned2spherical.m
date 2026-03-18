% xyz (1x3) = input cartesian NED coordinates [m] 
% r = distance [m] 
% az = azimuth [degrees] 
% elev = elevation [degrees] 
function [r, az, elev] = ned2spherical(xyz) 

r = sqrt(xyz(1)^2 + xyz(2)^2 + xyz(3)^2);

elev = rad2deg(asin(-xyz(3)/r));

az = mod(rad2deg(atan2(xyz(2), xyz(1))), 360);

if ismember("fd", who("global")) 
    global fd; 
    fprintf(fd, "r = %f, az = %f, elev = %f\n", r, az, elev); 
end 
end 