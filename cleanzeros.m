function [OUT] = cleanzeros(IN)
% Removes all zeros from a vector
%   We use zeros to make the dimensions of the matrix match for all 
%   patients, however we need to remove them for further calculations

OUT = IN(IN>0);

end

