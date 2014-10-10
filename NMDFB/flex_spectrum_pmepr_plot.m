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
filenames = {'pmepr_seg2_mc1000.mat', 6, 2;
             'pmepr_seg4_mc1000.mat', 5, 4;
             'pmepr_seg8_mc1000.mat', 4, 8;
             'pmepr_seg13_mc1000.mat', 3, 13};
numSegments = length(filenames);

%%
space = {'500 kHz', '2 MHz', '5 MHz', '10 MHz', '20 MHz', '50 MHz'};
numSpace = length(space);
qam = {'QPSK', '16QAM', '64QAM', '256QAM', '1024QAM'};
qamoptions = length(qam);
markers = {'h', 'o', '^', 's', 'd'};
markercolor = {'b', 'k', 'm', 'r', 'g', 'c'};

%% Data structure for PMEPR vs. number of segments
mean_pmepr = cell(numSpace, 1);
for ss = 1:numSpace
    % ss = 1:3, size(4, 5)';
    % ss = 4  , size(3, 5)';
    % ss = 5  , size(2, 5)';
    % ss = 6  , size(1, 5)';
    mean_pmepr{ss, 1} = zeros(qamoptions, 4-((ss-3)>0)*(ss-3));
end
max_pmepr = mean_pmepr;
         
%% 
for ff = 1:numSegments
    load(filenames{ff, 1});
    
    %% Plot the average PMEPR va. spacing curves for each modulation order
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
    axis([0.7, filenames{ff, 2}+.3, 5.8, 8.2]);
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
    title(['Average PMEPR (20 MHz Signal Equally Divided into ', ...
        num2str(filenames{ff, 3}) ' Segments)']);
    
    %% Plot the average and maximum PMEPR vs. Modulation order for the
    %  given fragmentation, averaged over all spacing as the PMEPR are very
    %  close to each other for different spacing
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
    title(['20 MHz Signal Equally Divided into ', ...
        num2str(filenames{ff, 3}), ' Segments']);
    grid on;
    
    %% Build the data structure for plotting PMEPR againist the number of
    % segments
    tmp_mean = mean(pmepr_fragmented, 3);
    tmp_max = max(pmepr_fragmented, [], 3);
    for ss = 1:filenames{ff,2}
        mean_pmepr{ss, 1}(:, ff) = tmp_mean(:, ss);
        max_pmepr{ss, 1}(:, ff) = tmp_max(:, ss);
    end

end

%% Plot the PMEPR against number of segmentations for a given
%  modulation order and spacing

for qq = 1:qamoptions
    hfig = figure(100+qq);
    for ss = 1:numSpace-1
        plot(1:size(mean_pmepr{ss, 1}, 2), mean_pmepr{ss, 1}(qq, :), ...
            ['-', markers{ss}, markercolor{ss}], 'MarkerSize', 6, ...
            'MarkerEdgeColor', markercolor{ss}, 'MarkerFaceColor', ...
            markercolor{ss}, 'LineWidth', 1);
        hold on;
    end
    axis([0.5, 4.5, 4, 7]);
    grid on;
    haxes2 = gca;
    set(haxes2, 'XTick',[1:4]); 
    set(haxes2, 'XTickLabel', {'2 Segments', '4 Segments', '8 Segments', ...
        '13 Segments'}, 'FontSize', fontsz);
    ylabel('Peak-to-Mean Envelope Power Ratio (PMEPR) (dB)', 'FontSize', fontsz);
    ll = legend(space(1:numSpace-1));
    set(ll, 'FontSize', fontsz);
    if qq~=1
        set(ll, 'Location', 'SouthEast');
    end
    title(['Mean PMEPR of a 20 MHz ' qam{qq} ' Signal'], 'FontSize', fontsz);
    saveTightFigure(hfig, ['MeanPMEPR_' qam{qq} '.pdf']);
    
    hfig = figure(200+qq);
    for ss = 1:numSpace-1
        plot(1:size(mean_pmepr{ss, 1}, 2), max_pmepr{ss, 1}(qq, :), ...
            ['-', markers{ss}, markercolor{ss}], 'MarkerSize', 6, ...
            'MarkerEdgeColor', markercolor{ss}, 'MarkerFaceColor', ...
            markercolor{ss}, 'LineWidth', 1);
        hold on;
    end
    axis([0.5, 4.5, 5, 12]);
    grid on;
    haxes2 = gca;
    set(haxes2, 'XTick',[1:4]); 
    set(haxes2, 'XTickLabel', {'2 Segments', '4 Segments', '8 Segments', ...
        '13 Segments'}, 'FontSize', fontsz);
    ylabel('Peak-to-Mean Envelope Power Ratio (PMEPR) (dB)', 'FontSize', fontsz);
    ll = legend(space(1:numSpace-1));
    set(ll, 'FontSize', fontsz);
    if qq~=1
        set(ll, 'Location', 'SouthEast');
    end
    title(['Maximum PMEPR of a 20 MHz ' qam{qq} ' Signal'], 'FontSize', fontsz);
    saveTightFigure(hfig, ['MaxPMEPR_' qam{qq} '.pdf']);
end
