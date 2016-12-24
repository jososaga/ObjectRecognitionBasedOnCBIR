function [X, final_num_smp] = rand_sampling(is_siftgeo, database, num_img, num_smp, gridSpacing, patchSize, maxImSize, nrml_threshold)
%==========================================================================
% usage: Sample local features for unsupervised codebook training
%  
% inputs
% is_siftgeo    - Whether the descriptors are or not in siftgeo files
% database      - The database
% num_img       - Number of images, these images must contains descriptors
% num_smp       - The desired number of samples
%
% outputs
% X             - The num_smp samples
%
% written by Joan Sosa
% Oct. 2013, DIBRIS, University of Genova
%==========================================================================

num_per_img = round(num_smp/num_img);

X = [];

for ii = 1:num_img,
    fpath = database.path{ii};
    if is_siftgeo,
        feaSet.feaArr = single (siftgeo_read_fast (fpath));
    else
        load(fpath);
        
        %%remove, eliminar, borrar
        %[feaSet] = CalculateSiftDescriptorOneImage(fpath, gridSpacing, patchSize, maxImSize, nrml_threshold);
%         [feaSet] = CalculateSparseSiftDescriptorOneImage(fpath, maxImSize, nrml_threshold);
    end;
    num_fea = size(feaSet.feaArr, 2);
    
    if num_fea >= num_per_img,
        rndidx = randperm(num_fea);
        X = [X feaSet.feaArr(:, rndidx(1:num_per_img))];
    else % num_fea < num_per_img, then I can not apply rndidx(1:num_per_img) [exception, index out of range]
        rndidx = randperm(num_fea);
        X = [X feaSet.feaArr(:, rndidx(1:num_fea))];
    end;
    
    clear rndidx feaSet;
end;

final_num_smp = size(X, 2);
