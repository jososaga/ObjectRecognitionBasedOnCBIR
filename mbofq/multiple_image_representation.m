% This code is for performing experiments related to Content-based image
% retrieval

% Author: Joan Sosa Garcia

%% Clear variables
clear all;
clc;

Running_Method = 'Feature_Extraction'; % 'Feature_Extraction'; 'Descriptor_Computation';

switch Running_Method
    case 'Feature_Extraction'
        %% Extract Features
        %{
        ex1.img_dir = '/media/samsungdisk/Work/UNIGE/Image-Datasets/banknotes/Banknotes-Originals/all/banknotes/'; 
        ex1.data_dir = '/media/samsungdisk/Work/UNIGE/Image-Datasets/banknotes/dense/data-dense/600/';
        % ex1.dataSet = 'banknotes';
        ex1.gridSpacing = 8;
        ex1.patchSize = 16;
        ex1.maxImSize = 600;
        ex1.nrml_threshold = 1; 
        ex1.is_sparse = false;
        ex1.save_newImg = true;

        ex2.img_dir = '/media/samsungdisk/Work/UNIGE/Image-Datasets/banknotes/Banknotes-Originals/all/banknotes/'; 
        ex2.data_dir = '/media/samsungdisk/Work/UNIGE/Image-Datasets/banknotes/dense/data-dense/1000/';
        % ex2.dataSet = 'banknotes';
        ex2.gridSpacing = 8;
        ex2.patchSize = 16;
        ex2.maxImSize = 1000;
        ex2.nrml_threshold = 1; 
        ex2.is_sparse = false;
        ex2.save_newImg = true;

        ex3.img_dir = '/media/samsungdisk/Work/UNIGE/Image-Datasets/banknotes/Banknotes-Originals/all-test/banknotes/'; 
        ex3.data_dir = '/media/samsungdisk/Work/UNIGE/Image-Datasets/banknotes/dense-test/data-dense/600/';
        % ex3.dataSet = 'banknotes';
        ex3.gridSpacing = 8;
        ex3.patchSize = 16;
        ex3.maxImSize = 600;
        ex3.nrml_threshold = 1; 
        ex3.is_sparse = false;
        ex3.save_newImg = true;

        ex4.img_dir = '/media/samsungdisk/Work/UNIGE/Image-Datasets/banknotes/Banknotes-Originals/all-test/banknotes/'; 
        ex4.data_dir = '/media/samsungdisk/Work/UNIGE/Image-Datasets/banknotes/dense-test/data-dense/1000/';
        % ex4.dataSet = 'banknotes';
        ex4.gridSpacing = 8;
        ex4.patchSize = 16;
        ex4.maxImSize = 1000;
        ex4.nrml_threshold = 1; 
        ex4.is_sparse = false;
        ex4.save_newImg = true;

        experiments{1} = ex1;
        experiments{2} = ex2;
        experiments{3} = ex3;
        experiments{4} = ex4;
        %}
        
        ex1.img_dir = 'I:\Work\UNIGE\Image-Datasets\banknotes\Training\banknotes\pgm\'; 
        ex1.data_dir = 'I:\Work\UNIGE\Image-Datasets\banknotes\Training\banknotes\data\sparse\data-sparse-surf\descriptors\from-simplebanknotes\resolutions\90%\features\';
        ex1.imgOuput_dir = 'I:\Work\UNIGE\Image-Datasets\banknotes\Training\banknotes\data\sparse\data-sparse-surf\descriptors\from-simplebanknotes\resolutions\90%\images\';
        ex1.dataSet = 'banknotes';
        ex1.maxImSize = 1064;
        ex1.nrml_threshold = 1; 
        ex1.is_sparse = true;
        ex1.save_newImg = true;
        ex1.featMethod = 'SURF';
        
        ex2.img_dir = 'I:\Work\UNIGE\Image-Datasets\banknotes\Training\banknotes\pgm\'; 
        ex2.data_dir = 'I:\Work\UNIGE\Image-Datasets\banknotes\Training\banknotes\data\sparse\data-sparse-surf\descriptors\from-simplebanknotes\resolutions\80%\features\';
        ex2.imgOuput_dir = 'I:\Work\UNIGE\Image-Datasets\banknotes\Training\banknotes\data\sparse\data-sparse-surf\descriptors\from-simplebanknotes\resolutions\80%\images\';
        ex2.dataSet = 'banknotes';
        ex2.maxImSize = 946;
        ex2.nrml_threshold = 1; 
        ex2.is_sparse = true;
        ex2.save_newImg = true;
        ex2.featMethod = 'SURF';
        
        ex3.img_dir = 'I:\Work\UNIGE\Image-Datasets\banknotes\Training\banknotes\pgm\'; 
        ex3.data_dir = 'I:\Work\UNIGE\Image-Datasets\banknotes\Training\banknotes\data\sparse\data-sparse-surf\descriptors\from-simplebanknotes\resolutions\70%\features\';
        ex3.imgOuput_dir = 'I:\Work\UNIGE\Image-Datasets\banknotes\Training\banknotes\data\sparse\data-sparse-surf\descriptors\from-simplebanknotes\resolutions\70%\images\';
        ex3.dataSet = 'banknotes';
        ex3.maxImSize = 827;
        ex3.nrml_threshold = 1; 
        ex3.is_sparse = true;
        ex3.save_newImg = true;
        ex3.featMethod = 'SURF';
        
        ex4.img_dir = 'I:\Work\UNIGE\Image-Datasets\banknotes\Training\banknotes\pgm\'; 
        ex4.data_dir = 'I:\Work\UNIGE\Image-Datasets\banknotes\Training\banknotes\data\sparse\data-sparse-surf\descriptors\from-simplebanknotes\resolutions\60%\features\';
        ex4.imgOuput_dir = 'I:\Work\UNIGE\Image-Datasets\banknotes\Training\banknotes\data\sparse\data-sparse-surf\descriptors\from-simplebanknotes\resolutions\60%\images\';
        ex4.dataSet = 'banknotes';
        ex4.maxImSize = 710;
        ex4.nrml_threshold = 1; 
        ex4.is_sparse = true;
        ex4.save_newImg = true;
        ex4.featMethod = 'SURF';
        
        ex5.img_dir = 'I:\Work\UNIGE\Image-Datasets\banknotes\Training\banknotes\pgm\'; 
        ex5.data_dir = 'I:\Work\UNIGE\Image-Datasets\banknotes\Training\banknotes\data\sparse\data-sparse-surf\descriptors\from-simplebanknotes\resolutions\50%\features\';
        ex5.imgOuput_dir = 'I:\Work\UNIGE\Image-Datasets\banknotes\Training\banknotes\data\sparse\data-sparse-surf\descriptors\from-simplebanknotes\resolutions\50%\images\';
        ex5.dataSet = 'banknotes';
        ex5.maxImSize = 591;
        ex5.nrml_threshold = 1; 
        ex5.is_sparse = true;
        ex5.save_newImg = true;
        ex5.featMethod = 'SURF';
        
        ex6.img_dir = 'I:\Work\UNIGE\Image-Datasets\banknotes\Training\banknotes\pgm\'; 
        ex6.data_dir = 'I:\Work\UNIGE\Image-Datasets\banknotes\Training\banknotes\data\sparse\data-sparse-surf\descriptors\from-simplebanknotes\resolutions\40%\features\';
        ex6.imgOuput_dir = 'I:\Work\UNIGE\Image-Datasets\banknotes\Training\banknotes\data\sparse\data-sparse-surf\descriptors\from-simplebanknotes\resolutions\40%\images\';
        ex6.dataSet = 'banknotes';
        ex6.maxImSize = 473;
        ex6.nrml_threshold = 1; 
        ex6.is_sparse = true;
        ex6.save_newImg = true;
        ex6.featMethod = 'SURF';
        
        experiments{1} = ex1;
        experiments{2} = ex2;
        experiments{3} = ex3;
        experiments{4} = ex4;
        experiments{5} = ex5;
        experiments{6} = ex6;

        for num_exp=1:length(experiments)
            
            switch experiments{num_exp}.is_sparse
                case true
                    [database] = CalculateSparseSiftDescriptor(experiments{num_exp}.img_dir, experiments{num_exp}.imgOuput_dir, experiments{num_exp}.data_dir, experiments{num_exp}.maxImSize, experiments{num_exp}.nrml_threshold, experiments{num_exp}.featMethod, experiments{num_exp}.save_newImg);
                case false
                    [database] = CalculateSiftDescriptor(experiments{num_exp}.img_dir, experiments{num_exp}.data_dir, 8, 16, experiments{num_exp}.maxImSize, experiments{num_exp}.nrml_threshold, experiments{num_exp}.save_newImg);
            end
            clear database;
            
        end


    case 'Descriptor_Computation'
        %% Compute descriptors
        
