function [database, sift, gnd, qidx] = load_firenze (dir_jpg, dir_mat, skip_load_sift)

siftfname = struct2cell (dir(fullfile(dir_jpg, '*.jpg')));
siftfname = siftfname(1, :);

nimg = size (siftfname, 2);

database = [];
database.imnum = nimg; % total image number of the database
database.path = {}; % contain the pathes for each image

nq = 23;                 % number of queries
%imlist = [];              % the set of image number
qidx = [];                % the query identifiers
gnd = cell (nq, 1);       % first element is the query image number
                          % following are the corresponding matching images
sift = {};

qno = 0;                  % current query number
for i = 1:nimg
  imno = str2num(siftfname{i}(1:end-4)); 
  %imlist = [imlist imno]; % compute image number
  c_path = fullfile(dir_jpg, siftfname{i});
  database.path = [ database.path c_path];
  
  if mod(imno, 100) == 0
    qno = qno + 1;
    qidx = [qidx i];
  end
  
  gnd{qno} = [gnd{qno} i];
  if ~skip_load_sift
      load(fullfile(dir_mat, [int2str(imno) '.mat']));
      sift{i} = single (feaSet.feaArr);
  end
end

if nq ~= qno,
    a=b+c;
end

