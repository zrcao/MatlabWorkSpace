function cdfplotnorm(x, plottype)
% DESCRIPTION cdfplotnorm(x, plottype)
%  CDF plot of the input matrix for each
%  column separately. The y axis is scaled so that normal distributed
% data will show up as straight line.
% INPUT
%  x --         a real matrix (no Nans or Infs)
%  plottype --  String describing the plot, e.g. 'r*'
%               plots red stars.
% OUTPUT
%  only the plot
% SEE ALSO
%  cdfplothigh, cdfplotmed, cdfplotlow
% TRY 
%  cdfplotnorm(randn(10000,1))

% by Magnus Almgren 050217

x = sort(x(:,:));
ytemp = linspace(0,1,1+2*size(x,1))';
y = adjsiza(ytemp(2:2:end-1),x);

% Reduce the number of points in the plot.
nmax = 1000; % roughly the maximum number before the sparse function come into play
spind = round(linspace(1,size(y,1),min(size(y,1),nmax)));
x = x(spind,:);
y = y(spind,:);

if exist('plottype', 'var')
 plot(x,qfuncinv(1-y), plottype)
else
 plot(x,qfuncinv(1-y))
end

set(gca,'ylim',qfuncinv(1-[0.001 0.999]));
% set proper labels
v = 1:9;
v1 = [0.001*v  0.01*v 0.1 0.2 0.3 0.4];

set(gca,'ytick',qfuncinv(1-[v1 0.5 1-fliplr(v1)]));
labels=[
 '0.1  ';'     ';'     ';'     ';'0.5  ';'     ';'     ';'     ';'     ';
 '1    ';'     ';'     ';'     ';'5    ';'     ';'     ';'     ';'     ';
 '10   ';'     ';'     ';'     ';'50   ';'     ';'     ';'     ';'90   ';
 '     ';'     ';'     ';'     ';'95   ';'     ';'     ';'     ';'99   ';
 '     ';'     ';'     ';'     ';'99.5 ';'     ';'     ';'     ';'99.9 ';
];
set(gca,'yticklabel',labels);
ylabel('C.D.F.  [%]')
grid on;

% $Id: cdfplotnorm.m,v 1.3 2005/06/10 13:24:56 epkpart Exp $
