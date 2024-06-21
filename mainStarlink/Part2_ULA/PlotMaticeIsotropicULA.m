function PlotMaticeIsotropicULA(angleElevation, numAntenna, PrxIsoTracking, SNRIsoTracking, channelCapIsoTracking)
    figure('Name', 'Isotropic ULA');
        subplot(221)
            for figAntennaCounter = 1: 1: length(numAntenna)
                plot(angleElevation, PrxIsoTracking(figAntennaCounter, :));
                hold on
            end
            xlabel('Angle [deg]');
            ylabel('Received Power [dBm]');
            xlim([0 180]);
            legend('4 Antennas', '8 Antennas', '16 Antennas');
            subtitle('Received Power for Isotropic Array');
        
        subplot(222)
            for figAntennaCounter = 1: 1: length(numAntenna)
                plot(angleElevation, SNRIsoTracking(figAntennaCounter, :));
                hold on
            end
            xlabel('Angle [deg]');
            ylabel('SNR [dB]');
            xlim([0 180]);
            legend('4 Antennas', '8 Antennas', '16 Antennas');
            subtitle('SNR for Isotropic Array');

        subplot(223)
            for figAntennaCounter = 1: 1: length(numAntenna)
                plot(angleElevation, channelCapIsoTracking(figAntennaCounter, :));
                hold on
            end
            xlabel('Angle [deg]');
            ylabel('Channel Capacity [bits/s]');
            xlim([0 180]);
            legend('4 Antennas', '8 Antennas', '16 Antennas');
            subtitle('Channel Capacity for Isotropic Array');
end