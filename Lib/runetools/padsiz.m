function varargout = padsiz(pad, varargin)
% DESCRIPTION [a,b,...] = padsiz(pad,a,b,...)
%  Will extend dimensions of each input argument to maximum 
%  size of the other arguments.
% INPUT
%  pad --       Nonfilled areas are padded with this value.
%  varargin --  Matrices of any size
% OUTPUT
%  The result is matrices of the same size.
%  The nonfilled areas are padded with pad.
% TRY
%  [a, b] = padsiz(NaN, ones(1,2), ones(2,1))
% SEE ALSO 
%  adjsiza,adjsiz,repelem

% by Magnus Almgren 990317

dim = maxsize(varargin{:});
for i = 1:length(varargin)  % Go through all arguments.
 varargout{i} = zeros([dim 1])+pad;
 siz = size(varargin{i});
 if ~any(siz==0)
  ind = indpart(dim, siz);
  varargout{i}(ind) = varargin{i}(:);
 end
end

function ind = indpart(dimb, dims)
% DESCRIPTION ind = indpart(dims, dimb)
%  Calculates index from a smaller matrix into a bigger.
% INPUT
%  dims --  The size of the smaller matrix.
%  dimb --  The size of the bigger matrix.
% OUTPUT
%  ind --   An index in the first dimension.
% TRY
%  indpart(size(ones(3,2)),size(ones(1,2)))

% by Magnus Almgren 981001

for j = 1:length(dims)
 v{j}=flatten(1:dims(j),j);
end
v{length(dims)+1} = dimb;
ind = flatten(index(v{:}));
% $Id: padsiz.m,v 1.3 2005/06/10 13:24:56 epkpart Exp $