%         % SimpleBanknotes Hess-Aff SPARSE VLAD HARD 25600
%         ex2.img_dir = ''; 
%         ex2.data_dir = '/media/samsungdisk/Work/UNIGE/Image-Datasets/banknotes/Test/simplebanknotes/data/sparse/data-sparse-surf/simplebanknotes/';
%         ex2.dictionaryPath = '/media/samsungdisk/Work/UNIGE/Image-Datasets/banknotes/Test/simplebanknotes/data/sparse/data-sparse-surf/dictionaries/clust_simplebanknotes_k1000.fvecs';
%         ex2.outputPath = '/media/samsungdisk/Work/UNIGE/Image-Datasets/banknotes/Test/simplebanknotes/data/sparse/data-sparse-surf/descriptors/SPM/';
%         ex2.dataSet = 'simplebanknotes';
%         ex2.method = 'spm';
%         ex2.nBases = 1000;
%         ex2.nConfigSpace = 1;
%         ex2.is_sparse = true;
%         ex2.is_siftgeo = false;
%         ex2.encoding_method = 'hard';
%         ex2.dimensions = 64;

        % SimpleBanknotes Hess-Aff SPARSE FISHER HARD 25600
        ex3.img_dir = ''; 
        ex3.data_dir = '/media/samsungdisk/Work/UNIGE/Image-Datasets/banknotes/Test/simplebanknotes/data/sparse/data-sparse-surf/simplebanknotes/';
        ex3.dictionaryPath = '/media/samsungdisk/Work/UNIGE/Image-Datasets/banknotes/Test/simplebanknotes/data/sparse/data-sparse-surf/dictionaries/clust_simplebanknotes_k200.fvecs';
        ex3.outputPath = '/media/samsungdisk/Work/UNIGE/Image-Datasets/banknotes/Test/simplebanknotes/data/sparse/data-sparse-surf/descriptors/FISHER/';
        ex3.dataSet = 'simplebanknotes';
        ex3.method = 'bof';
        ex3.nBases = 200;
        ex3.is_sparse = true;
        ex3.is_siftgeo = false;
        ex3.tempDataset = 'simplebanknotes';
        ex3.gmmPath = '/media/samsungdisk/Work/UNIGE/Image-Datasets/banknotes/Test/simplebanknotes/data/sparse/data-sparse-surf/dictionaries/gmm/';
        ex3.encoding_method = 'hard';
        ex3.dimensions = 64;
        
        experiments{1} = ex3;

        for num_exp=1:length(experiments)

            %% Loading metadata
            switch experiments{num_exp}.is_siftgeo

                case true
                    %% Loading database
                    rt_img_dir = experiments{num_exp}.img_dir;
                    rt_data_dir = experiments{num_exp}.data_dir;
                    database = retr_database_dir(experiments{num_exp}.is_siftgeo, rt_data_dir, false);
                    
                case false
                    %% Loading database
                    rt_img_dir = experiments{num_exp}.img_dir;
                    rt_data_dir = experiments{num_exp}.data_dir;
                    database = retr_database_dir(experiments{num_exp}.is_siftgeo, rt_data_dir, false);
                    
            end;
            %% Loading Dictionaries
            switch experiments{num_exp}.is_sparse

                case true
                    %% Loading dictionaries
                    codingDictionary = fvecs_read(experiments{num_exp}.dictionaryPath);

                case false
                    %% Loading dictionaries
                    load(experiments{num_exp}.dictionaryPath);

            end;

            %% Setting vector dimensions
            dimFea = 0;
            switch experiments{num_exp}.method
                case 'bofxq'
                    dimFea = experiments{num_exp}.nBases*4;

                case 'vlad'
                    dimFea = experiments{num_exp}.nBases*experiments{num_exp}.dimensions;

                case 'fisher'
