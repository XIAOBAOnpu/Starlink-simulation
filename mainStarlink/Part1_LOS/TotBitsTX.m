function totBits = TotBitsTX(ChannelCap, angle)
    params = parameters();
    alpha = elevation2center(angle);
    alpha_pos = [alpha(1: (size(alpha, 2) - 1)/2) flip(alpha(1: (size(alpha, 2) - 1)/2+1))];
    N = size(alpha, 2);

    for n = 1: 1: N - 1
        deltaAlpha(n) = abs(alpha(n) - alpha(n+1));
    end

    deltaT = params.Trev * (deltaAlpha / (2*pi));

    totBits = trapz([0 cumsum(deltaT)], ChannelCap);
    
    % N = size(alpha_pos, 2);
    % for n = 1: 1: N - 1
    %     deltaAlpha(n) = abs(alpha_pos(n) - alpha_pos(n+1));
    % end
    % 
    % deltaT = params.Trev * (deltaAlpha / (2*pi));
    % 
    % totBits = trapz([0 cumsum(deltaT)], ChannelCap);
end