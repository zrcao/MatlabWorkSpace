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

mc = 1000;
hop1_iterates = zeros(mc, 1);
hop2_iterates = zeros(mc, 1);
max_hops = zeros(mc, 1);
for mm = 1:mc
    idx = randi([1, num_rates], num_nodes*(num_nodes-1)/2, 1);
    weights = delay(idx);

    DG =  sparse([s_nodes], [d_nodes], [weights]);
    %UG = sparse([s_nodes; d_nodes], [d_nodes; s_nodes], [weights; weights]);
    UG = tril(DG+DG');
    %view(biograph(DG, [], 'ShowArrows','off','ShowWeights','on')); 

    iter = 0;
    old_relay_pool =[];
    hop1_converged = 0;
    while ~hop1_converged
        iter = iter+1;
        [dist,path,pred] = graphshortestpath(UG,1,'directed',false);
        relay_pool = find(pred==1);
        if isequal(relay_pool, old_relay_pool)
            hop1_converged = 1;
        else        
            num_relay = length(relay_pool);
            val = zeros(num_relay, 1);
            for ii = 1:num_relay
                val(ii) = DG(1, ii);
            end
            new_weight=max(val);
            if min(val)== new_weight
                hop1_converged=1;
            else
                for ii = 1:num_relay
                    DG(1,ii) = new_weight; 
                end
                old_relay_pool = relay_pool;
            end
        end
    end
    hop1_iterates(mm) = iter;
    
    hop2_converged = 0;
    while ~hop2_converged
        hop2_nodes = find(pred~=1 & pred~=0);
        num_hop2_nodes = length(hop2_nodes);
        val = zeros(num_hop2_nodes);
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
    
    
    paths = graphpred2path(pred, [2:num_nodes]);
    pathhops = zeros(num_nodes-1, 1);
    for ii = 1:num_nodes-1
        pathhops(ii) = length(paths{1})-1;
    end
    max_hops(mm) = max(pathhops);
end

