function sm = sizes(varargin) % size for many matrices as a matrix
% DESCRIPTION  res = sizes(a,b,c,...) 
%  Sizes of matrices collected in a matrix. 
% INPUT
%  a -- a matrix of any type 
%  b -- as above
%  c -- as above
% OUTPUT
%  sm -- a matrix with sizes of one matrix per row
% SEE ALSO 
%  sizem, maxsize, size
% TRY 
%  sizes(ones(2,3,4),ones(1,2),ones(5,6,7)) => [2 3 4; 1 2 1; 5 6 7]

% by Magnus Almgren 970529 revised 030930 revised 050517

n = 2;
for j = 1:nargin
 siz = size(varargin{j});
 s{j} = siz;
 n(j) = length(siz);
end
sm = ones(nargin,max(n));
for j = 1:nargin
 sm(j,1:n(j)) = s{j};
end
