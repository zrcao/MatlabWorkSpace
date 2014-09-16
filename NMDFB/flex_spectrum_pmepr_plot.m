%%
clear *;
libpath = genpath('../Lib');
addpath(libpath);

h_fig = findobj(0, 'type', 'figure');
for hh = 1:length(h_fig)
    figure(h_fig(hh));clf;
end

fontsz = 14;

%% Results to be processed
filenames = {'pmepr_seg2_mc1000.mat', 6;
             'pmepr_seg4_mc1000.mat', 5;
             'pmepr_seg8_mc1000.mat', 4;
             'pmepr_seg13_mc1000.mat', 3};

%%
space = {'500 kHz', '2 MHz', '5 MHz', '10 MHz', '20 MHz', '50 MHz'};
qam = {'QPSK', '16QAM', '64QAM', '256QAM', '1024QAM'};
qamoptions = length(qam);
markers = {'h', 'o', '^', 's', 'd'};
markercolor = {'b', 'k', 'm', 'r', 'g', 'c'};

         
%% 
for ff = 1:4
    load(filenames{ff, 1});
    figure((ff-1)*10+1);
    for oo = 1:qamoptions
        plot(1:filenames{ff, 2}, ...
            10*log10(mean(pmepr_fragmented(oo, :, :), 3)), ...
            ['-', markers{oo}, markercolor{oo}], ...
            'MarkerSize', 6, ...
            'MarkerEdgeColor', markercolor{oo}, ...
            'MarkerFaceColor', markercolor{oo}, ...
            'LineWidth', 1);
        hold on;
    end
    axis([0.7, filenames{ff, 2}+.3, 5.8, 8]);
    grid on;
%     switch ff
%         case 2
%             axis([0.7, filenames{ff, 2}+.3, 6.6, 8]);
%         case 4
%             axis([0.7, filenames{ff, 2}+.3, 5.6, 8]);       
%     end
 
    set(gca, 'XTick', 1:filenames{ff,2});
    set(gca, 'XTickLabel', space(1:filenames{ff, 2}), 'FontSize', fontsz);
    xlabel('Frequency Spacing Between Neighboring Segments', 'FontSize', fontsz);
    ylabel('Peak-to-Mean Envelope Power Ratio (PMEPR) (dB)', 'FontSize', fontsz);
    ll = legend(qam, 'Location', 'SouthEast');
    set(ll, 'FontSize', fontsz);
    title('Average PMEPR (20 MHz Signal Equally divided into 13 Segments)');

    figure((ff-1)*10+2);
    plot(1:5, 10*log10(mean(mean(pmepr_continuous, 3), 2)), '-bd', ...
        'MarkerSize', 8, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b', ...
        'LineWidth', 1); 
    hold on;
    plot(1:5, 10*log10(max(max(pmepr_continuous, [], 3), [], 2)), '-bs', ...
        'MarkerSize', 6, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b', ...
        'LineWidth', 1);
    plot(1:5, 10*log10(mean(mean(pmepr_fragmented, 3), 2)), '--rh', ...
        'MarkerSize', 8, 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r', ...
        'LineWidth', 1);
    plot(1:5, 10*log10(max(max(pmepr_fragmented, [], 3), [], 2)), '--r^', ...
        'MarkerSize', 8, 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r', ...
        'LineWidth', 1);
    axis([0.5, 5.5, 3, 11]);
    set(gca, 'XTick', 1:5);
    set(gca, 'XTickLabel', qam, 'FontSize', fontsz);
    ll = legend('Continuous Spectrum Average PMEPR', ...
                'Continuous Spectrum Maximum PMEPR', ...
                'Fragmented Spectrum Average PMEPR', ...
                'Fragmented Spectrum Maximum PMEPR', 'Location', 'SouthEast');
    set(ll, 'FontSize', fontsz);
    xlabel('QAM Modulation Order', 'FontSize', fontsz);
    ylabel('Peak-to-Mean Envelope Power Ratio (PMEPR) (dB)', 'FontSize', fontsz);
    title('20 MHz Signal Equally divided into 13 Segments');
    grid on;
end


load('pmepr_bin2.mat');

figure(2);hold on;
plot([1:5], 10*log10(mean(mean(pmepr_continuous, 3), 2)), '*');
plot([1:5], 10*log10(max(max(pmepr_continuous, [], 3), [], 2)), 's'); 
set(gca, 'XTick', [1:5]);
set(gca, 'XTickLabel', [1:5]);

plot([1:5], 10*log10(mean(pmepr_fragmented, 3)));
plot([1:5], 10*log10(max(pmepr_fragmented, [], 3)), '^');
