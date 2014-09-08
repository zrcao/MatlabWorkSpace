%%
clear *;
libpath = genpath('../Lib');
addpath(libpath);

h_fig = findobj(0, 'type', 'figure');
for hh = 1:length(h_fig)
    figure(h_fig(hh));clf;
end

%% 
load('pmepr_bin13.mat');

figure(1);hold on;
plot([1:5], 10*log10(mean(mean(pmepr_continuous, 3), 2)), '*');
plot([1:5], 10*log10(max(max(pmepr_continuous, [], 3), [], 2)), 's'); 
set(gca, 'XTick', [1:5]);
set(gca, 'XTickLabel', [1:5]);

plot([1:5], 10*log10(mean(pmepr_fragmented, 3)));
plot([1:5], 10*log10(max(pmepr_fragmented, [], 3)), '^');


load('pmepr_bin2.mat');

figure(2);hold on;
plot([1:5], 10*log10(mean(mean(pmepr_continuous, 3), 2)), '*');
plot([1:5], 10*log10(max(max(pmepr_continuous, [], 3), [], 2)), 's'); 
set(gca, 'XTick', [1:5]);
set(gca, 'XTickLabel', [1:5]);

plot([1:5], 10*log10(mean(pmepr_fragmented, 3)));
plot([1:5], 10*log10(max(pmepr_fragmented, [], 3)), '^');
