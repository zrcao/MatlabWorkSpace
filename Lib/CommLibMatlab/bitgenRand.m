function bits = bitgenRand(numBits, varargin)
% DESCRIPTION
%   Function bits = bitgenRand(numBits, randBitSeed) generates random bits
%   with a given random seed. The generated bits are a column vection in
%   the first dimension.
% INPUT
%  numBit     -- the number of bits to be generated
%  randomSeed -- the seed for setting randint statues
% OUTPUT
%  bits -- a vector of bits on dimension d.bit

%  by Zhongren Cao 2014-08-26 

if ~isempty(varargin)
    randomSeed = varargin{1};
    oldseed = rng(randomSeed);
else
    oldseed = rng('shuffle');
end
bits = randi([0, 1], numBits,1); 
rng(oldseed);
