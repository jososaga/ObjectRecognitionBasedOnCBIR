% This function computes the mAP for a given set of returned results.
%
% Usage: map = compute_map (idx, gnd);
%
% Notes:
% 1) ranks starts from 1
% 2) The top result (the query itself) should be filtered externally
function map = compute_map_oxford (idx, gnd, gnd_junk, imlist)

    map = 0;
    nq = size (gnd, 1);   % number of queries

    for i = 1:nq
        ap = compute_ap_oxford (gnd{i}, gnd_junk{i}, idx(:,i), imlist);
        map = map + ap;
    end
    map = map / nq;

end

function ap = compute_ap_oxford(gnd_one_query, junk_one_query, ranking, imlist)

  old_recall = 0.0;
  old_precision = 1.0;
  ap = 0.0;
  
  intersect_size = 0;
  
  j = 0;
  for i=1:length(ranking)
    if ismember(imlist(ranking(i)), junk_one_query)
        continue;
    end
    if ismember(imlist(ranking(i)), gnd_one_query) 
        intersect_size = intersect_size + 1;
    end

    recall = intersect_size / length(gnd_one_query);
    precision = intersect_size / (j + 1.0);

    ap = ap + (recall - old_recall)*((old_precision + precision)/2.0);

    old_recall = recall;
    old_precision = precision;
    j = j + 1;
  end
  
end

