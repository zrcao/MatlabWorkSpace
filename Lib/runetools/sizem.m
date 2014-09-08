function res = sizem(m, dims)
% DESCRIPTION res = sizem(m, dims) 
%  For a matrix m the size is given for each element of dims.
%  Dims is the dimensions for which the size is determined.
%  If dims is omitted then the size of all dimensions of m are delivered
%  as by the function size.
% INPUT 
%  m --    A matrix of any size.
%  dims -- A matrix with dimensions for which the size will be determined. 
% OUTPUT 
%  res --  a matrix of the same size as dims containing the corresponding sizes.  
% TRY 
%  sizem(ones(2,3,4)) => [2 3 4]
%  sizem(ones(2,3,4), [2 3]) => [3 4]
% SEE ALSO 
%  sizes, ndims

% by Magnus Almgren 030930 revised 031120

if nargin < 2 % default the ordinary size function
 res = size(m);
 return
end
res = dims; % output has the same size as the input 
for i = 1:length(dims(:))
 res(i) = size(m,dims(i));
end

% $Id: sizem.m,v 1.3 2005/06/10 13:24:56 epkpart Exp $
