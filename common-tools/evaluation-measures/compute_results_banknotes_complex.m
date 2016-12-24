function [accuracy_class, accuracy_subclass, perclass, persubclass, majoritary_class, matching_class] = compute_results_banknotes_complex(imlist_query, imlist_training, query_indexes, ranking, ranking_positions)
% query_indexes == number of columns of ranking matrix. query_indexes
% contains the indices of the images in the imlist_query cells

nq = size (ranking, 2);   % number of queries
perclass = zeros(1, nq);
majoritary_class = zeros(1, nq);
matching_class = zeros(1, nq);

persubclass = zeros(1, nq);
majoritary_subclass = cell(1, nq);
matching_subclass = zeros(1, nq);

for i = 1:nq
    
    query_class = imlist_query{query_indexes(i)}.class;
    query_subclass = imlist_query{query_indexes(i)}.subclass_definition;
    
    correct_perclass = 0;
    correct_persubclass = 0;
    training_class_array = zeros(1, ranking_positions);
    training_subclass_array = {};
    for j=1:ranking_positions
        training_index = ranking(j, i);
        training_class = imlist_training{training_index}.class;
        training_class_array(j) = training_class;
        training_subclass = imlist_training{training_index}.subclass_definition;
        
        if query_class == training_class
            correct_perclass = correct_perclass + 1;
            
            if strcmp(query_subclass, training_subclass)
                correct_persubclass = correct_persubclass + 1;
                training_subclass_array = [training_subclass_array training_subclass];
            end
        end
    end
   
    perclass(i) = correct_perclass;
    persubclass(i) = correct_persubclass;
    
    majoritary_class(i) = mode(training_class_array);
    matching_class(i) = (query_class == majoritary_class(i));
    
    majoritary_subclass{i} = '';
    matching_subclass(i) = 0;
    if matching_class(i) && ~isempty(training_subclass_array)
        [unique_strings, ~, string_map] = unique(training_subclass_array);
        most_common_string = unique_strings(mode(string_map));
        majoritary_subclass{i} = most_common_string;
        matching_subclass(i) = strcmp(query_subclass, majoritary_subclass{i});
    end
        
end

accuracy_class = (sum(matching_class)/length(perclass))*100;
accuracy_subclass = (sum(matching_subclass)/length(persubclass))*100;
end