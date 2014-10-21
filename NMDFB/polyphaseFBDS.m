function output_bb = polyphaseFBDS(signal, filter_coef, downsampleRate, branches)
% FUNCTION
%
%    output_bb = polyphaseFBDS(signal,filter_coef,downsampleRate,branches)
%
%  implements the analysis (downsampling) section of polyphase based 
%  non-maximally decimated filter bank channelizer operation (NMDFB). 
%  It can also be used for maximally decimated polyphase downsampling of a 
%  baseband signal when the number of paths equals the down sampling rate.
% INPUTS
%  signal -- the wide band baseband input sigalvector to the NMDFB
%  filter_coef -- the coefficients of the base analysis nyquist filter
%  downsampleRate -- the down sampling rate.
%  branches -- the number of paths in the channelizer. When 'branches' == 
%              'downsampleRate', the function implements maximally
%              decimated polyphase filter for a baseband signal. When
%              'branches' > 'downsampleRate', the function implements the
%              analysis section of an NMDFB channelizer.
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

%% Input Check
if branches < downsampleRate
    error(['The number of polyphase branches must be greater than or ' ...
        'equal to the downsampleRate']);
end
if mod(branches, downsampleRate)~=0
    error('The number of branches must be integer times the downsampleRate!');
end
if ~isvector(signal)
    error('The input "signal" must be a vector!'); 
end
if ~isvector(filter_coef)
    error('The input "filter_coef" must be a vector!');
end
filter_len = length(filter_coef);
if rem(filter_len, branches)~=0
    error('The filter length must be divided of the number of branches');
end

%% Prepare the input signal for NMDFB polyphase filter bank input
signal_len = length(signal);
signal_pad = [zeros(branches-1, 1); flatten(signal,1)];
signal_rot = rotate(signal_pad, (1-branches:0), 1);
signal_rot = signal_rot(1:signal_len, :);

kappa = branches/downsampleRate;
signalcell = cell(kappa, 1);
for kk = 1:kappa
    signalcell{kk} = signal_rot(kk*downsampleRate:branches:end, :);
end

%% Put filter coefficients into the polyphase filter bank
filter_coef = flatten(filter_coef, 1);
% The following four lines of code are obsolate as it is required that the length
% of the filter should be dividied by the number of branches
l=rem(length(filter_coef), branches);  
if l~=0
    filter_coef = [filter_coef; zeros(branches-l, 1)];
end
% Reshape the filter coefficients
filter_coef = (reshape(filter_coef, branches, filter_len/branches)).';

%% Signals go through the polyphase filter banks.
ttll = 0; %% Total length of the final polyphase FB output.
OO=cell(kappa, 1);
for kk = 1:kappa
    zisSig = signalcell{kk};
    zisOutput = zeros(size(zisSig));
    for bb = 1:branches
        zisOutput(:, bb) = filter(filter_coef(:, bb), 1, zisSig(:, bb));
    end
    OO{kk} = zisOutput;
    ttll = ttll + size(zisOutput, 1);
end
output = zeros(ttll, branches);
for kk = 1:kappa
    zisll = size(OO{kk}, 1);
    output(kk+(0:(zisll-1))*kappa, :) = OO{kk};
end

%% IFFT Operation
output = branches*ifft(output, [], 2);

%% Bring all sub-channels into baseband
output_bb = output.*...
    exp(-2i*pi*((1:ttll)'*downsampleRate)*(0:branches-1)/branches);
