function [x y] = angle2xyPosition(angle)
    % input should be in deg
    params = parameters();
    distance = ang2dis(angle);
    x = distance .* cosd(angle);
    y = distance .* sind(angle);
end