function map = compute_results_banknotes(idx, gnd)

map = 0;
nq = size (gnd, 1);   % number of queries
temp=0;

for i = 1:nq
    nn=0;  
    for j = 1:size(idx,1)
        pos = find (idx (j, i) == gnd{i});
        if isempty(pos),
            a = true;
        end
        if ~isempty(pos) && pos<48,
            nn=nn+1;
        end
    end
    temp=temp+nn;
end

map=temp/(nq);




