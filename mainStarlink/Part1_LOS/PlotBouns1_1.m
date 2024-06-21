function PlotBouns1_1(rainAttenutaion, rainP_RX, rainSNR, rainChannelCap)
    params = parameters();
    figure
    xAxis = 0: params.res: 180;
    
    subplot(221)
        for pPlotCount = 1: 1: size(rainAttenutaion, 1)
            plot(xAxis, rainAttenutaion(pPlotCount, :));
            hold on;
        end
        legend('p = 1%', 'p = 0.1%', 'p = 0.01%', 'p = 0.001%')
        xlabel("Angle [deg]");
        ylabel("Rain Attenutaion [dB]");
        xlim([0 180]);
        subtitle("Rain Attenutaion");
    
    subplot(222)
        for pPlotCount = 1: 1: size(rainP_RX, 1)
            plot(xAxis, rainP_RX(pPlotCount, :));
            hold on;
        end
        legend('p = 1%', 'p = 0.1%', 'p = 0.01%', 'p = 0.001%')
        xlabel("Angle [deg]");
        ylabel("Rec. Power [dBm] [dB]");
        xlim([0 180]);
        subtitle("Received Power");
    
    subplot(223)
        for pPlotCount = 1: 1: size(rainSNR, 1)
            plot(xAxis, rainSNR(pPlotCount, :));
            hold on;
        end
        legend('p = 1%', 'p = 0.1%', 'p = 0.01%', 'p = 0.001%')
        xlabel("Angle [deg]");
        ylabel("SNR [dB]");
        xlim([0 180]);
        subtitle("SNR");
    
    subplot(224)
        for pPlotCount = 1: 1: size(rainChannelCap, 1)
            plot(xAxis, rainChannelCap(pPlotCount, :));
            hold on;
        end
        legend('p = 1%', 'p = 0.1%', 'p = 0.01%', 'p = 0.001%')
        xlabel("Angle [deg]");
        ylabel("Channel Capacity [bit/s]");
        xlim([0 180]);
        subtitle("Channel Capacity");
end