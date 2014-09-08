%% Scripts to test nom-maximum decimated polyphase filter banks
clear *;

h_fig = findobj(0, 'type', 'figure');
for hh = 1:length(h_fig)
    figure(h_fig(hh));clf;
end

libpath = genpath('../Lib');
addpath(libpath);

%% Setup
debug = 1; % Turn debug on (1) or off (0);

BW = 64e3;  % Hz, overall signal bandwidth
Fs = 64e3;  % Hz, initial signal sampling rate
signal_len = 1024*16*4; % Length of the input signal

%% Parameters
M = 64; % the number of channels in the channelizer

%% Generate experiment signals
signal_type = 3;
switch signal_type
    case 1 % random complex 
        signal = sqrt(0.5)*irandn(signal_len, 1);
    case 2 % single band signals
        f1 = 200; %
        signal = exp(2i*pi*f1*(0:signal_len-1)'/Fs);
    case 3 % multiple bands signals
        sig_f = zeros(1, M);
        sig_a = zeros(1, M);
        sig_f(1) = 100; %
        sig_a(1) = 1;
        sig_f(2) = 800; %
        sig_a(2) = 2;
        sig_f(3) = 1600; %
        sig_a(3) = 0.5;
%          sig_f(4) = 3200; %
%          sig_f(M-1) = 62000; %
%          sig_f(M) = 63000;
        signal = sum(mprod(sig_a, exp(2i*pi*(1:signal_len)'*sig_f/Fs)), 2);
end

%% Kaiser Windowed SINC function as the AFB
sinc_hb_period = 6;
sinc_coef = sinc(-(sinc_hb_period-1/M):1/M:(sinc_hb_period-1/M));
sinc_coef = (kaiser(length(sinc_coef), 10))'.*sinc_coef/M;
filter_coef = [0; flatten(sinc_coef, 1)];
fir_length = length(filter_coef);
fir_halfL = fir_length/2;

%% downsample rate
ds = 2;
kappa = M/ds;

%% Filter output with NMDFB 
% The following version of polyphaseFBDS is obsoleted.
output_bb = polyphaseFBDS(signal, filter_coef, ds, M);

%% Multi-channel baseband processing
input_bb = output_bb; 

%% Synthesis filter-bank
ff=remez(12*64,[0 0.725 1.275 32.0]/32.0,{'myfrf',[1 1 0 0]},[5 1]);
ff = ff(1:end-1);
us = ds;
output = polyphaseFBUS(input_bb, ff, us);

%% Plot
if debug
    fontsz = 16;
    %% Plot the signal spectrum
    figure(1);
    [Pxx, W] = pwelch(signal, hamming(1024*16), 1024*8, 1024*16, Fs);
    PxxdB = 10*log10(Pxx);
    Pxx = fftshift(PxxdB - max(PxxdB));
    W = W - Fs/2;
    plot(W, Pxx);
    axis([-5e3, 5e3, -100, 10]);
    xlabel('Frequency (Hz)', 'FontSize', fontsz);
    ylabel('Relative Power Spectrum Density (dB)', 'FontSize', fontsz);
    title('The Channelizer Input Signal Spectrum', 'FontSize', fontsz);
    text(-600, -5, '100Hz');
    text(100, 3, '800Hz');
    text(1000, -10, '1600Hz');
    
    %% PLot the filter spectrum
    figure(2);hold on;
    for mm = -2:2:2
        zisfilter = filter_coef.*exp(2i*pi*(0:fir_length-1)'*mm/M);
        plot((-0.5:1/4096:0.5-1/4096)*M,fftshift(abs(fft(zisfilter,4096))), 'k');
    end
    plot((-0.5:1/4096:0.5-1/4096)*M,fftshift(abs(fft(ff,4096))), 'r');
    axis([-4, 4, 0, 1.1]);
    xlabel('Spectrum Channel Index', 'FontSize', fontsz);
    ylabel('Linear Filter Magnitude', 'FontSize', fontsz);
    text(-3, 1.05, 'Black: Analysis Filter', 'FontSize', fontsz);
    text(1, 1.05, 'Red: Synthesis Filter', 'FontSize', fontsz, 'Color', 'r');
    
    %% Plot the analysis filter output against the original signal to 
    %  demonstrate the effect of neighboring subchannel spectrum overlap.
    figure(3);
    ch = 3;
    bb_signal = (sig_a(ch)*exp(2i*pi*(1:signal_len)'*sig_f(ch)/Fs)).*...
        exp(-2i*pi*(1:signal_len)'*(ch-1)/M);
    plot((1:length(bb_signal))+fir_halfL, real(bb_signal)); hold on;
    plot((ds:ds:length(signal)), real(output_bb(:, ch)), '-r+');
    axis([10001, 11000, -1, 1]);
    leg = legend(['The input of channelizer' ...
        ' path #' num2str(ch)], ['The output of channelizer path #' ...
        num2str(ch)]);
    set(leg, 'FontSize', fontsz);
    txt(1) = {'The difference between the input and output of a single'};
    txt(2) = {'path is due to the spectrum overlap between neighboring'};
    txt(3) = {'path filters. However, the signal can still be perfectly'}; 
    txt(4) = {'reconstructed after the synthesis section!'};
    text(10020, -0.75, txt, 'FontSize', fontsz);
    xlabel('Sample Index', 'FontSize', 14);
    ylabel('Amplitude');
    title('Analysis Section Single Path Input and Output Comparison', ...
        'FontSize', fontsz);
    
    %% Plot the synthesized output against the input to demonstrate perfect
    % reconstruction.
    figure(4);
    plot((1:length(output))+64*12-us+1, real(signal), ...
        'LineWidth', 2); hold on;
    plot(real(output), 'r+');
    axis([10001, 11000, -4, 6]);
    leg = legend('Channelizer Input Signal', 'Channelizer Output Signal');
    set(leg, 'FontSize', fontsz);
    xlabel('Sample Index', 'FontSize', fontsz);
    ylabel('Amplitude', 'FontSize', fontsz);
    title('Channelizer Perfect Reconstruction Demonstration', ...
        'FontSize', fontsz);
end

rmpath(libpath);