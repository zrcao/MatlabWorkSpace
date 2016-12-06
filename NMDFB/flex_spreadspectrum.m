%% Clean Workspace

clear *;
h_fig = findobj(0, 'type', 'figure');
for hh = 1:length(h_fig)
    figure(h_fig(hh));clf;
end

%% Setup Simulation Levels

debug = 1;
verbose = 1;
fontsz = 14;
savefigure = 0;

%% Parameters for Simulated Systems
Fs = 100e6; % Sampling rate is 100 MHz
BW_span = 50e6; % 50MHz 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters for DSP Analysis 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%For pwelch();
winL = 4096;
fftsz = winL;
win = kaiser(winL, 15);
win = win/sum(win);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NMDFB Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
M = 256; % Number of channels
ds= 128;
% Generate Analysis Prototyping Filter
sinc_hb_period = 16;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Channel Paramters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
par.txcorrmatrix = 1;
par.rxcorrmatrix = 1;
maxPathDelay = 10e-8; % Seconds
minPathGain = -20; % dB
pathdecay_coeff = (minPathGain/10)*log(10)/maxPathDelay;

channel_case = 1;
switch channel_case
    case 1
        par.pathdelay = [0 110 190 410]*1e-9;
        par.avgPathGains = [0 -9.7 -19.2 -22.8];
    case 2
        par.pathdelay = [0 310 710 1090 1730 2510]*1e-9;
        par.avgPathGains = [0 -1 -9 -10 -15 -20];
    case 3
        par.pathdelay = [0 200 800 1200 2300 3700]*1e-9;
        par.avgPathGains = [0 -0.9 -4.9 -8.0 -7.8 -23.9];
    otherwise
        par.pathdelay = [0:1/Fs:maxPathDelay];
        %par.pathdelay = [0:3/Fs:9/Fs];
        decay_profile = exp(pathdecay_coeff*par.pathdelay);
        par.avgPathGains = 10*log10(decay_profile);
end



%% Generate the channel
H = comm.MIMOChannel('TransmitCorrelationMatrix', par.txcorrmatrix, ...
                     'ReceiveCorrelationMatrix', par.rxcorrmatrix, ...
                     'SampleRate', Fs, 'PathDelays', par.pathdelay, ...
                     'AveragePathGains', par.avgPathGains, ...
                     'MaximumDopplerShift', 0);
                 
% Use fred's nyq_2zz
hfilt2 = nyq_2zz(BW_span, Fs, 0.2, 0, 1, 0);

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
    hold off;
end
             
