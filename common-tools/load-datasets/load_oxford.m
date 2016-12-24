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
function [imlist, gnd, gnd_junk, qidx] = load_oxford (dir_jpg, dir_evaluation)

imlist = struct2cell (dir(fullfile(dir_jpg, '*.jpg')));
imlist = imlist(1, :);
for i=1:length(imlist)
    imlist(i) = {imlist{i}(1:end-4)};
end 


eval_names = struct2cell (dir(fullfile(dir_evaluation, '*.txt')));
eval_names = eval_names(1, :);

landmarks = {'all_souls' 'ashmolean' 'balliol' 'bodleian' 'christ_church' 'cornmarket' 'hertford' 'keble' 'magdalen' 'pitt_rivers' 'radcliffe_camera'};

queries_55 = {'all_souls_000013', 'all_souls_000026', 'oxford_002985', 'all_souls_000051', 'oxford_003410';
              'ashmolean_000058', 'ashmolean_000000', 'ashmolean_000269', 'ashmolean_000007', 'ashmolean_000305';
              'balliol_000051', 'balliol_000187', 'balliol_000167', 'balliol_000194', 'oxford_001753';
              'bodleian_000107', 'oxford_002416', 'bodleian_000108', 'bodleian_000407', 'bodleian_000163';
              'christ_church_000179', 'oxford_002734', 'christ_church_000999', 'christ_church_001020', 'oxford_002562';
              'cornmarket_000047', 'cornmarket_000105', 'cornmarket_000019', 'oxford_000545', 'cornmarket_000131';
              'hertford_000015', 'oxford_001752', 'oxford_000317', 'hertford_000027', 'hertford_000063';
              'keble_000245', 'keble_000214', 'keble_000227', 'keble_000028', 'keble_000055';
              'magdalen_000078', 'oxford_003335', 'magdalen_000058', 'oxford_001115', 'magdalen_000560'; 
              'pitt_rivers_000033', 'pitt_rivers_000119', 'pitt_rivers_000153', 'pitt_rivers_000087', 'pitt_rivers_000058';
              'radcliffe_camera_000519', 'oxford_002904', 'radcliffe_camera_000523', 'radcliffe_camera_000095', 'bodleian_000132'};

nq = 55;                  % number of queries
qidx = [];                % the query identifiers
gnd = cell (nq, 1);       % first element is the query image number
gnd_junk = cell (nq, 1);
                          % following are the corresponding matching images

qno = 0;                  % current query number
for i = 1:11
    landmark_name = landmarks{i};
    for j = 1: 5
        good_path = fullfile(dir_evaluation, [landmark_name '_' int2str(j) '_good.txt']);
        ok_path = fullfile(dir_evaluation, [landmark_name '_' int2str(j) '_ok.txt']);
        junk_path = fullfile(dir_evaluation, [landmark_name '_' int2str(j) '_junk.txt']); 
        
        goods = read_oxford_file(good_path);
        oks = read_oxford_file(ok_path);
        junk = read_oxford_file(junk_path);
        
        positives = [goods; oks]; %[goods; oks]; goods;
        
        pos = (i-1)*5 + j;
        gnd{pos} = positives;
        gnd_junk{pos} = junk;
        
        [truefalse, index] = ismember(queries_55{i,j}, imlist);
        qidx = [qidx index];
        
    end
%   imno = str2num(siftfname{i}(1:end-8)); 
%   imlist = [imlist imno]; % compute image number
%   
%   % Remove
%   c_path = fullfile(dir_jpg, [int2str(imno),'.jpg']);
%   database.path = [ database.path c_path];
%   
%   if mod(imno, 100) == 0
%     qno = qno + 1;
%     qidx = [qidx i];
%   end
%   
%   gnd{qno} = [gnd{qno} i];
%   sift{i} = single (siftgeo_read_fast ([dir_sift siftfname{i}]));
end

end

function output = read_oxford_file(path)
    %# preassign output to some large cell array
    output=cell(220,1);
    sizS = 220;
    lineCt = 1;
    fid = fopen(path);
    tline = fgetl(fid);
    while ischar(tline)
       output{lineCt} = tline;
       lineCt = lineCt + 1;
       %# grow output if necessary
       if lineCt > sizS
           output = [output;cell(220,1)];
           sizS = sizS + 220;
       end
       tline = fgetl(fid);
    end
    fclose(fid);
    %# remove empty entries in output
    output(lineCt:end) = [];
end

