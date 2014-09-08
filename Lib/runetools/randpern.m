function rp = randpern(siz, varargin) % the same as randperm but for many dimensions
% DESCRIPTION rp = randpern(siz, dim) 
%  returns a matrix with permutated indices in specified dimension
%  also in the singleton case. siz specifies the dimension of the result
%  If varagin does not specify the dimension along which random indices
%  are going to be created it is done along the first dimension i.e along rows.
% INPUTS
%  siz -- the size of the generated matrx
%  dim -- the dimension along which the permutated integer sequence is
%  generated.
% OUTPUTS
%  rp -- the matrix of size siz with permutated sequencies 
% SEE ALSO 
%  randperm, bindice
% TRY  randpern([4 3 2], 2) where you can see a matrix with size [4 3 2] and 
%  that there are not the same number along any column.

% by Magnus Almgren 970525

% take the index from a random matrix
[dum, rp] = sort(rand(siz), varargin{:});

% $Id: randpern.m,v 1.3 2005/06/10 13:24:56 epkpart Exp $
