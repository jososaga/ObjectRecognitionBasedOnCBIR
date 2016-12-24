function [database, features, total_features] = retr_database_dir(load_siftgeo, rt_data_dir, load_features)
%=========================================================================
% inputs
% rt_data_dir   -the rootpath for the database. e.g. '../data/caltech101'
% outputs
% database      -a tructure of the dir
%                   .path   pathes for each image file
%                   .label  label for each image file
%
% written by Joan Sosa
% Oct. 2013, DIBRIS, University of Genova
%=========================================================================

fprintf('dir the database...');
database = [];

database.imnum = 0; % total image number of the database
database.path = {}; % contain the pathes for each image
features = [];
total_features = 0;
if not(load_siftgeo),
    frames = dir(fullfile(rt_data_dir, '*.mat'));
else
    frames = dir(fullfile(rt_data_dir, '*.siftgeo'));
end;

c_num = length(frames);
database.imnum = c_num;

for jj = 1:c_num,
    c_path = fullfile(rt_data_dir, frames(jj).name);
    database.path = [database.path, c_path];
    
    if load_features
        if load_siftgeo
            feaSet.feaArr = single (siftgeo_read_fast (c_path));
            features = [features feaSet.feaArr];
            total_features = total_features + size(feaSet.feaArr, 2);
            if size(feaSet.feaArr, 2) == 0
                tt =3;
            end
        else
            load(c_path);
            features = [features feaSet.feaArr];
            total_features = total_features + size(feaSet.feaArr, 2);
        end;
    end
end;

disp('done!');