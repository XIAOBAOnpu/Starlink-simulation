clc;
clear;
close all;

addpath(genpath('Part1_LOS'));
addpath(genpath('Part2_ULA'));
addpath(genpath('Function'));
params = parameters();
angleElevation = 0: params.res: 180;

%% =============================== Part 2 =============================== 
pointingAngle = [90 45 30 0];
numAntenna = [4 8 16];

GIsoAntenna = gainIsoptropicAntenna(angleElevation, pointingAngle, numAntenna);
GPatAntenna = gainPatchAntenna(angleElevation, pointingAngle, numAntenna);
PlotULAGainPattern(GIsoAntenna, GPatAntenna, pointingAngle, numAntenna);

% Assume perfect tracking
errorPerect = 0;

gainIsoTracking = gainIsoTackingsatellite(angleElevation, numAntenna, errorPerect);
gainPatTracking = gainPatTackingsatellite(angleElevation, numAntenna, errorPerect);

save('isoTracking.mat', 'gainIsoTracking');
save('patTracking.mat', 'gainPatTracking');

for antennaCounter = 1: 1: length(numAntenna)
    PrxIsoTracking(antennaCounter, :) = RX_power(angleElevation, gainIsoTracking(antennaCounter, :));
    PrxPatTracking(antennaCounter, :) = RX_power(angleElevation, gainPatTracking(antennaCounter, :));

    SNRIsoTracking(antennaCounter, :) = SNR_dB(PrxIsoTracking(antennaCounter, :));
    SNRPatTracking(antennaCounter, :) = SNR_dB(PrxPatTracking(antennaCounter, :));

    channelCapIsoTracking(antennaCounter, :) = ChannelCapacity(SNRIsoTracking(antennaCounter, :));
    channelCapPatTracking(antennaCounter, :) = ChannelCapacity(SNRPatTracking(antennaCounter, :));

    totalBitsTXIsoTracking(antennaCounter, :) = TotBitsTX(channelCapIsoTracking(antennaCounter, :), angleElevation); 
    totalBitsTXPatTracking(antennaCounter, :) = TotBitsTX(channelCapPatTracking(antennaCounter, :), angleElevation); 
end

totalBitsTXIsoTracking_inByte = totalBitsTXIsoTracking ./ 8;
totalBitsTXPatTracking_inByte = totalBitsTXPatTracking ./ 8;

PlotMaticeIsotropicULA(angleElevation, numAntenna, PrxIsoTracking, SNRIsoTracking, channelCapIsoTracking);
PlotMaticePatchULA(angleElevation, numAntenna, PrxPatTracking, SNRPatTracking, channelCapPatTracking);
disp(['========================================== Bonus Start=========================================='])

%% =============================== Bonus 2.1 =============================== 
depointingAngle = [0, 0.2: 0.3: 2];
% numAntennaDepoint = [1 100 500 1000 3000];
numAntennaDepoint = [1: 5: 1201];

for depointingAngleCounter = 1: 1: length(depointingAngle)
    gainIsoDepoint(:, :, depointingAngleCounter) = gainIsoTackingsatellite(angleElevation, numAntennaDepoint, depointingAngle(depointingAngleCounter));
    gainPatDepoint(:, :, depointingAngleCounter) = gainPatTackingsatellite(angleElevation, numAntennaDepoint, depointingAngle(depointingAngleCounter));
end

for depointingAngleCounter = 1: 1: length(depointingAngle)
    for antennaCounter = 1: 1: length(numAntennaDepoint)
        PrxIsoDepoint(antennaCounter, :) = RX_power(angleElevation, gainIsoDepoint(antennaCounter, :, depointingAngleCounter));
        PrxPatdepoint(antennaCounter, :) = RX_power(angleElevation, gainPatDepoint(antennaCounter, :, depointingAngleCounter));
    
        SNRIsoDepoint(antennaCounter, :) = SNR_dB(PrxIsoDepoint(antennaCounter, :));
        SNRPatDepoint(antennaCounter, :) = SNR_dB(PrxPatdepoint(antennaCounter, :));
    
        channelCapIsoDepoint(antennaCounter, :) = ChannelCapacity(SNRIsoDepoint(antennaCounter, :));
        channelCapPatDepoint(antennaCounter, :) = ChannelCapacity(SNRPatDepoint(antennaCounter, :));
    
        totalBitsTXIsoDepoint(antennaCounter, :, depointingAngleCounter) = TotBitsTX(channelCapIsoDepoint(antennaCounter, :), angleElevation); 
        totalBitsTXPatDepoint(antennaCounter, :, depointingAngleCounter) = TotBitsTX(channelCapPatDepoint(antennaCounter, :), angleElevation); 
    end
end
totalBitsTXIsoDepoint_inByte = squeeze(totalBitsTXIsoDepoint ./ 8);
totalBitsTXPatDepoint_inByte = squeeze(totalBitsTXPatDepoint ./ 8);

save('isoDepoint.mat', 'gainIsoDepoint');
save('patDepoint.mat', 'gainPatDepoint');

for numofAngles = 1: 1: length(depointingAngle)
    [valueIso, indexIso] = max(totalBitsTXIsoDepoint_inByte(:, numofAngles));
    [valuePat, indexPat] = max(totalBitsTXPatDepoint_inByte(:, numofAngles));

    disp(['Iso: For depointing angle is ', num2str(depointingAngle(numofAngles)), '. Max total bits TX get when ', ...
        num2str(numAntennaDepoint(indexIso)) , ' antennas, bits in total is ', num2str(valueIso), ' bytes.'])
    disp(['Pat: For depointing angle is ', num2str(depointingAngle(numofAngles)), '. Max total bits TX get when ', ...
        num2str(numAntennaDepoint(indexPat)) , ' antennas, bits in total is ', num2str(valuePat), ' bytes.'])
    disp('===============================================================================================================');
end

figure('Name', 'Total bits TX Iso. with error');
for plotDepointAngleCounter = 1: 1: length(depointingAngle)
    plot(numAntennaDepoint, totalBitsTXIsoDepoint_inByte(:, plotDepointAngleCounter));
    hold on;
end
legend('Depointing angle = 0', 'Depointing angle = 0.2', 'Depointing angle = 0.5', 'Depointing angle = 0.8', 'Depointing angle = 1.1', ...
   'Depointing angle = 1.4', 'Depointing angle = 1.7',  'Depointing angle = 1.0');
xlabel('Number of antennas');
ylabel('Total bits TX [Bytes]');
title('Total bits TX Iso. with error');

figure('Name', 'Total bits TX Pat. with error');
for plotDepointAngleCounter = 1: 1: length(depointingAngle)
    plot(numAntennaDepoint, totalBitsTXPatDepoint_inByte(:, plotDepointAngleCounter));
    hold on;
end
legend('Depointing angle = 0', 'Depointing angle = 0.2', 'Depointing angle = 0.5', 'Depointing angle = 0.8', 'Depointing angle = 1.1', ...
   'Depointing angle = 1.4', 'Depointing angle = 1.7',  'Depointing angle = 1.0');
xlabel('Number of antennas');
ylabel('Total bits TX [Bytes]');
title('Total bits TX Pat. with error');