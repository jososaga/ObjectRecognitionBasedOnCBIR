function [Features, NumFeaturesPerImage] = load_siftgeofiles(dir_sift, dir_imgs)

siftfname = struct2cell (dir([dir_sift '*.siftgeo']));
siftfname = siftfname(1, :);

nimg = size (siftfname, 2);

for i = 1:nimg
  imno = siftfname{i}(1:end-8); 
    
  % Features{i}.feaArr = single (siftgeo_read_fast (fullfile(dir_sift, siftfname{i})));
  [v, meta, im_h, im_w] = my_siftgeo_read (fullfile(dir_sift, siftfname{i}), fullfile(dir_imgs, [imno '.pgm']));
  
  Features{i}.feaArr = v;
  Features{i}.x = meta(:, 1);
  Features{i}.y = meta(:, 2);
  Features{i}.width = im_w;
  Features{i}.height = im_h;
  NumFeaturesPerImage = [NumFeaturesPerImage size(Features{i}.feaArr, 2)];
  
  clear v meta im_h im_w;
end 

