% Solve Keppler equation for Eccentric Anomally iteratively 
% Loop is exited when we reach the desired tolerance 
% e = orbit eccentricity 
% tol = convergence tolerance 
% M = Mean Anomaly [rad] 
% E = eccentric anomaly [rad] 
function E = eccentric(e, tol, M)

    % Esta funcion resuelve M = E - e*sin(E) para E (orbita eliptica)

    % ===== STEP 3 ====
    
     % --- Validaciones básicas ---
    if e < 0 || e >= 1
        error('eccentric: e debe cumplir 0 <= e < 1 (órbita elíptica).');
    end
    if tol <= 0
        error('eccentric: tol debe ser positiva.');
    end

    E0 = M;
    E1 = M + e*sin(E0);

    while abs(E1-E0) > tol

        E0 = E1;
        E1 = M + e*sin(E0);

        % f  = E - e*sin(E) - M;      % f(E)=0
        % fp = 1 - e*cos(E);          % f'(E)
        % 
        % dE = -f / fp;
        % E = E + dE;  % Update E with the correction
        % 
        % if abs(dE) < tol % Check for convergence
        %     converged = 1;
        % end

    end

    E = E1;

    if ismember("fd", who("global")) 
        global fd; 
        fprintf(fd, "E = %f\n", mod(E, 2 * pi)); 
    end 
end 