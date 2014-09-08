function varargout = histnw(varargin)
% DESCRIPTION  [h, bincenter1, bincenter2,...] = histn(d1,d2,...,w,b1,b2,...)
%  An n dimensional histogram function. The output is a matrix with
%  corresponding binpositions. Much like hist.m 
% INPUT
%  d1 -- observations to be put in first dimension
%  d2 -- observations to be put in second dimension
%  d3 -- ...
%   d1,d2,d3,...  must all contain the same number of observations
%  w --  weight value for each sample
%  b1 -- If scalar then b1 indicate the size of each bin. 
%        If a vector then b1 indicate the centerposition of the bin
%        in the first dimension
%  b2 -- the same as b1 but for the second dimension 
%  b3 -- ...
% OUTPUT
%  h -- An multi dimensional matrix with positive integers indicating the
%   number of samples in corresponding bin. The number of dimensions are 
%   the number of input arguments divided by 2 
%  bincenter1 -- a vector indicating binpositions in first dimension
%  bincenter2 -- a vector indicating binpositions in second dimension
%  bincenter3 -- ...
% SEE ALSO
%  histn, hist
% TRY
%  histnw(0.3, 0.75, 0.45, 0:0.2:1, 0:0.25:1)
%  image(histnw(rand(10000,1), rand(10000,1), rand(10000,1)*2, 0.5, 0:0.2:1, 0:0.2:1)/10)

% by Magnus Almgren 020423
% changed prod(size(.)) to numel(.) MA 050804

nmax = (nargin-1)/2; % number of dimensions
for n = 1:nmax % for dimension n
 d{n} = varargin{n}(:); %flatten into first dimension
 w    = varargin{nmax+1}(:); % weight of each observation
 b{n} = varargin{n+nmax+1}(:); % bincenter for n:th dim
 [bincentern, binbordn] = sbin(b{n},d{n}); % get the actual bins and borders
 bincenter{n} = bincentern;
 bind{n} = vsortind(d{n},binbordn(1:end-1)); % sort samples to corresp bin
 siz(n) = size(bincentern,1); 
end
% calculate the two dimensional histogram matrix
bind{n+1} = siz; % in order to  prepare a call to index 
totind = index(bind{:});  
varargout{1} = reshape(full(sparse(totind,1,w,prod(siz),1)),[siz 1]);
[varargout{2:nmax+1}] = deal(bincenter{1:nmax});

function [bincenter, binborder] = sbin(b,d)
% It is asumed that b and d only make use of first dimension
if exist('d','var') & numel(b) == 1
 bincenter = (round(min(d)/b)*b:b:round(max(d)/b)*b).';
else
 bincenter = b(:); % the centrpoint in each bin already given
end
% Calculate bin borders
b = bincenter;
b(2:end+1,2) = b;
b(1,2) = b(1,1)    -diff(b(1:2,1));
b(end,1) = b(end,2)+diff(b(end-1:end,2));
binborder = mean(b,2); % edges of bin

% $Id: histnw.m,v 1.4 2005/08/15 10:29:21 eraalm Exp $
