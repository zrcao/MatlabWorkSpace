function ind = minind(varargin)
% DESCRIPTION ind = minind(x,[],dim)
%  As min, but keeps only index.
%  Calculates the index along dimension of the third argument,
%  otherwise along the first non-singleton dimension.
% INPUT 
%  x --    any matrix
%  dim --  An integer > 0  indicating the dimension along which the operation will 
%          be performed. Inputs are the same as to min.
% OUTPUT 
%  ind --  Index along the dimension of the operation to the min value.
% TRY 
%  minind([2.3; 3.2]), minind(rand(1,2,3),[],2)
% SEE ALSO 
%  min, maxind

% by Magnus Almgren 990326

[dum, ind] = min(varargin{:});


% $Id: minind.m,v 1.3 2005/06/10 13:24:56 epkpart Exp $
