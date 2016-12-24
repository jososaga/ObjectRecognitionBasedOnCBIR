
function [imlist, gnd, qidx] = load_ukb (dir_sift)

siftfname = struct2cell (dir([dir_sift '*.jpg']));
siftfname = siftfname(1, :);

nimg = size (siftfname, 2);

nq = 10200;                 % number of queries
imlist = [];              % the set of image number
qidx = [];                % the query identifiers
gnd = cell (nq, 1);       % first element is the query image number
                          % following are the corresponding matching images
sift = cell (nimg, 1);    %  one set of descriptors per image

qno = 0;                  % current query number
for i = 1:nimg
  imno = str2num(siftfname{i}(8:end-4)); 
  imlist = [imlist imno]; % compute image number
  
  if mod(imno, 4) == 0
      
      if qno > 0
          % gnd{qno+1} = [i i+1 i+2 i+3] first time = [0 1 2 3]
          gnd{qno+1} = [gnd{qno}(2) gnd{qno}(1) gnd{qno}(3) gnd{qno}(4)];  % positions = 2 1 3 4
          gnd{qno+2} = [gnd{qno}(3) gnd{qno}(1) gnd{qno}(2) gnd{qno}(4)];  % positions = 3 1 2 4
          gnd{qno+3} = [gnd{qno}(4) gnd{qno}(1) gnd{qno}(2) gnd{qno}(3)];  % positions = 4 1 2 3
          
          qno = qno + 3;
          last_index = qidx(size(qidx, 2));
          qidx = [qidx last_index+1 last_index+2 last_index+3];
      end
      
      qno = qno + 1;
      qidx = [qidx i];
  end
    
  gnd{qno} = [gnd{qno} i];

end

gnd{qno+1} = [gnd{qno}(2) gnd{qno}(1) gnd{qno}(3) gnd{qno}(4)];  % positions = 2 1 3 4
gnd{qno+2} = [gnd{qno}(3) gnd{qno}(1) gnd{qno}(2) gnd{qno}(4)];  % positions = 3 1 2 4
gnd{qno+3} = [gnd{qno}(4) gnd{qno}(1) gnd{qno}(2) gnd{qno}(3)];  % positions = 4 1 2 3

qno = qno + 3;
last_index = qidx(size(qidx, 2));
qidx = [qidx last_index+1 last_index+2 last_index+3];



