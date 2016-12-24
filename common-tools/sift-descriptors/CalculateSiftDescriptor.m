function [database] = CalculateSiftDescriptor(rt_img_dir, rt_data_dir, gridSpacing, patchSize, maxImSize, nrml_threshold, save_newImg)
%==========================================================================
% usage: calculate the sift descriptors given the image directory or Load
% the general configuration for .siftgeo files
%
% inputs
% rt_img_dir    -image database root path
% rt_data_dir   -feature database root path
% gridSpacing   -spacing for sampling dense descriptors
% patchSize     -patch size for extracting sift feature
% maxImSize     -maximum size of the input image
% nrml_threshold    -low contrast normalization threshold
%
% outputs
% database      -directory for the calculated sift features
%
% Lazebnik's SIFT code is used.
%
% written by Joan Sosa
% Oct. 2013, DIBRIS, University of Genova
%==========================================================================

disp('Extracting SIFT features...');
database = [];

database.imnum = 0; % total image number of the database
database.path = {}; % contain the pathes for each image


%% Computing sift descriptors

frames = dir(fullfile(rt_img_dir, '*.jpg'));

%% Borrar eliminar Select random 2000 images
% random = randperm(length(frames));
% frames = frames(random(1:5000));

c_num = length(frames);           
database.imnum = c_num;

siftpath = fullfile(rt_data_dir);        
if ~isdir(siftpath),
    mkdir(siftpath);
end;

for jj = 1:c_num,
    imgpath = fullfile(rt_img_dir, frames(jj).name);
    % database.path = [database.path, imgpath]; % remove, borrar, eliminar

    % Remove, Eliminar, Borrar
%     try
%         I = imread(imgpath);  
%     catch
%         feaSet.feaArr = [];
%         feaSet.x = [];
%         feaSet.y = [];
%         feaSet.width = 0;
%         feaSet.height = 0;
%         feaSet.width_patches = 0;
%         feaSet.height_patches = 0;
%         feaSet.total_patches = 0;
% 
%         [pdir, fname] = fileparts(frames(jj).name);                        
%         fpath = fullfile(rt_data_dir, [fname, '.mat']);
% 
%         save(fpath, 'feaSet');
%         database.path = [database.path, fpath];
%         continue;
%     end
    
    I = imread(imgpath);
    if ndims(I) == 3,
        I = im2double(rgb2gray(I));
    else
        I = im2double(I);
    end;

    [im_h, im_w] = size(I);

    if max(im_h, im_w) > maxImSize,
        I = imresize(I, maxImSize/max(im_h, im_w), 'bicubic');
        [im_h, im_w] = size(I);
        if save_newImg
            [pathstr, name, ext] = fileparts(imgpath); 
            imwrite(I,[rt_data_dir name ext]);
        end
    end;

    % make grid sampling SIFT descriptors
    remX = mod(im_w-patchSize,gridSpacing);
    offsetX = floor(remX/2)+1;
    remY = mod(im_h-patchSize,gridSpacing);
    offsetY = floor(remY/2)+1;

    [gridX,gridY] = meshgrid(offsetX:gridSpacing:im_w-patchSize+1, offsetY:gridSpacing:im_h-patchSize+1);

    fprintf('Processing %s: wid %d, hgt %d, grid size: %d x %d, %d patches\n', ...
             frames(jj).name, im_w, im_h, size(gridX, 2), size(gridX, 1), numel(gridX));

    % find SIFT descriptors
    siftArr = sp_find_sift_grid(I, gridX, gridY, patchSize, 0.8);
    [siftArr, siftlen] = sp_normalize_sift(siftArr, nrml_threshold);

    feaSet.feaArr = siftArr';
    feaSet.x = gridX(:) + patchSize/2 - 0.5;
    feaSet.y = gridY(:) + patchSize/2 - 0.5;
    feaSet.width = im_w;
    feaSet.height = im_h;
    feaSet.width_patches = size(gridX, 2);
    feaSet.height_patches = size(gridX, 1);
    feaSet.total_patches = numel(gridX);

    [pdir, fname] = fileparts(frames(jj).name);                        
    fpath = fullfile(rt_data_dir, [fname, '.mat']);

    save(fpath, 'feaSet');
    database.path = [database.path, fpath];

    clear imgpath I remX offsetX remY offsetY gridX gridY siftArr siftlen feaset;
end;

% clear frames; 

