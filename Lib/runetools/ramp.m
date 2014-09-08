function n = ramp(siz,dim)
% DESCRIPTION n = ramp(siz,dim)
%  Creates a ramp along dimension dim in a matrix of size siz.
% The values in the result are thus 1:siz(dim)
% INPUT
%   siz -- size of the generated matrix
%   dim -- dim ension in which the ramp is generated
% OUTPUT 
%  n -- A matrix of size according to siz containing the ramp
% TRY
%  ramp([4 3 2],2)
% SEE ALSO 
%  nans, zeros, ones, infs

% by Magnus Almgren 050820

n = mplus(zeros(siz),flatten(1:siz(dim),dim));
