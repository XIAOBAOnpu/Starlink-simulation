clc;
clear;
close all;

addpath(genpath('Part1_LOS'));
addpath(genpath('Function'));
params = parameters();

angle = 0: params.res: 180;
G_RX = 1;

%% =============================== Part 1 =============================== 
pathLoss = PathLoss(angle);
P_RX = RX_power(angle, G_RX);
SNR = SNR_dB(P_RX);
channelCap = ChannelCapacity(SNR);
totalBitsTX = TotBitsTX(channelCap, angle); 
% should be e9 if unit in bits
% but e8 if unit in bytes (divide by 8)

PlotPart1(pathLoss, P_RX, SNR, channelCap);
disp(['TotBits During One Pass = ', num2str(totalBitsTX/8), ' Bytes ']);
%% =============================== Bonus 1.1 =============================== 
% for p% --> means that it has p% of chances that exceed some amount of
% rain rate
angleRain = [];
p = [1 0.1 0.01 0.001];

for angleCount = 1: length(angle)
    if angle(angleCount) <= 20
        angleRain(angleCount) = 20;
    elseif angle(angleCount) >= 160
        angleRain(angleCount) = 160;
    else
        angleRain(angleCount) = angle(angleCount);  % only [20, 160] deg considered
    end
end

for pCount = 1: 1: numel(p)
    rainAttenutaion(pCount, :) = RainAttenuation(p(pCount), angleRain);
    rainP_RX(pCount, :) = P_RX - rainAttenutaion(pCount, :);
    rainSNR(pCount, :) = SNR_dB(rainP_RX(pCount, :));
    rainChannelCap(pCount, :) = ChannelCapacity(rainSNR(pCount, :));
    rainTotalBitsTX(pCount) = TotBitsTX(rainChannelCap(pCount, :), angleRain);
end

PlotBouns1_1(rainAttenutaion, rainP_RX, rainSNR, rainChannelCap);

%% =============================== Bonus 1.2 =============================== 
time = angle2time(angle);
disp(['========================== Constant Bits ==========================']);
[totBitConst totBitsConstMax totBitsConstMaxIndex] = ConstBitRate(time, channelCap);
disp(['Max TotBits without Rain = ', num2str(totBitsConstMax/8), ' Bytes at Angle ', num2str(angle(totBitsConstMaxIndex))]);


[rainTotBitConst1 rainTotBitsConstMax1 rainTotBitsConstMaxIndex1] = ConstBitRate(time, rainChannelCap(1, :));
disp(['Max TotBits with p ',num2str(p(1)), ' = ', num2str(rainTotBitsConstMax1/8), ' Bytes at Angle ', num2str(angle(rainTotBitsConstMaxIndex1))]);

[rainTotBitConst01 rainTotBitsConstMax01 rainTotBitsConstMaxIndex01] = ConstBitRate(time, rainChannelCap(2, :));
disp(['Max TotBits with p ',num2str(p(2)), ' = ', num2str(rainTotBitsConstMax01/8), ' Bytes at Angle ', num2str(angle(rainTotBitsConstMaxIndex01))]);

[rainTotBitConst001 rainTotBitsConstMax001 rainTotBitsConstMaxIndex001] = ConstBitRate(time, rainChannelCap(3, :));
disp(['Max TotBits with p ',num2str(p(3)), ' = ', num2str(rainTotBitsConstMax001/8), ' Bytes at Angle ', num2str(angle(rainTotBitsConstMaxIndex001))]);

[rainTotBitConst0001 rainTotBitsConstMax0001 rainTotBitsConstMaxIndex0001] = ConstBitRate(time, rainChannelCap(4, :));
disp(['Max TotBits with p ',num2str(p(4)), ' = ', num2str(rainTotBitsConstMax0001/8), ' Bytes at Angle ', num2str(angle(rainTotBitsConstMaxIndex0001))]);

PlotBouns1_2(totBitConst, time, channelCap);


% [a,b,c]=sphere(99);
% surf(a,b,c);colormap cool
% hold on
% % 在球面外生成一些随机点% 进行三角剖分后% 设置成半透明冷色% 一些透明三角形交错叠加形成炫酷星球
% x=randn(3,999);       
% x=1.01*x./vecnorm(x);p=delaunay(x');h=patch('faces',p,'vertices',x','FaceVertexCData',cool(size(p,1)),'FaceAlpha',.25);
% % 设置坐标区域比例
% axis equal off
% % 设置背景色
% set(gcf,'color','k')
% set(gcf,'InvertHardCopy','off')% 平滑星球表面配色
% shading flat
% % 在星球外生成一些随机点当作星星
% r=@()rand(1,3e2);scatter(r()*10-5,r()*10-5,r().^2*200,'.w');camva(2)
