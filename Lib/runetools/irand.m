function res = irand(varargin)
% DESCRIPTION res = irand(r,c,...)
%  Complex random rectangular distributed numbers
%  in the real as well as in the imaginary part.
% INPUT
%  size parameters as for i.e. zeros
% OUTPUT
%  res --   A matrix of size according to input with complex
%           elements. The real part is in the range [0 1] and 
%           the imaginary within [0 i].
% TRY
%  plot(irand(1000,1),'.')
% SEE ALSO
%  irandn, setseed

% by Magnus Almgren 970611

res = rand(varargin{:}) + i*rand(varargin{:});

% $Id: irand.m,v 1.3 2005/06/10 13:24:56 epkpart Exp $
