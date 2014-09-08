function n = infs(varargin)
% DESCRIPTION n = infs(r,c,...)
%  Creates an Inf matrix of size siz.
% INPUT
%  of the same type as i.e. ones
% OUTPUT
%  n --  A matrix of size according to input containing only
%        Inf (Infinite values).
% TRY
%  infs(1,2,3) or infs([1 2 3])
% SEE ALSO
%  zeros,ones,nans

% by Magnus Almgren 98111

n = Inf + ones(varargin{:});
% $Id: infs.m,v 1.3 2005/06/10 13:24:56 epkpart Exp $
