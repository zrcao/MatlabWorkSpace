function res = repelem(m, siz) % repeats elements
% DESCRIPTION res = repelem(m, siz)
%  Repeats each element in m siz times where siz is a vector 
%  with one element for each dimension. Much like repmat.
% INPUT 
%  m --     Matrix with elements to repeat. 
%  siz --   Number of repetitions. 
% OUTPUT
%  res --   A matrix siz times the size of m where repetitions are made 
%           per element.
% SEE ALSO
%  repmat
% TRY 
%  repelem([1 2; 3 4],[2 2] )
%  repelem(rand(2,3),[3 2]) 
%  repelem(rand(2,3),[3])
%  repelem(rand(2,3),[3 2 2])
 
% by Magnus Almgren 98110 heavily revsied 031119 
if isempty(m)
 res = repmat(m,siz); % repelem(ones(0,2),[1 3]) does have a meaning
 return
end
sizs = sizes(m,ones(siz));
% create an index vector for each dimension
for i = 1:size(sizs,2)  
 indi{i} = flatten(repmat(1:sizs(1,i),[sizs(2,i) 1]),i);
end
% the {:} expands the cell array as separate arguments
res = m(index(indi{:}, sizs(1,:)));

% $Id: repelem.m,v 1.3 2005/06/10 13:24:56 epkpart Exp $
