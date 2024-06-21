function PlotSingleAntennaRadiatedIntensity()
    % Radiated angle
    theta = linspace(0, pi, 361);

    % Radiated intensity
    U0_patch = sin(theta).^2; 
    U0_iso = 1;

    % plot
    figure
    subplot(121)
    polarplot(theta, U0_iso .* ones(size(theta)), 'LineWidth', 2);
    subtitle('Radiated intensity Isotropic')
    subplot(122)
    polarplot(theta, U0_patch .* ones(size(theta)), 'LineWidth', 2);
    subtitle('Radiated intensity Patch')

    pax = gca;
    pax.ThetaTickLabel = string(pax.ThetaTickLabel) + char(176);
end
