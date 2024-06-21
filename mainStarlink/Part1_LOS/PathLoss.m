function pathLoss = PathLoss(angle)
    params = parameters();
    G_RX = 1;
    disPathLoss = ang2dis(angle);
    pathLoss = 20 * log10(4*pi .* disPathLoss ./ params.wavelength);
end