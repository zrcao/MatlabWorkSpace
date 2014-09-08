function res = mins(m, dims)  
% DESCRIPTION res = mins(m, dim)
% min over many dimensions in one call 
% mins(a,[j k] == min(min(a,[],j),[],k)
% Note that this function makes use of only two arguments 
% when min would have made use of three.
% INPUT 
%  m --    any matrix 
%  dims --  Any integer matrix greater than 0
% OUTPUT
%  res --  A matrix only spanning dimensions not present in dims.
% TRY
%  mins(randn(2,3,4),[2 3]) 

% by Magnus Almgren 050408

if nargin > 1
 for j = 1:length(dims(:))
  m = min(m,[],dims(j));
 end
 res = m;
else
 res = min(m); % the ordinary min
end
