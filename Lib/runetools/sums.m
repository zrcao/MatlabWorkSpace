function res = sums(m, dims)  
% DESCRIPTION res = sums(m, dim)
% sum over many dimensions in one call 
% sums(a,[j k] == sum(sum(a,j),k)
% INPUT 
%  m --    any matrix 
%  dims --  Any integer matrix greater than 0
% OUTPUT
%  res --  A matrix only spanning dimensions not present in dims.
% TRY
%  sums(randn(2,3,4),[2 3]) 

% by Magnus Almgren 050330

if nargin > 1
 for j = 1:length(dims(:))
  m = sum(m,dims(j));
 end
 res = m;
else
 res = sum(m); % the ordinary sum
end
