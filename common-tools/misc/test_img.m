clear all;


dir_pqcodes = './pqcodes/';
dir_yael = './yael/';
dir_sift = '/media/joan/Elements/Joan-Experiments/Image-Datasets/firenze/firenze/'; %'/media/joan/Elements/Joan-Experiments/Image-Datasets/ukb/'; %'/media/joan/New Volume/LinuxExperiments/UKB/ukb/';'./siftgeo/';

addpath ([dir_yael '/matlab']);
addpath (dir_pqcodes);


% Parameters
shortlistsize = 259;             % number of elements ranked by the system

%----------------------------------------------------------------------------
% Retrieve the list of images and construct the groundtruth
% [imlist, sift, gnd, qidx] = load_holidays (dir_sift);
% [imlist, gnd, qidx] = load_ukb (dir_sift);
%clear imlist;

%vDim = [ 10752  21504  43008  86016];

% fpathID = ['/media/joan/Elements/Joan-Experiments/Image-Datasets/firenze/600x600/dictionaries/IR_firenze_43008.fvecs']; %/home/joan/Desktop/ALDICR_SpatialPyramidRepresentation/boureau/dictionaries
% v = fvecs_read (fpathID);
 
%% Compute VLAD
CDpath = '/media/joan/Elements/Joan-Experiments/Image-Datasets/firenze/600x600/dictionaries/dict_flickr_512_Coding.mat';
load(CDpath);
[imlist, sift, gnd, qidx] = load_firenze (dir_sift, '/media/joan/Elements/Joan-Experiments/Image-Datasets/firenze/600x600/data/firenze/');
v = compute_vlad (single(codingDictionary), sift); 
database = retr_database_dir(false, '/media/joan/Elements/Joan-Experiments/Image-Datasets/firenze/firenze');

%----------------------------------------------------------------------------
% Full VLAD
% perform the queries (without product quantization nor PCA) and find 
% the rank of the tp. Keep only top results (i.e., keep shortlistsize results). 
% for exact mAP, replace following line by k = length (imlist)

v = sign(v).*abs(v).^(1/2);
v = yael_fvecs_normalize (v);
[idx, dis] = yael_nn (v, v(:,qidx), 6);


    for jj=1:size(idx,2),
    figure, 
    subplot(2, 3, 1);
    X1=imread(database.path{idx(1, jj)});
    subimage(X1);

    subplot(2, 3, 2);
    X1=imread(database.path{idx(2, jj)});
    subimage(X1);
    
    subplot(2, 3, 3);
    X1=imread(database.path{idx(3, jj)});
    subimage(X1);

    subplot(2, 3, 4);
    X1=imread(database.path{idx(4, jj)});
    subimage(X1);
    
    subplot(2, 3, 5);
    X1=imread(database.path{idx(5, jj)});
    subimage(X1);

    subplot(2, 3, 6);
    X1=imread(database.path{idx(6, jj)});
    subimage(X1);
    end

idx = idx (2:end,:);  % remove the query from the ranking


map_vlad = compute_results_firenze (idx, gnd);
% map_vlad = compute_results (idx, gnd);
% map_vlad = compute_results_ukb(idx, gnd);
fprintf ('full VLAD.                           mAP = %.4f\n', map_vlad);
