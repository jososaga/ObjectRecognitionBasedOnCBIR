clear all;
close all;

experiments{1}.dataset = 'banknotes';
experiments{1}.method = 'bof';
experiments{1}.nBases = 10000;

% experiments{2}.dataset = 'cereal';
% experiments{2}.method = 'bofxq';
% experiments{2}.nBases = 5000;
% 
% experiments{3}.dataset = 'cereal';
% experiments{3}.method = 'vlad';
% experiments{3}.nBases = 300;
% 
% experiments{4}.dataset = 'cereal';
% experiments{4}.method = 'fisher';
% experiments{4}.nBases = 150;
% 
% experiments{5}.dataset = 'cereal';
% experiments{5}.method = 'spm';
% experiments{5}.nBases = 1000;

output = {};

for ee=1:length(experiments)
    %% Parameters
    folder_path = 'D:\Dropbox\Unige-Research\1-Object Recognition Demo App\Demo-code\ObjectRecognitionFramework_1.2\object-tree\Currencies\Euro\';
    tempDataset = 'simplebanknotes';
    dictionaryPath = [folder_path 'dictionaries\clust_' tempDataset '_k' int2str(experiments{ee}.nBases) '.fvecs'];
    dimensions = 64;
    gmmPath = [folder_path 'gmm\'];
    nConfigSpace = 1;
    encoding_method = 'hard';
    idf_path = [folder_path 'IDF_' tempDataset '_10000.fvecs'];
    %% Loading IDF training
    IDF_training = fvecs_read  (idf_path);
    %% Loading Dictionaries
    codingDictionary = fvecs_read(dictionaryPath);
    %% Setting descriptor dimension
    dimFea = 0;
    switch experiments{ee}.method
        case 'bofxq'
            dimFea = experiments{ee}.nBases*4;
        case 'vlad'
            dimFea = experiments{ee}.nBases*dimensions;
        case 'fisher'
            load([gmmPath 'means_' tempDataset '_k' int2str(experiments{ee}.nBases) '.mat']);
            load([gmmPath 'covariances_' tempDataset '_k' int2str(experiments{ee}.nBases) '.mat']);
            load([gmmPath 'priors_' tempDataset '_k' int2str(experiments{ee}.nBases) '.mat']);
            dimFea = experiments{ee}.nBases*dimensions*2;
        case 'bof'
            wIDF = zeros(1, experiments{ee}.nBases, 'single');
            dimFea = experiments{ee}.nBases;
        case 'spm'
            pyramid = [1, 2, 4];
            dimFea = sum((experiments{ee}.nBases)*(nConfigSpace)*pyramid.^2);
    end;
    % query_vector = zeros(dimFea, 1, 'single');
    % Reference dataset
    load([folder_path 'classes_reference.mat']);
    load([folder_path, 'reference_norm_', experiments{ee}.method, '_', num2str(dimFea), '.mat']);
    num_ranked_images = 7;

    % Compute Image Vectors
    img_folder = [folder_path 'output\TEMP_GLASSENSE\'];
    siftfname = struct2cell(dir(fullfile(img_folder, '*.jpg'))); % struct2cell(dir(fullfile(img_folder, '*.jpg')));
    siftfname = siftfname(1, :);
    nimg = size (siftfname, 2);
    im_descriptors = zeros(dimFea, nimg, 'single');
    query_vector = zeros(dimFea, 1, 'single');
    real_class = zeros(1, nimg);
    predicted_class = zeros(1, nimg);
    correct_prediction = zeros(1, nimg);
    min_distances = zeros(1, nimg);
    number_false_image = 163;
    for i=1:nimg
        img_path = fullfile(img_folder, siftfname{i});
        IM = imread(img_path);
        real_class(i) = str2num(siftfname{i}(4:end-4));

        % Extracting SURF features from current frame
        [im_h, im_w] = size(IM);
        points = detectSURFFeatures(IM);
        [features, valid_points] = extractFeatures(IM, points);
        imageFeatures = features';
        locs = [double(valid_points.Location(:, 1)) double(valid_points.Location(:, 2))]';%double(valid_points.Location(:, 1:2))';
        %% Computing Image Descriptor
        if ~isempty(imageFeatures)
            switch encoding_method
                case 'hard'
                    [idx, dis] = yael_nn (single(codingDictionary), single(imageFeatures), 1); %LLC_coding_appr(codingDictionary', imageFeatures',knn)';
                    coordI = [1:size(imageFeatures, 2)];
                    coordJ = double(idx);
                    values = ones(1, size(imageFeatures, 2), 'double');
                    codes = sparse(coordI, coordJ, values, size(imageFeatures, 2), size(codingDictionary, 2));
            end

            %% Computing image descriptor of the current image with corresponding method
            switch experiments{ee}.method
                case 'bofxq'
                    border_filter = zeros(1, size(locs,2)) + 1;
                    area = true;
                    query_vector(:, 1) = vwdist_repr(codes', locs, codingDictionary, area, border_filter); % vwdist_repr(codes', locs, codingDictionary, area, border_filter); % vwdist_repr_upd(codes', locs, codingDictionary, area, border_filter, feaSet.height_patches, feaSet.width_patches);
                case 'vlad'
                    query_vector(:, 1) = vl_vlad(double(imageFeatures), double(codingDictionary), full(codes'));
                case 'fisher'
                    query_vector(:, 1) = vl_fisher(imageFeatures, means, covariances, priors);
                case 'bof'
                    query_vector(:, 1) = full(sum(codes));
                    if sum(query_vector)~=0
                        query_vector = query_vector/sum(query_vector);
                    end;
                case 'spm'
                    poolingDictionary = ones(experiments{ee}.nBases, 1);
                    pool_method = 'sum';
                    normFact_pool_method = 2;
                    norm_factor = 2;
                    query_vector(:, 1) = boureau_pooling(codes', locs, pyramid, im_w, im_h, poolingDictionary, pool_method, normFact_pool_method, norm_factor); % boureau_pooling(codes', locs, pyramid, im_w, im_h, poolingDictionary, 2);
            end;            
        end;

        %% Postprocessing analysis in case is needed
        switch experiments{ee}.method
            case 'bof'
                query_vector(:, 1) = (query_vector(:, 1)).*(IDF_training');
        end;

        %% Compute Ranking
        query_vector_norm = sign(query_vector).*abs(query_vector).^(0.1);
        query_vector_norm = yael_vecs_normalize(query_vector_norm);
        [ranking, dis] = yael_nn (reference_norm, query_vector_norm, num_ranked_images, 2); % yael_nn (vn, -vn(:,qidx), num_ranked_images, 16);

        training_class_array = zeros(1, num_ranked_images);
        for j=1:num_ranked_images
            training_index = ranking(j, 1);
            training_class = classes_reference{training_index}.class;
            training_class_array(j) = training_class;
        end
        majoritary_class = mode(training_class_array);

        % Final computation
        min_dis = dis(num_ranked_images);
        if isnan(min_dis)
            min_dis = intmax;
        end
        min_distances(i) = min_dis;
        predicted_class(i) = majoritary_class;
        correct_prediction(i) = majoritary_class == real_class(i);
        
        %% Only for Banknotes
        if strcmp(experiments{ee}.dataset, 'banknotes')
            if (majoritary_class == 11 || majoritary_class == 12) && (real_class(i) == 11 || real_class(i) == 12)
                correct_prediction(i) = 1;
            end
            if (majoritary_class == 13 || majoritary_class == 15) && (real_class(i) == 13 || real_class(i) == 15)
                correct_prediction(i) = 1;
            end
        end
        
        im_descriptors(:, i) = query_vector(:, 1);
    end
    accuracy = (sum(correct_prediction(number_false_image+1:end))/(length(correct_prediction)-number_false_image))*100;
    output{ee}.accuracy = accuracy;
    
    % Compute ROC curve parameters
    min_dis = [1.5:0.01:2];
    vpr_y = [];
    fpr_x = [];
    acc_all = [];
    for i=1:size(min_dis, 2)
        min_distances_temp = min_distances < min_dis(i);
        vp = sum(min_distances_temp(number_false_image+1:end));
        fn = sum(min_distances_temp(number_false_image+1:end)==0); 
        fp = sum(min_distances_temp(1:number_false_image));
        vn = sum(min_distances_temp(1:number_false_image)==0);

        vpr = vp/(vp+fn);
        fpr = fp/(fp+vn);
        vpr_y = [vpr_y vpr];
        fpr_x = [fpr_x fpr];

        acc = (vp+vn)/nimg;
        acc_all = [acc_all acc];
    end
    output{ee}.vpr_y = vpr_y;
    output{ee}.fpr_x = fpr_x;
    output{ee}.acc_all = acc_all;
    [maxacc, idxacc] = max(acc_all);
    output{ee}.maxacc_idx = [maxacc, idxacc];
    output{ee}.min_dis = min_dis;
end

co = [0 0 1;
      0 0.5 0;
      1 0 0;
      0 0.75 0.75;
      0.75 0 0.75;
      0.75 0.75 0;
      0.25 0.25 0.25];
set(groot,'defaultAxesColorOrder', co);

symbols = {'d-', 'o-', 's-', '*-', '.-', 'x-'};  
func_names = {'BoF (D=10k)', 'MBoFQ (D=20k)', 'VLAD (D=20k)', 'Fisher (D=20k)', 'SPM (D=20k)'};

h1=figure(1);
clf;   
hold all;
for i=1:length(output)
    figure(1);
    plot(output{i}.fpr_x, output{i}.vpr_y, symbols{i}, 'DisplayName', [func_names{i}, ' acc=', sprintf('%0.1f', output{i}.accuracy)]);%[func_names{i}, ' acc=', sprintf('%0.1f', output{i}.accuracy)]); func_names{i});
end

figure(1);     
hleyend = legend('show');
set(hleyend,'Location','South','Interpreter','latex','FontName','Times','FontSize',9);
box on;
grid on;

set(gca,'XGrid','on');
set(gca,'YGrid','on');
set(gca,...
    'Units','normalized',...
    'FontUnits','points',...
    'FontWeight','normal',...
    'FontSize',16,...
    'FontName','Times');
xlabel('False positive rate (FPR)',...
    'FontUnits','points',...
    'FontWeight','normal',...
    'FontSize',18,...
    'FontName','Times');
ylabel('True positive rate (TPR)',...    
    'FontUnits','points',...
    'FontWeight','normal',...
    'FontSize',18,...
    'FontName','Times');     
axis square; 
title('Cans');
% saveas(h1,fullfile(img_folder, 'threshold_selection_max.fig'),'fig');
% print(h1,'-depsc2',fullfile(img_folder, 'threshold_selection_max.eps'));