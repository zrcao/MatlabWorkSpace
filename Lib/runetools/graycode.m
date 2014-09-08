function b = graycode(n)
% DESCRIPTION b = graycode(n)
%  Generates a binary graycode with n bits
% INPUT 
%  n -- number of bits in the code.
% OUTPUT
%  b -- binary gray code in a matrix with size 2^n by n
% SEE ALSO
%  binary
% TRY
%  graycode(3)

% by Magnus Almgren 020418 revised 050821

b = mod(mprod(mplus((0:2^n-1)',2.^[n-1:-1:0]),2.^-[n+1:-1:2]),1)>=0.5;