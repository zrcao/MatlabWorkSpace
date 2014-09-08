function b = erlang(a, n) % erlang b formula for any matrix sizes
% DESCRIPTION b = erlang(a, n) 
%  Erlang b formula for any matrix sizes.
%  Input arguments will extend singleton dimensions of each input 
%  argument to match the other arguments.
%  erlang(0,0) will result in 0.
% INPUT
%  a --  The offered traffic.
%  n --  The available number of servers.
% OUTPUT
%  b --  The resulting blocking probability.
% TRY 
%  erlang((0:0.1:1)',1:2), erlang(inf,1), erllang(1,inf)

% by Magnus Almgren 980930 revised 040202 by MA rev 050203 MA the empty case

% due to a bug in matlab when more than 2 dimensions of x
loggam = inline('reshape(gammaln(x),size(x))');

newdim = firstsing(a,n); %Find first not used dimension.
maxn = max(n,[],newdim); % maximum number of servers
maxn(isinf(maxn))=0; % set low value
nv = flatten(cumsum(ones(max(maxn(:))+1,1))-1,newdim);

%gamln = gammaln(nv+1); % Calc nat log of all factorials that is used.
[am, nm, nv] = adjsiza(a,n,nv); % Make all args to the same size.
warning off
loga = log(am);
warning on
t = loga.*nm - loggam(nm+1); % The nominator
b = 1./sum(exp(loga.*nv - loggam(nv+1) - t).*(nm>=nv),newdim);

% Clean up all odd cases
b(isinf(adjsiza(n,a))) = 0; % infinite # of servers 
b(adjsiza(a,n)==0) = 0; % no offered traffic
b(isinf(adjsiza(a,n))) = 1; % infinite traffic 
b(isinf(adjsiza(a,n))) = 1; % infinite traffic 
b(isnan(adjsiza(a,n))) = nan; % nans => nan 
b(isnan(adjsiza(n,a))) = nan; % nans => nan

% The function is calculated in logarithms to avoid overflow
% when n is in the order of 170 or more


% $Id: erlang.m,v 1.3 2005/06/10 13:24:56 epkpart Exp $
