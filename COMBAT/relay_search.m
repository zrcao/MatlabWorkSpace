clear *;
test = 0;

rates = [6 9 12 18 24 36 48 54];
num_rates = length(rates);
delay = 1./rates;

num_nodes = 13;
s_nodes=[];
d_nodes = [];
% In the sparse graph setup, the destination nodes are always larger than
% the source node, except the last two nodes, in which the source node is
% larger.
for source = 1:num_nodes
    for dest = source+1:num_nodes
        s_nodes = [s_nodes; source];
        d_nodes = [d_nodes; dest];
    end
end
%s_nodes(end) = num_nodes;
%d_nodes(end) = num_nodes-1;

mc = 50000;

max_hops = zeros(mc, 1);
max_dist = zeros(mc, 1);
num_bins = 6;
num_hops = zeros(mc, num_bins+1); % 

for mm = 1:mc 
    % Generate the graph for this run
    idx = randi([1, num_rates], num_nodes*(num_nodes-1)/2, 1);
    weights = delay(idx);
    edges = [d_nodes s_nodes weights'];
    multicastsource = randi([1, num_nodes], 1);
    %multicastsource = 1;
    
    finished = 0;
    relay_nodes = multicastsource;
    tbd_nodes = 1:num_nodes;
    pos = find(tbd_nodes == multicastsource);
    tbd_nodes(pos) = [];
    frozen_nodes = [];

    stage = 0;
    while ~finished
        stage = stage+1;
        [frozen_nodes, relay_nodes, tbd_nodes, edges] = combat_search...
            (frozen_nodes, relay_nodes, tbd_nodes, edges, multicastsource);
        
        if isempty(tbd_nodes) 
            finished = 1;
        end
    end
    
    % Process the finaly route 
    DG =  sparse(edges(:,1), edges(:,2), edges(:,3), num_nodes, num_nodes);
    %view(biograph(DG, [], 'ShowArrows','off','ShowWeights','on')); 
    [dist,route,pred] = graphshortestpath(DG, multicastsource,'directed',false);
    max_dist(mm) = max(dist);
    max_hops(mm) = stage;
    
    pathhops = zeros(num_nodes, 1);
    for ii = 1:num_nodes
        pathhops(ii) = length(route{ii})-1;
    end
    num_hops(mm, :) = hist(pathhops, 0:num_bins);   
end

hop_distribution = sum(num_hops(:, 2:end), 1); 
% Above, the first column is the multicastsource itself.
hop_percentage = hop_distribution/sum(hop_distribution);
frame_hist = hist(max_hops, 0:num_bins);
frame_percentage = frame_hist(2:end)/mc;

rate_bins  = 5:0.1:30;
rate_hist = hist(1./max_dist, rate_bins)/mc;

%% Save results
filename = 'relay_search.mat';
save(filename);

%% Plots
fontsz = 18;

h1=figure(1);
fh = bar(1:num_bins, [hop_percentage; frame_percentage]');
set(fh(2), 'FaceColor', 'm', 'LineStyle', ':');
haxes = gca;
set(haxes, 'XLim', [0 6]);
set(haxes, 'XTickLabel', {'1', '2', '3', '4', '5', ''}, 'FontSize', fontsz);
xlabel('Number of COMBAT Transmission Hops', ...
    'FontSize', fontsz+2, 'FontWeight','bold');
set(haxes, 'YLim', [0, 0.7]);
set(haxes, 'YTick', [0:0.1:0.7]);
set(haxes, ...
    'YTickLabel', {'0', '10%', '20%', '30%', '40%', '50%', '60%', '70%'}, ...
    'FontSize', fontsz);
ylabel(haxes, 'Percentage', 'FontSize', fontsz+2, 'FontWeight','bold');
title('Distribution of COMBAT Transmission Hops', 'FontSize', fontsz+2, ...
    'FontWeight','bold');
lh = legend('Hops of Individual Nodes', 'Hops of Multicast Sessions');
set(lh, 'FontSize', fontsz+2);
saveTightFigure(h1, 'percent_hops.pdf');

h2=figure(2);
ratecdf = cumsum(rate_hist);
plot(rate_bins, ratecdf, 'LineWidth', 2); hold on;
wificdf = zeros(size(rate_bins));
pos =  find(rate_bins==6);
wificdf(pos:end) = 1;
plot(rate_bins, wificdf, 'r--', 'LineWidth',2);
haxes = gca;
set(haxes, 'XLim', [4,28]);
set(haxes, 'XTick', 4:2:28);
%set(haxes, 'XTickLabel', {'6', '10', '14', '18', '22', '26'}, ... 
%    'FontSize', fontsz);
xlabel('Link Layer Multicast Data Rate (Mbps)', 'FontWeight','bold', ...
    'FontSize', fontsz+2);
set(haxes, 'YLim', [0, 1.02]);
set(haxes, 'YTick', 0:0.1:1);
set(haxes, 'YTickLabel', {'0', '10%', '20%', '30%', '40%', '50%', ...
    '60%', '70%', '80%', '90%', '100%'}, 'FontSize', fontsz);
ylabel('Cumulative Percentage', 'FontWeight','bold', ...
    'FontSize', fontsz+2);
title('Cumulative Distribution of Multicast Data Rate',  'FontSize', fontsz+2, ...
    'FontWeight', 'bold');
ll = legend('COMBAT Approach', 'Base Rate Approach', 'Location', 'SouthEast');
set(ll, 'FontSize', fontsz+2);
grid on;
saveTightFigure(h2, 'link_rate.pdf');

hold off;



