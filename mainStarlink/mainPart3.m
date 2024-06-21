clc;
clear;
close all;

addpath(genpath('Part1_LOS'));
addpath(genpath('Part3_rayTracing'));
addpath(genpath('Function'));
params = parameters();
EIRPlinear = 10e3;

angle = 0: params.res: 90;
rayFlag = LOSFlag(angle);

[xSatelitte, ySatelitte] = angle2xyPosition(angle);


for antennaCount = 1: 1: 3

    % ULA here assuming 1 antenna with prefect pointing
    % to change:
    % -> choose the index of the depointing angle from here:
    % depointingAngle = [0, 0.2: 0.3: 2];
    % -> choose the index of the number of antennas from here:
    % numAntennaDepoint = [1: 5: 1201];
    % and replace the index into this .mat: gainIsoDepoint/gainPatDepoint below
    % load('isoDepoint.mat');
    % load('patDepoint.mat');
    load('isoTracking.mat', 'gainIsoTracking');
    load('patTracking.mat', 'gainPatTracking');
    % GIso = isoDepoint(2, :, antennaCount);
    % GPat = patDepoint(2, :, antennaCount);
    GIso = gainIsoTracking(antennaCount, :);
    GPat = gainPatTracking(antennaCount, :);
    % N.B.: In this 3D mat, the first index is number of antennas, the third is
    % depointing angle
    
    % rayFlag = [rayFlag flip(rayFlag(1: end - 1))];
    %% ================================== to calc. ISO ================================== 
    for flagCounter = 1: 1: length(rayFlag)
        if rayFlag(flagCounter) == 0     % defraction only
            Factor = knifeEdge(xSatelitte(flagCounter), ySatelitte(flagCounter));
            distancesLOS = sqrt((xSatelitte(flagCounter))^2 + (ySatelitte(flagCounter))^2);
            LOS = (params.wavelength / (4*pi))^2 * GIso(flagCounter) * EIRPlinear * abs(exp(-1j*params.beta*distancesLOS) / distancesLOS)^2;
            PrxIso(flagCounter) = Factor * LOS;
                
        elseif rayFlag(flagCounter) == 1    % reflection
            FactorREF = reflectionFactor(xSatelitte(flagCounter), ySatelitte(flagCounter));
            distancesNLOScompare = sqrt((xSatelitte(flagCounter) + 20)^2 + (ySatelitte(flagCounter))^2);
            % 1 antenna + perfect point
            PrxIsocompareREF = (params.wavelength / (4*pi))^2 * GIso(flagCounter) * EIRPlinear * abs(FactorREF* ...
                exp(-1j*params.beta*distancesNLOScompare) / distancesNLOScompare)^2;

            FactorDIF = knifeEdge(xSatelitte(flagCounter), ySatelitte(flagCounter));
            distancesLOScompare = sqrt((xSatelitte(flagCounter))^2 + (ySatelitte(flagCounter))^2);
            LOScompare = (params.wavelength / (4*pi))^2 * GIso(flagCounter) * EIRPlinear * abs(exp(-1j*params.beta*distancesLOScompare) / distancesLOScompare)^2;
            PrxIsocompareDIF = FactorDIF * LOScompare;
                if flagCounter == 401
                xxx=xSatelitte(flagCounter);
                yyy=ySatelitte(flagCounter)
                aaa=FactorREF;
                bbb=FactorDIF;
            end
            if abs(PrxIsocompareREF) > abs(PrxIsocompareDIF)
                PrxIso(flagCounter) = PrxIsocompareREF;
            else
                PrxIso(flagCounter) = PrxIsocompareDIF;
            end
    
        else    % LOS
            distancesLOS = sqrt((xSatelitte(flagCounter))^2 + (ySatelitte(flagCounter))^2);
            PrxIso(flagCounter) = (params.wavelength / (4*pi))^2 * GIso(1, flagCounter, 1) * EIRPlinear * abs(exp(-1j*params.beta*distancesLOS) / distancesLOS)^2;
        end
    end
    PrxIsoTemp = 10 * log10(PrxIso * 1e3);    % convert to dbm
    SNRIsoTemp = SNR_dB(PrxIsoTemp);
    channelCapIsoTemp = ChannelCapacity(SNRIsoTemp);
    
    PrxIsoFinal(antennaCount, :) = [PrxIsoTemp flip(PrxIsoTemp(1: end - 1))];
    SNRIsoFinal(antennaCount, :) = [SNRIsoTemp flip(SNRIsoTemp(1: end - 1))];
    channelCapIsoFinal(antennaCount, :) = [channelCapIsoTemp flip(channelCapIsoTemp(1: end - 1))];
    totalBitsTXIsoFinal(antennaCount) = TotBitsTX(channelCapIsoFinal(antennaCount, :), [0: params.res: 180]); 
    
    %% ================================== to calc. Prx PAT ================================== 
    for flagCounter = 1: 1: length(rayFlag)
        if rayFlag(flagCounter) == 0     % defraction only
            Factor = knifeEdge(xSatelitte(flagCounter), ySatelitte(flagCounter));
            distancesLOS = sqrt((xSatelitte(flagCounter))^2 + (ySatelitte(flagCounter))^2);
            LOS = (params.wavelength / (4*pi))^2 * GPat(flagCounter) * EIRPlinear * abs(exp(-1j*params.beta*distancesLOS) / distancesLOS)^2;
            PrxPat(flagCounter) = Factor * LOS;
        elseif rayFlag(flagCounter) == 1    % reflection
            FactorREF = reflectionFactor(xSatelitte(flagCounter), ySatelitte(flagCounter));
            distancesNLOScompare = sqrt((xSatelitte(flagCounter) + 20)^2 + (ySatelitte(flagCounter))^2);
            % 1 antenna + perfect point
            PrxPatcompareREF = (params.wavelength / (4*pi))^2 * GPat(flagCounter) * EIRPlinear * abs(FactorREF* ...
                exp(-1j*params.beta*distancesNLOScompare) / distancesNLOScompare)^2;
            
            FactorDIF = knifeEdge(xSatelitte(flagCounter), ySatelitte(flagCounter));
            distancesLOScompare = sqrt((xSatelitte(flagCounter))^2 + (ySatelitte(flagCounter))^2);
            LOScompare = (params.wavelength / (4*pi))^2 * GPat(flagCounter) * EIRPlinear * abs(exp(-1j*params.beta*distancesLOScompare) / distancesLOScompare)^2;
            PrxPatcompareDIF = FactorDIF * LOScompare;
    
            if abs(PrxPatcompareREF) > abs(PrxPatcompareDIF)
                PrxPat(flagCounter) = PrxPatcompareREF;
            else
                PrxPat(flagCounter) = PrxPatcompareDIF;
            end
    
        else    % LOS
            distancesLOS = sqrt((xSatelitte(flagCounter))^2 + (ySatelitte(flagCounter))^2);
            PrxPat(flagCounter) = (params.wavelength / (4*pi))^2 * GPat(1, flagCounter, 1) * EIRPlinear * abs(exp(-1j*params.beta*distancesLOS) / distancesLOS)^2;
        end
    end
    PrxPatTemp = 10 * log10(PrxPat * 1e3);    % convert to dbm
    SNRPatTemp = SNR_dB(PrxPatTemp);
    channelCapPatTemp = ChannelCapacity(SNRPatTemp);
    
    PrxPatFinal(antennaCount, :) = [PrxPatTemp flip(PrxPatTemp(1: end - 1))];
    SNRPatFinal(antennaCount, :) = [SNRPatTemp flip(SNRPatTemp(1: end - 1))];
    channelCapPatFinal(antennaCount, :) = [channelCapPatTemp flip(channelCapPatTemp(1: end - 1))];
    totalBitsTXPatFinal(antennaCount) = TotBitsTX(channelCapPatFinal(antennaCount, :), [0: params.res: 180]); 
