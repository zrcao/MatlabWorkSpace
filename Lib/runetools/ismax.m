function bind = ismax(x,dim)
% DESCRIPTION bind = ismax(x,dim)
%  Calculates a binary matrix pointing to the maximum element 
%  in that dimension. Default dim is set to the first non singleton dimension
%  If no such dimension dim is set to 1.
% INPUT 
%  x --    any matrix
%  dim --  the dimension along which the operation will be performed.
% OUTPUT 
%  bind --  Binary matrix pointing to the max value in dimension dim.
% TRY
%  ismax([2.3; 3.2]),ismax(rand(5,6),2)
% SEE ALSO 
%  ismin, max, maxind

% by Magnus Almgren 011023 revised 040202
if ~exist('dim','var') % defauld dimension dim
 dim = firstnonsing(x); % first non singleton dimension
end
[dummy, ind] = max(x,[],dim);  % get index to max values
bind = false(size(x));  % create a logical matrix with filled with "false"
bind(index1(ind,dim,size(x))) = true; % set true on positions with max values
% $Id: ismax.m,v 1.3 2005/06/10 13:24:56 epkpart Exp $
