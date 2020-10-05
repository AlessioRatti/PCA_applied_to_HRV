function [selected] = loadsignal (FsECG, PATHsig, guarda, tmin, type)

% LOADSIGNAL
% WHAT IT DOES
    % This function loads all the signals and stores in a matrix the ones
    % tha fullfill the temporal requirements while making sure that they
    % are upright (it also performs saving of the matrix).
% INPUT
    % fsECG: sampling frequency of the ECG used in the signal that will be
    % loaded. It's used to calculate the time requirements
    % PATHsig: path of the stored signals
 %OUTPUT
    % selected: matrix with n rows (= # of signals that fullfill the
    % temporal requirements) and m columns ( = tmin*FsECG)
    
    for i=1:758
        s = num2str(i);
        patientARR(i) = strcat(s, ".mat");
    end
    
    selected = [];
    for i = 1:length(patientARR)
        ECG_temp = load(strcat(PATHsig, patientARR(i)));
        ECG_temp = ECG_temp.C;
        if mean(ECG_temp)<0  % Checking if the signal is upside down or not
            ECG_temp = ECG_temp*(-1);
        end
        if length(ECG_temp)>=(tmin*FsECG)
            selected = [selected; ECG_temp(1:tmin*FsECG)];
        end
    end
    
    % SAVING for future importing
    if guarda==1
        PATHsave = strcat(PATHsig, "tmin_", num2str(tmin), type, ".mat");
        save(PATHsave,'selected');
    end
end