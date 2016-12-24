I = vl_impattern('roofs1') ;
image(I) ;
I = single(rgb2gray(I)) ;
[f,d] = vl_sift(I) ;
perm = randperm(size(f,2)) ;
sel = perm(1:50) ;
h1 = vl_plotframe(f(:,sel)) ;
h2 = vl_plotframe(f(:,sel)) ;
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;

h3 = vl_plotsiftdescriptor(d(:,sel),f(:,sel)) ;
set(h3,'color','g') ;

numFeatures = 5000 ;
dimension = 2 ;
data = rand(dimension,numFeatures) ;

numClusters = 30 ;
[means, covariances, priors] = vl_gmm(data, numClusters);

numDataToBeEncoded = 1000;
dataToBeEncoded = rand(dimension,numDataToBeEncoded);

encoding = vl_fisher(dataToBeEncoded, means, covariances, priors);












% im1 = imread('/media/samsungdisk/Work/UNIGE/Image-Datasets/Banknotes/20/20150127_152152.jpg') ;
folder = '/media/samsungdisk/Work/UNIGE/Image-Datasets/Banknotes/20/';
foldertest = '/media/samsungdisk/Work/UNIGE/Image-Datasets/Banknotes/20/test/';
folder=foldertest;
classname = '2005';
imgs{1} = [ folder classname '000.jpg'];
imgs{2} = [ folder classname '001.jpg'];
imgs{3} = [ folder classname '002.jpg'];
imgs{4} = [ folder classname '003.jpg'];
imgs{5} = [ folder classname '004.jpg'];
imgs{6} = [ folder classname '005.jpg'];
imgs{7} = [ folder classname '006.jpg'];
imgs{8} = [ folder classname '007.jpg'];

h = figure; 
%----------1st row-------------------------
subplot(2, 4, 1);
X1=imread(imgs{1});
subimage(X1);

subplot(2, 4, 2);
X1=imread(imgs{2});
subimage(X1);

subplot(2, 4, 3);
X1=imread(imgs{3});
subimage(X1);

subplot(2, 4, 4);
X1=imread(imgs{4});
subimage(X1);

subplot(2, 4, 5);
X1=imread(imgs{5});
subimage(X1);

subplot(2, 4, 6);
X1=imread(imgs{6});
subimage(X1);

subplot(2, 4, 7);
X1=imread(imgs{7});
subimage(X1);

subplot(2, 4, 8);
X1=imread(imgs{8});
subimage(X1);

finish =true;

