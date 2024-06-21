function PlotMaticePatchULA(angleElevation, numAntenna, PrxPatTracking, SNRPatTracking, channelCapPatTracking)
    figure('Name', 'Patch ULA');
        subplot(221)
            for figAntennaCounter = 1: 1: length(numAntenna)
                plot(angleElevation, PrxPatTracking(figAntennaCounter, :));
                hold on
            end
            xlabel('Angle [deg]');
            ylabel('Received Power [dBm]');
            xlim([0 180]);
            legend('4 Antennas', '8 Antennas', '16 Antennas');
            subtitle('Received Power for Patch Array');
        
        subplot(222)
            for figAntennaCounter = 1: 1: length(numAntenna)
                plot(angleElevation, SNRPatTracking(figAntennaCounter, :));
                hold on
            end
            xlabel('Angle [deg]');
            ylabel('SNR [dB]');
            xlim([0 180]);
            legend('4 Antennas', '8 Antennas', '16 Antennas');
            subtitle('SNR for Patch Array');

        subplot(223)
            for figAntennaCounter = 1: 1: length(numAntenna)
                plot(angleElevation, channelCapPatTracking(figAntennaCounter, :));
                hold on
            end
            xlabel('Angle [deg]');
            ylabel('Channel Capacity [bits/s]');
            xlim([0 180]);
            legend('4 Antennas', '8 Antennas', '16 Antennas');
            subtitle('Channel Capacity for Patch Array');
end