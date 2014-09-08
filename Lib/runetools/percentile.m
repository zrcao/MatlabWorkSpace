function res = percentile(a, perc, dim)
% DESCRIPTION res = percentile(a, perc, dim)
%  Calculates percentile values along dim for the elements of a 
% INPUT 
%  a    --  A matrix with observations along dimension dim
%  perc --  Percent values for which percentiles are calculate.
%  dim  --  Dimension along which percentiles are calculated
% OUTPUT
%  res  --  One percentile value for each 
%           element of perc and for each a.
% TRY
%  percentile(rand(1000,1),25), percentile(randn(1000,2),[25; 50; 75])
% SEE ALSO
%  index1, setifnotexist 

% by Magnus Almgren 031204 revised 050203 the empty case
% changed prod(size(.)) to numel(.) MA 050804

 % dim is set to first non singleton dimension of a
setifnotexist('dim',firstnonsing(a));

[am, percm] = adjsizabdim(dim,a,perc); % shape perc and a to the same size
if numel(percm)==0 % empty percentile
 res = percm;
 return
end
if size(am,dim)==0 % empty sample matrix
 res = nans(size(percm));
 return
end

bm = sort(am,dim);
siz = size(am,dim);

% calculate index pointing to the closest value in bm
ind1 = max(1, min(siz, round(percm/100*siz))); 
ind = index1(ind1,dim,size(bm));
res = bm(ind); % pick that value
