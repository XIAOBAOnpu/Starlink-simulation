function F = knifeEdge(xSatelitte, ySatelitte)
    params = parameters();
    
    yWall = 10;     
    xWall = 10;        
    s1 = 10 * sqrt(2);
    s2 = sqrt((xSatelitte - xWall)^2 + (ySatelitte - yWall)^2);
    
    LOSdis = sqrt(xSatelitte^2 + ySatelitte^2);
    deltaR = s1 + s2 - LOSdis;
    %Qdisp(deltaR);
    v = sqrt(2 * params.beta / pi * deltaR);
    disp(v)

      
        FdB = -6.9 - 20*log10(sqrt((v-0.1)^2 + 1) + v - 0.1);
        F = sqrt(10^(FdB / 10));

    %disp()
end
