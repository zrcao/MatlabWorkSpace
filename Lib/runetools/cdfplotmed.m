function cdfplotmed(x,plottype)
% DESCRIPTION cdfplotmed(x)
%  CDF plot of the input matrix for each
%  column separately. By use of a linear scale
%  the middle part of the input is highlighted.
% INPUT
%  x --  a real matrix (no Nans or Infs)
%  plottype --  String describing the plot, e.g. 'r*'
%               plots red stars.
% OUTPUT
%  only the plot
% SEE ALSO
%  cdfplothigh, cdfplotlow
% TRY
%  cdfplotmed(randn(10000,1))

% by Magnus Almgren 000512, modified MA 050218

x = sort(x(:,:));
ytemp = linspace(0,1,1+2*size(x,1))';
y = adjsiza(ytemp(2:2:end-1),x);

% Reduce the number of points in the plot.
nmax = 1000; % roughly the maximum number before the sparse function come into play
spind = round(linspace(1,size(y,1),min(size(y,1),nmax)));
x = x(spind,:);
y = y(spind,:);

if exist('plottype', 'var')
 plot(x,y*100, plottype)
else
 plot(x,y*100)
end


set(gca,'ylim',[0 100]); % reduce the yaxis
% set proper labels
set(gca,'ytick',0:10:100);
ylabel('C.D.F.  [%]');
grid on;

if nargin > 2
 % Add some statistic information.
 s1 = ['mean ' sprintf('%8.2g',mean(x))];
 s2 = ['std  ' sprintf('%8.2g',std(x))];
 s3 = ['max  ' sprintf('%8.2g',max(x))];
 s4 = ['min  ' sprintf('%8.2g',min(x))];
 s(1,1:length(s1)) = s1;
 s(2,1:length(s2)) = s2;
 s(3,1:length(s3)) = s3;
 s(4,1:length(s4)) = s4;
 lim = axis;
 text(.9*lim(1)+.1*lim(2),80,s);
end
% $Id: cdfplotmed.m,v 1.3 2005/06/10 13:24:56 epkpart Exp $
