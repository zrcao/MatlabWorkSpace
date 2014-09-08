function flind = indexn(varargin)
% DESCRIPTION flind = indexn(ind1,dim1,ind2,dim2,ind3,dim3,...,siz)
% Calculates flat index into a matrix 
% with reordering in several specific dimensions
% INPUT 
%  ind1 --  any matrix with indices in dimension dim.
%  dim1 --  the dimension along which the operation will be performed.
%  ind2 --  any matrix with indices in dimension dim.
%  dim2 --  the dimension along which the operation will be performed.
%  ind3 --  any matrix with indices in dimension dim.
%  dim3 --  the dimension along which the operation will be performed.
%  ...
%  siz --  size of the matrix to which the index willbe applied.
% OUTPUT 
%  flind -- index into a matrix of size siz.
% TRY
% SEE ALSO 
%  index,index1,sub2ind,ind2sub

% by Magnus Almgren 050815 
mdim = max([varargin{2:2:end-1}]);
siz = varargin{end};
siz(numel(varargin{end})+1:mdim) = 1;
for i = 1:length(siz)
 v{i} = flatten((1:siz(i)),i); % assume all dimensions are just flat
end
for j = 1:2:nargin-1
 v{varargin{j+1}} = varargin{j}; % change the order for some of them
end
v{length(siz)+1} = siz; %
flind = index(v{:});
% $Id: indexn.m,v 1.1 2005/08/16 13:39:55 eraalm Exp $
