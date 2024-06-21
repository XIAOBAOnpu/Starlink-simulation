function PlotULAGainPattern(GIsoAntenna, GPatAntenna, pointingAngle, numAntenna)
    
    params = parameters();
    iterationAngle = 0: params.res: 180;

    figure('Name', 'Isotropic Antenna')
    for antennaCount = 1: 1: length(numAntenna)
        subplot(2, 3, antennaCount)
        for pointingAngleCount = 1: 1: length(pointingAngle)
            polarplot(deg2rad(iterationAngle'), GIsoAntenna(:, pointingAngleCount, antennaCount), 'LineWidth', 1);
            hold on
        end
        subtitle(['Isotropic Antenna Num = ' num2str(numAntenna(antennaCount))]);
    end
    %legend('Point Angle = 90', 'Point Angle = 45', 'Point Angle = 30', 'Point Angle = 0');
    
%     figure('Name', 'Patch Antenna')
    for antennaCount = 1: 1: length(numAntenna)
        subplot(2, 3, antennaCount + 3)
        for pointingAngleCount = 1: 1: length(pointingAngle)
            polarplot(deg2rad(iterationAngle'), GPatAntenna(:, pointingAngleCount, antennaCount), 'LineWidth', 1);
            hold on
        end
        subtitle(['Patch Antenna Num = ' num2str(numAntenna(antennaCount))]);
    end
    legend('Point Angle = 90', 'Point Angle = 45', 'Point Angle = 30', 'Point Angle = 0');

end