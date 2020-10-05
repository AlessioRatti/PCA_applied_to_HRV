function [ri] = berger (R, w, Frs, FsECG)

% BERGER'S ALGORITHM
% WHAT IT DOES
    % applies an algorithm based on a boxcar shifting window to interpolate
    % the values of R in order to find an interpolated frequency every
    % 1/Frs seconds.
%INPUT
    % R: original loaded R peaks 
    % w: witdth of the window used in the algorithm
    % Frs: resampling frequency used for B.A.
    % FsECG: original sampling frequency of the R signal
%output:
    % ri: equally spaced estimate of the HR (beats/s)

delay = R(1);
R = R-delay;
ratio=FsECG/Frs; % it MUST be an integer (eg 128)
tR = R./FsECG;
ri = zeros(1,floor(tR(length(tR))*4)-1);

N=w/2;
while ((N*w/2+w/2)*ratio<R(end)) %central point of the windows is shifting according to the tri scale
    
    app=R(find(R>(N-w/2)*ratio & R<(N+w/2)*ratio));
    
    if(length(app)==0) % there are no r-peaks within the window
        v= (w*ratio)./(R(find(R>=(N+w/2)*ratio, 1))-R(find(R<=(N-w/2)*ratio, 1, 'last')));
    elseif(length(app)>0) %there is at least one r-peak within the window
        v=(app(1)-(N-w/2)*ratio)/(app(1)-R(find(R<=(N-w/2)*ratio, 1, 'last')))+((N+w/2)*ratio-app(end))/(R(find(R>=(N+w/2)*ratio, 1))-app(end))+length(app)-1;
    end
    
    ri(N)=Frs/2*v;
    N=N+1;
end

% clean the output signal from B.A. using its custom clean function
%riC = cleanri (ri, Lri, RR, tRR, tri, Frs);


% SAVING
%{
    if save==1
        DATA = [ri, riC, tri];
        PATHsave = [PATHvar file '_ri.txt'];
        fid = fopen(PATHsave,'w');
        fprintf(fid, 'ri\t\t\t\triC\t\t\t\ttri\n');
        for i = 1:size(DATA,1)
            fprintf(fid,'%f\t\t%f\t\t%.2f', DATA(i,1), DATA(i,2), DATA(i,3));
            fprintf(fid,'\n');
        end
        fclose(fid);
    end
%}

end