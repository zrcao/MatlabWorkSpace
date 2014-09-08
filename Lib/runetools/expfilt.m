function  y = expfilt(x,alfa,yinit,dim)
% DESCRIPTION  y = expfilt(x,alfa,yinit,dim) first order iir filter
%  preserves amplitude level of input. E[x] = E[y]
%  (E[y.^2]=E[x.^2]*alfa^2 + E[y.^2].*(1-alfa).^2 if independent samples
%  The filtering is performed along dimension dim.
%  of x. x,alfa and yinit are are expanded in all dimension but dim in order
%  to match each others size. If the size of alfa is greater than one along 
%  dimension dim then the filter is non stationary.
%  yinit can be an earlier output from the filter.
% INPUTS
%  x     --  target for the filteroperation any complex matrix
%  alfa  --  filter constant. Defaults to 0.1
%  yinit --  target for the filteroperation. Defaults to 0
%  dim   --  dimension in which the filteroperation is performed.
% OUTPUTS
%  y     --  filtered version of x with the combined size of x,alfa and yinit
% SEE ALSO
%  filter
% TRY
%  plot(expfilt(randn(1000,2)))
%  plot(expfilt(ones(30,1),0.2),'.-')

%  by Magnus Almgren 031105 heavily revised MA 050216

% Set defaults
setifnotexist('alfa',0.1);
setifnotexist('yinit',0);
fns = firstnonsing(x,alfa,yinit); 
setifnotexist('dim',fns);

if size(yinit,dim)>=0
 % take the last sample out of xinint
 yinit = partof(yinit,dim,size(yinit,dim));
end

% adjust sizes so that they fit each other
[x,alfa] = adjsiza(x,alfa,yinit);
% scale y1 = yinit to the size of x and make an empty y matrix
[y1,y] = adjsizabdim(dim,yinit,partof(x,dim,[]),x);
 
for i = 1:size(x,dim) % iterate over all samples
 y1 = partof(alfa,dim,i).*partof(x,dim,i) +(1-partof(alfa,dim,i)).*y1;
 y = cat(dim,y,y1); % concatenate
end
