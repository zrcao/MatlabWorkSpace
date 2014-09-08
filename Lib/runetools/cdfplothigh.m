function cdfplothigh(x, plottype)
% DESCRIPTION cdfplothigh(x, plottype)
%  CDF plot of the input matrix for each
%  column separately. By use of a log scale 
%  the higher part of the input is highlighted.
% INPUT
%  x --         a real matrix (no Nans or Infs)
%  plottype --  String describing the plot, e.g. 'r*'
%               plots red stars.
% OUTPUT
%  only the plot
% SEE ALSO
%  cdfplotmed, cdfplotlow, cdfplotnorm
% TRY 
%  cdfplothigh(randn(10000,1))

% by Magnus Almgren 000512 modified by Sofia Mosesson 000711, MA 050218

x = sort(x(:,:));
ytemp = linspace(0,1,1+2*size(x,1))';
y = adjsiza(ytemp(2:2:end-1),x);

% Reduce the number of points in the plot.
% skip the lower part of the data points
ind =  y(:,1) > 0.1;
x = x(ind,:);
y = y(ind,:);

% sparsify if many entries
nmax = 1000; % roughly the maximum number before the sparse function come into play
spind = unique(round(db2lin(linspace(0,lin2db(size(y,1)),7*nmax))));
x = x(spind,:);
y = y(spind,:);

if exist('plottype', 'var')
 plot(x,-lin2db(1-y), plottype)
else
 plot(x,-lin2db(1-y))
end

set(gca,'ylim',[0 20]);
% set proper labels
set(gca,'ytick',-lin2db(1-[0:10:90 91:1:99]/100));
labels=[
 '  0';
 '   ';'   ';' 30';'   ';'   ';'   ';' 70';' 80';' 90';
 '   ';'   ';' 93';'   ';'   ';'   ';' 97';' 98';' 99';
];
set(gca,'yticklabel',labels);
ylabel('C.D.F.  [%]')
grid on

