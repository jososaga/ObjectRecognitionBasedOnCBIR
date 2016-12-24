
function Rth_precision = compute_average_Rth_Precision(idx, gnd)

nq = size (gnd, 1);   % number of queries
Rth_precision = 0;
precision = 0;
for i = 1:nq
    tp = [];
    
    Rth = length(gnd{i})-1;
    temp_ranking = idx (1:Rth, i);
    for j = 2:length(gnd{i})

        pos = find (gnd{i}(j) == temp_ranking);
        if ~isempty(pos)
          tp = [tp pos];
        end
    end

    precision = precision + length(tp)/Rth;
end
Rth_precision = precision / nq;



