%% 
clear *;
h_fig = findobj(0, 'type', 'figure');
for hh = 1:length(h_fig)
    figure(h_fig(hh));clf;
end

libpath = genpath('../Lib');
addpath(libpath);

debug = 1;
verbose = 0;
fontsz = 14;

% For pwelch();
winL = 4096;
fftsz = winL;
win = kaiser(winL, 15);
win = win/sum(win);

%% Generate random bits
numBits = 8192*3*5;
bits = bitgen('rand', numBits);

%% QAM Modulation Setup
bitsPerSymb = 4; % QAM order (4, 16, 64, 256)
% Generate QAM symbol table using gen_recqam_table.m
I_mapping = (graycode(bitsPerSymb/2))';
Q_mapping = flipud(graycode(bitsPerSymb/2));
qam_table = gen_recqam_table(I_mapping, Q_mapping);

%% Prepare bits for QAM modulation
symb_index = sum(mprod(reshape(bits, bitsPerSymb, numBits/bitsPerSymb), ...
    2.^(bitsPerSymb-1:-1:0)'), 1);
symbs = qam_table(symb_index+1, 2);
symbsLen = length(symbs);

%% TX Pulse shaping
sig_BW = 20; % MHz
Fs = 100; % MHz
os = Fs/sig_BW;

% Raised cosine filter
rolloff = 0.4;
filt_order = 64;
hfilt = firrcos(filt_order, sig_BW/2, rolloff, Fs, 'rolloff', 'sqrt');

hf = fft(hfilt, fftsz);
if debug
    figure(1);hold on;
    plot((-0.5:1/fftsz:(0.5-1/fftsz))*Fs, 20*log10(fftshift(abs(hf))), 'r');
    xlabel('Frequency (MHz)');
    ylabel('Amplitude');
    grid on;
end

% Use fred's nyq_2zz
filename = 'shapingpulse.mat';
if ~exist(filename, 'file')
    hfilt2 = nyq_2zz(sig_BW, Fs, 0.25, 26, 1, 0);
    save(filename, 'hfilt2');
else
    load(filename);
end

hf2 = fft(hfilt2, fftsz);
if debug
    figure(1);hold on;
    plot((-0.5:1/fftsz:(0.5-1/fftsz))*Fs, 20*log10(fftshift(abs(hf2))), 'k');
    xlabel('Frequency (MHz)');
    ylabel('Amplitude');
    grid on;
    xlabel('Frequency (MHz)', 'FontSize', fontsz);
    ylabel('Magnitude (dB/Hz)', 'FontSize', fontsz);
    title('Pulse Shaping Filter for Waveform Generation', 'FontSize', fontsz);
end

chosen_filter = hfilt2;
fir_length = length(chosen_filter);
fir_halfL = (fir_length-1)/2;
txsig = conv(chosen_filter, upsample(symbs, os)*os);
rxsig = conv(chosen_filter, txsig);
if debug && verbose
    figure(102);hold on;
    plot(real(rxsig));
    plot(length(chosen_filter)-1+(1:os:length(symbs)*os), real(symbs), 'ro');

    figure(103);hold on;
    plot(real(symbs), imag(symbs), '+');
    rxsymbs = rxsig(length(chosen_filter)-1+(1:os:length(symbs)*os));
    plot(real(rxsymbs), imag(rxsymbs), 'r.');
end

txsigPW = abs(txsig).^2;
meanSigPW = mean(abs(txsigPW(filt_order/2+(1:symbsLen*os))));
maxSigPW = max(txsigPW);
PAPR = 10*log10(maxSigPW/meanSigPW);

if debug
    [Pxx, W] = pwelch(txsig(fir_halfL+(1:length(symbs)*os)), ...
        win, fftsz/2, fftsz, Fs);
    W = fftshift(W - (W >= Fs/2)*Fs);
    Pxx = 10*log10(Pxx);
    Pxx = fftshift(Pxx - max(Pxx));
    figure(104);
    plot(W, Pxx, 'r');
    grid on;
    axis([-Fs/2, Fs/2, -150, 10]);
    xlabel('Frequency (MHz)', 'FontSize', fontsz);
    ylabel('Relative PSD Magnitude (dB/Hz)', 'FontSize', fontsz);
    title('Basedband PSD of Transmitted Signals', 'FontSize', fontsz);    
end


%% NMDFB Prototyping Filters
M = 256; % Number of channels
ds= 128;
% Generate Analysis Prototyping Filter
sinc_hb_period = 6;
sinc_coef = sinc(-(sinc_hb_period-1/M):1/M:(sinc_hb_period-1/M));
sinc_coef = (kaiser(length(sinc_coef), 10))'.*sinc_coef/M;
filter_coef = [0; flatten(sinc_coef, 1)];
fir_length = length(filter_coef);
fir_halfL = fir_length/2;

figure(2);hold on;
for mm = -2:2:2
    zisfilter = filter_coef.*exp(2i*pi*(0:fir_length-1)'*mm/M);
    semilogy((-0.5:1/fftsz:0.5-1/fftsz)*Fs, ...
        20*log10(fftshift(abs(fft(zisfilter,fftsz)))), 'k');
end
axis([-4*Fs/M, 4*Fs/M, -150, 10]);
xlabel('Frequency (MHz)', 'FontSize', fontsz);
ylabel('Linear Filter Magnitude', 'FontSize', fontsz);
text(-3*Fs/M, 5, 'Black: Analysis Filter', 'FontSize', fontsz);
grid on;

figure(3);hold on;
for mm = -2:2:2
    zisfilter = filter_coef.*exp(2i*pi*(0:fir_length-1)'*mm/M);
    semilogy((-0.5:1/fftsz:0.5-1/fftsz)*M, ...
        20*log10(fftshift(abs(fft(zisfilter,fftsz)))), 'k');
end
axis([-4, 4, -150, 10]);
xlabel('Normalized Frequency', 'FontSize', fontsz);
ylabel('Linear Filter Magnitude', 'FontSize', fontsz);
text(-3, 5, 'Black: Analysis Filter', 'FontSize', fontsz);
grid on;

filename = 'synthesis_filter.mat'; 
if exist(filename, 'file')
    load(filename);
else
    ff=remez(fir_length-1,[0 0.75 1.18 M/2]*2/M,{'myfrf',[1 1 0 0]},[1 10]);
    save(filename, 'ff');
end
figure(3);
plot((-0.5:1/fftsz:0.5-1/fftsz)*M,20*log10(fftshift(abs(fft(ff,fftsz)))), 'r');
text(1, 5, 'Red: Synthesis Filter', 'FontSize', fontsz, 'Color', 'r');

%% Analysis Filters
analysis_output = polyphaseFBDS(txsig, filter_coef, ds, M);

%% Mapping
fragment_mapping;
% mapping = (1:M)*eye(M);
mapping = mappings{4, 3};

synthesis_input = zeros(size(analysis_output));
synthesis_input(:, mapping(:, 2)) = analysis_output(:, mapping(:, 1));

%% Synthesis Filters
txwave = polyphaseFBUS(synthesis_input, ff, ds);

%% Plots
if debug && verbose
    figure(4);
    plot(real(txwave));hold on;
    plot(fir_length+1-ds+(1:length(txsig)), real(txsig), 'r');
    figure(5);
    plot(imag(txwave));hold on;
    plot(fir_length+1-ds+(1:length(txsig)), imag(txsig), 'r');
end

%% Spectrum of generated signals
[Pxx, W] = pwelch(txwave(fir_length+1000:end), win, fftsz/2, fftsz, Fs);
figure(7);
W = fftshift(W - (W >= Fs/2)*Fs);
Pxx = 10*log10(Pxx);
Pxx = fftshift(Pxx - max(Pxx));
plot(W, Pxx);
grid on;
xlabel('Frequency (MHz)', 'FontSize', fontsz);
ylabel('Relative PSD Magnitude (dB/Hz)', 'FontSize', fontsz);
title('Basedband PSD of Fragmented Transmitted Signals', 'FontSize', fontsz); 
axis([-50, 50, -150, 10]);

%%
rmpath(libpath);