function p = npdf1(x,m,s) % pdf of the normaldistribution
% DESCRPTION
% p = npdf1(x,m,s)
% the n dimensional normal density function
% threeinputs are expanded in order ot fit the other inputarguments
% INPUT
%  x -- 
%  m -- mean value
%  s -- standard deviation
% OUTPUT
%  p --  probability density
% SEE ALSO
% mplus, mdiv
% TRY
%  npdf1(0,[nan 0 1 inf],[nan 0 1 inf]')
%  plot(linspace(-3,3,61)',npdf1(linspace(-3,3,61)',0,[1 0.5]),'.-')

% by Magnus Almgren 990423  030612 MA 040108 MA major code tune up 050511 MA

setifnotexistorempty('m',0); % default mean value
setifnotexistorempty('s',1); % default standard deviation

d = mdiv(abs(mplus(x,-m)),s);
p = mdiv(exp(-0.5*d.^2)/sqrt(2*pi),s);

% clean up
p(d == inf) = 0; 
p(isnan(d)) = nan;
