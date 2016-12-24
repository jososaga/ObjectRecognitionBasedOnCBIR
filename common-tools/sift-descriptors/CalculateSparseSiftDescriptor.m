function [database] = CalculateSparseSiftDescriptor(rt_img_dir, rt_imgOuput_dir, rt_data_dir, maxImSize, nrml_threshold, featMethod, save_newImg)
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

frames = dir(fullfile(rt_img_dir, '*.pgm'));

c_num = length(frames);           
database.imnum = c_num;

siftpath = fullfile(rt_data_dir);        
if ~isdir(siftpath),
    mkdir(siftpath);
end;

for jj = 1:c_num,
    imgpath = fullfile(rt_img_dir, frames(jj).name);
    %database.path = [database.path, imgpath]; % remove, borrar, eliminar

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
            imwrite(I,[rt_imgOuput_dir name ext]);
        end
    end;

    fprintf('Processing %s: wid %d, hgt %d\n', ...
                     frames(jj).name, im_w, im_h);

     switch featMethod
         case 'SIFT'
%              % find SIFT descriptors
%             [f, d] = vl_sift(I); 
%             [siftArr, siftlen] = sp_normalize_sift(double(d)', nrml_threshold); %
%             siftArr = double(d');
%             feaSet.feaArr = siftArr';
%             feaSet.x = double(f(1, :)');
%             feaSet.y = double(f(2, :)');
%             feaSet.width = im_w;
%             feaSet.height = im_h;
            
         case 'SURF'
            points = detectSURFFeatures(I);
            [features, valid_points] = extractFeatures(I, points);
            feaSet.feaArr = features';
            feaSet.x = double(valid_points.Location(:, 1));
            feaSet.y = double(valid_points.Location(:, 2));
            feaSet.width = im_w;
            feaSet.height = im_h;
     end
    
    %change quitar comentario remove comment

    

    [pdir, fname] = fileparts(frames(jj).name);                        
    fpath = fullfile(rt_data_dir, [fname, '.mat']);
    
    save(fpath, 'feaSet');
    database.path = [database.path, fpath];

    clear imgpath I siftArr siftlen feaset;
end;

clear frames; 
