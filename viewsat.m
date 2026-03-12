function err = viewsat(AZIMUTH, ELEV, ID, min_elev, max_elev, downstr)
    hFig = figure(111);
    clf(hFig);
    daspect([1,1,1]);
    set(hFig, 'Position', [50 50 1200 1200]);
    
    hold on;

    % Plot Limits of coverage
    grey=[0.5,0.5,0.5];
    legendangle = pi/4;
    r = max_elev;
    p = (-r/2);
    rectangle('Position',[p p r r],'Curvature',[1,1], 'LineWidth', 2, 'EdgeColor', 'k', 'FaceColor', [1 0.8 0.8]);
    text(-p*cos(legendangle)+1, -p*sin(legendangle)+1.5,'0\circ');
    r = max_elev-min_elev;
    p = (-r/2);
    rectangle('Position',[p p r r],'Curvature',[1,1], 'LineStyle', '-', 'EdgeColor', grey, 'FaceColor', 'w');


    % Plot diferent elevations
    N = 5;  % Number of elevations (Number of rings)
    elevations = linspace(min_elev, max_elev, N);
    d = (max_elev-min_elev)/2;
    for index = 1:length(elevations)
        elev = elevations(index);
        r = (max_elev-elev);
        p = (-r/2);

        if (r~=0)
            rectangle('Position',[p p r r],'Curvature',[1,1], 'LineStyle', '-', 'EdgeColor', grey);
        else
            rectangle('Position',[p p 0.1 0.1],'Curvature',[1,1], 'LineStyle', '-', 'EdgeColor', grey);
        end

        % Plot Elevation of each ring
        text(-p*cos(legendangle)+1, -p*sin(legendangle)+1.5,[int2str(elev) '\circ']);
    end

    % Plot radial lines
    N = 12; % Number of radials
    radials = linspace(0, 360, N+1);
    for (index = 1:N)
        px = max_elev*sin(radials(index)*pi/180)/2;
        py = max_elev*cos(radials(index)*pi/180)/2;
        plot([0 px], [0 py], 'Color', grey);
        text(px*1.1-4, py*1.1,[int2str(radials(index)) '\circ']);
    end

    % Plot coordinates (North, East, South and West)
    a = max_elev/2;
    text(-4, +a+15, 'North');
    text(-4, -a-15, 'South');
    text(+a+15, +0, 'East');
    text(-a-25, +0, 'West');

    % Fix axes
    m = 40; % Margin
    axis([-d-m-5 d+m -d-m d+m]);

    % Plot title
    title('GPS constellation');

    % Hide Y axis
    set(gca,'YTick',[])
    set(gca,'YColor','w')

    % Hide X axis
    set(gca,'XTick',[])
    set(gca,'XColor','w')

    % Plot Satellite positions
    satcolors = ['r' 'g' 'b' 'c' 'm' 'k'];
    satmarkers = ['*' '*' '*'];
    for index = 1:length(AZIMUTH)
        if (ELEV(index) < 90 && ELEV(index) > 0)
            c = mod(index,length(satcolors))+1;
            m = mod(fix(index/length(satmarkers)),length(satmarkers))+1;
            x = (max_elev - ELEV(index))*sin(pi*AZIMUTH(index)/180)/2;
            y = (max_elev - ELEV(index))*cos(pi*AZIMUTH(index)/180)/2;
            plot(x, y, [satmarkers(m) satcolors(c)]);
            text(x, y, ['  ' int2str(ID(index))]);
        end
    end

    text(max_elev/4, -max_elev/2-20, downstr);
    
    hold off;


    % Return no error
    err = 0;
end
