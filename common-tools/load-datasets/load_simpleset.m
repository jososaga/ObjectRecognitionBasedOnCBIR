function [imlist, gnd, qidx, database] = load_simpleset (dir_jpg)

jpgfname = struct2cell (dir([dir_jpg '*.jpg']));
jpgfname = jpgfname(1, :);

nimg = size (jpgfname, 2);

nq = 12;                 % number of queries
imlist = [];              % the set of image number
qidx = [];                % the query identifiers
gnd = cell (nq, 1);       % first element is the query image number
                          % following are the corresponding matching images
sift = cell (nimg, 1);    %  one set of descriptors per image

% Remove
database = [];
database.imnum = nimg; % total image number of the database
database.path = {}; % contain the pathes for each image

qno = 0;                  % current query number
for i = 1:nimg
  imno = str2num(jpgfname{i}(1:end-4)); 
  imlist = [imlist imno]; % compute image number
  
  % Remove
  c_path = fullfile(dir_jpg, [int2str(imno),'.jpg']);
  database.path = [ database.path c_path];
  
  if mod(imno, 100) == 0
    qno = qno + 1;
    qidx = [qidx i];
  end
  
  gnd{qno} = [gnd{qno} i];
end 

