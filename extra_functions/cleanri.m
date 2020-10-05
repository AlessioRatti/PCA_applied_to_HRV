function riC = cleanri(ri, Lri, RR, RRC, tRR, tri, Frs, w) %ri RR R length(ri)
% CLEAN ri
% WHAT
    % Calculates std (standard deviation) and mean of the RR signal
    % Using those values as a refence cleans the signal ri from its outliers.
    % A point is an outlier if it differs more than 5*std from the mean.
    
% INPUT
    % ri: signal interpolated using BA
    % Lri: length of the ri signal
    % RR: difference between each couple of adjacent elements in the
    % original signal R
    % tRR: time axis of the RR values
    % LRR: length of the RR array
    % Frs: resampling frequency used in BA
    
% OUTPUT
    % riC: the cleaned version of the ri vector from the values above the threshold

riC=zeros(Lri, 1); % preallocation of the clean ri interpolation

i=1;
while i<=(Lri-1) %sequential reading of all values, the value gets converted to time later (i/Frs)=t
    if ((RR(find(tRR>=i/Frs, 1)))~=(RRC(find(tRR>=i/Frs, 1))))
    % detects if the value of RR got corrected in RRC
        lock = find(tRR>=i/Frs, 1); % locks down the position of the wrong RR value that got corrected
        % hence the previous and following are correct and can be used for
        % interpolation
        x = [tRR(lock-1)-w/Frs tRR(lock+1)+w/Frs]; % pinpoints the time boundaries of the nearest acceptable values in RR
        % units in time [s]
        y1 = round(x(1)*4)/4;
        y2 = round(x(2)*4)/4;
        yri = [ri(find(tri>=y1,1)) ri(find(tri<=y2,1,'last'))]; % finds the closest ri based on time (x vector)
        xri = [tri(find(tri>=y1,1)) tri(find(tri<=y2,1,'last'))];
        coeff = polyfit(xri,yri,1);
        j=xri(1)*Frs;
        while j <= xri(2)*Frs
            riC(j) = polyval(coeff,tri(j));
            j=j+1;
        end 
        i=j;
    else
        riC(i) = ri(i);
        i = i+1;
    end
end
riC(i)=ri(i);

end