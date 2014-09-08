function symb_table  = gen_recqam_table(I_mapping, Q_mapping, varargin)
% DESCRIPTION
%  Generates a one dimensional cell array. The k-th cell element is a table of 
%  constellations for 2^k. Specifically
%  1 <=> BPSK, 2 <=> QPSK
% INPUT
%   none
% OUTPUT
% symb_table -- cell array with complex matrices of gray code ordered QAM
%               symbols

%  by Zhongren Cao, 2014-08-27

[nI, Isize] = size(I_mapping); 
[Qsize, nQ] = size(Q_mapping); 
if log2(Isize)~=nI || log2(Qsize)~=nQ
    error('The length of mapping vectors must be power of 2!');
end
Ivec = -(Isize-1): 2: (Isize-1);
Qvec =  (Qsize-1):-2:-(Qsize-1);
symb_mat = mplus(Ivec, 1i*Qvec');
M = Isize*Qsize;
total_energy = sum(sum(abs(symb_mat).^2));
symb_mat = symb_mat*sqrt(M/total_energy);
symb_table = symb_mat(:);

Iidx = sum(mprod(I_mapping, 2.^(nI-1:-1:0)'), 1)*2^nQ;
Qidx = sum(mprod(Q_mapping, 2.^(nQ-1:-1:0)), 2);
idx = flatten(mplus(Iidx, Qidx));
[idx, order] = sort(idx);
symb_table = [idx symb_table(order)];

if ~isempty(varargin)
    figure;plot(real(symb_table(:, 2)), imag(symb_table(:, 2)), 'kx', ...
        'MarkerSize', 10, 'LineWidth', 2);
    axis([-1.25 1.25 -1.25 1.25]);
    for ii = 1:Isize
        for qq = 1:Qsize
            zisStr = [];
            for ll = 1:nI
                zisStr = [zisStr num2str(I_mapping(ll, ii))];
            end
            for ll = 1:nQ
                zisStr = [zisStr num2str(Q_mapping(qq, ll))];
            end
            text(real(symb_mat(qq, ii))-0.1, ...
                imag(symb_mat(qq, ii))+0.1, ...
                zisStr); % Note in Matlab, the first matrix dimension is 
                         % the row, which corresponds to Q-mapping
        end
    end
end