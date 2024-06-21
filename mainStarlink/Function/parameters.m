function params = parameters()
    % ========= parameter =========
    params.fc = 26e9;          % [Hz]  Carrier frequency: 26 GHz.
    params.BW = 40e6;          % [Hz]  Bandwidth: 40 MHz.
    params.EIRP = 40;          % [dBW] Transmitter EIRP: 40 dBW (10 kW).
    params.Fn_RX = 2;          % [dB]  Receiver noise figure: 2 dB.
    params.temp_RX = 275;      % [K]   Receiver antenna temperature: 275 K.
    params.altitude = 500e3;   % [m]   Satellite orbit altitude: 500 km.
    params.Trev = 5668;        % [s]   Satellite revolution period: 5668 s.
    params.rain_rate = 30;     % [mm/h] Rain rate exceeded for 0.01% of the time: 30 mm/h.
    params.Re = 6371e3;        % [m]   radius of the earth.
    params.c = 299792458;      % [m/s] speed of the light.
    params.k = 1.379 * 1e-23;  % [W/(Hz*K)] Boltzmann constant.

    params.res = 0.1;          % [deg] resolution of the angle
    params.wavelength = params.c / params.fc;    % wavelength.
    params.beta = 2*pi / params.wavelength;      % wave vector.
end
