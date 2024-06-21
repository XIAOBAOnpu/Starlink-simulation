function PlotBouns1_2(totBitConst, time, channelCap)
    params = parameters();
    figure
    % xAxis = time(1: 180 / params.res / 2);

    indexCount = linspace(1, 180/params.res + 1, 180/params.res + 1);
    indexMidPoint = 180 / params.res / 2 + 1;

    for nFront = 1: 1: indexMidPoint - 1
        nBack = size(indexCount, 2) + 1 - nFront;
        deltaT(nFront) = abs(time(nFront) - time(nBack));
    end

    [maxBits xIndexMax] = max(totBitConst);

    subplot(121)
        plot(time, channelCap);
        xlabel("Time [s]");
        ylabel("Channel Capacity [Bits/s]");
        xlim([0 time(end)]);
        subtitle("Channel Cap. vs Time");
    subplot(122)
        plot(deltaT, totBitConst);
        hold on;
        scatter(deltaT(xIndexMax), maxBits, 'r', 'filled');
        xlabel("Transmission Time (\Delta time) [s]");
        ylabel("Total Bits at Const. Bitrate [Bits]");
        xlim([0 length(deltaT)]);
        subtitle("Total Bits at Const. Bitrate");
end