function Gamma = reflectionFactor(x, y)
    params = parameters();

    xWall = -10;
    yWall = 10;
    xRxMirror = -20;

    kWall = (yWall - 0) / (xWall - xWall);
    kRay  = (y - 0) / abs(x - xRxMirror);
    theta = atan2(kRay - kWall, 1 + kRay * kWall);

    GammaNum = (cos(theta) - sqrt(4) * sqrt(1 - 1/4 * sin(theta)^2));
    GammaDem = (cos(theta) + sqrt(4) * sqrt(1 - 1/4 * sin(theta)^2));

    Gamma = GammaNum / GammaDem;
end