function [frozen_nodes, relay_nodes, tbd_nodes, edges] = combat_search...
    (frozen_nodes, relay_nodes, tbd_nodes, edges, varargin)
% The following function performs a single hop relay and rate
% identification for the COMBAT operation. 
% The input has three groups of nodes
%   1. frozen_nodes : Nodes that not only have been processed in previous 
%                     stages, but it connections to all other nodes have 
%                     been purged such that only their relay destinations
%                     are left. 
%   2. relay_nodes  : relays that are identified in the previous hop stage.
%                     The connection among these relay_nodes have been
%                     purged. However, their connections to unprocssed
%                     nodes are still left.
%   3. tbd_nodes    : nodes that have not been processed
% The fourth inputs is edges, which is the node pairs and corresponding
% weights to define a grape, the columns are
%       [destination_nodes, source_nodes, weights]

if ~isempty(varargin)
    source = varargin{1};
else
    source = 1;
end

num_nodes = max(max(edges(:, 1:2)));
num_relay = length(relay_nodes);

iter = 0;
old_hops =[];
hop_converged = 0;
while ~hop_converged
    iter = iter+1;
%     if iter>=20
%         trouble =1;
%     end
    DG =  sparse(edges(:,1), edges(:,2), edges(:,3), num_nodes, num_nodes);
    %view(biograph(DG, [], 'ShowArrows','off','ShowWeights','on')); 
    [dist,route,pred] = graphshortestpath(DG, source,'directed',false);
    [maxdist, maxdistNode] = max(dist);
    maxpath = graphpred2path(pred, maxdistNode);
    
    hops = zeros(num_nodes-1,2);
    hopWeights = zeros(num_nodes-1, 1);
    cc = 0;
    maxpathflag = 0;
    for rr = 1:num_relay
        if ismember(relay_nodes(rr), maxpath)
            [tmp, idx] = find(maxpath==relay_nodes(rr));
            maxpathdst = maxpath(idx+1);
            maxpathflag = 1;
        end
        node_pool = find(pred==relay_nodes(rr));
        num_thirds = length(node_pool);
        for tt = 1:num_thirds
            cc = cc + 1;
            zishop = [relay_nodes(rr) node_pool(tt)];
            hops(cc,:) = zishop;
            hopWeights(cc) = getEdgeWeight(edges, zishop);
            if maxpathflag && (node_pool(tt) == maxpathdst)
                maxpathHopWeight = hopWeights(cc);
            end
        end
    end
    hops = hops(1:cc, :);
    hopWeights = hopWeights(1:cc, :);
    [maxHopWeight, idx] = max(hopWeights);
    maxhop = hops(idx, :);

    if (isequal(hops, old_hops)) && (min(hopWeights) == maxHopWeight) 
        % If the new search results in a set of potential hops
        % that is the same as the previous set of hops, and the weights are
        % all the same, then the search is finished.
        hop_converged = 1;
    else
        copy_weight = 1;

        if maxpathHopWeight~=maxHopWeight
            % If the longest path's hop weight does not have the 
            % lowest rate (i.e., maxHopWeight) among all hop weights,
            % check whether the longest hop with the lowest rate can
            % use maxpath(2) as its relay. It can as long as the
            % longest delay path doesn't change or the new longest
            % path has less penalty.
            edges_tmp = removeEdge(edges, maxhop);
            DG_tmp=sparse(edges_tmp(:, 1), edges_tmp(:,2), ...
                edges_tmp(:,3), num_nodes, num_nodes);
            [dist_tmp,route_tmp,pred_tmp] = ...
                graphshortestpath(DG_tmp,source,'directed',false);
            % If the new longest delay is less than the old
            % delay added with the longer first hopp;
            altermaxdist = maxdist+maxHopWeight-maxpathHopWeight;

            if (max(dist_tmp)<=altermaxdist)
                edges = edges_tmp;
                copy_weight = 0;
            end
        end

        if copy_weight
            for hh=1:cc
                edges = setEdge(edges, hops(hh, :), maxHopWeight);
            end
        end
        old_hops = hops;
    end    
end

old_relay_nodes = relay_nodes;

relay_nodes = hops(:, 2);
% Eliminate the new relay nodes from the tbd_nodes
for rr=1:length(relay_nodes)
    pos = find(tbd_nodes == relay_nodes(rr));
    if ~isempty(pos)
        tbd_nodes(pos) = [];
    end
end
% Remove all edges from the new tbd_nodes to the olde_relay_nodes;
for tt = 1:length(tbd_nodes)
    for rr = 1:length(old_relay_nodes)
        zishop = [tbd_nodes(tt), old_relay_nodes(rr)];
        edges = removeEdge(edges, zishop);
    end
end

% Remove unused edge between old_relay_nodes and new relay_nodes
for rr = 1:length(old_relay_nodes)
    for nn = 1:length(relay_nodes)
        cond = (hops(:,1)==old_relay_nodes(rr)) & ...
            (hops(:, 2) == relay_nodes(nn));
        if isempty(find(cond, 1))
            zisedge = [old_relay_nodes(rr) relay_nodes(nn)];
            edges = removeEdge(edges, zisedge);
        end
    end
end

% Put the old_relay_nodes to the frozen_nodes
frozen_nodes = [frozen_nodes; old_relay_nodes];

% Remove the edges among nodes in the new relay_nodes
for rr=1:(length(relay_nodes)-1)
    for nn = (rr+1):length(relay_nodes)
        zishop = [relay_nodes(rr) relay_nodes(nn)];
        edges = removeEdge(edges, zishop);
    end
end

end % END OF FUNCTION

function edges = removeEdge(edges, hop)
    thisidx = findEdge(edges, hop);
    edges(thisidx, :) = [];
end


function edges = setEdge(edges, hop, weight)
    thisidx = findEdge(edges, hop);
    edges(thisidx, 3) = weight;
end

function weight = getEdgeWeight(edges, hop)
    thisidx = findEdge(edges, hop);
    weight = edges(thisidx, 3);
end

function thisidx = findEdge(edges, hop)
% This function returns the row index of the hop in the edge matrix
    thisidx = find((edges(:,1)==max(hop))&(edges(:,2)==min(hop)));
end