function bits = bitgenStr(str)
% 

if(ischar(mp.data))
	bits = dec2bin(mp.data, 8);
	bits = flatten(bits');
	
	% This next part is for matching up with the Sysgen implementation, in which the
	% the order of the bits are read from 31-0, 63-32, etc.


	bits = dimf(bits, [], [d.bit]);
	bits = double(bits)-48;
end
