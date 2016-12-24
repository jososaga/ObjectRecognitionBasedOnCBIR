% This function writes the parameters to a gmm file
% 
% Usage: gmm_write (filename)
function [] = gmm_write (w, mu, sigma, filename)

% open the file
fid = fopen (filename, 'wb');
 
if fid == -1
  error ('I/O error : Unable to open the file %s\n', filename)
end

d = size(mu, 1);
k = size(mu, 2);

% first write the vector size and the number of centroids
count = fwrite (fid, d, 'int');
if count ~= 1 
    error ('Unable to write vector dimension: count!=1 \n');
end
count = fwrite (fid, k, 'int');
if count ~= 1 
    error ('Unable to write count of vectors: count!=1 \n');
end


% write the elements
count = fwrite (fid, w, 'float=>single');
if count ~= k 
    error ('Unable to write w vectors: count!=k \n');
end
count = fwrite (fid, mu(:), 'float=>single');
if count ~= d*k 
    error ('Unable to write mu vectors: count!=d*k \n');
end
count = fwrite (fid, sigma(:), 'float=>single');
if count ~= d*k 
    error ('Unable to write sigma vectors: count!=d*k \n');
end

fclose (fid);
