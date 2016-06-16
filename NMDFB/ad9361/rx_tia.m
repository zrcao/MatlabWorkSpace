function H = rx_tia(cutoff, F)
% Funtion rx_tia models the behavior of AD9361 RX TIA low pass filter, 
% which is a single pole LPF.
%
% INPUT
%   cutoff -- 3 dB cutoff frequency in Hz;
%        F -- frequency points (Hz) to be evaluated;
% OUTPUT
%   H -- Complex filter amplitude
%
% BY: Zhongren Cao, C-3 Comm Systems
 

B = 2*pi*cutoff;
A = [1, 2*pi*cutoff];
H = freqs(B, A, 2*pi*F);

end