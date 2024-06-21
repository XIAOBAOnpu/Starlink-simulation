function center_angle = elevation2center(surface_angle)
    % input should be in deg
    params = parameters();
    dis = ang2dis(surface_angle);
    center_angle = asin(dis .* cosd(surface_angle) / (params.altitude + params.Re));
end