function P_RX = RX_power(angle, G_RX)
    params = parameters();
    EIRP_linear = 10e3; % [W]
    dis = ang2dis(angle);
    RX_powerLinear = EIRP_linear .* G_RX .* (params.wavelength ./ (4*pi * dis)).^2;
    P_RX = 10 * log10(RX_powerLinear * 10^3);
end