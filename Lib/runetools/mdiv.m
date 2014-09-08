function s = mdiv(varargin) % generalized division
% DESCRIPTION s = mdiv(a,b)
%  Divides (./) variables of different sizes.
%  No warning if divide by zero.
%  Arguments are expanded to fit each other and then divided element by 
%  element. Expansion is made on singleton dimensions to fit the size 
%  of other arguments.
% INPUT
%  any two arguments of numeric matrices
% OUTPUT
%  s -- The ratio (./) of the inputs
% TRY
%  mdiv(ones(1,2),ones(2,1)), size(mdiv(ones(2,1),ones(2,3,4)))
%  Compare 0/0 with mdiv(0,0)
% SEE ALSO
%  mplus,mprod,mexp,adjsiza

% by Magnus Almgren 000517 adjsiza 050517

[v{1:nargin}] = adjsiza(varargin{:});
warning off
s = v{1}./v{2};
warning on
