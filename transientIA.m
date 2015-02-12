%% 

n_Tx = 2;
n_Rx = 2;

numNodes = 10;

%% Generate all channels
ch = cell(numNodes, numNodes);
for nn = 1:numNodes
    ch{nn, nn} = 1;
    for qq = 1:nn-1
        ch{nn, qq} = ch{qq, nn}';
    end
    for qq = nn+1:numNodes
        H=randn(n_Rx, n_Tx)+j*randn(n_Rx, n_Tx);
        ch{nn, qq} = H./ sqrt(sum(sum(abs(H).^2))); 
    end
end

%% The owning pair of the slot is Tx node 1 and Rx node 2.
H = ch{2, 1};
[V, D] = eig(H'*H);
signal_vec = V(:, n_Tx);
interference_vec = V(:, 1);
txbf_rx2 = cell(numNodes, 1);
txbf_rx2{1} = H\signal_vec;
txbf_rx2{1} = txbf_rx2{1}/norm(txbf_rx2{1});

for nn = 3:numNodes
     txbf_rx2{nn} = ch{2, nn}\interference_vec;
     txbf_rx2{nn} = txbf_rx2{nn}/norm(txbf_rx2{nn});
end

%% Node 3 as the receiver
%% Node 3:10 as the receiver
sigSpace = zeros(n_Rx, numNodes, numNodes);
cross = zeros(numNodes, numNodes);
sigpw = zeros(numNodes, numNodes, numNodes);
for rr = 3:numNodes
    sigSpace(:, 1, rr) = ch{rr, 1}*txbf_rx2{1};
    for tt = 3:numNodes
        if tt~=rr
            sigSpace(:, tt, rr) = ch{rr, tt}*txbf_rx2{tt};
            
            
            equalizer = txbf_rx2{tt}'*ch{rr, tt}';
            for ii = 1:numNodes
                if (ii~=2)&&(ii~=rr)
                    sigpw(ii, tt, rr)= equalizer*ch{rr, ii}*txbf_rx2{ii};
                end
            end
        end
        cross(tt, rr) = sigSpace(:, tt, rr)'*sigSpace(:, 1, rr);
    end
end

abs(cross)