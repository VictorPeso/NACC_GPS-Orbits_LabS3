function plotALL(G, Me, Oe, tol, esec, NS, Eph)
t_target = esec;
plotworld(115)
for satellite_num = 1:1:NS

    id = Eph(satellite_num, 1);       % sat. identifier 
    e = Eph(satellite_num, 3);        % orbit eccentricity
    toa = Eph(satellite_num, 4);      % Time of Applicability [seconds within current week] 
    io = Eph(satellite_num, 5);       % orbit inclination [rad] 
    dO = Eph(satellite_num, 6);       % derivative of right ascension of AN [rad/s] 
    a = Eph(satellite_num, 7)^2;      % orbit semi-major axis [m] 
    Lo = Eph(satellite_num, 8);       % longitude of AN at week epoch [rad] (uncorrected) 
    w = Eph(satellite_num, 9);        % argument of perigee [rad] 
    Mo = Eph(satellite_num, 10);      % Mean Anomaly at ToA [rad]

    dt = t_target - toa;
    Oo = Lo - Oe*toa;

    [lat, long] = subsatellite(Oe, G, Me, a, Mo, dt, e, tol, w, Oo, dO, io);

    hold on;
    plot(long, lat, 'r*') 
    text(long + 2, lat + 1, sprintf('%d', id));

    step = 5*60;
    N = (60*60)/step;

    vec = zeros(N, 2);

    t0 = t_target;

    for k = 1:N

        t = t0 - (k-1)*step;   % actual GPS time
        dt = t - toa;          % time since almanac epoch

        [lat, long] = subsatellite(Oe, G, Me, a, Mo, dt, e, tol, w, Oo, dO, io);

        % Asegura longitudes en [-180, 180] por si esta fuera del rango
        long = mod(long + 180, 360) - 180;

        vec(k, 1) = long;
        vec(k, 2) = lat;
    end

    plot(vec(:, 1), vec(:, 2), 'b.');

end
end
