function H = rx_bblpf(cutoff, F)
% Funtion rx_bblpf models the behavior of AD9361 RX baseband low pass 
% filter, which is a 3rd order butterworth analogy filter.
%
% INPUT
%   cutoff -- 3 dB cutoff frequency in Hz;
%        F -- frequency points (Hz) to be evaluated;
% OUTPUT
%   H -- Complex filter amplitude
%
% BY: Zhongren Cao, C-3 Comm Systems
[B, A] = butter(3, 2*pi*cutoff, 's');
H = freqs(B, A, 2*pi*F);
end