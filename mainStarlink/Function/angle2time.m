function time = angle2time(angle)
    params = parameters();
    alpha = elevation2center(angle);
    N = size(alpha, 2);

    for n = 1: 1: N - 1
        deltaAlpha(n) = abs(alpha(n) - alpha(n+1));
    end

    deltaT = params.Trev * (deltaAlpha / (2*pi));
    alphaAngle = [0 cumsum(deltaAlpha)];
    time = [0 cumsum(deltaT)];
end