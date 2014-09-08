function y = rotate(x, rot, dim) % shifts first argument 
% DESCRIPTION y = rotate(x, rot, dim) makes a shift of x 
% according to rot in dimension dim. If dim is not present
% then first dimension is assumed
% INPUTS
%  x -- the matrix to be shifted
%  rot -- a matrix containing the shift 
%  dim -- the dimension along which shift will take place
% OUTPUT
%  y -- the shifted result
% TRY rotate(1:10,(0:3)',2) rotate(magic(2),[0 1]) 

% by Magnus Almgren 981114 heavily revised 040202

setifnotexist('dim',firstnonsing(x))
[x, rot] = adjsiza(x, rot);
siz = size(x);
d = wrapind(mplus(flatten(1:size(x,dim),dim),-rot),size(x,dim));
ind = index1(d,dim,siz);
y = x(ind);

% $Id: rotate.m,v 1.3 2005/06/10 13:24:56 epkpart Exp $
