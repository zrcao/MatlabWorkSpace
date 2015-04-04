clear *;
test = 0;

rates = [6 9 12 18 24 36 48 54];
num_rates = length(rates);
delay = 1./rates;

num_nodes = 10;
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
s_nodes(end) = num_nodes;
d_nodes(end) = num_nodes-1;

mc = 5000;
hop1_iterates = zeros(mc, 1);
hop1_noswitch = zeros(mc, 1);
hop2_iterates = zeros(mc, 1);
max_hops = zeros(mc, 1);
max_dist = zeros(mc, 1);
num_bins = 6;
num_hops = zeros(mc, num_bins);

for mm = 1:mc 
    idx = randi([1, num_rates], num_nodes*(num_nodes-1)/2, 1);
    weights = delay(idx);
    
    connections = [d_nodes s_nodes weights];
    DG =  sparse([d_nodes], [s_nodes], [weights]);
    init_DG = DG;
    %view(biograph(DG, [], 'ShowArrows','off','ShowWeights','on')); 
    
    %UG = sparse([s_nodes; d_nodes], [d_nodes; s_nodes], [weights; weights]);
    %UG = tril(DG+DG');
    UG = DG+DG';
    full_UG = full(UG);
    finished = 0;

    iter = 0;
    noswitch = 0;
    old_relay_pool =[];
    hop1_converged = 0;
    while ~hop1_converged
        iter = iter+1;
        [dist,route,pred] = graphshortestpath(DG,1,'directed',false);
        [maxdist, maxdistNode] = max(dist);
        maxpath = graphpred2path(pred, maxdistNode);
        relay_pool = find(pred==1);
        if isequal(relay_pool, old_relay_pool) 
            % If the new search results in a set of potential first hops
            % that is a subset of the previous set of first hops. The
            % search for relay hops stops.
            hop1_converged = 1;
        else
            num_relay = length(relay_pool);
            val = zeros(num_relay, 1);
            for ii = 1:num_relay
                val(ii) = full_UG(1, relay_pool(ii));
            end
            [maxDelay, pos] = max(val);
            maxDelayRelay = relay_pool(pos);
            if min(val)== maxDelay
                % If all first hop relays have the same rates, the search
                % is done.
                hop1_converged=1;
            else
                % Find the longest path. maxpath(2) is the first hop of the
                % longest path.
                copy_weight = 0;
                if full_UG(1, maxpath(2))~=maxDelay
                    % If the longest path's first hop does not have the 
                    % lowest rate (i.e., maxDelay) among all first hop relays,
                    % Check whether the relay hop with the lowest rate can
                    % use maxpath(2) as its relay. It can as long as the
                    % longest delay path doesn't change or the new longest
                    % path has less penalty.
                    DG_tmp = DG;
                    DG_tmp(maxDelayRelay, 1) = 10;
                    %UG_tmp = DG_tmp'+DG_tmp;
                    [dist_tmp,route_tmp,pred_tmp] = ...
                        graphshortestpath(DG_tmp,1,'directed',false);
                    % If the new longest delay is less than the old
                    % delay added with the longer first hopp;
                    altermaxdist = maxdist+maxDelay-full_UG(1, maxpath(2));
                        
                    if (max(dist_tmp)<=altermaxdist)
                        DG(maxDelayRelay, 1) = 10;
                    else
                        noswitch = noswitch + 1;
                        copy_weight = 1;
                    end
                else
                    copy_weight=1;
                end
                
                if copy_weight
                    new_weight = maxDelay;
                    for ii = 1:num_relay
                        DG(relay_pool(ii), 1) = new_weight; 
                    end
                end
                old_relay_pool = relay_pool;
                UG = DG+DG';
                full_UG = full(UG);
            end
        end
    end
    hop1_iterates(mm) = iter;
    hop1_noswitch(mm) = noswitch;
    
    %% Testing code
    if test 
        relay_pool = find(pred==1);
        num_relay = length(relay_pool);
        val = zeros(num_relay, 1);
        for ii = 1:num_relay
            val(ii) = full_UG(1, relay_pool(ii));
        end
        if min(val)~=max(val)
            display('Something is not right after first hop relay selection!');
        end
    end
    
    %% Path after first hopper relay node and rate selection, find all the
    %  second hop nodes
    if length(maxpath)<3
        finished = 1;
    end
    % Remove the link from all third+ nodes to Node 1
    for nn=2:num_nodes
        if ~ismember(nn, relay_pool)
            DG(nn, 1) = 10;
        end
    end
    
    iter =0;
    hop2_converged = 0;
    old_hops = [];
    while ~hop2_converged && ~finished
        iter = iter+1;
        
        [dist,route,pred] = graphshortestpath(DG,1,'directed',false);
        [maxdist, maxdistNode] = max(dist);
        %maxpath = graphpred2path(pred, maxdistNode);
        maxpath = route{maxdistNode};
        if length(maxpath)<3
            finished = 1;
        else
            hops = [];
            val = [];
            for rr = 1:num_relay
                node_pool = find(pred==relay_pool(rr));
                num_thirds = length(node_pool);
                for tt = 1:num_thirds
                    zishop = [relay_pool(rr) node_pool(tt)];
                    hops = [hops; zishop];
                    val = [val; full_UG(zishop(1), zishop(2))];
                end
            end
            [max23Delay, pairIdx] = max(val);
            % check whether the maximum delay hop is between the last two
            % nodes. The way the undirect graph is setup in Matlab requires we
            % to swap the index of the edge between these two nodes.
            cond = (isequal(hops(pairIdx, :), [num_nodes-1, num_nodes])) || ...
                (isequal(hops(pairIdx, :), [num_nodes, num_nodes-1]));
            special = 0;
            if cond
                special = 1;
            end

            if min(val)==max23Delay
                hop2_converged = 1;
            else
                maxpath23Delay = full_UG(maxpath(2), maxpath(3));
                copy_weight = 0;
                if maxpath23Delay~=max23Delay
                    DG_tmp = DG;
                    %DG_tmp(hops(pairIdx, 2), 1) = 10;
                    if ~special
                        DG_tmp(max(hops(pairIdx, :)), min(hops(pairIdx, :))) = 10;
                    else
                        DG_tmp(num_nodes-1, num_nodes) = 10;
                    end
                    [dist_tmp,route_tmp,pred_tmp] = ...
                            graphshortestpath(DG_tmp,1,'directed',false);
                    altermaxdist = maxdist + max23Delay-maxpath23Delay;

                    if (max(dist_tmp)<=altermaxdist)
                        DG = DG_tmp;
                    else
                        copy_weight = 1;
                    end
                else
                    copy_weight = 1;
                end

                if copy_weight
                    num_pairs = length(val);
                    for pp = 1:num_pairs
                        cond = (isequal(hops(pp, :), [num_nodes-1, num_nodes])) ...
                            || (isequal(hops(pp, :), [num_nodes, num_nodes-1]));
                        if cond
                            DG(num_nodes-1,num_nodes) = max23Delay;
                        else
                            DG(max(hops(pp, :)), min(hops(pp, :))) = max23Delay;
                        end
                    end
                end
                old_hops = hops;
                UG = DG+DG';
                full_UG = full(UG);
            end
        end
    end
    hop2_iterates(mm) = iter;
    
    pathhops = zeros(num_nodes-1, 1);
    for ii = 1:num_nodes-1
        pathhops(ii) = length(route{ii+1})-1;
    end
    num_hops(mm, :) = hist(pathhops, 1:num_bins);
    
    max_hops(mm) = max(pathhops);
    max_dist(mm) = max(maxdist);
end




    















































