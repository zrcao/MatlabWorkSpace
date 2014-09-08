function s = ncumsum(varargin)  % normalised cumsum 
% DESCRIPTION
%  s = ncumsum(m,dim)
%  As cumsum but normalised along dimension dim. The last element of the output
%  will be one.
% INPUT
%  m -- any numeric matrix
% dim -- the dimension along which the accumulated summation takes place
% OUTPUT
%  s -- a cumulative normalised sum of m
% SEE ALSO
%  cumsum, sum, cumprod
% TRY
%  ncumsum(rand(4,2,3),3)

% by Magnus Almgren 990223

s = mdiv(cumsum(varargin{:}),sum(varargin{:}));
% $Id: ncumsum.m,v 1.3 2005/06/10 13:24:56 epkpart Exp $
