function GIsoAntenna = gainIsoptropicAntenna(angleElevation, pointingAngle, numAntenna)

    % This UIsoAntenna is a 3-D matrix. Consists of length(numAntenna) 2-D matrix
    % Each 2-D matrix has length(theta) rows and length(pointingAngle) cols.

    params = parameters();
    d = params.wavelength / 2;
    beta = params.beta;
    theta = angleElevation;
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
%                 sinTerm(i, j, k) = sind(numAntenna(k) * psi(i, j, k) / 2) / sind(psi(i, j, k) / 2);
%                 AF(i, j, k) = exp(1j * (numAntenna(k)-1) * psi(i, j, k)/2) * sinTerm(i, j, k);
                AF(i, j, k) = (1 - exp(1j * numAntenna(k) * psi(i, j, k))) / (1 - exp(1j * psi(i, j, k)));

                if isnan(AF(i, j, k)) == 1
                    AF(i, j, k) = numAntenna(k);
                end

                UIsoAntenna(i, j, k) = abs(AF(i, j, k))^2 * U_0;
            end
            sphericalUIso(:, j, k) = 1/2 * trapz(deg2rad(theta'), UIsoAntenna(:, j, k) .* sind(theta)');
            GIsoAntenna(:, j, k) = UIsoAntenna(:, j, k) ./ sphericalUIso(:, j, k);
        end
    end
end