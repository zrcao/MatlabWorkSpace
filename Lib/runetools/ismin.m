function bind = ismin(x,dim)
% DESCRIPTION bind = ismin(x,dim)
%  Calculates a binary matrix pointing to the minimum element 
%  in that dimension ,
%  otherwise along the first non-singleton dimension.
% INPUT 
%  x --    any matrix
%  dim --  the dimension along which the operation will be performed. 
% OUTPUT 
%  bind --  Binary matrix pointing to the min value in dimension dim.
% TRY
%  ismin([2.3; 3.2]),ismin(rand(5,6),2)
% SEE ALSO 
%  ismax, min, minind

% by Magnus Almgren 030930
if ~exist('dim','var') % defauld dimension dim
 dim = firstnonsing(x); % first non singleton dimension
end
[dummy, ind] = min(x,[],dim); % get index to min values
bind = false(size(x)); % create a logical matrix with filled with "false" 
bind(index1(ind,dim,size(x))) = true; % set true on positions with min values
% $Id: ismin.m,v 1.3 2005/06/10 13:24:56 epkpart Exp $
