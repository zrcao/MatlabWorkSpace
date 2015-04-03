clear *;
test = 1;

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
hop1_noswitch = zeros(mc, 1);

hop2_iterates = zeros(mc, 1);
max_hops = zeros(mc, 1);
for mm = 1:mc
    idx = randi([1, num_rates], num_nodes*(num_nodes-1)/2, 1);
    weights = delay(idx);

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
    [dist; pred]
    
    iter =0;
    hop2_converged = 0;
    old_hops = [];
    while ~hop2_converged && ~finished
        iter = iter+1;
        hops = [];
        val = [];
        for rr = 1:num_relay
            node_pool = find(pred==relay_pool(rr));
            num_thirds = length(node_pool);
            for tt = 1:num_thirds
                zishop = [relay_pool(rr) node_pool(tt)];
                hops = [hops; zishop];
                val = [val; full_UG(zishop(1), zishop(2))];
                DG(node_pool(tt), 1) = 10;
            end
        end
        [max23Delay, pairIdx] = max(val);
        % check whether the maximum delay hop is between 9 and 10;
        special = 0;
        if isequal(hops(pairIdx, :), [9, 10]) || isequal(hops(pairIdx, :), [10, 9])
            special = 1;
        end
        
        if min(val)==max23Delay
            hop2_converged = 1;
        else
            maxpath23Delay = full_UG(maxpath(2), maxpath(3));
            copy_weight = 0;
            if maxpath23Delay~=max23Delay
                DG_tmp = DG;
                DG_tmp(hops(pairIdx, 2), 1) = 10;
                if ~special
                    DG_tmp(max(hops(pairIdx, :)), min(hops(pairIdx, :))) = 10;
                else
                    DG_tmp(9, 10) = 10;
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
                    if isequal(hops(pp, :), [9, 10]) || isequal(hops(pp, :), [10, 9])
                        DG(9,10) = max23Delay;
                    else
                        DG(max(hops(pp, :)), min(hops(pp, :))) = max23Delay;
                    end
                end
            end
            old_hops = hops;
            UG = DG+DG';
            full_UG = full(UG);
        end
        [dist,route,pred] = graphshortestpath(DG,1,'directed',false);
        [maxdist, maxdistNode] = max(dist);
        maxpath = graphpred2path(pred, maxdistNode);
        if length(maxpath)<3
            finished = 1;
        end
    end
   
    
    
%     %% Dealing with the second hop
%     
%     hop2_converged = 0;
%     while ~hop2_converged
%         hop2_nodes = find(pred~=1 & pred~=0);
%         num_hop2_nodes = length(hop2_nodes);
%         relays = [];
%         for hh = 1:num_hop2_nodes;
%             if ~ismember(pred(hop2_nodes(hh)), relays)
%                 relays = [relays; pred(hop2_nodes(hh))];
%             end
%         end
%         relays = sort(relays);
%         
%         val = zeros(num_hop2_nodes, 1);
%         for ii = 1:hop2_nodes
%             idx1 = min(hop2_nodes(ii), pred(hop2_nodes(ii)));
%             idx2 = max(hop2_nodes(ii), pred(hop2_nodes(ii)));
%             val(ii) = DG(idx1, idx2);
%         end
%         new_weight=max(val);
%         if min(val)== new_weight
%             hop2_converged=1;
%         else
%             for ii = 1:num_relay
%                 idx1 = min(hop2_nodes(ii), pred(hop2_nodes(ii)));
%                 idx2 = max(hop2_nodes(ii), pred(hop2_nodes(ii)));
%                 DG(idx1, idx2) = new_weight; 
%             end
%         end
%     end
    
    paths = graphpred2path(pred, [2:num_nodes]);
    pathhops = zeros(num_nodes-1, 1);
    for ii = 1:num_nodes-1
        pathhops(ii) = length(paths{1})-1;
    end
    max_hops(mm) = max(pathhops);  
end



