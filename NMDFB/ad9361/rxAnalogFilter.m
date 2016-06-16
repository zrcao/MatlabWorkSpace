bbbw = [400e3 3e6, 10e6, 20e6];

F = logspace(-1, log10(400e6), 8192);

hfig1 = figure(1);hold on;
hfig2 = figure(2);hold on;
markercolor = {'b', 'k', 'm', 'r', 'g', 'c'};

for ll = 1:length(bbbw)
    tia_cutoff = 2.5*bbbw(ll);
    Htia = rx_tia(tia_cutoff, F);
    
    bblpf_cutoff = 1.4*bbbw(ll);
    Hbb = rx_bblpf(bblpf_cutoff, F);
    
    figure(ll*10);hold on;grid on;
    plot(F/1e6, 20*log10(abs(Htia)), markercolor{1}, 'LineWidth', 2);
    plot(F/1e6, 20*log10(abs(Hbb)), markercolor{2}, 'LineWidth', 2);
    
    tt = 20*(log10(abs(Htia))+log10(abs(Hbb)));
    plot(F/1e6, tt, markercolor{3}, 'LineWidth', 2);
    
    figure(1);
    plot(F/1e6, tt, markercolor{ll}, 'LineWidth', 2);
    figure(2);
    plot(F/1e6, tt, markercolor{ll}, 'LineWidth', 2);
    
end

fontsz = 14;
figure(1);
axis([0, 200, -75, 5]);
grid on;
title('AD9361 Rx Analogy TIA and Baseband LPF Joint Response','FontSize',fontsz);
xlabel('Frequency (MHz)', 'FontSize', fontsz);
ylabel('Magnitude (dB)', 'FontSize', fontsz);
ll = legend('BBBW = 400kHz', 'BBBW = 3MHz', 'BBBW = 10MHz', 'BBBW = 20MHz');
set(ll, 'FontSize', fontsz);
saveTightFigure(hfig1, 'AD9361_RX_LPF_200MHz.pdf');

figure(2);
axis([0, 10, -35, 5]);
grid on;
title('AD9361 Rx Analogy TIA and Baseband LPF Joint Response','FontSize',fontsz);
xlabel('Frequency (MHz)', 'FontSize', fontsz);
ylabel('Magnitude (dB)', 'FontSize', fontsz);
ll = legend('BBBW = 400kHz', 'BBBW = 3MHz', 'BBBW = 10MHz', 'BBBW = 20MHz');
set(ll, 'FontSize', fontsz, 'Location', 'best');
saveTightFigure(hfig2, 'AD9361_RX_LPF_10MHz.pdf');