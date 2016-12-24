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
function [imlist, imlist_classes, sift, sift_meta, gnd, gnd_all, qidx, qidx_all, database] = load_banknotes(dir_sift, dir_jpg, load_descriptors, database_name)

siftfname = struct2cell (dir(fullfile(dir_jpg, '*.pgm')));
siftfname = siftfname(1, :);

nimg = size (siftfname, 2);

nq = 30;                 % number of queries
imlist = [];              % the set of image number
imlist_classes = cell (nimg, 1);
qidx = [];                % the query identifiers
qidx_all = [];
gnd = cell (nq, 1);       % first element is the query image number
gnd_all = cell (nimg, 1); 
                          % following are the corresponding matching images
sift = cell (nimg, 1);    %  one set of descriptors per image
sift_meta = cell (nimg, 1);

% Remove
database = [];
database.imnum = nimg; % total image number of the database
database.path = {}; % contain the pathes for each image

qno = 0;                  % current query number
for i = 1:nimg
  imno = str2num(siftfname{i}(1:end-8));  
  imlist = [imlist imno]; % compute image number
  
  class = str2num(siftfname{i}(1:2));
  sub_class = str2num(siftfname{i}(3:4));
  imlist_classes{i}.imno = imno;
  imlist_classes{i}.class = class;
  imlist_classes{i}.sub_class = sub_class;
    
  % Remove
  c_path = fullfile(dir_jpg, [int2str(imno),'.jpg']);
  database.path = [ database.path c_path];
  
  if mod(imno, 100) == 0
    qno = qno + 1;
    qidx = [qidx i];
  end
  
  gnd{qno} = [gnd{qno} i];
  
  % Using each individual image as a query
  qno_all = fix((i-1)/48);
  gnd_all{i} = [(qno_all*48+1):(qno_all*48+1)+47];
  qidx_all = [qidx_all i];
  
  if load_descriptors, 
%     sift{i} = single (siftgeo_read_fast ([dir_sift siftfname{i}]));
    [v, meta] = siftgeo_read ([dir_sift siftfname{i}]);
    sift{i} = v';
    sift_meta{i} = meta';
  else
    sift{i} = [];
    sift_meta{i} = [];
  end
end 

