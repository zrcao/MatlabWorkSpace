function n = nans(varargin)
% DESCRIPTION n = nans(r,c,...)
%  Creates a NaN matrix of size (r,c,...).
% INPUT
%    -- Of the same type as i.e. ones.
% OUTPUT 
%  n -- A matrix of size according to input containing only NaN values
% TRY
%  nans(1,2,3) or nans([1 2 3])
% SEE ALSO 
%  zeros, ones, infs

% by Magnus Almgren 981119

n = NaN + ones(varargin{:});
% $Id: nans.m,v 1.3 2005/06/10 13:24:56 epkpart Exp $
