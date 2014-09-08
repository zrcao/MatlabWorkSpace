function zi = interpndim(varargin)
% DESCRIPTION zi = interpndim(x1,x2,x3,...,body,xi1,xi2,xi3,...)
%  interpolates linearly to find zi. The values of the
%  underlying N-D matrix body at the points in vectors x1,x2,...,xn.
%  Vectors x1,x2,...,xn specify the points at which the data is given.
%  This is much in line with interp2 but extended to 
%  1 any number of dimensions
%  2 extrapolates outside xn
%  3 xn can be decreasing
%  4 xn can only sapan dimension n
%  the first dimension x1 must have the same size as the first dimension of the body
%  the second dimension x2 must have the same size as the second dimension of the body
%  and so on
%  the body may have n dimensions
%  xi1,xi2,xi3,... can have any size as long as they match each other
%  singletons will be expanded to fit the other arguments xi1,xi2,...xin
%  zi will receive the "combined" size of xi1,xi2,...,xin  
% SEE ALSO
%  interp2, interp1n
% TRY 
%  interpndim([1;2],[1;2],1) interpndim([1;2],[1 2],[1 2;4 5],[1.1; 2.2],[0.9 1.9]) 
%  interpndim([1;2],[1 2],[1 2;4 5],[1.1  2.2],[0.9 1.9]) 
%  interpndim([1;2],[1 2;4 5],2)
%  size(interpndim(cumsum(rand(10,1)),cumsum(rand(1,10)),rand(10),100*rand(6),100*rand(6))) 

% by Magnus Almgren 050217 endsing MA 050429

narg = (nargin-1)/2; % number of dimensions to interpolate in
lns = endsing(varargin{narg+2:end})-1; % lns+1 and up are singleton dimensions

% shift dimensions of body and x1,x2,x3,... lns+1 dimensions to avoid collision 
% with xi1,xi2,xi3,... 
zi = shiftdim(varargin{narg+1},-lns); % the body
for j = 1:narg
 zi = interp1n(flatten(varargin{j},lns+j),zi,varargin{narg+1+j},lns+j);
end