ch = step(H, [hfilt2'; zeros(800-length(hfilt2), 1)]);

if debug
    figure(2);%subplot(3,1,1);
    scale = M;
    plot((-0.5:1/fftsz:(0.5-1/fftsz))*scale, 20*log10(abs(...
        fftshift(fft(ch, fftsz)))));
    axis([-0.5*scale, 0.5*scale, -80, 20]);
end

%%

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

%% 
seg = [2 4 8 13];
spacing = {'500 kHz', '2 MHz', '5 MHz', '10 MHz', '20 MHz', '50 MHz'};
qam = {'QPSK', '16QAM', '64QAM', '256QAM', '1024QAM'};

%% QAM Modulation Setup
loop = 1;
while loop
    bitsPerSymb = input(['How many bits per symbol? \n' ...
                         '1 - BPSK \n' ...
                         '2 - QPSK \n' ...
                         '4 - 16QAM \n' ...
                         '6 - 64QAM \n' ...
                         '8 - 512QAM \n' ...
                         '10- 1024QAM \n'...
                         'Please provide your option here -- ']);
    if ~ismember(bitsPerSymb, [1 2 4 6 8 10])
        display('Invalid option! Please try again!');
    else
        loop = 0;
    end
end

%% Number of symbols
loop = 1;
while loop
    symbsLen = input('How many symbols you would like to generate? [8192]');
    if isempty(symbsLen)
        symbsLen=8192;
    end
    if symbsLen<8192
        display('The minimum length of symbols is 8192! Please try again!');
    else
        loop = 0;
    end
end
%bitsPerSymb = 4; % QAM order (4, 16, 64, 256)
%% Generate QAM symbol table using gen_recqam_table.m
I_mapping = (graycode(bitsPerSymb/2))';
Q_mapping = flipud(graycode(bitsPerSymb/2));
qam_table = gen_recqam_table(I_mapping, Q_mapping);

%% Generate random bits
numBits = symbsLen*bitsPerSymb;
bits = bitgen('rand', numBits);

%% Prepare bits for QAM modulation
symb_index = sum(mprod(reshape(bits, bitsPerSymb, symbsLen), ...
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
recsig = conv(chosen_filter, txsig);
if debug && verbose
    figure(102);hold on;
    plot(real(recsig));
    plot(length(chosen_filter)-1+(1:os:length(symbs)*os), real(symbs), 'ro');

    figure(103);hold on;
    plot(real(symbs), imag(symbs), '+');
    rxsymbs = recsig(length(chosen_filter)-1+(1:os:length(symbs)*os));
    plot(real(rxsymbs), imag(rxsymbs), 'rx');
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


%% Analysis Filters
txsigpad = [txsig; zeros(2*fir_length, 1)];
analysis_output = polyphaseFBDS(txsigpad, filter_coef, ds, M);

%% Mapping
fragment_mapping;

loop = 1;
while loop
    numSegs = input(['How many segments? \n' ...
                         '1 -  2 Segments \n' ...
                         '2 -  4 Segments \n' ...
                         '3 -  8 Segments \n' ...
                         '4 - 13 segments \n' ...
                         'Please provide your option here -- ']);
    if ~ismember(numSegs, [1 2 3 4])
        display('Invalid option! Please try again!');
    else
        loop = 0;
    end
end

loop = 1;
switch numSegs
    case 1
        while loop
            space = input(['Please choose the spacing between segments? \n' ...
                         '1 -  500 kHz\n' ...
                         '2 -    2 MHz\n' ...
                         '3 -    5 MHz\n' ...
                         '4 -   10 MHz\n' ...
                         '5 -   20 MHz\n' ...
                         '6 -   50 MHz\n' ...
                         'Please provide your option here -- ']);
            if ~ismember(space, [1 2 3 4 5 6])
                display('Invalid option! Please try again!');
            else
                loop = 0;
            end
        end
    case 2
        while loop
            space = input(['Please choose the spacing between segments? \n' ...
                         '1 -  500 kHz\n' ...
                         '2 -    2 MHz\n' ...
                         '3 -    5 MHz\n' ...
                         '4 -   10 MHz\n' ...
                         '5 -   20 MHz\n' ...
                         'Please provide your option here -- ']);
            if ~ismember(space, [1 2 3 4 5])
                display('Invalid option! Please try again!');
            else
                loop = 0;
            end
        end
    case 3
        while loop
            space = input(['Please choose the spacing between segments? \n' ...
                         '1 -  500 kHz\n' ...
                         '2 -    2 MHz\n' ...
                         '3 -    5 MHz\n' ...
                         '4 -   10 MHz\n' ...
                         'Please provide your option here -- ']);
            if ~ismember(space, [1 2 3 4])
                display('Invalid option! Please try again!');
            else
                loop = 0;
            end
        end
    case 4
        while loop
            space = input(['Please choose the spacing between segments? \n' ...
                         '1 -  500 kHz\n' ...
                         '2 -    2 MHz\n' ...
                         '3 -    5 MHz\n' ...
                    'Please provide your option here -- ']);
            if ~ismember(space, [1 2 3])
                display('Invalid option! Please try again!');
            else
                loop = 0;
            end
        end
end

% mapping = (1:M)*eye(M);
mapping = mappings{numSegs, space};

synthesis_input = zeros(size(analysis_output));
synthesis_input(:, mapping(:, 2)) = analysis_output(:, mapping(:, 1));

%synthesis_input = analysis_output;

%% Synthesis Filters
txwave = polyphaseFBUS(synthesis_input, ff, ds);

%% Plots
if debug && verbose
    figure(4);
    plot(real(txwave));hold on;
    plot(fir_length+1-ds+(1:length(txsigpad)), real(txsigpad), 'r');
    figure(5);
    plot(imag(txwave));hold on;
    plot(fir_length+1-ds+(1:length(txsigpad)), imag(txsigpad), 'r');
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

%% Trim the signal
padding = 0*M;
txtrim = txwave(fir_length+1-ds-padding+(1:(length(txsig)+2*padding)));

[Pxx, W] = pwelch(round(txtrim*10^15)/10^12, win, fftsz/2, fftsz, Fs);
figure(71);
W = fftshift(W - (W >= Fs/2)*Fs);
Pxx = 10*log10(Pxx);
Pxx = fftshift(Pxx - max(Pxx));
plot(W, Pxx);
grid on;
xlabel('Frequency (MHz)', 'FontSize', fontsz);
ylabel('Relative PSD Magnitude (dB/Hz)', 'FontSize', fontsz);
title('Basedband PSD of Fragmented Transmitted Signals', 'FontSize', fontsz); 
axis([-50, 50, -150, 10]);

%% Receiver NMDFB
txwavepad = [txtrim; zeros(fir_length-1, 1)];
rx_analysis_output = polyphaseFBDS(txwavepad, filter_coef, ds, M);
rx_synthesis_input = zeros(size(rx_analysis_output));
rx_synthesis_input(:, mapping(:, 1)) = rx_analysis_output(:, mapping(:, 2));
%rx_synthesis_input = rx_analysis_output;
rxwave = polyphaseFBUS(rx_synthesis_input, ff, ds);
rxtrim = rxwave(fir_length+1-ds+(1:length(txtrim)));

[Pxx, W] = pwelch(rxwave(2*fir_length+1000:end), win, fftsz/2, fftsz, Fs);
figure(8);
W = fftshift(W - (W >= Fs/2)*Fs);
Pxx = 10*log10(Pxx);
Pxx = fftshift(Pxx - max(Pxx));
plot(W, Pxx);
grid on;
xlabel('Frequency (MHz)', 'FontSize', fontsz);
ylabel('Relative PSD Magnitude (dB/Hz)', 'FontSize', fontsz);
title('Basedband PSD of Fragmented Transmitted Signals', 'FontSize', fontsz); 
axis([-50, 50, -150, 10]);

if debug && verbose
    figure(9);
    plot(real(rxtrim));hold on;
    plot([1:length(txsig)]+padding, real(txsig), 'm');
    figure(10);
    plot(imag(rxtrim));hold on;
    plot([1:length(txsig)]+padding, imag(txsig), 'm');    
end

recsig = conv(chosen_filter, rxtrim([1:length(txsig)]+padding));
finalsymbs = recsig(length(chosen_filter)-1+(1:os:length(symbs)*os));
hfig = figure(11);
plot(real(finalsymbs), imag(finalsymbs), 'x');
xlabel('Real', 'FontSize', fontsz);
ylabel('Imagery', 'FontSize', fontsz);
title(['Divided into ' num2str(seg(numSegs)) ' Segments spaced by ' ...
    spacing{space}], 'FontSize', fontsz);
if savefigure
    filename = ['./fig/seg-' num2str(seg(numSegs)), '_space-', ...
        spacing{space}, '_bit-', num2str(bitsPerSymb), '.pdf'];
    saveTightFigure(hfig, filename);
end

%%
%rmpath(libpath);