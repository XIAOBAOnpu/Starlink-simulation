function rainAtten = RainAttenuation(p, angle)
    params = parameters();
    h_R = 2.4;      % [km] alt. of the clouds
    ds = h_R ./ sind(angle);
    k = 0.15 + 0.003 * (cosd(angle)).^2;
    alpha = (0.15 + 0.007 * (cosd(angle)).^2) ./ k;
    gamma = k .* 30.^alpha;

    Lr001 = gamma .* ds;
    Lrp = Lr001 .* (p / 0.01).^(-0.65 - 0.03*log(p) + 0.05*log(Lr001));
    
    rainAtten = Lrp;
end