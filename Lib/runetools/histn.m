function varargout = histn(varargin)
% DESCRIPTION  [h, bincenter1, bincenter2,...] = histn(d1,d2,...,b1,b2,...)
%  An n dimensional histogram function. The output is a matrix with
%  corresponding binpositions. Much like hist.m
% INPUT
%  d1 -- observations to be put in first dimension
%  d2 -- observations to be put in second dimension
%  d3 -- ...
%   d1,d2,d3,...  must all contain the same number of observations
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
%  histnw, hist
% TRY
%  histn(0.3, 0.75, 0:0.2:1, 0:0.25:1)
%  image(histn(rand(10000,1), rand(10000,1), 0:0.2:1, 0:0.2:1)/10)

% by Magnus Almgren 031015

[varargout{1:nargin/2+1}] = histnw(varargin{1:nargin/2}, 1, varargin{nargin/2+1:end});

% $Id: histn.m,v 1.3 2005/06/10 13:24:56 epkpart Exp $
