function bits = bitgen(method, varargin)
% DESCRIPTION
%
% INPUT
%
% OUTPUT
%

% By Zhongren Cao 2014-08-26

switch(method)
	case 'lfsr'
		bits = bitgenLfsr(d, mp);
	case 'rand'
        if length(varargin)<1
            error(['Additional inputs are needed when the ' ...
                   'generation method is "rand"\n'...
                   'Please using bitgen("rand", NumBits, RandomSeed)!']);
        end
        if floor(varargin{1})<=0
            error('The number of bits must be a positive integer!');
        end
        if length(varargin)>1
            bits = bitgenRand(floor(varargin{1}), varargin{2});
        else
            bits = bitgenRand(floor(varargin{1}));
        end
	case 'file'
		bits = bitgenData();
    case 'char'
	otherwise
		error('Error: Bit generation case selection invalid');
end
