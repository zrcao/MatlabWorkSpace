function yi = interp1n(x,y,xi,dim)
% DESCRIPTION yi = interp1n(x,y,xi,dim) extension of interp1
%  x, y and xi must be of the same size (or singletons) except along dimension
%  dim where only x and y have to be of the same size. yi will
%  inherit the size from x,y and yi in all dimensions but dim where the size
%  will be the same as of xi. Values outside x will be extrapolated from the two nearest
%  values. Interp1n does only first order interpolation i.e.'linear'
% INPUT
%  x -- a matrix with real values. x must be monotonic along dimension dim
%       but can be decreasing
%  y -- a matrix with possibly complex values
%  xi --   a matrix with real values.
%  dim -- the dimension of x and y along which interpolation is performed
% OUTPUT
%  yi -- the interpolated result 
% SEE ALSO
%  interp1
% TRY 
%  interp1n([0;1],[1;2],0.4) % compare with interp1([1; 0],[2; 1],0.4)
%  interp1n([1;0],[2;1],0.4) % x is decreasing
%  interp1n([1;2],[1;2],0) % extrapolation
%  interp1n([1 2 3],[4 5 7],1.5,2) % along second dimension
%  interp1n(-cumsum(rand(3,2,1)),rand(3,1,2),rand(4,2,2)) % different sizes combined
%  size(interp1n(-cumsum(rand(3,2,1)),rand(3,1,2),rand(4,2,2,3))) % check out sizes

% by Magnus Almgren 030724 revised 050204 MA the empty case

% The dimension dim is default set 1 if not present
if ~exist('dim','var') 
 dim = firstnonsing(x);
end

% Check dimension of x and y
if size(x,dim)~=size(y,dim) | size(x,dim)<2
 error('The size of x and y must be at least 2 and equal along dimension dim');
end

% Align sizes of input arguments except for dimension dim
[x,y,xi] = adjsizabdim(dim,x,y,xi);

% Make sure that x is not both increasing and decreasing along dimension dim
maxd = max(sign(diff(x,[],dim)),[],dim);
mind = min(sign(diff(x,[],dim)),[],dim);
if any(maxd(:)-mind(:)==2)
 error('First argument is both increasing and decreasing along dimension dim');
end

% Flip direction along dimension dim if x is decreasing
flipdir = sign(maxd+mind+0.1); % 1 <=> increasing, -1 <=> decreasing. A small offset added to avoid sign(0) 
flind = mplus(mprod(flipdir,flatten(1:size(x,dim),dim)), (size(x,dim)+1)*(flipdir==-1)); 
flindm = index1(flind,dim,size(x));
x = x(flindm);
y = y(flindm);

% Calculate index for xi into xv
ind = min(vsortind(xi,x,dim),size(x,dim)-1); % indices into x and along dimension dim
 
% Calculate flat indices into a matrix of size(x)
ind1 = index1(ind  ,dim,size(x));
ind2 = index1(ind+1,dim,size(x));
siz = size(ind1);

% Calculate xi-x1 and xi-x2
% reshape makes the size of the indexing operation to follow the size of
% the argument
xix1 = xi - reshape(x(ind1),siz);
xix2 = xi - reshape(x(ind2),siz);

% Calculate y values
y1 = reshape(y(ind1),siz);
y2 = reshape(y(ind2),siz);

% Interpolate 
% mdiv does supress warnings when xix1-xix2 happens to be zero
yi = mdiv(xix1.*y2 - xix2.*y1, xix1-xix2);
