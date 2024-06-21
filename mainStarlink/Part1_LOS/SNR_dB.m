function snr = SNR_dB(P_RX)
    % P_RX in dBm
    params = parameters();
    snr = P_RX - 30 - params.Fn_RX - 10 * log10(params.k * params.temp_RX * params.BW);
end