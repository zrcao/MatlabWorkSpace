function indi = vsortind(xi,xv,dim)
% DESCRIPTION indi = vsortind(xi,xv,dim)
%  xi and xv will be expanded to equal size for all dimensions except dim
%  For each value of xi an index is calculated so that
%  the index to the maximum value of xv not exceeds the 
%  corresponding value in xi. The output will receive the combined size of
%  xv and xi except for dimension dim where the size is that of xi
%  Make shure that the input argument xv is either increasing or decreasing
%  along the dimension dim.
%  Note that first xv-value along dim has nothing to do with the result
% 
% INPUT
%  xi --  a real matrix for which index is going to be created. 
%  xv --  a real matrix that is either increasing or decreasing along
%         dimension dim into which indi is pointingf
%  dim -- dimension along xv in which index will be fitted 
% OUTPUT 
%  indi -- A matrix with indices into xv such that xi <= xv(indi) 
% SEE ALSO
%  interp1n, interpndim, histn, histnw
% TRY
%  x = 0:0.1:5; plot(x,vsortind(x, (1:4)'),'*')
%  x = 0:0.1:5; plot(x,vsortind(x', [1:4; 3:6]'),'*')
%  r = randn(10000,1); plot(r,vsortind(r,linspace(-2,2,7)'),'.')

% by Magnus Almgren 030724 revised 050204 MA the empty case

% Default dim is set the fisrt non singleton dimension of xv
setifnotexist('dim',firstnonsing(xv));

% Make sure that x is monotonic i.e. all(diff(xv,[],dim))>=0
signdiffxv = sign(diff(xv,[],dim));
maxd = max(signdiffxv(:));
mind = min(signdiffxv(:));
if maxd-mind==2
 error('Second argument is both increasing and decreasing');
elseif mind==-1 % all of x must be decrasing along dimension dim
 xv = flipdim(xv,dim);
 flipped = 1;
else
 flipped = 0;
end

% Adjust input argument sizes to match each other except for dimension dim
[xi xv] = adjsizabdim(dim,xi,xv);

% Find ind such that xv(ind) is just beneath or equal to xi
indi = ones(size(xi));
step = 2.^ceil(log2(size(xv,dim)+eps));  % the initial step size. eps <=> avoid log(0)
while step>1
 step =  max(1,step/2); % decrease stepsize
 indiprop = index1(min(size(xv,dim),indi + step),dim,size(xv)); 
 xvind = reshape(xv(indiprop),size(indiprop)); % just due to the odd syntax of this language
 indi = min(size(xv,dim),indi + step*(xi-xvind>=0)); % eventually increase ind 
end

% Turn index values around if flipped earlier on
if flipped 
 indi = indi - size(xv,dim) + 1;
end

% $Id: vsortind.m,v 1.3 2005/06/10 13:24:56 epkpart Exp $
