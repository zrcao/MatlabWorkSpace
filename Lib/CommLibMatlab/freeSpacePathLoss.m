function l = freeSpacePathLoss(d, f)
% SUMMARY
%  Function output = freeSpacePathLoss(d, f) calculates the free space path-loss
%  for radio signals
% INPUTS
%  d -- distance from the transmitter (meters)
%  f -- carrier center frequency (MHz)
% OUTPUTS
%  l -- pathloss in dB

% Zhongren Cao


l = 20*log10(d)+20*log10(f)+32.45-60;
