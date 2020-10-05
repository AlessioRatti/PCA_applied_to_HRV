function [RRC] = cleanRR (RR, tRR, FsECG, threshold, moving_average, graph)

% CLEAN RR
% WHAT
    % Calculates std (standard deviation) and mean of the RR signal
    % Using those values as a refence cleans the signal from its outliers.
    % A point is an outlier if it differs more than 4std from the mean.
% INPUT
    % RR: difference between each couple of adjacent elements in the
    % original signal
% OUTPUT
    % RRC: the cleaned version of the RR vector from the values above the threshold

    LRR = length(RR);
    RRC = zeros(LRR, 1);            % vector preallocation
    RRC(1:5) = RR(1:5);
    if(mod(moving_average, 2)==0)   % moving_average needs to be an odd value
        moving_average=moving_average+1;
    end
        
    % first part of untreated signal due to moving average
    RRC(1:moving_average)=RR(1:moving_average);
    
    m = zeros((LRR-moving_average),1);
    s = zeros((LRR-moving_average),1);

    %M = movmean(RR, moving_average, );
    for i = moving_average+1:LRR %sequential reading of all values
        m(i-moving_average) = mean(RRC(i-moving_average:i-1));% moving mean
        s(i-moving_average) = std(RRC(i-moving_average:i-1));% moving standard deviation
        if (RR(i)>m(i-moving_average)+threshold.*s(i-moving_average)||RR(i)<m(i-moving_average)-threshold.*s(i-moving_average)) %detects if the valueas are outliers
            y = [RR(i-1) RR(i+1)];
            x = [tRR(i-1) tRR(i+1)];
            coeff = polyfit(x,y,1);
            RRC(i) = polyval(coeff,tRR(i));
        else
            RRC(i)=RR(i);
        end
    end
    if graph == 1
    % plotting
        figure
        plot(tRR, RR./FsECG.*1000, '-o') % original signal
        hold on
        plot(tRR, RRC./FsECG.*1000)  % corrected signal
        hold on
        plot(tRR(moving_average+1:LRR), (m+threshold.*s)./FsECG.*1000) %upper boundary
        hold on
        plot(tRR(moving_average+1:LRR), (m-threshold.*s)./FsECG.*1000) %lower boundary
        legend('RR', 'RR clean', 'Upper boundary', 'Lower boundary')
        ylabel('RR [ms]'), xlabel('time [s]')
        grid on

    end

end