function dim = endsing(varargin) % find first non singleton dimension
% DESCRIPTION dim = endsing(a,b,c...)
%  Finds last non singleton dimension plus one in any of the input arguments
%  if all arguments are scalars then dim = 1;
% INPUT
%  a,b,c --  any number of matrices of any kind
% OUTPUT
%  dim -- The last non singleton dimension plus one in any of the matrices 
% SEE ALSO 
%  firstsing, firstnonsing
% TRY 
%  endsing(rand(1,1,2), rand(1,2,2)) => 4

% by Magnus Almgren 03101 fix for the scalar case MA 050304

dims = find(any(sizes(varargin{:})~=1,1));
if isempty(dims)
 dim = 1; % if empty selct first dimension
else
 dim = dims(end)+1;
end

