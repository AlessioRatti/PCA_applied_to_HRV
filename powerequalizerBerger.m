function [Pxx] = powerequalizerBerger(Pxx, F, Frs)

% Equalization of the power using a sinc function after resampling
% procedure as susggested in the paper

    H = (sin((2*pi*F)/Frs)./((2*pi*F)/Frs)).^2;
    H(1) = 1;
    Pxx = Pxx ./ H;
end

