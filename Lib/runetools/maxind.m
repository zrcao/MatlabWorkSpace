function ind = maxind(varargin)
% DESCRIPTION ind = maxind(x,[],dim)
%  As max but keeps only index.
%  Calculates the index along dimension of the third argument,
%  otherwise along the first non-singleton dimension.
% INPUT 
%  x --    any matrix
%  dim --  An integer > 0  indicating the dimension along which the operation will 
%          be performed. Inputs are the same as to max
% OUTPUT 
%  ind --  Index along the dimension of the operation to the max value.
% TRY
%  maxind([2.3; 3.2]), maxind(rand(1,2,3),[],2)
% SEE ALSO 
%  max, minind

% by Magnus Almgren 990326

[dum, ind] = max(varargin{:});

% $Id: maxind.m,v 1.3 2005/06/10 13:24:56 epkpart Exp $
