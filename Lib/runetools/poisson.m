function n = poisson(lambda)
% function n = poisson(lambda)
%
% Generate random numbers according to Poisson distribution
%
% The parameter lambda specifies the mean number of arrivals
% and may be a vector or matrix, in which case one random number
% is generated for each entry of lambda.
%
% Created 2000-02-04, Niclas Wiberg revised MA 050217

% dimension to count arrivals in
if isempty(lambda)
 n = lambda;
 return
end

dim = firstsing(lambda);

% maximum number of arrivals
lambdamax = max(0,max(lambda(:)));
nmax = ceil(3 + lambdamax + 5 * sqrt(max(0,lambdamax)));

% random arrival times in a poission process (along dimension dim)
sz = size(lambda);
sz(dim) = nmax;
t = cumsum(-log(rand(sz)),dim);

% count how many arrived within window
n = sum(mplus(t,-lambda) < 0, dim);

% set to NaN for negative and nan arguments 
n(lambda<0) = nan;
n(isnan(lambda)) = nan;