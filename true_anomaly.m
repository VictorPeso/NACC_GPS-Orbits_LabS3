% compute True Anomaly [rad] given the Eccentric Anomaly [rad] and the 
% orbit eccentricity 
% e = orbit eccentricity 
% E = Eccentric Anomaly [rad] 
% v = True Anomaly [rad] 
function v = true_anomaly(e, E) 

    % ===== STEP 4 ==== 

    sv = (sqrt(1 - e^2)*sin(E))/(1-e*cos(E));
    cv = (cos(E) - e)/(1-e*cos(E));
    % Cálculo de la Anomalía Verdadera (nu)
    v = atan2(sv,cv);
    

    % v = atan2(sqrt(1 - e^2) * sin(E), cos(E) - e);
    if ismember("fd", who("global")) 
        global fd; 
        fprintf(fd, "v = %f\n", mod(v, 2 * pi));  
    end 
end 