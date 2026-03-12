% Convert from LLA coordinates to cartesian (x,y,z) assuming WGS84 ellipsoid
% lla (1x3) = input latitude [rad], longitude [rad] and height [m]
% xyz (1x3) = computed cartesian coordinates [m]
function xyz = lla2xyz(lla)

a = 6378137;                                    
e2 = 0.00669437999014;                          

lat = lla(1);
lon = lla(2);
h   = lla(3);

% Radius of curvature in the prime vertical
N = a / sqrt(1 - e2 * sin(lat)^2);

x = (N + h) * cos(lat) * cos(lon);
y = (N + h) * cos(lat) * sin(lon);
z = (N * (1 - e2) + h) * sin(lat);

xyz = [x y z];

if ismember("fd", who("global"))
    global fd;
    fprintf(fd, "xyz = %f, %f, %f\n", xyz);
end

end