function y = lincumsum(varargin) 
% DESCRIPTION y = lincumsum(m, dim) 
%  The same as cumsum but the main input argument
%  and the outpout are in dB.
%  y = lin2db(cumsum(db2lin(m),dim)).
%  dim is optional.
% INPUT 
%  m --  A matrix with real values representing entities in dB.
%  dim -- The dimension in which the operation takes place.
% OUTPUT
%  y --  The corresponding matrix cumsummed in the linear domain.
% TRY
%  lincumsum([0; 0]), lincumsum([0 0],2), linsumcum([-inf 0])
% SEE ALSO 
%  cumsum, linsum, linmean 

% by Magnus Almgren 011008

% cumsum in linear and back to dB again
y = lin2db(cumsum(db2lin(varargin{1}),varargin{2:end}));


% $Id: lincumsum.m,v 1.3 2005/06/10 13:24:56 epkpart Exp $
