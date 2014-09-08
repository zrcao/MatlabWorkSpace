function s = mexp(varargin) % generaliized .^
% DESCRIPTION s = mexp(a,b)
%  raises a (.^) to b although different sizes.
%  Arguments are expanded to fit each other and then rasied
%  Expansion is made on singleton dimensions to fit the size of other argument.
% INPUT
%  any two arguments of numeric matrices
% OUTPUT
%  s -- a.^b
% TRY
%  mexp(2,1:8), mexp((0:4)',0:5), size(mexp(ones(2,1),ones(2,3,4)))
% SEE ALSO
%  mprod,mplus,mdiv,adjsiza

% by Magnus Almgren 010930 revised 050216 MA the empty case 050517 MA adjsiza
 
[v{1:nargin}] = adjsiza(varargin{:});
s = v{1}.^v{2};
 