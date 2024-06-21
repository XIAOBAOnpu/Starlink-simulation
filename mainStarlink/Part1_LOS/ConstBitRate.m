function [totBits totBitsMax totBitsMaxIndex]= ConstBitRate(time, channelCap)
    params = parameters();
    indexCount = linspace(1, 180/params.res + 1, 180/params.res + 1);
    indexMidPoint = 180 / params.res / 2 + 1;

    for nFront = 1: 1: indexMidPoint - 1
        nBack = size(indexCount, 2) + 1 - nFront;
        totBits(nFront) = abs(time(nFront) - time(nBack)) * channelCap(nFront);
    end
    [totBitsMax totBitsMaxIndex]= max(totBits);
    channelCapMax = channelCap(totBitsMaxIndex);

    
    % disp(['ChannelCap Max the TotBits = ', num2str(channelCapMax)]);
    % % assume the totbits in the mid is equal to adjcent one
    % totBitsMid(indexMidPoint) = totBits(indexMidPoint - 1);  
    % 
    % totBits = [totBits totBitsMid flip(totBits)]
end

