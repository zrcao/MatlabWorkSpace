function immat(m)
% DESCRIPTION
%  immat(m)
%  Displays a matrix as a picture where high values are displayed as being
%  hot (white) and low values cold (black) and red in between. 
%  -inf is displaued as dark grey. Nan as grey Inf as light grey. Only real part
%  of the input is displayed. The matrix is also squeezed into a two
%  dimensional matrix before it is displayed. First dimension as is and then all the others 
% INPUT
%  m  -- Any matrix of any size and dimensions
% OUTPUT
%  only the plot
% SEE ALSO
%  image, imagesc
% TRY
%  immat(1:128)  % default displays 1:128
%  immat([1 2  3 ; -inf nan inf])
%  immat(randn(10,20))

% by Magnus Almgren 040619

setifnotexist('m',1:128); % default matrix to display
if isempty(m)
 return
end
 
m = real(squeeze(m(:,:)));
snan  = isnan(m); % save positions with these extreme values
sinf  = m==  Inf;
sminf = m== -Inf;
finitemin = min(m(isfinite(m)));
mm = m;
if ~isempty(finitemin) % if there are at least one finite value 
 m(snan | sinf | sminf) = finitemin; % set to least finite value
end
d = max(m(:))-min(m(:));
minv = min(m(:));
if d == 0 % all values the same
 m = zeros(size(m));
 d = 1;
 minv = 0;
end
x = -((m-minv)/d)*7.5+3.5;
x = qfunc(mplus(x,cat(3,-2.5, 0, 2.5)));
x = mplus(mprod(x,~sinf ), 0.9 * sinf ); 
x = mplus(mprod(x,~snan ), 0.6 * snan ); 
x = mplus(mprod(x,~sminf), 0.3 * sminf); 

imagesc(x)

dstr = sprintf('Min = %4.5g, Max = %4.5g',min(mm(:)),max(mm(:)));
title(dstr);
