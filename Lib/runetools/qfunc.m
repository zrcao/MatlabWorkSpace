function y = qfunc(x);
% DESCRIPTION  y = qfunc(x) 
%  The Q function
% INPUT 
%  x --  Any real matrix
% OUTPUT
%  y -- Q(x)
% SEE ALSO
%  erfc, qfuncinv
% TRY
%  qfunc([-inf -1 0 1 inf Nan])

% by Magnus ALmgren 030320
y = 0.5*erfc(x/sqrt(2));

% $Id: qfunc.m,v 1.3 2005/06/10 13:24:56 epkpart Exp $