end

%%  ================================== plot  ================================== 
figure('Name', 'Iso. Antenna')
subplot(221)
    for plotCounter = 1: 1: size(PrxIsoFinal, 1)
        plot([0: params.res: 180], PrxIsoFinal(plotCounter, :)); 
        hold on;
    end
    xlabel("Angle [deg]");
    ylabel("Rec. Power [dBm]");
    xlim([0 180]);
    legend('4 antennas', '8 antennas', '16 antennas');
    subtitle("Received Power");
subplot(222)
    for plotCounter = 1: 1: size(SNRIsoFinal, 1)
        plot([0: params.res: 180], SNRIsoFinal(plotCounter, :));
        hold on;
    end
    xlabel("Angle [deg]");
    ylabel("SNR [dB]");
    xlim([0 180]);
    legend('4 antennas', '8 antennas', '16 antennas');
    subtitle("SNR");
subplot(223)
    for plotCounter = 1: 1: size(channelCapIsoFinal, 1)
        plot([0: params.res: 180], channelCapIsoFinal(plotCounter, :));
        hold on;
    end
    xlabel("Angle [deg]");
    ylabel("Channel Capacity [bit/s]");
    xlim([0 180]);
    legend('4 antennas', '8 antennas', '16 antennas');
    subtitle("Channel Capacity");

figure('Name', 'Pat. Antenna')
subplot(221)
    for plotCounter = 1: 1: size(PrxPatFinal, 1)
        plot([0: params.res: 180], PrxPatFinal(plotCounter, :)); 
        hold on;
    end
    xlabel("Angle [deg]");
    ylabel("Rec. Power [dBm]");
    xlim([0 180]);
    legend('4 antennas', '8 antennas', '16 antennas');
    subtitle("Received Power");
subplot(222)
    for plotCounter = 1: 1: size(SNRPatFinal, 1)
        plot([0: params.res: 180], SNRPatFinal(plotCounter, :));
        hold on;
    end
    xlabel("Angle [deg]");
    ylabel("SNR [dB]");
    xlim([0 180]);
    legend('4 antennas', '8 antennas', '16 antennas');
    subtitle("SNR");
subplot(223)
    for plotCounter = 1: 1: size(channelCapPatFinal, 1)
        plot([0: params.res: 180], channelCapPatFinal(plotCounter, :));
        hold on;
    end
    xlabel("Angle [deg]");
    ylabel("Channel Capacity [bit/s]");
    xlim([0 180]);
    legend('4 antennas', '8 antennas', '16 antennas');
    subtitle("Channel Capacity");