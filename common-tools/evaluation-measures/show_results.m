% Show the results of the experiments


%% 300x300 Image size

%vectorDim = [ 10752  21504  43008  86016  172032 344064];

x_300_512 = [ 1      2      4      8      16     32];

y_300_512 = [0.5430 0.5391 0.5352 0.5331 0.5234 0.5224]; % For the best result [0.5430]. Now we obtain 0.5312, only taking the first 2 levels of the pyramid. size=2560.

x_300_256 = [ 8      16     32     64];

y_300_256 = [0.5114 0.4990 0.5096 0.5064];


%% 600x600 Image size

x_600_512 = [ 1      32];

y_600_512 = [0.5662 0.5641]; % For the best result [0.5662] size=10752. Now we obtain 0.5306, only taking the first 2 levels of the pyramid. size=2560.


x_600_1024 = [1024];

y_600_1024 = [0.6034];       % For the best result [0.6034] size=21504. Now we obtain 0.5908, only taking the first 2 levels of the pyramid. size=5120.


x_600_2048 = [2048];

y_600_2048 = [0.6209];       % For the best result [0.6209] size=43008. Now we obtain 0.6114, only taking the first 2 levels of the pyramid. size=10240.


x_600_4096 = [4096];         

y_600_4096 = [0.6419];       % For the best result [0.6419] size=86016. Now we obtain 0.6306, only taking the first 2 levels of the pyramid. size=20480.
                             % With PCA analysis after taken the first two
                             % levels of the pyramid: 2-levels->PCA(128) we
                             % obtain mAP = 0.6380

x_600_8192 = [8192];

y_600_8192 = [0.6473];       % For the best result [0.6473] size=43008. Now we obtain 0.6468, only taking the first 2 levels of the pyramid. size=40960.
                             % With PCA analysis after taken the first two
                             % levels of the pyramid: 2-levels->PCA(128) we
                             % obtain mAP = 0.6450

%% 1000x1000 Image size

x_1000 = [ 1024   2048   4096   8192];

y_1000 = [0.5915 0.6266 0.6387 0.6483];

%% Show the ggraphics

figure, 
subplot(1, 3, 1), 
scatter(x_300_512, y_300_512); hold on;
scatter(x_300_256, y_300_256);
legend('C=512', 'C=256', 'Location', 'NorthEast');
xlabel('Pooling dictionary size');
title('Images at max resolution 300x300');

subplot(1, 3, 2),
scatter(x_600_512, y_600_512); hold on;
scatter(x_600_1024, y_600_1024); hold on;
scatter(x_600_2048, y_600_2048); hold on;
scatter(x_600_4096, y_600_4096); hold on;
scatter(x_600_8192, y_600_8192);
legend('C=512', 'C=1024', 'C=2048', 'C=4096', 'C=8192','Location', 'NorthEast');
xlabel('Pooling dictionary size');
title('Images at max resolution 600x600');

subplot(1, 3, 3),
scatter(x_1000, y_1000);
% plot(x_1000_2048, y_1000_2048); hold on;
% plot(x_1000_4096, y_1000_4096);
legend('P=1', 'Location', 'SouthEast');
xlabel('Coding dictionary size');
title('Images at max resolution 1000x1000');



%% 300x300 Image size

%vDim = [ 10752  21504  43008  86016];

x_300 = [ 512 1024   2048   4096];

y_300 = [0.5407 0.5621 0.5645 0.5380];

%% 600x600 Image size

x_600 = [ 512 1024   2048   4096];

y_600 = [0.5841 0.6033 0.6193 0.6382];

%% 1000x1000 Image size

x_1000 = [ 512 1024   2048   4096];

y_1000 = [0.5544 0.5891 0.6261 0.6349];