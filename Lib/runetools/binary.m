function  b = binary(n)
% DESCRIPTION
%  b = binary(n)
%  full binary sequence in n bits
%  size of output is 2^n by n
% INPUT 
%  n  -- the numberof bits in each binary word
% OUTPUT 
%  b -- All possible binary words in an ordered sequence
%       with the most significant bit to the left.
%       One word per row in a numeric matrix.
% SEE AlSO
%  graycode
% TRY
%  binary(3)

% by Magnus Almgren 020219
b = mod(mprod((0:2^n-1)',2.^-[n:-1:1]),1)>=0.5;