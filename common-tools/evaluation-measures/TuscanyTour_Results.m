%% -------------------------------------------------------------------------
% ******************************Full Size Vectors**************************
% -------------------------------------------------------------------------
%% ********************* Holidays *****************************************

% TuscanyTour (Flickr12k): No-Dimensionality reduction (Full size vectors),
% Co-missing visual words. Full vectors were built using the training 
% dataset Flickr12k. Learning meanV_before vector on the
% learning phase, using the dataset Flickr12k
% Area-4096 (16384) -> 
%             alpha = 0    mAP: 0.5439
%             alpha = 0.1  mAP: 0.5459
%             alpha = 0.2  mAP: 0.5462
%             alpha = 0.3  mAP: 0.5475
%             alpha = 0.4  mAP: 0.5429
%             alpha = 0.5  mAP: 0.5402
%             alpha = 0.6  mAP: 0.5281
%             alpha = 0.7  mAP: 0.5153
%             alpha = 0.8  mAP: 0.4998
%             alpha = 0.9  mAP: 0.4852
%             alpha = 1.0  mAP: 0.4650
%             alpha = 1.2  mAP: 0.4335
% Area-2048 (8192) -> 
%             alpha = 0    mAP: 0.3984
%             alpha = 0.1  mAP: 0.4064
%             alpha = 0.2  mAP: 0.4180
%             alpha = 0.3  mAP: 0.4225
%             alpha = 0.4  mAP: 0.4301
%             alpha = 0.5  mAP: 0.4338
%             alpha = 0.6  mAP: 0.4369
%             alpha = 0.7  mAP: 0.4329
%             alpha = 0.8  mAP: 0.4260
%             alpha = 0.9  mAP: 0.4150
%             alpha = 1.0  mAP: 0.4024
%             alpha = 1.2  mAP: 0.3740
%-------------------------------------
% BoF-4096 (16384) -> 
%             alpha = 0    mAP: 0.5489
%             alpha = 0.1  mAP: 0.5527
%             alpha = 0.2  mAP: 0.5535
%             alpha = 0.3  mAP: 0.5563
%             alpha = 0.4  mAP: 0.5570
%             alpha = 0.5  mAP: 0.5502
%             alpha = 0.6  mAP: 0.5414
%             alpha = 0.7  mAP: 0.5341
%             alpha = 0.8  mAP: 0.5260
%             alpha = 0.9  mAP: 0.5061
%             alpha = 1    mAP: 0.4908
%             alpha = 1.2  mAP: 0.4590
% BoF-2048 (8192) -> 
%             alpha = 0    mAP: 0.4102
%             alpha = 0.1  mAP: 0.4169
%             alpha = 0.2  mAP: 0.4261
%             alpha = 0.3  mAP: 0.4369
%             alpha = 0.4  mAP: 0.4457
%             alpha = 0.5  mAP: 0.4480
%             alpha = 0.6  mAP: 0.4493
%             alpha = 0.7  mAP: 0.4463
%             alpha = 0.8  mAP: 0.4428
%             alpha = 0.9  mAP: 0.4212
%             alpha = 1    mAP: 0.4101
%             alpha = 1.2  mAP: 0.3866
%-------------------------------------
% VLAD-128 (16384) ->      
%             alpha = 0    mAP: 0.5463
%             alpha = 0.1  mAP: 0.5460
%             alpha = 0.2  mAP: 0.5460
%             alpha = 0.3  mAP: 0.5460
%             alpha = 0.4  mAP: 0.5462
%             alpha = 0.5  mAP: 0.5458
%             alpha = 0.6  mAP: 0.5442
%             alpha = 0.7  mAP: 0.5447
%             alpha = 0.8  mAP: 0.5448
%             alpha = 0.9  mAP: 0.5453
%             alpha = 1    mAP: 0.5459
%             alpha = 1.2  mAP: 0.5459
% VLAD-64 (8192) ->      
%             alpha = 0    mAP: 0.4490
%             alpha = 0.1  mAP: 0.4495
%             alpha = 0.2  mAP: 0.4491
%             alpha = 0.3  mAP: 0.4492
%             alpha = 0.4  mAP: 0.4483
%             alpha = 0.5  mAP: 0.4478
%             alpha = 0.6  mAP: 0.4477
%             alpha = 0.7  mAP: 0.4465
%             alpha = 0.8  mAP: 0.4463
%             alpha = 0.9  mAP: 0.4464
%             alpha = 1    mAP: 0.4463
%             alpha = 1.2  mAP: 0.4422

%% -------------------------------------------------------------------------
% ******************************Short Size Vectors**************************
% -------------------------------------------------------------------------

% TuscanyTour (Flickr12k): Dimensionality reduction (PCA and Whitening). 
% Full vectors were built using the training dataset Flickr12k. Learning 
% PCA and Whitening vectors on the learning phase, using the dataset 
% Flickr12k. Dimension = 128.
%
% Area -4096 -> mAP = 0.2362
% Area -2048 -> mAP = 0.
%-------------------------------------
% BoF  -4096 -> mAP = 0.2396, 2514
% BoF  -2048 -> mAP = 0.
%-------------------------------------
% VLAD -4096 -> mAP = 0.4573
% VLAD -2048 -> mAP = 0.3748

% TuscanyTour (Flickr12k to build and TuscanyTour to reduction): Dimensionality reduction (PCA). 
% Full vectors were built using the training dataset Flickr12k. Learning 
% PCA on the learning phase, using the same dataset 
% TuscanyTour. Dimension = 128.
%
% Area -4096 -> mAP = 0.4909
% Area -2048 -> mAP = 0.
%-------------------------------------
% BoF  -4096 -> mAP = 0.4745
% BoF  -2048 -> mAP = 0.
%-------------------------------------
% VLAD -4096 -> mAP = 0.5539
% VLAD -2048 -> mAP = 0.


%% Show the Results


