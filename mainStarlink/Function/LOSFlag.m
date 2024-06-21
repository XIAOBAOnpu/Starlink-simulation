function LOS_flag = LOSFlag(eleAngle)
    % valid from 0~90 deg, for 90~180 deg it is symmetric
    % if flag = 0 -> LOS not available, consider reflection or defraction
    % if flag = 1 -> LOS
    xWall = 10;
    yWall = 10;
    
    [xSatelitte ySatelitte] = angle2xyPosition(eleAngle);
    

    thetaREF = asind(10 / 30);
    kSatelitte2RX = ySatelitte ./ xSatelitte;

    for flagCounter = 1: 1: length(kSatelitte2RX)
        if (eleAngle(flagCounter) <= 45)
            if (eleAngle(flagCounter) <= thetaREF) 
                LOS_flag(flagCounter) = 0;      % satelitte lower than the wall -> defraction only
            else
                LOS_flag(flagCounter) = 1;      % TX path is blocked by the wall -> defraction + reflection
            end
        else
            LOS_flag(flagCounter) = 2;          % LOS -> LOS
        end
    end
end