function [meanRR, meanHR, range, SDNN, RMSSD, NN50, pNN50, HRVti] = timeDomain(RR, FsECG)
% Extraction of time-domain variables
% WHAT IT DOES
    % Calculates some of the simplest time-domain variables using the
    % tachogram
% INPUT
    % RR: RR differences (tachogram)
    % FsECG: original sampling frequency of the ECG
% OUTPUT
    % meanRR [mS]
    % meanHR [bpm]
    % range [mS]


%% 1st Part: Simple time-domain variables
    meanRR = mean(RR)./FsECG.*1000;
    meanHR = 1/mean(RR).*FsECG.*60;
    range = (max(RR)-min(RR))/FsECG*1000;
    
 %% 2nd Part: Statistical time-domain measures
 
    %--------------------------------------------------------------------------    
% Standard deviation of the whole recording (can also be calculated over
% short periods of 5 mins)
% SDNN: Standard Deviation of the NN intervals
    
    SDNN = std(RR./FsECG.*1000);

%--------------------------------------------------------------------------
% SDANN: standard deviation of the average NN interval calculate over short
% periods (5min) ==>1 min for SAHS
% The window shifts of half a window at a time ==> the windows shift for an
% entire length (1 min)

%     shortSDANN=5; % window length in minutes (short window)
%     mean5min=zeros(floor(tRR(length(tRR))./(shortSDANN*60)), 1);
%     % (calculates the row of windows)
%     % preallocates the vector
%     i=1; % keeps the time scale in windows
%     while (i*shortSDANN*60)<=tRR(length(tRR))
%         mean5min(i)=mean(RRC(find( (tRR>=((i-1)*shortSDANN*60)) & (tRR<=(i*shortSDANN*60)) )));
%         % finds and averages all the RR values inside the 5-min-long window
%         i=i+1;
%     end
%     mediatot = mean(RRC)./FsECG.*1000;
%     mean5min = mean5min./FsECG.*1000; % samples ==> seconds ==> ms    
%     SDANN = std(mean5min);

%--------------------------------------------------------------------------
% SDNN index: the mean of the 5-min std deviation of the NN interval
% calculated over 24H (long recording)
% Windows shortened to 1 min for SAHS

%     shortSDNNI=5; % lenght of the window = 1 min
%     std5min=zeros(floor(tRR(length(tRR))./(shortSDNNI*60)), 1);
%     i=1; % keeps the time scale in seconds
%     while (i)*shortSDNNI*60<=tRR(length(tRR))
%         std5min(i)=std(RRC(find( (tRR>=((i-1)*shortSDNNI*60)) & (tRR<=(i*shortSDNNI*60)) )));
%         i=i+1;
%     end
%     
%     mediatot = mean(RRC)./FsECG.*1000;
%     std5min = std5min./FsECG.*1000; % samples ==> seconds ==> ms    
%     SDNNI = mean(std5min);

%--------------------------------------------------------------------------
%RMSSD: the square root of the mean of the squared differences of successive NN
%intervals
    
    RMSSD = sqrt(1/(length(RR)).*sum((diff(RR./FsECG.*1000)).^2));

%--------------------------------------------------------------------------
% NN50: the number of interval differences of successive NN intervals
% greater than 50ms

    NN50 = sum(abs(diff(RR)./FsECG.*1000)>50);

%--------------------------------------------------------------------------
% pNN50: NN50/(total number of NN intervals)

    pNN50 = NN50/length(RR).*100;
    
%--------------------------------------------------------------------------
%% Geometrical methods
% HRV triangular index
    
    
    %Histogram of the NN intervals
    % conversion of RR from samples difference into actual time difference
    RR_t = RR./FsECG; % [samples --> mS]
    [SDD,~] = histcounts(RR_t, 'binwidth', 1/128);
    HRVti = sum(SDD)/max(SDD);
   

%     nbins = 
%     h = histogram(RR,nbins)
%      = (RR./FsECG.*1000)/length(RR); %NN intervals
%     bins = ceil(length(NN)/8); % total bins 
%     numNN = NN/bins; % num of NN in each bin?
%     HRV3I = length(NN)/numNN; %3angular index
    
end

