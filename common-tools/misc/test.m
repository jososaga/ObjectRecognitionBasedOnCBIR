% % [y,Fs] = audioread(fullfile('D:\Dropbox\Unige-Research\1-Object Recognition Demo App\Demo-code\ObjectRecognitionFramework_1.2\object-tree\Medicines\Medicine Box\media', 'prod00017000.flac'));
% % playerObj = audioplayer(y,Fs);
% % playblocking(playerObj);


ouput_path = 'C:\Users\joan\Desktop\negatives\all\';
siftfname = struct2cell (dir(fullfile(ouput_path, '*.jpg')));
siftfname = siftfname(1, :);
nimg = size (siftfname, 2);
 for i=1:nimg,
     [pathstr,name,ext] = fileparts(fullfile(ouput_path,siftfname{i}));
     IM = imread(fullfile(ouput_path,siftfname{i}));    
     if ndims(IM) == 3,
        IM = im2double(rgb2gray(IM));
     else
        IM = im2double(IM);
     end;
     ouput_path_new = 'C:\Users\joan\Desktop\negatives\bw\';
     file_path = [ouput_path_new, siftfname{i}];
     imwrite(IM, file_path)
 end

% % clear all;
% % 
% % %----------------------------------------------------------------------------
% % % This test program reproduces the results obtained for the method 
% % % presented in the paper:
% % % "Aggregating local descriptors into a compact image reprensentation"
% % %
% % % Authors: Herve Jegou and Matthijs Douze
% % % Contact: herve.jegou@inria.fr and matthijs.douze@inria.fr
% % % Copyright INRIA 2010
% % %
% % % Licence: 
% % % This software and its subprograms are governed by the CeCILL license 
% % % under French law and abiding by the rules of distribution of free software. 
% % % See http://www.cecill.info/licences.en.html
% % 
% % % Various directories for mandatory libraries:
% % %   Yael and its Matlab interface should be compiled (mexfiles)
% % %   Pqcodes requires to compile sumidxtab (mex sumidxtab.c)
% % %----------------------------------------------------------------------------
% % 
% % dir_pqcodes = './pqcodes/';
% % dir_yael = './yael/';
% % dir_sift = './siftgeo/'; % '/media/joan/Elements/Joan-Experiments/Image-Datasets/firenze/firenze/'; %'/media/joan/Elements/Joan-Experiments/Image-Datasets/ukb/'; %'/media/joan/New Volume/LinuxExperiments/UKB/ukb/';'./siftgeo/';
% % dir_ukb = '/media/joan/Elements/Joan-Experiments/Image-Datasets/ukb/';
% % dir_data = './data/';
% % 
% % addpath ([dir_yael '/matlab']);
% % addpath (dir_pqcodes);
% % 
% % f_centroids = [dir_data 'clust_k64.fvecs'];    % given in the package
% % f_vlad = [dir_data 'vlad_k64_holidays.fvecs']; % computed
% % f_pca_proj = [dir_data 'pca_proj_matrix_vladk64_flickr1Mstar.fvecs']; %proj matrix
% % 
% % do_compute_vlad = true;          % compute vlads or use the pre-compiled ones
% % 
% % % Parameters
% % shortlistsize = 1000;             % number of elements ranked by the system
% % dd = 128;                         % number of components kept by PCA transform
% % 
% % nsq = 16;                         % ADC: number of subquantizers
% % nsq_bits = 8;                     % ADC: number of bit/subquantizer
% % 
% % %%  PCA
% % fpathID = ['/media/joan/Elements/Joan-Experiments/Image-Datasets/flickr12k/Experiments-PCA/dictionaries1/4096/IR_flickr12k_16384.fvecs']; %/home/joan/Desktop/ALDICR_SpatialPyramidRepresentation/boureau/dictionaries
% % v = fvecs_read (fpathID);
% % 
% % for j=1:size(v,2),
% %     vector = v(:,j);
% %     for i=1:4:size(vector,1),
% %         if(sum(vector(i:i+3))~=0),
% %             v(i:i+3, j) = vector(i:i+3)/norm(vector(i:i+3));
% %         end
% %     end
% % end
% % % VW-representation per quadrant
% % for j=1:size(v,2),
% %     v_temp = v(:, j)';
% %     v1 = v_temp(1:4:end);
% %     v1 = v1/norm(v1);
% %     v2 = v_temp(2:4:end);
% %     v2 = v2/norm(v2);
% %     v3 = v_temp(3:4:end);
% %     v3 = v3/norm(v3);
% %     v4 = v_temp(4:4:end);
% %     v4 = v4/norm(v4);
% %     v_temp = [v1 v2 v3 v4];
% %     v(:, j) = v_temp;
% % end
% % % v = yael_fvecs_normalize (v);
% % v = v';
% % 
% % % v = v - min(v(:));
% % % v = v / max(v(:));
% % min_mapping = min(v(:));
% % v = v - min_mapping;
% % max_mapping = max(v(:));
% % v = v / max_mapping;
% % [vv, mapping] = compute_mapping(v, 'PCA', 128);
% % save('/media/joan/Elements/Joan-Experiments/Image-Datasets/flickr12k/Experiments-PCA/dictionaries1/4096/NotNormalized/MyR-BoF/mapping_4096_5000.mat', 'mapping');
% % save('/media/joan/Elements/Joan-Experiments/Image-Datasets/flickr12k/Experiments-PCA/dictionaries1/4096/NotNormalized/MyR-BoF/min_mapping_4096_5000.mat', 'min_mapping');
% % save('/media/joan/Elements/Joan-Experiments/Image-Datasets/flickr12k/Experiments-PCA/dictionaries1/4096/NotNormalized/MyR-BoF/max_mapping_4096_5000.mat', 'max_mapping');
% % 
% % 
% % %% ----------------------------------------------------------------------------
% % % Retrieve the list of images and construct the groundtruth
% % [imlist, sift, gnd, qidx] = load_holidays (dir_sift, '');
% % % [imlist, gnd, qidx] = load_ukb (dir_ukb);
% % %clear imlist;
% % 
% % %vDim = [ 10752  21504  43008  86016];
% % 
% % % fpathID = ['/media/joan/Elements/Joan-Experiments/Experiments/Densely-Holidays-SPM-TrainedOnFlickr12K/600x600/dictionaries2-MyR/4096/IR_holidays_16384.fvecs']; %/home/joan/Desktop/ALDICR_SpatialPyramidRepresentation/boureau/dictionaries
% % % v = fvecs_read (fpathID);
% % 
% %  
% %  
% % % dictionarySize = 4096;
% % % pyramid = [1 4 16];
% % % cumulPyramid = cumsum(pyramid);
% % % positions = cumulPyramid*dictionarySize;
% % % positions = [0 positions];
% % % positionsSize = size(positions, 2);
% % % v(positions(positionsSize-1)+1:positions(positionsSize), :)=[];
% % % 
% % 
% % %% PCA projections
% % %v = single(compute_mapping(v', 'PCA', 10000)');
% % % [vv, mapping] = compute_mapping(v, 'PCA', 5000);
% % % save('/media/joan/Elements/Joan-Experiments/Image-Datasets/flickr100k/dictionaries1/mapping_5000.mat', 'mapping');
% % % load('/media/joan/Elements/Joan-Experiments/Image-Datasets/flickr100k/Experiments-PCA/dictionaries/5000-600x600-2048-Max-SinNormTodoVect/mapping.mat');
% % % v = single(out_of_sample(v', mapping))';
% % % aa=reconstruct_data(bb', mapping);
% % 
% % % %% Compute VLAD
% % % CDpath = '/media/joan/Elements/Joan-Experiments/Image-Datasets/firenze/600x600/dictionaries/dict_flickr_512_Coding.mat';
% % % load(CDpath);
% % % [imlist, sift, gnd, qidx] = load_firenze (dir_sift, '/media/joan/Elements/Joan-Experiments/Image-Datasets/firenze/600x600/data/firenze/');
% % %  v = compute_vlad (single(codingDictionary), sift); 
% % 
% % % compute or load the VLAD descriptors
% % if do_compute_vlad                 % compute VLADs from SIFT descriptors
% %   centroids = fvecs_read (f_centroids);
% %   v = compute_vlad (centroids, sift); 
% % else                               % load them from disk
% %   v = fvecs_read (f_vlad);
% % end
% % d_vlad = size (v, 1);              % dimension of the vlad vectors
% %   
% % 
% % %----------------------------------------------------------------------------
% % % Full VLAD
% % % perform the queries (without product quantization nor PCA) and find 
% % % the rank of the tp. Keep only top results (i.e., keep shortlistsize results). 
% % % for exact mAP, replace following line by k = length (imlist)
% % 
% % % 4-normalization
% % for j=1:size(v,2),
% %     vector = v(:,j);
% %     for i=1:4:size(vector,1),
% %         if(sum(vector(i:i+3))~=0),
% %             v(i:i+3, j) = vector(i:i+3)/norm(vector(i:i+3));
% %         end
% %     end
% % end
% % 
% % % v = sign(v).*abs(v).^(1/2);
% % v = yael_fvecs_normalize (v);
% % [idx, dis] = yael_nn (v, v(:,qidx), shortlistsize, 2);
% % idx = idx (2:end,:);  % remove the query from the ranking
% % 
% % % map_vlad = compute_results_PN_firenze (idx, gnd, 10);
% % map_vlad = compute_results (idx, gnd);
% % % map_vlad = compute_results_ukb(idx, gnd);
% % fprintf ('full VLAD.                           mAP = %.4f\n', map_vlad);
% % 
% % %% My New Evaluation with Histogram Intersection
% % % % v = sign(v).*abs(v).^(1/2);
% % % v = yael_fvecs_normalize (v);
% % % mIntersection = hist_isect(v(:,qidx)', v');
% % % [mIsecDist mIsecIdx] = sort(mIntersection, 2, 'descend');
% % % mIsecIdx = mIsecIdx(:, 1:shortlistsize)';
% % % idx = mIsecIdx (2:end,:);  % remove the query from the ranking
% % % 
% % % map_vlad = compute_results (idx, gnd);
% % % % map_vlad = compute_results_ukb(mIsecIdx, gnd);
% % % fprintf ('full VLAD.                           mAP = %.4f\n', map_vlad);
% % %% Borrar lo anterior si no da resultado
% % 
% % 
% % 
% % %----------------------------------------------------------------------------
% % % VLAD with PCA projection
% % % perform the PCA projection, and keep dd components only
% % f = fopen (f_pca_proj);
% % mu = fvec_read (f);     % mean. Note that VLAD are already almost centered. 
% % pca_proj = fvec_read (f);
% % pca_proj = reshape (pca_proj, d_vlad, 1024)'; % only the 1024 eigenvectors are stored
% % fclose (f);
% % pca_proj = pca_proj (1:dd,:);
% % 
% % % project the descriptors and compute the results after PCA
% % vp = pca_proj * (v - repmat (mu, 1, size (v,2)));
% % vp = yael_fvecs_normalize (vp);
% % 
% % [idx, dis] = yael_nn (vp, vp(:,qidx), shortlistsize + 1);
% % idx = idx (2:end,:);  % remove the query from the ranking
% % 
% % map_vlad_pca = compute_results (idx, gnd);
% % fprintf ('PCA VLAD (D''=%d)                    mAP = %.3f\n', dd, map_vlad_pca);
% % 
% % 
% % %----------------------------------------------------------------------------
% % % VLAD with PCA projection and PQcodes (ADC variant)
% % % Here, the PQcodes are learned on the Holidays dataset (not in our paper) 
% % % However, we observe comparable results for both learning sets. 
% % % Note: due to the randomness, the mAP varies from an experiment to another
% % 
% % % whitening with a random orthogonal matrix
% % Q = randn (dd);
% % Q = single (Q);
% % Q = yael_fvecs_normalize (Q)';
% % Q = yael_fvecs_normalize (Q)';
% % 
% % vpq = Q * vp;
% % 
% % % learn the pqcodes and encode the vectors
% % % pq = pq_new (nsq, nsq_bits, vpq); % OJO Esta es la linea original 
% % pq = pq_new (nsq, vpq); % OJO NEW
% % vpqcoded = pq_assign (pq, vpq);
% % 
% % % Perform the search
% % [idx, dis] = pq_search (pq, vpqcoded, vpq(:, qidx), shortlistsize);
% % idx = idx';
% % idx = idx (2:end, :);
% % 
% % map_vlad_pca_adc = compute_results (idx, gnd);
% % fprintf ('full VLAD.                           mAP = %.3f\n', map_vlad);
% % fprintf ('PCA VLAD (D''=%d)                    mAP = %.3f\n', dd, map_vlad_pca);
% % fprintf ('PCA+ADC VLAD (D''=%d, %d bytes/img)  mAP = %.3f\n', dd, nsq*nsq_bits/8, map_vlad_pca_adc);
