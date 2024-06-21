function GIsoAntennaTracking = gainIsoTackingsatellite(angleElevation, numAntenna, error)

    % This UIsoAntenna is a 3-D matrix. Consists of length(numAntenna) 2-D matrix
    % Each 2-D matrix has length(theta) rows and length(pointingAngle) cols.

    params = parameters();
    d = params.wavelength / 2;
    beta = params.beta;
    theta = angleElevation;
    % theta = 0: 1: 180;
    pointingAngle = theta + error;
    U_0 = 1;
    AF = zeros(length(theta), length(pointingAngle), length(numAntenna));
    phaseShift = zeros(length(theta), length(pointingAngle), length(numAntenna));
    sinTerm = zeros(length(theta), length(pointingAngle), length(numAntenna));
    UIsoAntenna = zeros(length(theta), length(pointingAngle), length(numAntenna));

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

                UIsoAntenna(i, j, k) = abs(AF(i, j, k))^2 .* U_0;

%                 if j == i + error / params.res    % in this case the ULS tracks the satelitte all the time
%                     UIsoAntennaTracking(k, j) = UIsoAntenna(i, j, k);
%                 end
                % if j == i + error / params.res   
                %     if j > length(pointingAngle)
                %         j = length(pointingAngle);
                %         UIsoAntennaTracking(k, j) = UIsoAntenna(i, j, k);
                %     else
                %         UIsoAntennaTracking(k, j) = UIsoAntenna(i, j, k);
                %     end
                % end
                if j == i   
                    UIsoAntennaTracking(k, j) = UIsoAntenna(i, j, k);
                end

            end
            sphericalUIso(:, j, k) = 1/2 * trapz(deg2rad(theta'), UIsoAntenna(:, j, k) .* sind(theta)');
            
        end
        disp(['Isotropic ULA with ', num2str(numAntenna(k)), ' elements, depointing angle ', num2str(error), ' finishes...'])
        disp('----------------------------------------------------------------------------');
    end

    GIsoAntennaTracking = UIsoAntennaTracking ./ squeeze(sphericalUIso)';
    
end