% This code is for performing experiments related to Content-based image
% retrieval

% Author: Joan Sosa Garcia

%% Clear variables
clear all;
clc;

%% Parameter setting

% directory setup
img_dir = '/media/joan/Elements/Joan/Image-Datasets/holidays/'; % directory for dataset images
data_dir = '/media/joan/Elements/Joan/Image-Datasets/holidays/data/600/data/'; % directory to save the sift features of the chosen dataset
dataSet = 'holidays';

% sift descriptor extraction
skip_cal_sift = false;              % if 'skip_cal_sift' is false, set the following parameter
skip_sparse_sift = true;
skip_siftgeo = true;
gridSpacing = 8;
patchSize = 16;
maxImSize = 600;
nrml_threshold = 1;                 % low contrast region normalization threshold (descriptor length)

% dictionary training for sparse coding
skip_dic_training = false;
nBases = 768;
nConfigSpace = 1;
nsmp = 1000000;
beta = 1e-5;                        % a small regularization for stablizing sparse coding
num_iters = 50;

% feature pooling parameters
pyramid = [1, 2, 4];                % spatial block number on each level of the pyramid
gamma = 0.15;
knn = 5;                          

% Working with .siftgeo files
is_siftgeo = false;

method = 'bof'; % 'myr-yes-borders';
border = 'normal';
is_sparse = 'no';


switch is_sparse
        case 'yes'
            pgm_dir = '/media/joan/SAMSUNG/Work/UNIGE/Image-Datasets/holidays/sparse/pgm';
            rt_img_dir = img_dir;
            rt_data_dir = data_dir;

        case 'no'
            rt_img_dir = fullfile(img_dir, dataSet);
            rt_data_dir = fullfile(data_dir, dataSet);
end;


%% Calculating sift features or retrieving the database directory
if skip_siftgeo,    
    if skip_cal_sift,
        database = retr_database_dir(is_siftgeo, rt_data_dir);
    else
        if  skip_sparse_sift,
            [database] = CalculateSiftDescriptor(rt_img_dir, rt_data_dir, gridSpacing, patchSize, maxImSize, nrml_threshold);
        else
            [database] = CalculateSparseSiftDescriptor(rt_img_dir, rt_data_dir, maxImSize, nrml_threshold);
        end;
    end;
else
    database = retr_database_dir(is_siftgeo, rt_data_dir);
end;


%% Computing or Loading the dictionaries
switch is_sparse
        case 'yes'
            temp_dataSet = dataSet;
            dataSet = 'flickr12k';
            dictionariesPath = '/media/joan/SAMSUNG/Work/UNIGE/Image-Datasets/flickr12k/sparse/features/';
            Fpath = fullfile(dictionariesPath, ['sparse_features_' dataSet '.ivecs']);
            Dpath = fullfile(dictionariesPath, ['dictionary_' num2str(nBases) '_' dataSet '.fvecs']);
            dataSet = temp_dataSet;

        case 'no'
            tempTempDataSet = dataSet;
            dataSet = 'flickr12k';
            dictionariesPath = ['/media/joan/SAMSUNG/Work/UNIGE/Image-Datasets/' dataSet '/dictionaries/600/768/'];
            CDpath = [dictionariesPath 'dict_' dataSet '_' num2str(nBases) '_Coding_' num2str(maxImSize) '.mat'];
            PDpath = [dictionariesPath 'dict_' dataSet '_' num2str(nConfigSpace) '_Pooling_' num2str(maxImSize) '.mat'];
            Fpath =  [dictionariesPath 'rand_features_' dataSet '_' num2str(nsmp) '_Samples_' num2str(maxImSize) '.mat'];
            TCpath = [dictionariesPath 'rand_codes_' dataSet '_' num2str(nsmp) '_' num2str(nBases) '_' '_Codes_' num2str(maxImSize) '.mat'];
            dataSet = tempTempDataSet;
end;





