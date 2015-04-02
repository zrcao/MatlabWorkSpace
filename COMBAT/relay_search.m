rates = [6 9 12 18 24 36 48 54];
num_rates = length(rates);
delay = 1./rates;

num_nodes = 10;
s_nodes=[];
d_nodes = [];

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
hop1_abnormal = zeros(mc, 1);
hop1_noswitch = zeros(mc, 1);

hop2_iterates = zeros(mc, 1);
max_hops = zeros(mc, 1);
for mm = 1:mc
    idx = randi([1, num_rates], num_nodes*(num_nodes-1)/2, 1);
    weights = delay(idx);

    DG =  sparse([d_nodes], [s_nodes], [weights]);
    %view(biograph(DG, [], 'ShowArrows','off','ShowWeights','on')); 
    
    %UG = sparse([s_nodes; d_nodes], [d_nodes; s_nodes], [weights; weights]);
    %UG = tril(DG+DG');
    UG = DG+DG';
    full_UG = full(UG);

    iter = 0;
    abnorm = 0;
    noswitch = 0;
    old_relay_pool =[];
    hop1_converged = 0;
    while ~hop1_converged
        iter = iter+1;
        [dist,path,pred] = graphshortestpath(UG,1,'directed',false);
        relay_pool = find(pred==1);
        if ismember(relay_pool, old_relay_pool) 
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
                [maxdist, maxdistNode] = max(dist);
                maxpath = graphpred2path(pred, maxdistNode);
                
                if full_UG(1, maxpath(2))~=maxDelay
                    abnorm = abnorm+1;
                    % If the longest path's first hop does not have the 
                    % lowest rate (i.e., maxDelay) among all first hop relays,
                    % Check whether the relay hop with the lowest rate can
                    % use maxpath(2) as its relay. It can as long as the
                    % longest delay path doesn't change or the new longest
                    % path has less penalty.
                    DG_tmp = DG;
                    DG_tmp(maxDelayRelay, 1) = 10;
                    UG_tmp = DG_tmp'+DG_tmp;
                    [dist_tmp,path_tmp,pred_tmp] = ...
                        graphshortestpath(UG_tmp,1,'directed',false);
                    if max(dist_tmp)<=maxdist
                        DG(maxDelayRelay, 1) = 10;
                    else
                        noswitch = noswitch + 1;
                    end
                else
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
    hop1_abnormal(mm) = abnorm;
    hop1_noswitch(mm) = noswitch;
    
    paths = graphpred2path(pred, [2:num_nodes]);
    pathhops = zeros(num_nodes-1, 1);
    for ii = 1:num_nodes-1
        pathhops(ii) = length(paths{1})-1;
    end
    max_hops(mm) = max(pathhops);  
end
    
    hop2_converged = 0;
    while ~hop2_converged
        hop2_nodes = find(pred~=1 & pred~=0);
        num_hop2_nodes = length(hop2_nodes);
        relays = [];
        for hh = 1:num_hop2_nodes;
            if ~ismember(pred(hop2_nodes(hh)), relays)
                relays = [relays; pred(hop2_nodes(hh))];
            end
        end
        relays = sort(relays);
        
        val = zeros(num_hop2_nodes, 1);
        for ii = 1:hop2_nodes
            idx1 = min(hop2_nodes(ii), pred(hop2_nodes(ii)));
            idx2 = max(hop2_nodes(ii), pred(hop2_nodes(ii)));
            val(ii) = DG(idx1, idx2);
        end
        new_weight=max(val);
        if min(val)== new_weight
            hop2_converged=1;
        else
            for ii = 1:num_relay
                idx1 = min(hop2_nodes(ii), pred(hop2_nodes(ii)));
                idx2 = max(hop2_nodes(ii), pred(hop2_nodes(ii)));
                DG(idx1, idx2) = new_weight; 
            end
        end
    end
    
    



