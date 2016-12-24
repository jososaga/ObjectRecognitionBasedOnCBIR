
function [imlist_classes, features, database, rgb_descriptors] = load_banknotes_variants(dir_sift, dir_jpg, dir_pgm, load_descriptors, load_siftgeo, database_name, load_rgb_descriptors)


switch database_name
    case 'banknotes'
        subclass_def = {'front' 'front' 'front' 'back' 'back' 'back'};
    case 'simplebanknotes'
        subclass_def = {'front' 'front' 'front' 'back' 'back' 'back'};
        
    case 'differentattacks'
        subclass_def = {'front' 'back' 'front' 'back' 'front' 'back' 'front' 'front' 'back' 'back'};
        
    case 'selectedimages'
        subclass_def = {'front' 'back'};
end

siftfname = struct2cell (dir(fullfile(dir_pgm, '*.pgm')));
siftfname = siftfname(1, :);

nimg = size (siftfname, 2);

imlist_classes = cell (nimg, 1);

features = cell (nimg, 1);

if load_rgb_descriptors
    rgb_descriptors = zeros(3, nimg);
else
    rgb_descriptors = [];
end

% Remove
database = [];
database.imnum = nimg; % total image number of the database
database.path = {}; % contain the pathes for each image

for i = 1:nimg
  imno = str2num(siftfname{i}(1:end-8));  
  class = str2num(siftfname{i}(1:2));
  subclass = str2num(siftfname{i}(3:4));
  imlist_classes{i}.imno = imno;
  imlist_classes{i}.class = class;
  imlist_classes{i}.subclass_index =subclass;
  imlist_classes{i}.subclass_definition = subclass_def{subclass+1};
  
  c_path = fullfile(dir_jpg, [int2str(imno),'.jpg']);
  c_path_pgm = fullfile(dir_pgm, [int2str(imno),'.jpg.pgm']);
  database.path = [ database.path c_path_pgm];
  
  imlist_classes{i}.path = c_path;
  imlist_classes{i}.path_pgm = c_path_pgm;
  
  if load_descriptors, 
%     sift{i} = single (siftgeo_read_fast ([dir_sift siftfname{i}]));
    fpath = fullfile(dir_sift, int2str(imno));
    if load_siftgeo
        fpath = [fpath '.siftgeo'];
        [v, meta] = siftgeo_read (fpath);
        features{i}.features = v';
        features{i}.locs = meta(:, 1:2)';
    else
        fpath = [fpath '.jpg.mat'];
        load(fpath);
        features{i}.features = feaSet.feaArr;
        features{i}.locs = [feaSet.x feaSet.y]';
    end
  else
    features{i}.features = [];
    features{i}.locs = [];
  end
  
  if load_rgb_descriptors
    I = imread(fullfile(dir_jpg, [int2str(imno),'.jpg']));
    [im_h, im_w, im_rgb] = size(I);
    maxImSize = 1182;
    if max(im_h, im_w) > maxImSize,
        I = imresize(I, maxImSize/max(im_h, im_w), 'bicubic');
        [im_h, im_w, im_rgb] = size(I);
    end;
    total_pixels = im_h*im_w;
    r_c = sum(sum(I(:, :, 1)));%/total_pixels;
    g_c = sum(sum(I(:, :, 2)));%/total_pixels;
    b_c = sum(sum(I(:, :, 3)));%/total_pixels;
    rgb_descriptors(:, i) = [r_c g_c b_c]';
  end
end 

% mappin_names = containers.Map;