if ~skip_dic_training,
    
    % Load the samples to learn the coding dictionary
    try 
        load(Fpath);
        if is_siftgeo,
            [X, siftlen] = sp_normalize_sift(X', nrml_threshold); % Normalize the siftgeo vectors
            X = X';
        end;
%         X = double(X); 
%         save(Fpath, 'X');
    catch
        X = rand_sampling(is_siftgeo, database, database.imnum, nsmp, gridSpacing, patchSize, maxImSize, nrml_threshold);
        save(Fpath, 'X');
    end
    
    % Learn the coding dictionary
    try
        load(CDpath);
    catch
%         Using as a dictionary the first nBases-sift of all images       
%         rndidx = randperm(size(X, 2)); remove, borrar, eliminar
%         codingDictionary = X(:, rndidx(1:nBases)); remove,borrar,eliminar

        [codingDictionary] = build_dictionary(false, '', X, nBases, 20, 8);
        save(CDpath, 'codingDictionary');
    end
    
    % Compute the sparse codes
    try
        load(TCpath);
    catch
        sCodes = [];
        num_samples_perImg = round(nsmp/database.imnum);
        
        %% 
        if nConfigSpace>1,
            for i=1:database.imnum,
                 if ~mod(i, 50),
                    fprintf([num2str(i) '.\n']);
                 else
                    fprintf([num2str(i) '.']);
                 end;

                if is_siftgeo,
                    tempFeatures = single (siftgeo_read_fast (database.path{i}));
                    [tempFeatures, siftlen] = sp_normalize_sift(tempFeatures', nrml_threshold); % Normalize the siftgeo vectors
                    tempFeatures = tempFeatures';
                else
                    % load(database.path{i});
                    
                    %% remove, eliminar, borrar
                    %[feaSet] = CalculateSiftDescriptorOneImage(database.path{i}, gridSpacing, patchSize, maxImSize, nrml_threshold);
                    
                    tempFeatures = feaSet.feaArr;
                    clear feaSet;
                end;

                if size(tempFeatures, 2) > 0,
                    tempsCodes = LLC_coding_appr(codingDictionary', tempFeatures', knn)';

                    numFeaTC = size(tempsCodes, 2); 
                    % Sampling
                    if numFeaTC >= num_samples_perImg,
                        rndidx = randperm(numFeaTC);
                        tempsCodes =  tempsCodes(:, rndidx(1:num_samples_perImg));
                    else
                        rndidx = randperm(numFeaTC);
                        tempsCodes = tempsCodes(:, rndidx(1:numFeaTC));
                    end;

                    sCodes = [sCodes tempsCodes];

                    clear rndidx tempsCodes;
                end;

                clear tempFeatures;
            end        
        else
            if is_siftgeo,
                tempFeatures = single (siftgeo_read_fast (database.path{1}));
                [tempFeatures, siftlen] = sp_normalize_sift(tempFeatures', nrml_threshold); % Normalize the siftgeo vectors
                tempFeatures = tempFeatures';
            else
                 load(database.path{1});
                
                %% remove, eliminar, borrar
%                 [feaSet] = CalculateSiftDescriptorOneImage(database.path{1}, gridSpacing, patchSize, maxImSize, nrml_threshold);
                
                tempFeatures = feaSet.feaArr;
                clear feaSet;
            end;
            
            if size(tempFeatures, 2) > 0,
                tempsCodes = LLC_coding_appr(codingDictionary', tempFeatures', knn)';

                numFeaTC = size(tempsCodes, 2); 
                % Sampling
                if numFeaTC >= num_samples_perImg,
                    rndidx = randperm(numFeaTC);
                    tempsCodes =  tempsCodes(:, rndidx(1:num_samples_perImg));
                else
                    rndidx = randperm(numFeaTC);
                    tempsCodes = tempsCodes(:, rndidx(1:numFeaTC));
                end;

                sCodes = [sCodes tempsCodes];

                clear rndidx tempsCodes;
            end;
            
            clear tempFeatures;
        end;

        save(TCpath, 'sCodes');
        %clear sCodes;
    end
    
    % Learn the pooling dictionary
    [poolingDictionary] = build_dictionary(false, '', sCodes, nConfigSpace, 20, 8);
    save(PDpath, 'poolingDictionary');
    
    %clear sCodes;
else
    switch is_sparse
        case 'yes'
            codingDictionary = fvecs_read(Dpath);

        case 'no'
            load(CDpath);
            %load(PDpath);        
    end;
end;

%% Calculating the image representations
% pyramid = [1 2 4]; % 3 level pyramid, 21 spatial bins.
dimFea = nBases; % nBases*128; nBases*4; % sum(nBases*nConfigSpace*pyramid.^2);
numFea = length(database.path);

sc_fea = zeros(dimFea, numFea, 'single');

wIDF = zeros(1, nBases, 'double');
wTF = zeros(numFea, nBases, 'single');

disp('==================================================');
fprintf('Calculating the Boureau Image Representations...\n');
disp('==================================================');

for iter1 = 1:numFea,  
    if ~mod(iter1, 50),
        fprintf([num2str(iter1) '.\n']);
    else
        fprintf([num2str(iter1) '.']);
    end;
    
    fpathSiftgeo = database.path{iter1};
    
%     if is_siftgeo,
%         [pathstr, name, ext] = fileparts(fpathSiftgeo); 
%         fpathPgmImage = fullfile(rt_img_dir, [name '.jpg.pgm']); 
%         [v, meta, im_h, im_w] = my_siftgeo_read (fpathSiftgeo, fpathPgmImage);
%         [v, siftlen] = sp_normalize_sift(v, nrml_threshold); % Normalize the siftgeo vectors
%         imageFeatures = v';
%         locs=meta(:, 1:2);
% 
%         if size(imageFeatures, 2) ~= 0,
%             % Compute the Feature Codes from the current Image.
%             codes = LLC_coding_appr(codingDictionary', imageFeatures',knn)';
% 
%             % Pooling Stage. Calculate Image Descriptor for the Current Image
%             sc_fea(:, iter1) = boureau_pooling(codes, locs, pyramid, im_w, im_h, poolingDictionary);
%         else
%             sc_fea(:, iter1) = zeros(dimFea, 1);
%         end
%     else
        
        switch is_sparse
            case 'yes'
                siftgeo_path = database.path{iter1};
    
                [pathstr, file_name, file_ext] = fileparts(siftgeo_path); 
                file_path_pgm = fullfile(pgm_dir, [file_name '.jpg.pgm']); 
                [v, meta] = siftgeo_read(siftgeo_path);
                I = imread(file_path_pgm);
                [im_h, im_w] = size(I);
                clear I;

                imageFeatures = v';
                locs = meta(:, 1:2)';
                
                % Fill feaSet
                feaSet.width = im_w;
                feaSet.height = im_h;
                feaSet.feaArr = imageFeatures;
                
                
            case 'no'
                load(fpathSiftgeo);
                
                imageFeatures = feaSet.feaArr;
                locs=[feaSet.x feaSet.y]';
                im_w = feaSet.width;
                im_h = feaSet.height;
        end;
        
        %im_width_patches = feaSet.width_patches;
%         im_height_patches = feaSet.height_patches;
%         im_total_patches = feaSet.total_patches;
        
%% My new scheme for representing images 
        % Compute the Feature Codes from the current Image.
        if length(feaSet.feaArr)>0
            [idx, dis] = yael_nn (single(codingDictionary), single(imageFeatures), 1); %LLC_coding_appr(codingDictionary', imageFeatures',knn)';
            coordI = [1:size(imageFeatures, 2)];
            coordJ = double(idx);
            values = ones(1, size(imageFeatures, 2), 'double');
            codes = sparse(coordI, coordJ, values, size(imageFeatures, 2), size(codingDictionary, 2));

            switch method
                case 'myr-no-borders'
                    border_filter = zeros(1, size(locs,2)) + 1;
                    area = true;
                    sc_fea(:, iter1) = vwdist_repr(codes', locs, codingDictionary, area, border_filter);   

                case 'myr-yes-borders'
                    switch is_sparse
                        case 'yes'
                            border_filter_percentage = uint32(0.5*size(locs,2));
                            border_filter = zeros(1, size(locs,2))+1;
                            mask = [ones(1,size(locs,2) - border_filter_percentage),zeros(1,border_filter_percentage)];
                            mask = reshape(mask(randperm(size(locs,2))),[1, size(locs,2)]);
                            border_filter = border_filter.*mask;

                        case 'no'
                            %% My representation. Calculate Image Descriptor for the Current Image
                            feaSet.height_patches = uint32((feaSet.height-8)/8);
                            feaSet.width_patches = uint32((feaSet.width-8)/8);
                            border_filter = zeros(1, size(locs,2));
                            border_filter_percentage = 0.33;
                            filtered_rows = uint32(feaSet.height_patches*border_filter_percentage);
                            filtered_cols = uint32(feaSet.width_patches*border_filter_percentage);
                            min_lines = min([filtered_rows filtered_cols]);
                            min_long = min([feaSet.height_patches feaSet.width_patches]);
                            max_lines = max([filtered_rows filtered_cols]);
                            max_long = max([feaSet.height_patches feaSet.width_patches]);
            %                 M_image = zeros(feaSet.height_patches, feaSet.width_patches);

                            % Iterating column-wise
                            linear_index = 1;
                            for y=1:feaSet.width_patches;
                                for x=1:feaSet.height_patches;
                                    switch border
                                        case 'normal'
                                            if (x >= filtered_rows) &&  (x <= (feaSet.height_patches - filtered_rows)) && (y >= filtered_cols) && (y <= (feaSet.width_patches - filtered_cols))
                                                border_filter(linear_index) = 1;
                                             %   M_image(x, y) = 1;
                                            end;
                                        case 'wrong'
                                            if (x >= filtered_rows) &&  (x <= (feaSet.height_patches - filtered_rows)) && (y >= filtered_cols) && (y <= (feaSet.height_patches - filtered_rows))
                                                border_filter(linear_index) = 1;
                                            %    M_image(x, y) = 1;
                                            end
                                    end;
                                    linear_index = linear_index + 1;
                                end
                            end
                            
                    end;                

                    %imshow(M_image);
                    area = true;
                    sc_fea(:, iter1) = vwdist_repr(codes', locs, codingDictionary, area, border_filter);   

                case 'vlad'
                %% VLAD Representation
                    sc_fea(:, iter1) = vlad(single(codingDictionary), single(imageFeatures));
                    
                case 'bof'
                    % Computing weights
%                     tempCodesDistinctFromZero = double(codes ~= 0);
%                     tempW = sum(tempCodesDistinctFromZero);
%                     maxtempW = max(tempW);
%                     wTF(iter1, :) = 0.5 + 0.5*(tempW/maxtempW);
%                     wIDF = wIDF + double(tempW>0);
%                     clear tempCodesDistinctFromZero tempW maxtempW;
                    
                    % BoF representation
                    BoF = full(sum(codes));
                    wIDF = wIDF + double(BoF>0);
                    if sum(BoF)~=0
                        BoF = BoF/sum(BoF);
                    end;
                    sc_fea(:, iter1) = BoF;
                
                case 'spm'
                    %% Pooling Stage
                    poolingDictionary = ones(nBases, 1);
                    % Calculate Image Descriptor for the Current Image
                    sc_fea(:, iter1) = boureau_pooling(codes', locs, pyramid, im_w, im_h, poolingDictionary, 2);
                    

            end;
            
            
        end;
%     end;
end;

switch method
    
    case 'bof'
        % Update with the Log and Number of images.
        wIDF = repmat(numFea, 1, nBases)./(wIDF+1);
        wIDF = log(wIDF);
        
        outputPath = '/media/joan/SAMSUNG/Work/UNIGE/Image-Datasets/flickr12k/PCA-MetaData/21504/BoF/';
        IRpath = [outputPath 'IR_' dataSet '_' num2str(dimFea) '_withoutIDF.fvecs'];
        fvecs_write (IRpath, sc_fea);
        
        for iter1 = 1:numFea,
    %         wTFIDF =  wTF(iter1, :).*wIDF;
    %         tempVector =  repmat(wTFIDF, [1 21]);
    %         sc_fea(:, iter1) = sc_fea(:, iter1).*(tempVector');
            sc_fea(:, iter1) = sc_fea(:, iter1).*(wIDF');
    %         clear wTFIDF tempVector;
        end;
        IDFoutputPath = '/media/joan/SAMSUNG/Work/UNIGE/Image-Datasets/flickr12k/PCA-MetaData/21504/BoF/';
        IDFpath = [IDFoutputPath 'IDF_' dataSet '_' num2str(dimFea) '.fvecs'];
        fvecs_write (IDFpath, wIDF);
    
end;   

outputPath = '/media/joan/SAMSUNG/Work/UNIGE/Image-Datasets/flickr12k/PCA-MetaData/21504/BoF/';
IRpath = [outputPath 'IR_' dataSet '_' num2str(dimFea) '.fvecs'];
fvecs_write (IRpath, sc_fea);



%% SAVEsssssssss
        
%% Weighting scheme for representing images        
%         % Compute the Feature Codes from the current Image.
%         codes = LLC_coding_appr(codingDictionary', imageFeatures',knn)';
% %         
% %         % Computing weights
% %         tempCodesDistinctFromZero = double(codes' ~= 0);
% %         tempW = sum(tempCodesDistinctFromZero);
% %         maxtempW = max(tempW);
% %         wTF(iter1, :) = 0.5 + 0.5*(tempW/maxtempW);
% %         
% %         wIDF = wIDF + single(tempW>0);
% %         
% %         clear tempCodesDistinctFromZero tempW maxtempW;
% %         
%         norm_factor = 2;
%         % Pooling Stage. Calculate Image Descriptor for the Current Image
%         sc_fea(:, iter1) = boureau_pooling(codes, locs, pyramid, im_w, im_h, poolingDictionary, norm_factor);

% Nearest neighbor scheme for Quantization
%         % Compute the Feature Codes from the current Image.
%         [idx, dis] = yael_nn (single(codingDictionary), single(imageFeatures), 1); %LLC_coding_appr(codingDictionary', imageFeatures',knn)';
%         coordI = [1:size(imageFeatures, 2)];
%         coordJ = double(idx);
%         values = ones(1, size(imageFeatures, 2), 'double');
%         codes = sparse(coordI, coordJ, values, size(imageFeatures, 2), size(codingDictionary, 2));
%         
% %         % Computing weights
% %         tempCodesDistinctFromZero = double(codes ~= 0);
% %         tempW = sum(tempCodesDistinctFromZero);
% %         maxtempW = max(tempW);
% %         wTF(iter1, :) = 0.5 + 0.5*(tempW/maxtempW);
% %         
% %         wIDF = wIDF + double(tempW>0);
% %         
% %         clear tempCodesDistinctFromZero tempW maxtempW;
%         
%         % Pooling Stage. Calculate Image Descriptor for the Current Image
%         norm_factor = 2;
%         sc_fea(:, iter1) = boureau_pooling(codes', locs, pyramid, im_w, im_h, poolingDictionary, norm_factor);

%% My new scheme for representing images 
        % Compute the Feature Codes from the current Image.
%         [idx, dis] = yael_nn (single(codingDictionary), single(imageFeatures), 1); %LLC_coding_appr(codingDictionary', imageFeatures',knn)';
%         coordI = [1:size(imageFeatures, 2)];
%         coordJ = double(idx);
%         values = ones(1, size(imageFeatures, 2), 'double');
%         codes = sparse(coordI, coordJ, values, size(imageFeatures, 2), size(codingDictionary, 2));
        
%% My representation. Calculate Image Descriptor for the Current Image
%         feaSet.height_patches = uint32((feaSet.height-8)/8);
%         feaSet.width_patches = uint32((feaSet.width-8)/8);
%           border_filter = zeros(1, size(locs,2))+1;
%         border_filter_percentage = 0.33;
%         filtered_rows = uint32(feaSet.height_patches*border_filter_percentage);
%         filtered_cols = uint32(feaSet.width_patches*border_filter_percentage);
%         min_lines = min([filtered_rows filtered_cols]);
%         min_long = min([feaSet.height_patches feaSet.width_patches]);
%         max_lines = max([filtered_rows filtered_cols]);
%         max_long = max([feaSet.height_patches feaSet.width_patches]);
%         M_image = zeros(feaSet.height_patches, feaSet.width_patches);
%         
%         % Iterating column-wise
%         linear_index = 1; 
%         for y=1:feaSet.width_patches;
%             for x=1:feaSet.height_patches;
%                 % Best one (Fake) if (x >= filtered_rows) &&  (x <= (feaSet.height_patches - filtered_rows)) && (y >= filtered_cols) && (y <= (feaSet.height_patches - filtered_rows))
%                 % Real one        if (x >= filtered_rows) &&  (x <= (feaSet.height_patches - filtered_rows)) && (y >= filtered_cols) && (y <= (feaSet.width_patches - filtered_cols))
%                 % Only with min   if (x >= min_lines) &&  (x <= (min_long - min_lines)) && (y >= min_lines) && (y <= (min_long - min_lines))
%                 % Only horizontal if (x >= filtered_rows) &&  (x <= (feaSet.height_patches - filtered_rows))
%                 
% %                 if feaSet.height_patches > feaSet.width_patches % vertical image
% %                     if (x >= max_lines) &&  (x <= (max_long - max_lines)) && (y >= min_lines) && (y <= (min_long - min_lines))
% %                         border_filter(linear_index) = 1;
% %                         M_image(x, y) = 1;
% %                     end
% %                 else % horizontal image
% %                     if (x >= min_lines) &&  (x <= (min_long - min_lines)) && (y >= max_lines) && (y <= (max_long - max_lines))
% %                         border_filter(linear_index) = 1;
% %                         M_image(x, y) = 1;
% %                     end
% %                 end
%                 if (x >= filtered_rows) &&  (x <= (feaSet.height_patches - filtered_rows)) && (y >= filtered_cols) && (y <= (feaSet.height_patches - filtered_rows))
%                     border_filter(linear_index) = 1;
%                     %M_image(x, y) = 1;
%                 end
%                 
%                 linear_index = linear_index + 1;
%             end
%         end
%         
%         %imshow(M_image);
%         area = true;
%         sc_fea(:, iter1) = vwdist_repr(codes', locs, codingDictionary, area, border_filter);   


%% VLAD Representation
%         sc_fea(:, iter1) = vlad(single(codingDictionary), single(imageFeatures));
        
