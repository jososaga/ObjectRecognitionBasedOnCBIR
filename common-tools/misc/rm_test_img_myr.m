clear all;
clc;



%% Parameters--------------------------------------------------------------
dir_results = '';
dir_jpg = '/media/joan/Elements/Joan-Experiments/Image-Datasets/holidays/holidays';
dir_sift = './siftgeo/';
path_image_vectors = '/media/joan/Elements/Joan-Experiments/Experiments/Densely-Oxford-TrainedOnParis/600/dictionaries-MyR-Area/4096/IR_oxford_16384.fvecs'; 
num_ranked_images = 5062;
skip_load_sift = true;

%% Load data---------------------------------------------------------------
%% Firenze
% [database, sift, gnd, qidx] = load_firenze (dir_jpg, dir_sift, skip_load_sift);
% v = fvecs_read (path_image_vectors);

%% Holidays
% [imlist, sift, gnd, qidx, database] = load_holidays (dir_sift, dir_jpg);
% v = fvecs_read (path_image_vectors);

%% Oxford
dir_jpg_oxford = '/media/joan/Elements/Joan-Experiments/Image-Datasets/oxford/oxford/';
dir_evaluation_oxford = '/media/joan/Elements/Joan-Experiments/Image-Datasets/oxford/evaluation/gt/';
[imlist, gnd, gnd_junk, qidx] = load_oxford(dir_jpg_oxford, dir_evaluation_oxford);
v = fvecs_read (path_image_vectors);

%% UKB
% dir_ukb = '/media/joan/Elements/Joan-Experiments/Image-Datasets/ukb/';
% [imlist, gnd, qidx] = load_ukb (dir_ukb);
% v = fvecs_read (path_image_vectors);

%% PCA
% 4-normalization
for j=1:size(v,2),
    vector = v(:,j);
    for i=1:4:size(vector,1),
        if(sum(vector(i:i+3))~=0),
            v(i:i+3, j) = vector(i:i+3)/norm(vector(i:i+3));
        end
    end
end
% VW-representation per quadrant
for j=1:size(v,2),
    v_temp = v(:, j)';
    v1 = v_temp(1:4:end);
    v1 = v1/norm(v1);
    v2 = v_temp(2:4:end);
    v2 = v2/norm(v2);
    v3 = v_temp(3:4:end);
    v3 = v3/norm(v3);
    v4 = v_temp(4:4:end);
    v4 = v4/norm(v4);
    v_temp = [v1 v2 v3 v4];
    v(:, j) = v_temp;
