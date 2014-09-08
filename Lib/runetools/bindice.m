function res = bindice(prob,dim)
% DESCRIPTION
%  res = bindice(prob,dim)
%  Creates a binary matirx of the same size as prob.
%  One of the element is set according to the probabilities
%  along dim.
% INPUT
%  prob -- Matrix of any size with probabilities.
%  dim  -- Dimension along which the realisation is made
% OUTPUT
%  res  -- A binary matrix of the same size as prob.
% SEE ALSO
%  binmin, binmax, ncumsum, ismin, mplus
% TRY 
%  bindice(ones(6,5)), bindice(10*rand(4,3,2),2)

% by Magnus Almgren 000321 revised 030321 MA
if ~exist('dim','var')
 dim = firstnonsing(prob);
end
siz = size(prob);
siz(dim) = 1;
res = ismin(mplus(ncumsum(prob,dim),-rand(siz))<0,dim);


% $Id: bindice.m,v 1.3 2005/06/10 13:24:56 epkpart Exp $
