function cdfplotlow(x, plottype)
% DESCRIPTION cdfplotlow(x, plottype)
%  CDF plot of the input matrix for each
%  column separately. By use of a log scale 
%  the lower part of the input is highlighted.
% INPUT
%  x --         a real matrix (no Nans or Infs)
%  plottype --  String describing the plot, e.g. 'r*'
%               plots red stars.
% OUTPUT
%  the plot only
% SEE ALSO
%  cdfplothigh, cdfplotmed, cdfplotnorm
% TRY
%  cdfplotlow(randn(10000,1))

% by Magnus Almgren 000512 modified by Sofia Mosesson 000711, MA 050218 

x = sort(x(:,:));
ytemp = linspace(0,1,1+2*size(x,1))';
y = adjsiza(ytemp(2:2:end-1),x);

% Reduce the number of points in the plot.
% skip the upper part of the data points
ind =  y(:,1) < 0.9;
x = x(ind,:);
y = y(ind,:);

% sparsify if many entries
nmax = 1000; % roughly the maximum number before the sparse function come into play
spind = unique(round(db2lin(linspace(0,lin2db(size(y,1)),7*nmax))));
spind = size(y,1)+1-spind; % reverse order so sparsing is performed at the beginning 
x = x(spind,:);
y = y(spind,:);

if exist('plottype', 'var')
 plot(x,lin2db(y), plottype)
else
 plot(x,lin2db(y))
end

set(gca,'ylim',[-20 0]); % Reduce the yaxis.
% Set proper labels.
set(gca,'ytick',lin2db([1:10 20:10:100]/100));
labels=[
'  1';'  2';'  3';'   ';'  5';'   ';'   ';'   ';'   ';
' 10';' 20';' 30';'   ';' 50';'   ';'   ';'   ';'   ';
'100'];
set(gca,'yticklabel',labels);
ylabel('C.D.F.  [%]');
grid on;

