function [VLF, LF, HF, LF_HF, tot_pow] = frequencyDomain(ri,fs,ORDER)
% Different ways to calculate the psd in comparison
% WHAT IT DOES
    % This function returns 4 different power spectrums calculated with
    % different methods:
        % - Welch method
        % - Yule-Walker AR method
        % - Burg method
        % - Prof. Jordi Sola version of the Welch's method

% INPUT
    % sel: input signal (length can be around 5 mins WITHOUT the mean value
    % NFFT: length of the signal you want to calculate the Fourier
    % transform of
    % Fs: sampling frequency of the signal 'sel'
    % WINDOW: array containing the values of a certain window (eg hamming)
    % NOVERLAP: samples of overlap from section to section
    % ORDER: order of the YR and B models
    
%OUTPUT
    % Pxx, PxxYR, Pburg, Spec: array containing the power spectrum
    % calculated with each one of the methods
    % F: frequency axes from 0 to Fs/2 with steps of Fs/2/length(Pxx)

    % Initialize support variables
    avg = mean(ri);
    ri = ri - avg;                      % substract the mean value to eliminate DC component
    NFFT = 2.^(nextpow2(length(ri)));
    
    % Burg method

    [Pburg,F] = pburg(ri,ORDER,NFFT,fs);
    Pburg = powerequalizerBerger(Pburg, F, fs); %equalization
    % [Pxx,F] = pburg(X,ORDER,NFFT,Fs) returns a PSD computed as a function
    % of physical frequency.  Fs is the sampling frequency specified in
    % hertz.
    
    VLF = trapz(F(1:find(F<=0.04, 1, 'last')),Pburg(1:find(F<=0.04, 1, 'last')));
    LF = trapz(F(find(F>0.04,1):find(F<=0.15, 1, 'last')),Pburg(find(F>0.04,1):find(F<=0.15, 1, 'last')));
    HF = trapz(F(find(F>0.15,1):find(F<=0.4, 1, 'last')),Pburg(find(F>0.15,1):find(F<=0.4, 1, 'last')));
    LF_HF = LF/HF;
    x = (1./ri-mean(1./ri)) .* 1000;
    tot_pow = norm(x,2)^2/length(x);
end

