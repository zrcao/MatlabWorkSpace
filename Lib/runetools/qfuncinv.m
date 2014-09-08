function x = qfuncinv(y)
% DESCRIPTION  y = qfunc(x) 
%  The inverse Q function
%  If the input is outsde {0..1} Nan is delivered
% INPUT 
%  y --  Any real matrix
% OUTPUT
%  x -- Q^-1(x)
% SEE ALSO
%  erfc, qfunc
% TRY
%  qfuncinv(qfunc([-inf -1 0 1 inf NaN]))
%  plot(qfuncinv(0:0.025:1),0:0.025:1,'.-')
%  plot(-2:0.1:2,qfuncinv(qfunc(-2:0.1:2)),'.-')

% by Magnus Almgren 020925
x = erfinv(1-2*y)*sqrt(2);
% $Id: qfuncinv.m,v 1.3 2005/06/10 13:24:56 epkpart Exp $
