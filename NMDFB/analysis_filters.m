%% Analysis-Bank Filter Analysis
fftsz = 8192*128;
markers = {'x', 'h', 'o', '^', 's', 'd'};
markercolor = {'b', 'k', 'm', 'r', 'g', 'c'};


%% Compare difference number of channels for a given SINC function cycles
sinc_hb_period = 7;
M_vec = [64, 128, 256, 512, 1024, 2048];
num_M = length(M_vec);

for mm = 1:num_M
    M = M_vec(mm);
    sinc_coef = sinc(-(sinc_hb_period-1/M):1/M:(sinc_hb_period-1/M));
    sinc_coef = (kaiser(length(sinc_coef), 10))'.*sinc_coef/M;
    filter_coef = [0; flatten(sinc_coef, 1)];
    % plot
    figure(1);hold on;
    semilogy((-0.5:1/fftsz:0.5-1/fftsz)*M, ...
        20*log10(fftshift(abs(fft(sinc_coef,fftsz)))), markercolor{mm});
    hold off;
    figure(2);hold on;
    for cc = -1:1
        zisfilter = filter_coef.*exp(2i*pi*(0:length(filter_coef)-1)'*cc/M);
        semilogy((-0.5:1/fftsz:0.5-1/fftsz)*M, ...
            20*log10(fftshift(abs(fft(zisfilter,fftsz)))), markercolor{mm});
    end
    hold off;
end

figure(1);
axis([-4, 4, -150, 10]);
xlabel('Normalized Frequency', 'FontSize', fontsz);
ylabel('Linear Filter Magnitude', 'FontSize', fontsz);
grid on;

figure(2);
axis([-4, 4, -150, 10]);
xlabel('Normalized Frequency', 'FontSize', fontsz);
ylabel('Linear Filter Magnitude', 'FontSize', fontsz);
grid on;

% Section Conclusions
% 1. For a given SINC function cycle, the number of channels doesn't impact
% the spectrum shape of the resulting prototyping analysis filter against
% the normalized spectrum, i.e., (-0.5:1/fftsz:0.5-1/fftsz)*M
% 2. In other words, the overlap between two neighboring filters are
% constant against normalized spectrum

%% Compare the Kaiser Window BETA coefficients
beta = [1, 5, 10, 15];
M = 256;

for bb = 1:length(beta)
    sinc_coef = sinc(-(sinc_hb_period-1/M):1/M:(sinc_hb_period-1/M));
    sinc_coef = (kaiser(length(sinc_coef), beta(bb)))'.*sinc_coef/M;
    filter_coef = [0; flatten(sinc_coef, 1)];
    % plot
    figure(3);hold on;
    semilogy((-0.5:1/fftsz:0.5-1/fftsz)*M, ...
        20*log10(fftshift(abs(fft(sinc_coef,fftsz)))), markercolor{bb});
    hold off;
end
figure(3);
axis([-4, 4, -150, 10]);
xlabel('Normalized Frequency', 'FontSize', fontsz);
ylabel('Linear Filter Magnitude', 'FontSize', fontsz);
grid on;
% Section Conclusions
% 1. The higher the beta of the kaiser window, the lower the side lobes,
% and the smaller the passband ripples.


%% Compare different filter lengths (The number of SINC periods)
SINC_vec = [4, 8, 12, 16, 20, 24];
M = 256;
beta = 10;
for ss = 1:length(SINC_vec)
    sinc_hb_period = SINC_vec(ss);
    sinc_coef = sinc(-(sinc_hb_period-1/M):1/M:(sinc_hb_period-1/M));
    sinc_coef = (kaiser(length(sinc_coef), beta))'.*sinc_coef/M;
    filter_coef = [0; flatten(sinc_coef, 1)];
    % plot
    figure(4);hold on;
    semilogy((-0.5:1/fftsz:0.5-1/fftsz)*M, ...
        20*log10(fftshift(abs(fft(sinc_coef,fftsz)))), markercolor{ss});
    hold off;
end
figure(4);
axis([-4, 4, -150, 10]);
xlabel('Normalized Frequency', 'FontSize', fontsz);
ylabel('Linear Filter Magnitude', 'FontSize', fontsz);
grid on;
% Section Conclusions
% 1. The filter length determines the sharpness of the main lobe while
% keeping the same 3dB bandwidth of the main lobe. Therefore, the longer
% the filter, the narrower the main lobe.
% 2. The sidelobe and the passband ripples doesn't vary significantly along
% with the filter length.
% 3. Since the main lobe is narrower given longer filters, the overlap
% between neighboring channelizer bins are therefore smaller. 
% 4. Smaller overlap is preferrable for NMDFB-SS signals. On one hand, we
% can accommodate a wider signal inside each bin. On the other hand, the
% wasted bandwidth in between neighboring replicas is reduced thus the
% spectrum is more spreaded out, which is ideal for spread spectrum
% signals. A longer filter may require more channelizer paths. This is
% another feature good for NMDFB, as we can put more replicas over the
% spectrum.