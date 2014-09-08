function symb = bits2symb(bits, modorder)
% DESCRIPTION
%
% INPUT
%  d.frq     -- dimension along frequencies
%  d.blk      -- dimension along blocks
%  d.frm      -- dimension along frames
%  mp.scDataSz    -- data subcarriers per block
%  mp.blkPFrm -- blocks per frame
%  mp.numFrm      -- frames per simulation
%  bits       -- a matrix or vector with integer bit information, {0, 1} the number of bits along dimension d.freq
%                must correspond to modorder along the dimensions spanned by
%                modorder.
%  modorder   -- matrix with possible dimensions d.freq,d.blk,d.frame with integer values 1 to 4
%                1 <=> BPSK, 2 <=> QPSK, 3 <=> 8PSK, 4 <=> 16QAM
%                Any singleton dimension will be expanded to fit the
%                structure of symbols per block, block per frame and number
%                of frames.
% OUTPUT
%  symb       -- complex symbol matrix, carries symbol values.
% SEE ALSO
%  symb2bit_probs

%  by Magnus Almgren 070207

% Generate constellations for different modulation orders
symb_table = gen_symb_table;
% matrix has one element for each symbol position
dims      = [d.frq   d.blk      d.frm ];
siz(dims) = [mp.scDataSz mp.blkPFrm mp.numFrm];
siz(siz==0) = 1; % Cheating!! suppose some size intentionally was 0
mdo = adjsiza(modorder,zeros(siz));
endp = cumsum(mdo(:))'; % pointer to the end in the bitstream of each modorder
begp = [1 endp(1:end-1)+1]; % corresponding pointer to the beginning
if endp(end)>numel(bits(:))
    error('Not enough bits to generate symbols')
end
% go through the symbols one by one. Ugly??
for k = fliplr(1:numel(mdo)); % fliplr allocates the memory first time around
    bits_k = flatten(bits(begp(k):endp(k)),d.frq);
    ind_k = sum(mprod(flatten(2.^(mdo(k)-1:-1:0),d.frq),bits_k),d.frq)+1;
    symbs(k) = symb_table{mdo(k)}(ind_k);
end
symb = reshape(symbs,size(mdo)); % reshape into a matrix
