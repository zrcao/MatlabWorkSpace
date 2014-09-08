function bits = bitgenLfsr(d, mp);
% DESCRIPTION
% 
% INPUT
%  d.bit        -- dimension for bits
%  mp.lfsrbit    -- indicating the method to generate information bits, 1:
%                  using LFSR; 0: using random function.
%  mp.lfsrseed   -- input parameters for function 'lfsr'
%  mp.lfsrstage
%  mp.lfsrfdbk
%  mp.lfsrtype 
%  mp.rndbitstat -- seed to the random generator for bits
%  nbits        -- number of information bits to be generated
% OUTPUT
%  bits -- a vector of bits on dimension d.bit

%  by Zhongren Cao 070207 

lfsrBits = lfsr2(mp.lfsr.sz, mp.lfsr.fbPoly, mp.lfsr.seed, ...
		sum(mp.rawBitPFrm, d.frm), mp.lfsr.fib);

for cnt = 1:size(mp.rawBitPFrm, d.frm)
    bits(1:mp.rawBitPFrm(cnt),cnt) = lfsrBits(sum(mp.rawBitPFrm(1:cnt-1))+(1:mp.rawBitPFrm(cnt)));
end
    
% for cnt = 1:size(mp.rawBitPFrm, d.frm);
% 	numBits = partof(mp.rawBitPFrm, d.frm, cnt);
% 	bits(:,cnt) = [lfsr2(mp.lfsr.sz, mp.lfsr.fbPoly, mp.lfsr.seed, ...
% 		numBits, mp.lfsr.fib); zeros(max(mp.rawBitPFrm, [], d.frm)-numBits,1)];
% end
bits = dimf(bits, [d.bit d.frm], [1 2]);
