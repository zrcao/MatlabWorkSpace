%% 

clear *;
libpath = genpath('../Lib');
addpath(libpath);

h_fig = findobj(0, 'type', 'figure');
for hh = 1:length(h_fig)
    figure(h_fig(hh));clf;
end

debug = 1;
verbose = 0;
datasave = 0;
fontsz = 14;
spectrum_fig = 0;

% For pwelch();
winL = 4096;
fftsz = winL;
win = kaiser(winL, 15);
win = win/sum(win);


%% Simulation Parameters
numSymbs = 1024;

sig_BW = 20; % MHz
Fs = 100; % MHz
os = Fs/sig_BW;

% Use fred's nyq_2zz for pulse shaping filter
filename = 'shapingpulse.mat';
if ~exist(filename, 'file')
    hfilt2 = nyq_2zz(sig_BW, Fs, 0.25, 26, 1, 0);
    save(filename, 'hfilt2');
else
    load(filename);
end
shaping_filter = hfilt2;
length_shaping_filter = length(shaping_filter);
halfL_shaping_filter = (length_shaping_filter-1)/2;
% Mapping
fragment_mapping;

%% NMDFB Prototyping Filters
M = 256; % Number of channels
ds= 128;
% Generate Analysis Prototyping Filter
sinc_hb_period = 6;
sinc_coef = sinc(-(sinc_hb_period-1/M):1/M:(sinc_hb_period-1/M));
kaiser_coef = (kaiser(length(sinc_coef), 10))'.*sinc_coef/M;
analysis_filter = [0; flatten(kaiser_coef, 1)];
length_analysis_filter = length(analysis_filter);
halfL_analysis_filter = length_analysis_filter/2;

if debug && verbose
    figure(2);hold on;
    for mm = -2:2:2
        zisfilter = analysis_filter.*...
            exp(2i*pi*(0:length_analysis_filter-1)'*mm/M);
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
        zisfilter = ...
            analysis_filter.*exp(2i*pi*(0:length_analysis_filter-1)'*mm/M);
        semilogy((-0.5:1/fftsz:0.5-1/fftsz)*M, ...
            20*log10(fftshift(abs(fft(zisfilter,fftsz)))), 'k');
    end
    axis([-4, 4, -150, 10]);
    xlabel('Normalized Frequency', 'FontSize', fontsz);
    ylabel('Linear Filter Magnitude', 'FontSize', fontsz);
    text(-3, 5, 'Black: Analysis Filter', 'FontSize', fontsz);
    grid on;
end

filename = 'synthesis_filter.mat'; 
if exist(filename, 'file')
    load(filename);
else
    ff=remez(fir_length-1,[0 0.75 1.18 M/2]*2/M,{'myfrf',[1 1 0 0]},[1 10]);
    save(filename, 'ff');
end
synthesis_filter = ff;
length_synthesis_filter = length(synthesis_filter);

if debug && verbose
    figure(3);
    plot((-0.5:1/fftsz:0.5-1/fftsz)*M, ...
        20*log10(fftshift(abs(fft(synthesis_filter,fftsz)))), 'r');
    text(1, 5, 'Red: Synthesis Filter', 'FontSize', fontsz, 'Color', 'r');
end

%% Monte Carlo Setups
bitsPerSymb_vec = [2, 4, 6, 8, 10];
qamOptions = length(bitsPerSymb_vec);
segments = [2 4 8 13];
numSegments = length(segments);
spaces = [6 5 4 3];
spaceStr = {'500kHz', '2MHz', '5MHz', '10MHz', '20MHz', '50MHz'};


mc = 1;

for seg = 1:numSegments
    numSpace = spaces(seg);
    pmepr_continuous = zeros(qamOptions, numSpace, mc);
    pmepr_fragmented = zeros(qamOptions, numSpace, mc);

    for bb = 1:qamOptions
        display(['Now running ' num2str(bitsPerSymb_vec(bb)) ...
            ' bits per symbol' ' for ' num2str(segments(seg)) ...
            ' segments fragmentation.']);
        %% QAM Modulation Setup
        bitsPerSymb = bitsPerSymb_vec(bb);
        numBits = numSymbs*bitsPerSymb;
        % Generate QAM symbol table using gen_recqam_table.m
        I_mapping = (graycode(bitsPerSymb/2))';
        Q_mapping = flipud(graycode(bitsPerSymb/2));
        qam_table = gen_recqam_table(I_mapping, Q_mapping);

        for ss = 1:numSpace
            mapping = mappings{seg, ss};
            for mm = 1:mc
                %% Generate random bits
                bits = bitgen('rand', numBits);
                %% bits for QAM modulation then waveform generation
                symb_index = sum(mprod(...
                    reshape(bits, bitsPerSymb, numBits/bitsPerSymb...
                    ), 2.^(bitsPerSymb-1:-1:0)'), 1);
                symbs = qam_table(symb_index+1, 2);
                symbsLen = length(symbs);
                txsig = conv(shaping_filter, upsample(symbs, os)*os);

                txsigPW = abs(txsig(halfL_shaping_filter+(1:numSymbs*os))).^2;
                %meanSigPW = mean(abs(txsigPW(filt_order/2+(1:symbsLen*os))));
                maxSigPW = max(txsigPW);
                % Note that the mean power is 1.
                pmepr_continuous(bb, ss, mm) = maxSigPW;

                %% Padding txsigs
                length_padding = ceil(0.5*...
                    (length_analysis_filter + length_synthesis_filter));
                paddedtxsig = [txsig; zeros(length_padding, 1)];

                %% NMDFB Filters
                analysis_output = polyphaseFBDS(paddedtxsig, analysis_filter, ds, M);
                synthesis_input = zeros(size(analysis_output));
                synthesis_input(:, mapping(:, 2)) = ...
                    analysis_output(:, mapping(:, 1));
                txwave = polyphaseFBUS(synthesis_input, synthesis_filter, ds);

                txwavePW = abs(txwave(length_padding+(1:numSymbs*os-100))).^2;
                maxPW = max(txwavePW);
                pmepr_fragmented(bb, ss, mm) = maxPW;           
            end
            
            if debug && bb==1
                %% Spectrum of generated signals
                [Pxx, W] = pwelch(...
                    txwave(length_padding+(1:numSymbs*os-100)), win, ...
                    fftsz/2, fftsz, Fs);
                idx = seg*100+ss;
                hfig = figure(idx);
                if ~ismember(idx, h_fig)
                    set(hfig, 'Position', [0, 0, 560, 140]);
                end
                W = fftshift(W - (W >= Fs/2)*Fs);
                Pxx = 10*log10(Pxx);
                Pxx = fftshift(Pxx - max(Pxx));
                plot(W, Pxx);
                grid on;
                xlabel('Frequency (MHz)', 'FontSize', fontsz);
                ylabel('PSD (dB/Hz)', 'FontSize', fontsz);
                title([num2str(segments(seg)) ' Segments with ' spaceStr{ss}, ...
                    ' Spacing'], 'FontSize', fontsz); 
                axis([-50, 50, -150, 10]);
                figname = ['seg', num2str(segments(seg)), '_', spaceStr{ss}, ...
                    '.pdf'];
                saveTightFigure(hfig, figname);
            end
        end
    end
    filename = ['pmepr_seg' num2str(segments(seg)) '_mc' num2str(mc) '.mat'];
    if datasave
        save(filename, 'pmepr_continuous', 'pmepr_fragmented');
    end
end

rmpath(libpath);
