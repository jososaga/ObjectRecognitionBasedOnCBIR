clear all;
clc;




%% Show the features--------------------------------------------------------
num_ranked_images = 1491;
dir_sift_sparse = '/media/samsungdisk/Work/UNIGE/Image-Datasets/banknotes/Test/Simple/data/sparse/data-sparse-hess-aff-sift/banknotes/';
% dir_sift_dense = '/media/unigedisk/Joan/Image-Datasets/holidays/data/600/data/';
% dir_jpg_dense = '/media/unigedisk/Joan/Image-Datasets/holidays/holidays';
dir_jpg_sparse = '/media/samsungdisk/Work/UNIGE/Image-Datasets/banknotes/Test/Simple/pgm/';
% [imlist, sift, gnd, qidx, database] = load_holidays (dir_sift_sparse, dir_jpg, true);
% rt_img_dir_sparse = fullfile(dir_jpg_dense, 'holidays');

% rt_data_dir_sparse = dir_sift_sparse;
% rt_data_dir_dense = fullfile(dir_sift_dense, 'holidays');

% database_sparse = retr_database_dir(true, rt_data_dir_sparse);
% database_dense = retr_database_dir(false, rt_data_dir_dense);

% [imlist, sift, gnd, qidx, database_img] = load_holidays (dir_sift_sparse, dir_jpg_dense, false);

siftfname = struct2cell (dir([dir_sift_sparse '*.siftgeo']));
siftfname = siftfname(1, :);

pgmfname = struct2cell (dir([dir_jpg_sparse '*.jpg.pgm']));
pgmfname = pgmfname(1, :);

numFea = length(siftfname);% length(database_img.path);
for i=1:numFea,
    h = figure; 
    
    feaSparse_path = [dir_sift_sparse siftfname{i}]; % database_sparse.path{i};
%     feaDense_path = database_dense.path{i};
    %% Load sparse
    [pathstr, file_name, file_ext] = fileparts(feaSparse_path); 
    [v, meta] = siftgeo_read(feaSparse_path);
    imageFeatures = v';
    locs_sparse = meta(:, 1:2)';
    
    I_sparse = imread(fullfile(dir_jpg_sparse, pgmfname{i}));
    
    %% Load Dense
%     load(feaDense_path);
%     locs_dense = [feaSet.x feaSet.y]';
%     I_dense = imread(database_img.path{i});
%     if ndims(I_dense) == 3,
%         I_dense = im2double(rgb2gray(I_dense));
%     else
%         I_dense = im2double(I_dense);
%     end;
%     maxImSize = 600;
%     [im_h, im_w] = size(I_dense);
%     if max(im_h, im_w) > maxImSize,
%         I_dense = imresize(I_dense, maxImSize/max(im_h, im_w), 'bicubic');
%         [im_h, im_w] = size(I_dense);
%     end;
    % feaSet contains all features and more.
    
    
    %% Show both images with their features
    % Sparse Features
    subplot(1, 1, 1);
    subimage(I_sparse);
    hold on
    locs_sparse = int64(locs_sparse);
    h1 = vl_plotframe(locs_sparse) ;      
    set(h1,'color','r','linewidth',1) ;  
    
%     % Dense Features
%     subplot(1, 2, 2);
%     subimage(I_dense);
%     hold on
%     h1 = vl_plotframe(locs_dense) ;      
%     set(h1,'color','r','linewidth',1) ;  
    
    dir_results = '/media/samsungdisk/Work/UNIGE/Image-Datasets/banknotes/Test/Simple/data/sparse/data-sparse-hess-aff-sift/show-features/';
    file_name_result = [file_name '.jpg'];
    file_path = fullfile(dir_results, file_name_result);
    
    saveas(h, file_path);
    close(h);

end

aa=1;

%% Results
% Method               |  Dim  | Dataset    |    mAP ()
%----------------------------------------------------------
% VLAD sparse originals| 12800 | Holidays   | 0.535 (0.553)   
% VLAD sparse originals| 25600 | Holidays   | 0.566 (0.589)   
% VLAD sparse package  | 8192  | Holidays   | 0.525 (0.552)   
% VLAD sparse package  | 16384 | Holidays   | 0.566 (0.587)   
% VLAD dense           | 8192  | Holidays   | 0.528 (0.594) 
% VLAD dense           | 16384 | Holidays   | 0.547 (0.620)   
%----------------------------------------------------------
