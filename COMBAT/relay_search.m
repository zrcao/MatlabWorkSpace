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

mc = 100;


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

num_bins = 6;
figure(1);
num_hops = num_hops(:, 2:end);
hop_distribution = sum(num_hops, 1);
hop_percentage = hop_distribution/sum(hop_distribution);

figure(2);











