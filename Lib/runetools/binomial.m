function pr = binomial(m,n,p)
% DESCRIPTION pr = binomial(m,n,p)
%  binomial probabilty function 
%  the probability of m out of n samples each with probability p
% INPUTS
%  m -- integer matrix with vaules 0<=m<=n
%  n -- integer matrix with values 0<n
%  p -- sample probability 0<=p<=1
%  Sizes on all inputs are expanded to fit each other
% OUTPUT
%  pr -- probability values. Size is as the combined size of all inputs.
% SEE ALSO
%  poisson
% TRY
%  binomial(1,2,0.5), binomial(ones(2,2),2,0.5), binomial(0:3,3*ones(10,1),0.5)
%  
% by Magnus ALmgren 031111
[m,n,p] = adjsiza(m,n,p);

% a problem with N-D arrays and the gamma function
siz = size(m);
m = flatten(m);
n = flatten(n);
p = flatten(p);

m = max(-1,min(n+1,m)); 

% Do the computaion in the log domain to keep within the
% doubble floating range
warning off
pr = exp(gammaln(n+1)-gammaln(m+1)-gammaln(n-m+1)...
 +log(p).*m+log(1-p).*(n-m));
warning on

% adjust some problems with nans
pr(p==0& m==0) = 1;
pr(p==1& m==n) = 1;

pr = reshape(pr,siz); % related to the N-D problem
% $Id: binomial.m,v 1.3 2005/06/10 13:24:56 epkpart Exp $
