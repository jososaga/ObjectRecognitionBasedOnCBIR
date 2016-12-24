% Return the k nearest neighbors of a set of query vectors
%
% Usage: [ids,dis] = nn(v, q, k, threshold)
%   v                the dataset to be searched (one vector per column)
%   q                the set of queries (one query per column)
%   k                the number of nearest neigbors we want
%   threshold        the threshold to filter the visual words that will be
%                    considered for the final similarity
%
% Returned values
%   idx         the vector index of the nearest neighbors
%   dis         the corresponding *square* distances
%
% Both v and q contains vectors stored in columns, so transpose them if needed
function [idx, dis] = my_nn (v, q, k, dictionarySize, threshold, qidx)

vectors_count = size(v, 2);
vector_size = size(v, 1);
queries_count = size(q, 2);
query_size = size(q, 1);

if query_size ~= vector_size
  error ('The query and dataset vectors must be of the same size.\n');
end

dis = zeros(vectors_count, queries_count);

for i=1:queries_count
    if ~mod(i, 50),
        fprintf([num2str(i) '.\n']);
    else
        fprintf([num2str(i) '.']);
    end;

    for j=1:vectors_count
        query = q(:, i);
        vector = v(:,j);
        temp_dis = 0;
        vw_matching = 0;
        for vw=1:4,
            temp_query = query((vw-1)*dictionarySize + 1: vw*dictionarySize);
            temp_vector = vector((vw-1)*dictionarySize + 1: vw*dictionarySize);
            temp_temp_dis = sqrt(sum((temp_query - temp_vector) .^ 2));
%             if temp_temp_dis <= threshold
%                 temp_dis = temp_dis + temp_temp_dis;
%                 vw_matching = vw_matching + 1;
%             else
%                 a = 1;
%             end
            temp_dis = temp_dis + temp_temp_dis;
            vw_matching = vw_matching + 1;
        end
        dis(j, i) = temp_dis/(vw_matching*sqrt(2));
    end
end

[dis, idx] = sort (dis);
dis = dis (1:k, :);
idx = idx (1:k, :);



