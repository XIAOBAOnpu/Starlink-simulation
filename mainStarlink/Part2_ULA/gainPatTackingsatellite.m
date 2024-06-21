function GPatAntennaTracking = gainPatTackingsatellite(angleElevation, numAntenna, error)

    % This UIsoAntenna is a 3-D matrix. Consists of length(numAntenna) 2-D matrix
    % Each 2-D matrix has length(theta) rows and length(pointingAngle) cols.

    params = parameters();
    d = params.wavelength / 2;
    beta = params.beta;
    theta = angleElevation;
    pointingAngle = theta + error;
    U_0 = (sind(theta).^2)';
    AF = zeros(length(theta), length(pointingAngle), length(numAntenna));
    phaseShift = zeros(length(theta), length(pointingAngle), length(numAntenna));
    sinTerm = zeros(length(theta), length(pointingAngle), length(numAntenna));
    UPatAntenna = zeros(length(theta), length(pointingAngle), length(numAntenna));

    for k = 1: 1: length(numAntenna)
        for j = 1: length(pointingAngle)
            phaseShift(:, j, k) = beta * d * cosd(pointingAngle(j));
            for i = 1: 1: length(theta)
                psi(i, j, k) = beta * d * cosd(theta(i)) - phaseShift(i, j, k);
               % psi(i, j, k) = 0;
                AF(i, j, k) = (1 - exp(1j * numAntenna(k) * psi(i, j, k))) / (1 - exp(1j * psi(i, j, k)));

                if isnan(AF(i, j, k)) == 1
                    AF(i, j, k) = numAntenna(k);
                end
                
                % calculate from theta -> 0~180 and pointing angle from
                % 0~180
                UPatAntenna(i, j, k) = abs(AF(i, j, k))^2 .* U_0(i);
                
                % in this case the ULA tracks the satelitte all the time,
                % i.e. only keep the term when pointing angle = satelitte
                % angle (theta_m = theta)
                % num of antenna's row, and each row stands for 1801
                % pointing angles
                if j == i 
                    UPatAntennaTracking(k, j) = UPatAntenna(i, j, k);
                end

            end
            % for every pointing angle, got a normalization factor over
            % theta from 0~180
            sphericalUPat(:, j, k) = 1/2 * trapz(deg2rad(theta'), UPatAntenna(:, j, k) .* sind(theta)');

        end
        disp(['Patch ULA with ', num2str(numAntenna(k)), ' elements, depointing angle ', num2str(error), ' finishes...'])
        disp('----------------------------------------------------------------------------');
    end
    
    % for each pointing angle, divide U by its own normalization factor
    GPatAntennaTracking = UPatAntennaTracking ./ squeeze(sphericalUPat)';
end