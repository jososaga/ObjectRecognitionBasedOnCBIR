
function map = compute_average_Precision_k(idx, gnd, k)

nq = size (gnd, 1);   % number of queries
map = 0;
precision = 0;
for i = 1:nq
  
%   for j = 1:size(idx, 1)
%     
%     pos = find (idx (j, i) == gnd{i}); % find (gnd{i}(j) == idx (:, i));
%     if ~isempty(pos)
%       good = good+1;
%     end
%   end
%   
%   map = good/length(gnd{i});
    tp = [];
    temp_ranking = idx (1:k, i);
    for j = 2:length(gnd{i})
    
        pos = find (gnd{i}(j) == temp_ranking);
        if ~isempty(pos)
          tp = [tp pos];
        end
    end
    
    precision = precision + length(tp)/k;
end
map = precision / nq;



