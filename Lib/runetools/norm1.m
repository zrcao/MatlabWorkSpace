function n = norm1(v, p, dim)  % vector norm along any dimension
% DESCRIPTION 
%  n = norm1(v, p, dim)
%  The vector norm (see norm) in dimension dim for any matrix v
%  v and p must match each other in terms of size.
%  Singleton dimension will be expanded to match. 
% INPUT
%  v --   The target for the norm. Any numeric matrix.
%  p --   The norm exponent. Any nonzero noninf real matrix. Default 2.
%  dim -- The dimesion along which the norm is taken. Any integer greater than
%         0. Default first nonsingleton dimension.
% OUTPUT
%  n --   the norm value. It takes the combined size of v and p
% SEE ALSO
%  norm, ncumsum
% TRY
%  norm1([3 6; 4 8])     => [5, 10]
%  norm1([3 6; 4 8],1,2) => [9; 12]  i.e. sum of each row

% by Magnus Almgren 031015

if ~exist('dim', 'var')
  dim = firstnonsing(v);  % default in first no singleton dimension
 end
 if ~exist('p', 'var')
  p = 2; % default quadratic norm
 end
 n = mexp(sum(mexp(v,p), dim),1./p);


% $Id: norm1.m,v 1.3 2005/06/10 13:24:56 epkpart Exp $
