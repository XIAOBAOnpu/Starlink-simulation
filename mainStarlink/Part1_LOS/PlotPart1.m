function PlotPart1(pathLoss, P_RX, SNR, channelCap)
    params = parameters();
    figure
    xAxis = 0: params.res: 180;
    
    subplot(221)
        plot(xAxis, pathLoss);
        xlabel("Angle [deg]");
        ylabel("Free-Space Path Loss [dB]");
        xlim([0 180]);
        subtitle("Free-Space Path Loss");
    
    subplot(222)
        plot(xAxis, P_RX);
        xlabel("Angle [deg]");
        ylabel("Rec. Power [dBm]");
        xlim([0 180]);
        subtitle("Received Power");
    
    subplot(223)
        plot(xAxis, SNR);
        xlabel("Angle [deg]");
        ylabel("SNR [dB]");
        xlim([0 180]);
        subtitle("SNR");
    
    subplot(224)
        plot(xAxis, channelCap);
        xlabel("Angle [deg]");
        ylabel("Channel Capacity [bit/s]");
        xlim([0 180]);
        subtitle("Channel Capacity");
end