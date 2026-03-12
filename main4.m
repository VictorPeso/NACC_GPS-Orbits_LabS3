clear all
close all
clc

G = 6.67384e-11;              % Gravitational constant
Me = 5.972e+24;               % Earth Mass
Oe = 7.2921151467e-5;         % Earth rotation angular velocity (rad/s) 
tol = 1.e-8;                  % tolerance for convergence 

global fd;
fd = fopen("main4.dat", "w");

% ******** Week 359 almanac for PRN-09 ********
% ID:                         09
% Health:                     000
% Eccentricity:               0.3363132477E-002
% Time of Applicability(s):   405504.0000
% Orbital Inclination(rad):   0.9646486122
% Rate of Right Ascen(r/s):  -0.7817468486E-008
% SQRT(A)  (m 1/2):           5153.735352
% Right Ascen at Week(rad):  -0.1029058803E+001
% Argument of Perigee(rad):   2.065742194
% Mean Anom(rad):             0.2087359114E+001
% Af0(s):                     0.7686614990E-003
% Af1(s/s):                   0.0000000000E+000
% week:                       359

[baseweek, esec, NS, Eph] = almanac();
all_ecef = zeros(NS,3);

% 1. Set user position to EETAC and compute its ECEF xyz coordinates using the WGS84 ellipsoid parameters
User_lat = deg2rad(41 + 16.578/60);
User_long = deg2rad(1 + 59.240/60);

User_cart_coord = lla2xyz([User_lat User_long 0]);

% Loop for EACH satellite 
    % 2.0 Prepare the ephemeris data for calling "kepler2ecef.m" 

for n = 1:1:NS
    satellite_num = n;

    id = Eph(satellite_num, 1);       % sat. identifier 
    e = Eph(satellite_num, 3);        % orbit eccentricity
    toa = Eph(satellite_num, 4);      % Time of Applicability [seconds within current week] 
    io = Eph(satellite_num, 5);       % orbit inclination [rad] 
    dO = Eph(satellite_num, 6);       % derivative of right ascension of AN [rad/s] 
    a = Eph(satellite_num, 7)^2;      % orbit semi-major axis [m] 
    Lo = Eph(satellite_num, 8);       % longitude of AN at week epoch [rad] (uncorrected) 
    w = Eph(satellite_num, 9);        % argument of perigee [rad] 
    Mo = Eph(satellite_num, 10);      % Mean Anomaly at ToA [rad] 

    t_target = esec;
    dt = t_target - toa;
    Oo = Lo - Oe*toa;

    [ecef] = kepler2ecef(Oe, G, Me, a, Mo, dt, e, tol, w, Oo, dO, io);

    all_ecef(n,1) = ecef(1); 
    all_ecef(n,2) = ecef(2); 
    all_ecef(n,3) = ecef(3); 

    fprintf(fd, "Oo = %f, esec = %f, dt = %f\n\n", mod(Oo, 2 * pi), esec, dt);
end

pointing_vec = zeros(NS,3);

for n = 1:1:NS
    pointing_vec(n,1) = all_ecef(n,1) - User_cart_coord(1);
    pointing_vec(n,2) = all_ecef(n,2) - User_cart_coord(2);
    pointing_vec(n,3) = all_ecef(n,3) - User_cart_coord(3);
end

% 3. Transform pointing vector to NED coordinates with respect to user  

ned_vec = zeros(NS, 3);
for n = 1:1:NS
    ned_vec(n,:) = ecef2ned(pointing_vec(n,:), User_lat, User_long);
    % ned_vec(n,2) = ecef2ned(pointing_vec(n,2), User_lat, User_long);
    % ned_vec(n,3) = ecef2ned(pointing_vec(n,3), User_lat, User_long);
end



% 4. Convert from cartesian to spherical (distance, elevation, azimuth) with respect to the user
sphe_vec = zeros(NS, 3);
for n = 1:1:NS
    [r, az, elev] = ned2spherical(ned_vec(n,:));
    sphe_vec(n,1) = r;
    sphe_vec(n,2) = az;
    sphe_vec(n,3) = elev;
end

% 5. Find out if the satellite is above the horizon  

prn = [];
azimuth = [];
elevation = [];

for n = 1:1:NS
    if sphe_vec(n,3) >= 10
        prn(end+1) = id;
        azimuth(end+1) = sphe_vec(n,2);
        elevation(end+1) = sphe_vec(n,3);
    end
end

% 6. AFTER the loop for all satellites call viewsat to plot the satellites above the user's horizon 

max_elev = 90;
min_elev = 10;
err = viewsat(azimuth, elevation, prn, min_elev, max_elev, "hola");

fprintf(fd, "\nVisible satellites:\n"); 

for (j = 1:NS)  % 'n' is the number of visible satellites 
    fprintf(fd, "prn = %d, azimuth = %f, elevation = %f\n", prn(j), azimuth(j), elevation(j)); 
end 

fclose(fd);