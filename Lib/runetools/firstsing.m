function dim = firstsing(varargin) 
% DESCRIPTION dim = firstsing(varargin)
%  Finds first singleton dimension common to all input arguments.
% INPUT
%  A number of matrices, probably with different sizes.
% OUTPUT
%  dim --  A positive integer indicating the first
%          common singleton dimension.
% SEE ALSO
%  firstnonsing
% TRY
%  firstsing(rand(2,1,2), rand(2,1)) => 2

% by Magnus Almgren 990317 fix for the empty case MA 050127

dims = find([all(sizes(varargin{:})==1,1) 1]==1);
dim = dims(1); % take the first found element in the list
