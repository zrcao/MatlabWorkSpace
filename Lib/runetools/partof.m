function res = partof(m,varargin)
% DESCRIPTION res = partof(m,dim1,ind1,dim2,ind2,dim3,ind3,...)
%  Part of matrix m in dimensions dim1,dim2,dim3,... with indices
%  ind1,ind2,ind3,...
% INPUT
%  m     -- any matrix
%  dim1,dim2,dim3   -- dimension in which the matrix will change size
%  ind1,ind2,ind3   -- an adress argument like 1:3 or logicaL([1 1 0 1])
% OUTPUT
%  res   -- a part of matrix m 
% SEE ALSO
%  padsiz
% TRY 
%  partof(magic(3),1,2:3)
%  partof(magic(3),2,2:3)
%  partof(magic(3),2,[1 1])
%  partof(magic(3),2,logical([1 0 1]))
%  partof(magic(3),4,':')
%  partof(magic(3),1,1:2,2,1:2)

% by Magnus Almgren 050111 updated 050614

% the maximum number of dimension in the resulting matrix
maxdim = ndims(m);
for j = 2:2:nargin-1
 maxdim = max(maxdim,varargin{j-1});
end

for j = 1:maxdim % Colon as a string is valid for some reason. Is it documented?
 adr{j} = ':';
end

for j = 2:2:nargin-1
 adr{varargin{j-1}} = varargin{j};
end

res = m(adr{:});
