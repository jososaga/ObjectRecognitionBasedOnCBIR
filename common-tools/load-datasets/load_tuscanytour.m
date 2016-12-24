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
function [imlist, gnd, qidx] = load_tuscanytour(dir_config, dir_jpg)

jpg_names = struct2cell (dir([dir_jpg '*.jpg']));
jpg_names = jpg_names(1, :);

nimg = size (jpg_names, 2);
% landmarks = {'1001'};

nq = 0;                   % number of queries
imlist = [];              % the set of image number
qidx = [];                % the query identifiers
gnd = cell (nq, 1);       % first element is the query image number
                          % following are the corresponding matching images

qno = 0;                  % current query number
last_landmark_name = '';
for i = 1:nimg
  img_landmark_name = jpg_names{i}(1:end-7);
  imno = str2num(jpg_names{i}(1:end-4)); 
  imlist = [imlist imno]; % compute image number
    
  if strcmp(img_landmark_name, last_landmark_name) == 0
    nq = nq + 1;
    qno = qno + 1;
    last_landmark_name = img_landmark_name;
    qidx = [qidx i];
    gnd{qno} = [];
  end
  
  gnd{qno} = [gnd{qno} i];
end 

