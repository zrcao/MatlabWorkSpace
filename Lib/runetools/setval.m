function res = setval(m, ind, val)  
% DESCRIPTION res = setval(m, ind, val)
% the size of the three input arguments must conform in size so they can
% be expanded to the same size
% INPUT 
%  m   --  any matrix 
%  ind --  Any flat or binary index matirx
%  val --  The value to set
% OUTPUT
%  res --  A matrix of the combined size of m, ind and val.
% TRY
%  r = rand(4,3,2)
%  setval(r,r>0.5,0)

% by Magnus Almgren 050408

[m, ind, val] = adjsiza(m, ind, val);
if islogical(ind)
 m(ind) = val(ind);
else
 m(ind) = val;
end
res = m;