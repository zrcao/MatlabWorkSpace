function res = maxs(m, dims)  
% DESCRIPTION res = maxs(m, dim)
% max over many dimensions in one call 
% maxs(a,[j k] == max(max(a,[],j),[],k)
% Note that this function makes use of only two arguments 
% when max would have made use of three.
% INPUT 
%  m --    any matrix 
%  dims --  Any integer matrix greater than 0
% OUTPUT
%  res --  A matrix only spanning dimensions not present in dims.
% TRY
%  maxs(randn(2,3,4),[2 3]) 

% by Magnus Almgren 050408

if nargin > 1
 for j = 1:length(dims(:))
  m = max(m,[],dims(j));
 end
 res = m;
else
 res = max(m); % the ordinary max
end
