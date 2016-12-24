function [feaSet] = CalculateSparseSiftDescriptorOneImage(imgpath, maxImSize, nrml_threshold)
    [I, map1] = imread(imgpath);
    
    if ndims(I) == 3,
        I = single(rgb2gray(I));
    else
        I = single(I);
    end;

    [im_h, im_w] = size(I);

    if max(im_h, im_w) > maxImSize,
        I = imresize(I, maxImSize/max(im_h, im_w), 'bicubic');
        [im_h, im_w] = size(I);
    end;

    fprintf('Processing %s: wid %d, hgt %d\n', ...
                     imgpath, im_w, im_h);

    % find SIFT descriptors
    [f, d] = vl_sift(I); 
    %[siftArr, siftlen] = sp_normalize_sift(double(d)', nrml_threshold);
    siftArr = double(d)'; % Borrar remove eliminar

    feaSet.feaArr = siftArr';
    feaSet.x = double(f(1, :)');
    feaSet.y = double(f(2, :)');
    feaSet.width = im_w;
    feaSet.height = im_h;