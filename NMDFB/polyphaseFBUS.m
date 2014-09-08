function output = polyphaseFBUS(signal_arr, filter_coef, upsampleRate)
% FUNCTION
%
%    output = polyphaseFBUS(signal_arr, filter_coef, upsampleRate)
%
%  implements the synthesis (upsampling) section of a polyphase based 
%  non-maximally decimated filter bank channelizer (NMDFB) operation. 
%  It can also be used for maximally decimated polyphase upsampling of a 
%  baseband signal when the number of paths equals the down sampling rate.
% INPUTS
%  signal_arr -- the m-th column of 'signal_arr' represents the time domain 
%                baseband input signal samples to the m-th path of the
%                synthesis filter. The number of paths of the synthesis
%                section is derived from the number of columns of
%                'signal_arr'.
%  filter_coef -- the coefficients of the base synthesis nyquist filter
%  upsampleRate -- the down sampling rate. 
% OUTPUTS
%  output_bb -- the output of NMDFB channelizer analysis section. The
%               number of columns equals to the number of paths of the
%               channelizer. The m-th column is the time domain samples of
%               the m-th subchannel output aliased to baseband.
% SEE ALSO
%
% REFERENCES
%   X. Chen, F. Harris, E. Venose and B. Rao, "Non-Maximally Decimated
%   Analysis/Synthesis Filter Banks: Applications in Wideband Digital
%   Filtering"

% by Zhongren Cao 08/12/2014

[signal_len, branches] = size(signal_arr);
if branches < upsampleRate
    error(['The number of polyphase branches must be greater than or ' ...
        'equal to the upsampleRate']);
end
if mod(branches, upsampleRate)~=0
    error('The number of branches must be integer times the upsampleRate!');
end

if ~isvector(filter_coef)
    error('The input "filter_coef" must be a vector!');
end


%% Arrange filter coefficients into polyphase structure
filter_len = length(filter_coef);
if rem(filter_len, branches)~=0
    error('The filter length must be divided of the number of branches');
end
filter_coef = upsampleRate*...
    (reshape(flatten(filter_coef, 1), branches, filter_len/branches)).';

%% Aliasing baseband imaging to different channels before polyphase upsampling
signal_arr = signal_arr.* ...
    exp(2i*pi*(1:signal_len)'*upsampleRate*(0:branches-1)/branches);

%% IFFT
signals = branches*ifft(signal_arr, [], 2);

%% Prepare signals for polyphase upsampling
kappa = branches/upsampleRate;
signals = [zeros(kappa-1, branches); signals];
rot = zeros(1, branches);
for kk = 1:kappa
   rot((1:upsampleRate)+(kk-1)*upsampleRate) = ...
       ones(1, upsampleRate)*(kk-kappa);
end
signals = rotate(signals, rot, 1);
signals = signals(1:signal_len, :);
%% Go through polyphase filter
signalcell = cell(kappa, 1);
OO = cell(kappa, 1);
ttll = 0;
for kk = 1:kappa
    signalcell{kk} = signals(kk:kappa:end, :);
    OO{kk} = zeros(size(signalcell{kk}));
    for bb = 1:branches
        OO{kk}(:, bb) = filter(filter_coef(:, bb), 1, signalcell{kk}(:, bb));
    end
    ttll = ttll + size(OO{kk}, 1);
end
polyout = zeros(ttll, branches);
for kk = 1:kappa
    polyout(kk:kappa:end, :) = OO{kk};
end
stacked_output = zeros(ttll, upsampleRate);
for kk = 1:kappa
    stacked_output = stacked_output + ...
        polyout(:, (1:upsampleRate)+(kk-1)*upsampleRate);
end
output = flatten(stacked_output.', 1);