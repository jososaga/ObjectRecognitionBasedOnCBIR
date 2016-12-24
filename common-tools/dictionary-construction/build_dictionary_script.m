% This code is for performing experiments related to Content-based image
% retrieval

% Author: Joan Sosa Garcia

%% Clear variables
clear all;
clc;

%% Parameter setting

% directory setup
img_dir = '/media/joan/Elements/Joan/Image-Datasets/holidays/'; % directory for dataset images
data_dir = '/media/samsungdisk/Work/UNIGE/Image-Datasets/banknotes/Test/simplebanknotes/data/sparse/data-sparse-surf/simplebanknotes';
dataSet = 'simplebanknotes';
output = '/media/samsungdisk/Work/UNIGE/Image-Datasets/banknotes/Test/simplebanknotes/data/sparse/data-sparse-surf/dictionaries/';
is_sparse = 'yes';
is_siftgeo = false;
load_features = true;
Method = 'AKmeans';
switch is_sparse
    case 'yes'
        pgm_dir = '';
        rt_img_dir = img_dir;
        rt_data_dir = data_dir;

    case 'no'
        rt_img_dir = fullfile(img_dir, dataSet);
        rt_data_dir = fullfile(data_dir, dataSet);
end;

% dictionary training for sparse coding
list_nBases = [300];
featuresPath = fullfile(output, [dataSet '_features_42758.mat']);
if not(exist(featuresPath, 'file'))
    [database, features, total_features]= retr_database_dir(is_siftgeo, rt_data_dir, load_features);                
    save(featuresPath, 'features');
else
    load(featuresPath);
end

% Pre-processing the data.
rndidx = randperm(size(features, 2));
features = features(:, rndidx);
switch Method
    case 'AKmeans'
        for i=1:length(list_nBases)
            dictionaryPath = fullfile(output, ['clust_' dataSet '_k' int2str(list_nBases(i)) '.fvecs']);
            [codingDictionary] = build_dictionary(true, dictionaryPath, features, list_nBases(i), 20, 8);
        end
    case 'GMM'
        for i = 1:length(list_nBases),
            [means, covariances, priors] = vl_gmm(features, list_nBases(i));
            save([output 'means_' dataSet '_k' int2str(list_nBases(i)) '.mat'], 'means');
            save([output 'covariances_' dataSet '_k' int2str(list_nBases(i)) '.mat'], 'covariances');
            save([output 'priors_' dataSet '_k' int2str(list_nBases(i)) '.mat'], 'priors');
        end;

end
