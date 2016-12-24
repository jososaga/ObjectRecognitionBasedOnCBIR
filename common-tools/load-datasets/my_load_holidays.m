% Load the set of image descriptors of the Holidays dataset
% and construct the groundtruth.
% Usage: [imlist, sift, qidx, gnd] = load_holidays (dir_sift)
% 
% Input/Output variables:
%   dir_sift   the directory where the siftgeo files are stored
%   imlist     the list of image number (the number of the files)
%   sift       a cell containing the sift descriptors
%   gnd        the groundtruth: first value is the query number
%              next are the corresponding matching images
function [imlist, sift, NumFeaturesPerImage] = load_holidays (dir_sift)

siftfname = struct2cell (dir([dir_sift '*.siftgeo']));
siftfname = siftfname(1, :);

nimg = size (siftfname, 2);

imlist = {};              % the set of image number
sift = [];    %  one set of descriptors per image
NumFeaturesPerImage = []; % Number of Features per Image

qno = 0;                  % current query number
for i = 1:nimg
  imno = siftfname{i}(1:end-8); 
  imlist = [imlist, imno]; 
  
  temp = single (siftgeo_read_fast ([dir_sift siftfname{i}]));
  NumFeaturesPerImage = [NumFeaturesPerImage size(temp, 2)];
  sift =[sift temp];
end 

