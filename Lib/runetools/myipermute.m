function varargout = myipermute(varargin) 
% DESCRIPTION [b1, b2, b3,...] = myipermute(a1, a2, a3,...,dims)
%  as ipermute but extended freedom in dims
% INPUT 
%  a1,a2,a3...  -- A matrices of any kind to operate on
%  dims         -- A ipermutation order  
% OUTPUT
%  b1,b2,b3,... -- The input matrix list a where the dimensions have changed places.
% SEE ALSO 
%  ipermute
% TRY
%  size(myipermute(ones(1,2,3),[]))
%  size(myipermute(ones(1,2,3),[2 1]))
%  size(myipermute(ones(1,2,3),[2]))
%  size(myipermute(ones(1,2),[3]))
%  [a, b] = myipermute(ones(1,2),ones(1,1,2),[3])

% by Magnus Almgren 050131
dims = varargin{end};
for j = 1:min(max(1,nargout),nargin-1)
 odims = 1:max([dims, ndims(varargin{j})]); % original order
 odims(dims) = []; % erase old ones
 varargout{j} = ipermute(varargin{j},[dims odims]); % concatenate new ones and ipermute
end