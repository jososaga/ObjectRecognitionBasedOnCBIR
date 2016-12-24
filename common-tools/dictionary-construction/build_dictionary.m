%----------------------------------------------------------------------------
%    Build dictionary
%----------------------------------------------------------------------------


function [dict_words] = build_dictionary(save, filename, features, param_centroids, param_iterations, param_trees)

dir_yael = './yael/';
dir_sift = './siftgeo/';
dir_data = './data/';

addpath ([dir_yael '/matlab']);

% Parameters
%num_centroids = 1024;

%f_centroids = [dir_data 'clust_k' num2str(num_centroids) '.fvecs'];    % given in the package

%----------------------------------------------------------------------------
% Retrieve the list of images and construct the groundtruth
%[imlist, features] = my_load_holidays (dir_sift);

% Build the dictionary using caltech-image-search package
dict_type = 'akmeans'; % 'kmeans' by default. Try also 'hkmeans'.
fprintf('Building the dictionary: %s\n', dict_type);
%%
switch dict_type
  % create an AKM dictionary
  case 'akmeans'
    num_words = param_centroids;
    num_iterations = param_iterations;
    num_trees = param_trees;
    dict_params =  {num_iterations, 'kdt', num_trees};

  % create an HKM dictionary
    %   case 'hkmeans'
    %     num_words = 100;
    %     num_iterations = 5;
    %     num_levels = 2;
    %     num_branches = 10;
    %     dict_params = {num_iterations, num_levels, num_branches};
end; % switch

% build the dictionary
dict_words = ccvBowGetDict(features, [], [], num_words, 'flat', dict_type, ...
  [], dict_params);

% save the dictionary to disk
if save,
    fvecs_write(filename, dict_words);
end





