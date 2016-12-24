function map = compute_results_ukb (idx, gnd)

map = 0;
nq = size (gnd, 1);   % number of queries
temp=0;

for i = 1:nq
    nn=0;  
    for j = 1:length(gnd{i})
        pos = find (gnd{i}(j) == idx (:, i));
        if pos <=4,
            nn=nn+1;
        end
    end
    temp=temp+nn;
end

map=temp/(nq);




