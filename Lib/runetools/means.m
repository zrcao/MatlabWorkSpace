function res = means(m, dims)  
% DESCRIPTION res = means(m, dim)
% mean over many dimensions in one call 
% means(a,[j k] == mean(mean(a,j),k)
% INPUT 
%  m --    any matrix 
%  dims --  Any integer matrix greater than 0
% OUTPUT
%  res --  A matrix only spanning dimensions not present in dims.
% TRY
%  means(randn(2,3,4),[2 3]) 

% by Magnus Almgren 050330

if nargin > 1
 for j = 1:length(dims(:))
  m = mean(m,dims(j));
 end
 res = m;
else
 res = mean(m); % the ordinary sum
end
