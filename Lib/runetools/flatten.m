function res = flatten(m, dim)  
% DESCRIPTION res = flatten(m, dim)
%  Align all elements of m along dimension dim.
%  The elements are taken columnwise from m.
%  If dim is not present along rows is assumed.
%  m can be any matrix and dim can be any 
%  scalar integer from 1 and up.
% INPUT 
%  m --    any matrix 
%  dim --  any integer greater than 0
% OUTPUT
%  res --  A matrix only spanning dimesion dim.
% TRY
%  flatten([1 2; 3 4],3) 

% by Magnus Almgren 970527 changed prod(size(.)) to numel(.) MA 050804

if nargin > 1 
  % Note the extra 1 at the end, since reshape needs 
  % a dimension vector of at least 2 element.
  res = reshape(m,[ones(1, dim-1), numel(m) 1]);
else
  res = m(:); % in the old matlab4 style
end

% $Id: flatten.m,v 1.4 2005/08/15 10:29:21 eraalm Exp $