%                     gmmPath = '/media/unigedisk/Joan/Image-Datasets/flickr60k/dictionaries/gmm/';
                    load([experiments{num_exp}.gmmPath 'means_' experiments{num_exp}.tempDataset '_k' int2str(experiments{num_exp}.nBases) '.mat']);
                    load([experiments{num_exp}.gmmPath 'covariances_' experiments{num_exp}.tempDataset '_k' int2str(experiments{num_exp}.nBases) '.mat']);
                    load([experiments{num_exp}.gmmPath 'priors_' experiments{num_exp}.tempDataset '_k' int2str(experiments{num_exp}.nBases) '.mat']);
                    dimFea = experiments{num_exp}.nBases*experiments{num_exp}.dimensions*2;

                case 'bof'
                    wIDF = zeros(1, experiments{num_exp}.nBases, 'single');
                    wTF = zeros(length(database.path), experiments{num_exp}.nBases, 'single');
                    dimFea = experiments{num_exp}.nBases;

                case 'spm'
                    pyramid = [1, 2, 4];
                    dimFea = sum((experiments{num_exp}.nBases)*(experiments{num_exp}.nConfigSpace)*pyramid.^2);
            end;
            numFea = length(database.path);
            sc_fea = zeros(dimFea, numFea, 'single');

            %% Computing image representations
            disp('==================================================');
            fprintf('Calculating Image Representations...\n');
            disp('==================================================');

            for iter1 = 1:numFea,  
                if ~mod(iter1, 50),
                    fprintf([num2str(iter1) '.\n']);
                else
                    fprintf([num2str(iter1) '.']);
                end;

                %% Loading current image features (column-wise)
                featuresPath = database.path{iter1};
                switch experiments{num_exp}.is_siftgeo
                    case true
                        [v, meta] = siftgeo_read(featuresPath);
                        imageFeatures = v';
                        locs = meta(:, 1:2)';

                        if ~isempty(experiments{num_exp}.img_dir)
                            [pathstr, name, ext] = fileparts(featuresPath);
                            fpathPGM = fullfile(experiments{num_exp}.img_dir, [name '.jpg.pgm']);
                            img_pgm = imread(fpathPGM);
                            [im_h, im_w] = size(img_pgm);
                            clear img_pgm;
                        end

                    case false
                        load(featuresPath);
                        imageFeatures = feaSet.feaArr;
                        locs=[feaSet.x feaSet.y]'; %% OJOJOJOJOJ problema con el SURF que los guarde mal inicialmente cdo hice feature detection
                        im_w = feaSet.width;
                        im_h = feaSet.height;
                end;

                if ~isempty(imageFeatures)
                    %% Encoding the local features with corresponding method
                    switch experiments{num_exp}.encoding_method
                        case 'hard'
                            [idx, dis] = yael_nn (single(codingDictionary), single(imageFeatures), 1); %LLC_coding_appr(codingDictionary', imageFeatures',knn)';
                            coordI = [1:size(imageFeatures, 2)];
                            coordJ = double(idx);
                            values = ones(1, size(imageFeatures, 2), 'double');
                            codes = sparse(coordI, coordJ, values, size(imageFeatures, 2), size(codingDictionary, 2));

                        case 'soft-llc'
                            codes = LLC_coding_appr(codingDictionary', imageFeatures',5);

                        case 'soft-gauss'
                            [codes] = yael_cross_distances(single(imageFeatures), single(codingDictionary), 2);
                            codes = (1/sqrt(2*pi)*experiments{num_exp}.sigma)*exp(-(1/2)*(codes.^2/experiments{num_exp}.sigma^2));
                            for ii=1:size(codes, 1)
                                codes(ii,:) = codes(ii,:)/sum(codes(ii,:));
                            end;

                    end

                    %% Computing image descriptor of the current image with corresponding method
                    switch experiments{num_exp}.method
                        case 'vlad'
                            sc_fea(:, iter1) = vl_vlad(double(imageFeatures), double(codingDictionary), full(codes'));

                        case 'fisher'
                            sc_fea(:, iter1) = vl_fisher(imageFeatures, means, covariances, priors);

                        case 'bof'
                            BoF = full(sum(codes));
                            wIDF = wIDF + double(BoF>0);
                            if sum(BoF)~=0
                                BoF = BoF/sum(BoF);
                            end;
                            sc_fea(:, iter1) = BoF;

                        case 'spm'
                            poolingDictionary = ones(experiments{num_exp}.nBases, 1);
                            pool_method = 'sum';
                            normFact_pool_method = 2;
                            norm_factor = 2;
                            sc_fea(:, iter1) = boureau_pooling(codes', locs, pyramid, im_w, im_h, poolingDictionary, pool_method, normFact_pool_method, norm_factor); % boureau_pooling(codes', locs, pyramid, im_w, im_h, poolingDictionary, 2);

                        case 'bofxq'
        %                     feaSet.height_patches = floor((feaSet.height-8)/8);
        %                     feaSet.width_patches = floor((feaSet.width-8)/8);
                            border_filter = zeros(1, size(locs,2)) + 1;
                            area = true;
                            sc_fea(:, iter1) = vwdist_repr(codes', locs, codingDictionary, area, border_filter); % vwdist_repr(codes', locs, codingDictionary, area, border_filter); % vwdist_repr_upd(codes', locs, codingDictionary, area, border_filter, feaSet.height_patches, feaSet.width_patches);
                    end;            
                end;

            end;

            %% Postprocessing analysis in case is needed
            switch experiments{num_exp}.method
                case 'bof'
                    % Update with the Log and Number of images.
                    wIDF = repmat(numFea, 1, experiments{num_exp}.nBases)./(wIDF+1);
                    wIDF = log(wIDF);

                    IRpath = [experiments{num_exp}.outputPath 'IR_' experiments{num_exp}.dataSet '_' num2str(dimFea) '_withoutIDF.fvecs'];
                    fvecs_write (IRpath, sc_fea);

                    for iter1 = 1:numFea,
                        sc_fea(:, iter1) = sc_fea(:, iter1).*(wIDF');
                    end;

                    IDFpath = [experiments{num_exp}.outputPath 'IDF_' experiments{num_exp}.dataSet '_' num2str(dimFea) '.fvecs'];
                    fvecs_write (IDFpath, wIDF);
            end;

            IRpath = [experiments{num_exp}.outputPath 'IR_' experiments{num_exp}.dataSet '_' num2str(dimFea) '.fvecs'];
            if not(exist(IRpath, 'file'))
                fvecs_write (IRpath, sc_fea);
            end

        end;
end