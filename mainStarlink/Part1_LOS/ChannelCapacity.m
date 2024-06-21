function channelCap = ChannelCapacity(SNR)
    params = parameters();
    snrLinear = 10 .^ (SNR / 10);
    channelCap = params.BW * log2(1 + snrLinear);
end