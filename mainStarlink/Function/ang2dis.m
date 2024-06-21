function distance = ang2dis(angle)  
    % input should be in deg
    params = parameters();
    distance = sqrt((params.Re + params.altitude)^2 - params.Re^2 * cosd(angle).^2) - params.Re .* sind(angle);
end