function res = cate(varargin)  
% DESCRIPTION res = cate(dim,a,b,c)
%  As the ordinary cat function with the added fuctionality that all matrices are
%  expanded to the same size in all dimensions except for dimension dim
% INPUT 
%  dim  --   
%  a,b,c --  Any matrices to be concatenated
% OUTPUT
%  res --  the concatenated result
% TRY
%   cate(1,1,ones(1,2))
%  cate(2,zeros(1,3),ones(2,4))

% by Magnus Almgren 050511 revised 050517

if nargin < 3
 res = cat(varargin{:});
 return
end

% More than two matrices! Align their sizes except for dinmension dim.
[varargin{2:nargin}] = adjsizabdim(varargin{:});

% Concatenate as usual
res = cat(varargin{:});