% function mosaic = sift_mosaic(im1, im2)
% 
% im1 = imread(fullfile(vl_root, 'data', 'river1.jpg')) ;
% im2 = imread(fullfile(vl_root, 'data', 'river2.jpg')) ;
% 
% % make single
% im1 = im2single(im1) ;
% im2 = im2single(im2) ;
% 
% % make grayscale
% if size(im1,3) > 1, im1g = rgb2gray(im1) ; else im1g = im1 ; end
% if size(im2,3) > 1, im2g = rgb2gray(im2) ; else im2g = im2 ; end
% 
% % --------------------------------------------------------------------
% %                                                         SIFT matches
% % --------------------------------------------------------------------
% 
% [f1,d1] = vl_sift(im1g) ;
% [f2,d2] = vl_sift(im2g) ;
% 
% [matches, scores] = vl_ubcmatch(d1,d2) ;
% 
% numMatches = size(matches,2) ;
% 
% X1 = f1(1:2,matches(1,:)) ; X1(3,:) = 1 ;
% X2 = f2(1:2,matches(2,:)) ; X2(3,:) = 1 ;
% 
% % --------------------------------------------------------------------
% %                                         RANSAC with homography model
% % --------------------------------------------------------------------
% 
% clear H score ok ;
% for t = 1:100
%   % estimate homograpyh
%   subset = vl_colsubset(1:numMatches, 4) ;
%   A = [] ;
%   for i = subset
%     A = cat(1, A, kron(X1(:,i)', vl_hat(X2(:,i)))) ;
%   end
%   [U,S,V] = svd(A) ;
%   H{t} = reshape(V(:,9),3,3) ;
% 
%   % score homography
%   X2_ = H{t} * X1 ;
%   du = X2_(1,:)./X2_(3,:) - X2(1,:)./X2(3,:) ;
%   dv = X2_(2,:)./X2_(3,:) - X2(2,:)./X2(3,:) ;
%   ok{t} = (du.*du + dv.*dv) < 6*6 ;
%   score(t) = sum(ok{t}) ;
% end
% 
% [score, best] = max(score) ;
% H = H{best} ;
% ok = ok{best} ;
% 
% % --------------------------------------------------------------------
% %                                                  Optional refinement
% % --------------------------------------------------------------------
% 
% function err = residual(H)
%  u = H(1) * X1(1,ok) + H(4) * X1(2,ok) + H(7) ;
%  v = H(2) * X1(1,ok) + H(5) * X1(2,ok) + H(8) ;
%  d = H(3) * X1(1,ok) + H(6) * X1(2,ok) + 1 ;
%  du = X2(1,ok) - u ./ d ;
%  dv = X2(2,ok) - v ./ d ;
%  err = sum(du.*du + dv.*dv) ;
% end
% 
% if exist('fminsearch') == 2
%   H = H / H(3,3) ;
%   opts = optimset('Display', 'none', 'TolFun', 1e-8, 'TolX', 1e-8) ;
%   H(1:8) = fminsearch(@residual, H(1:8)', opts) ;
% else
%   warning('Refinement disabled as fminsearch was not found.') ;
% end
% 
% % --------------------------------------------------------------------
% %                                                         Show matches
% % --------------------------------------------------------------------
% 
% dh1 = max(size(im2,1)-size(im1,1),0) ;
% dh2 = max(size(im1,1)-size(im2,1),0) ;
% 
% figure(1) ; clf ;
% subplot(2,1,1) ;
% imagesc([padarray(im1,dh1,'post') padarray(im2,dh2,'post')]) ;
% o = size(im1,2) ;
% line([f1(1,matches(1,:));f2(1,matches(2,:))+o], ...
%      [f1(2,matches(1,:));f2(2,matches(2,:))]) ;
% title(sprintf('%d tentative matches', numMatches)) ;
% axis image off ;
% 
% subplot(2,1,2) ;
% imagesc([padarray(im1,dh1,'post') padarray(im2,dh2,'post')]) ;
% o = size(im1,2) ;
% line([f1(1,matches(1,ok));f2(1,matches(2,ok))+o], ...
%      [f1(2,matches(1,ok));f2(2,matches(2,ok))]) ;
% title(sprintf('%d (%.2f%%) inliner matches out of %d', ...
%               sum(ok), ...
%               100*sum(ok)/numMatches, ...
%               numMatches)) ;
% axis image off ;
% 
% drawnow ;
% 
% end



% I = vl_impattern('roofs1') ;
% image(I) ;
% I = single(rgb2gray(I)) ;
% [f,d] = vl_sift(I) ;
% perm = randperm(size(f,2)) ;
% sel = perm(1:50) ;
% h1 = vl_plotframe(f(:,sel)) ;
% h2 = vl_plotframe(f(:,sel)) ;
% set(h1,'color','k','linewidth',3) ;
% set(h2,'color','y','linewidth',2) ;
% 
% h3 = vl_plotsiftdescriptor(d(:,sel),f(:,sel)) ;
% set(h3,'color','g') ;
% 
% numFeatures = 5000 ;
% dimension = 2 ;
% data = rand(dimension,numFeatures) ;
% 
% numClusters = 30 ;
% [means, covariances, priors] = vl_gmm(data, numClusters);
% 
% numDataToBeEncoded = 1000;
% dataToBeEncoded = rand(dimension,numDataToBeEncoded);
% 
% encoding = vl_fisher(dataToBeEncoded, means, covariances, priors);
% 
% 
% %% Clear variables
% clear all;
% clc;
% 
% %% Parameter setting
% 
% % directory setup
% img_dir = '/media/joan/Elements/Joan-Experiments/Image-Datasets';                  % directory for dataset images
% data_dir =  '/media/joan/Elements/Joan-Experiments/Experiments/New-SparseExperimentsFlickr12k-January2014/UKB/700x700/data'; % '/home/joan/Desktop/ALDICR_SpatialPyramidRepresentation/boureau/data';                  % directory to save the sift features of the chosen dataset
% dataSet = 'ukb';
% 
% % sift descriptor extraction
% skip_cal_sift = false;              % if 'skip_cal_sift' is false, set the following parameter
% skip_sparse_sift = false;
% skip_siftgeo = true;
% gridSpacing = 8;
% patchSize = 16;
% maxImSize = 1024;
% nrml_threshold = 1;                 % low contrast region normalization threshold (descriptor length)
% 
% 
% % Working with .siftgeo files
% is_siftgeo = false;
% 
% rt_img_dir = fullfile(img_dir, dataSet);
% rt_data_dir = fullfile(data_dir, dataSet);
% 
% %% Calculating sift features or retrieving the database directory
% if skip_siftgeo,    
%     if skip_cal_sift,
%         database = retr_database_dir(is_siftgeo, rt_data_dir);
%     else
%         if  skip_sparse_sift,
%             [database] = CalculateSiftDescriptor(rt_img_dir, rt_data_dir, gridSpacing, patchSize, maxImSize, nrml_threshold);
%         else
%             [database] = CalculateSparseSiftDescriptor(rt_img_dir, rt_data_dir, maxImSize, nrml_threshold);
%         end;
%     end;
% else
%     database = retr_database_dir(is_siftgeo, rt_data_dir);
% end;