end
v = yael_fvecs_normalize (v);
% v = v';
% v = v - min(v(:));
% v = v / max(v(:));
% [vv, mapping] = compute_mapping(v, 'PCA', 128);
% 
% v = single(vv');
% v = yael_fvecs_normalize (v);
[idx, dis] = yael_nn (v, v(:,qidx), num_ranked_images);
% idx_first_row = idx (1,:);
% idx = idx (2:end,:);  
% mAP = compute_results(idx, gnd);
mAP = compute_map_oxford(idx, gnd, gnd_junk, imlist);

% 
% load('/media/joan/Elements/Joan-Experiments/Image-Datasets/flickr12k/Experiments-PCA/dictionaries1/4096/MyR-Area/min_mapping_4096_5000.mat');
% load('/media/joan/Elements/Joan-Experiments/Image-Datasets/flickr12k/Experiments-PCA/dictionaries1/4096/MyR-Area/max_mapping_4096_5000.mat');
% v = v - min_mapping;
% v = v / max_mapping;
% 
% % v = v - min(v(:));
% % v = v / max(v(:));
% load('/media/joan/Elements/Joan-Experiments/Image-Datasets/flickr12k/Experiments-PCA/dictionaries1/4096/MyR-Area/mapping_4096_5000.mat');
% v = single(out_of_sample(v, mapping))';
% v = yael_fvecs_normalize (v);
% [idx, dis] = yael_nn (v, v(:,qidx), num_ranked_images);
% idx_first_row = idx (1,:);
% idx = idx (2:end,:);  
% mAP = compute_results(idx, gnd);
% mAP = compute_results_ukb(idx, gnd);
a=10;


%% % 4-normalization
% for j=1:size(v,2),
%     vector = v(:,j);
%     for i=1:4:size(vector,1),
%         if(sum(vector(i:i+3))~=0),
%             v(i:i+3, j) = vector(i:i+3)/norm(vector(i:i+3));
%         end
%     end
% end
% 
% %% VW-representation per quadrant
% for j=1:size(v,2),
%     v_temp = v(:, j)';
%     v1 = v_temp(1:4:end);
%     v1 = v1/norm(v1);
%     v2 = v_temp(2:4:end);
%     v2 = v2/norm(v2);
%     v3 = v_temp(3:4:end);
%     v3 = v3/norm(v3);
%     v4 = v_temp(4:4:end);
%     v4 = v4/norm(v4);
%     v_temp = [v1 v2 v3 v4];
%     v(:, j) = v_temp;
% end


%% VLAD Representation-----------------------------------------------------
% dir_data = './data/';
% dir_coding_dictionary=[dir_data 'clust_k64.fvecs']; 
% % % 
% codingDictionary = fvecs_read (dir_coding_dictionary);
% % % load(dir_coding_dictionary);
% % % v = fvecs_read (path_image_vectors);
% v = compute_vlad (codingDictionary, sift);
% v = sign(v).*abs(v).^(0.2);

%% Normalize vectors and compute image ranking-----------------------------
% v = [vlad' v']';
% v = yael_fvecs_normalize (v);
% [idx, dis] = my_nn (v, v(:,qidx), num_ranked_images, sqrt(2)/4);

% v = sign(v).*abs(v).^(0.8);
v = yael_fvecs_normalize (v);
[idx, dis] = yael_nn (v, v(:,qidx), num_ranked_images);

%% remove
% idx_first_row = idx (1,:);
% idx = idx (2:end,:);  
% mAP = compute_results(idx, gnd);
% 
% p_k = [2 4 6 8 10 12];
% p_k_results = [];
% str_p_k_results = [];
% for i=1:length(p_k),
%     new_value = compute_average_Precision_k(idx, gnd, p_k(i));
%     p_k_results = [p_k_results new_value];
%     t_s = sprintf ('P@%d = %.3f; ', p_k(i), new_value);
%     str_p_k_results = [ str_p_k_results t_s];
% end

% mAP = compute_map_oxford(idx, gnd, gnd_junk, imlist);
% MyR - Paris     -2048 - 0.2994
% MyR - Flickr12k -2048 - 0.2890
% MyR - Paris     -4096 - 0.
% MyR - Flickr12k -4096 - 0.3375


%% My image ranking--------------------------------------------------------
% v = yael_fvecs_normalize (v);
% [idx, dis] = yael_nn (v, v(:,qidx), num_ranked_images);

%% Visualize results-------------------------------------------------------
% results_count = 5;
% for r=1:size(idx,2),
%     h = figure; 
%     for c=1:results_count
%         % Search results
%         subplot(2, results_count, c);
%         img_name = imlist(idx(c, r));
%         X1=imread(strcat(dir_jpg_oxford, img_name{1}, '.jpg'));
%         subimage(X1);
%         if c==1,
%             title(sprintf ('mAP = %.4f - Distance = %.4f\n', mAP, dis(c,r)));
%         else 
%             title(sprintf ('Ranking - Dist = %.4f\n', dis(c,r)));
%         end
%         
%         % Ground truth results
%         if c <= length(gnd{r}), 
%             subplot(2, results_count, c + results_count);
%             img_name = gnd{r}(c);
%             X1=imread(strcat(dir_jpg_oxford, img_name{1}, '.jpg'));
%             subimage(X1);
%             title(sprintf ('Ground truth: %d\n', c));
%         end
%     end
%     file_prefix = ['VLAD' int2str(64) '-'];
%     file_name = [file_prefix 'Q' int2str(r)];
%     file_path = fullfile(dir_results, file_name);
%     %saveas(h,file_path,'fig');
%     saveas(h,file_path,'jpg');
%     close(h);
% end

%% Compute measures on the image ranking-----------------------------------



%% 2.-mAP-(Mean Average Precision)
idx_first_row = idx (1,:);
idx = idx (2:end,:);  
mAP = compute_results(idx, gnd);
str_mAP = sprintf ('mAP = %.3f; ', mAP);

%% 1.-P@K-(Precision for the top K ranked images)
p_k = [2 4 6 8 10 12 14];
p_k_results = [];
str_p_k_results = [];
for i=1:length(p_k),
    new_value = compute_average_Precision_k(idx, gnd, p_k(i));
    p_k_results = [p_k_results new_value];
    t_s = sprintf ('P@%d = %.3f; ', p_k(i), new_value);
    str_p_k_results = [ str_p_k_results t_s];
end

%% 1.-Rth Precision-(Precision at R-th position in the ranking, for a query that have R relevant images)
average_Rth_p = compute_average_Rth_Precision(idx, gnd);
str_average_Rth_p = sprintf ('Rth Precision = %.3f; ', average_Rth_p);
idx = [idx_first_row; idx];

fName = 'MyR-Avg-output.txt';         %# A file name
file_path = fullfile(dir_results, fName);
fid = fopen(fName,'w');            %# Open the file
if fid ~= -1
  str = [ str_mAP  str_p_k_results  str_average_Rth_p];
  fprintf(fid,'%s\r\n',str);       %# Print the string
  fclose(fid);                     %# Close the file
end

%% Show the results--------------------------------------------------------
file_prefix = ['Avg-' int2str(4096) '-'];
for jj=1:size(idx,2),
    h = figure; 
    %----------1 row-------------------------
    subplot(1, 5, 1);
    X1=imread(database.path{idx(1, jj)});
    subimage(X1);
    title(sprintf ('mAP = %.4f - Rth_P = %.4f - Distance = %.4f\n', mAP, average_Rth_p, dis(1,jj)));

    subplot(1, 5, 2);
    X1=imread(database.path{idx(2, jj)});
    subimage(X1);
    title(sprintf ('Distance = %.4f\n', dis(2,jj)));

    subplot(1, 5, 3);
    X1=imread(database.path{idx(3, jj)});
    subimage(X1);
    title(sprintf ('Distance = %.4f\n', dis(3,jj)));

    subplot(1, 5, 4);
    X1=imread(database.path{idx(4, jj)});
    subimage(X1);
    title(sprintf ('Distance = %.4f\n', dis(4,jj)));
    
    subplot(1, 5, 5);
    X1=imread(database.path{idx(5, jj)});
    subimage(X1);
    title(sprintf ('Distance = %.4f\n', dis(5,jj)));
    
    
    file_name = [file_prefix 'Q' int2str(jj)];
    file_path = fullfile(dir_results, file_name);
    %saveas(h,file_path,'fig');
    saveas(h,file_path,'jpg');
    close(h);

end

aa=1;

%% Comments----------------------------------------------------------------

%     subplot(3, 5, 6);
%     X1=imread(database.path{idx(6, jj)});
%     subimage(X1);
%     title(sprintf ('Distance = %.4f\n', dis(6)));
% 
%     %----------2 row-------------------------
%     subplot(3, 5, 7);
%     X1=imread(database.path{idx(7, jj)});
%     subimage(X1);
%     title(sprintf ('Distance = %.4f\n', dis(7)));
% 
%     subplot(3, 5, 8);
%     X1=imread(database.path{idx(8, jj)});
%     subimage(X1);
%     title(sprintf ('Distance = %.4f\n', dis(8)));
% 
%     subplot(3, 5, 9);
%     X1=imread(database.path{idx(9, jj)});
%     subimage(X1);
%     title(sprintf ('Distance = %.4f\n', dis(9)));
% 
%     subplot(3, 5, 10);
%     X1=imread(database.path{idx(10, jj)});
%     subimage(X1);
%     title(sprintf ('Distance = %.4f\n', dis(10)));
% 
%     %----------3 row-------------------------
%     subplot(3, 5, 11);
%     X1=imread(database.path{idx(11, jj)});
%     subimage(X1);
%     title(sprintf ('Distance = %.4f\n', dis(11)));
%     
%     subplot(3, 5, 12);
%     X1=imread(database.path{idx(12, jj)});
%     subimage(X1);
%     title(sprintf ('Distance = %.4f\n', dis(12)));
%     
%     subplot(3, 5, 13);
%     X1=imread(database.path{idx(13, jj)});
%     subimage(X1);
%     title(sprintf ('Distance = %.4f\n', dis(13)));
%     
%     subplot(3, 5, 14);
%     X1=imread(database.path{idx(14, jj)});
%     subimage(X1);
%     title(sprintf ('Distance = %.4f\n', dis(14)));
% 
%     subplot(3, 5, 15);
%     X1=imread(database.path{idx(15, jj)});
%     subimage(X1);
%     title(sprintf ('Distance = %.4f\n', dis(15)));



