% U: Quantized features. Column-wise vectors
% Codewords: Visual words dictionary.
function [Pooling]=vwdist_repr_upd(U,locs, Codewords, area, border_filter, height_patches, width_patches)

vw_number = size(Codewords, 2);
locs_number = size(locs, 2);

% Locations in the following format: M(X, Y) access to the position X,Y of
% the matrix M, where the mattrix M is the matrix of the detected features
locsX = locs(2,:);
locsY = locs(1,:);

vwQ1_number = zeros(vw_number, 1);
vwQ2_number = zeros(vw_number, 1);
vwQ3_number = zeros(vw_number, 1);
vwQ4_number = zeros(vw_number, 1);


M_fea = zeros(height_patches, width_patches);
for y=1:width_patches;
    for x=1:height_patches;
        %   M_image(x, y) = 1;
        index = height_patches*(y-1) + x;
        M_fea(x, y) = index;        
    end
end

for y=1:width_patches;
    for x=1:height_patches;
        
        % First quadrant -> upper-left: xi<X and yi<Y
        pos_Q = M_fea(1:x-1, 1:y-1);
        pos_Q = pos_Q(:);
        if not(isempty(pos_Q)),
            if area,
                denominator = length(pos_Q);
            end
            
            temp_bof = sum(U(:, pos_Q), 2);
            if sum(temp_bof)~=0
                temp_bof = temp_bof/sum(temp_bof);
            end;
            vwQ1_number = vwQ1_number + temp_bof/denominator;
        end

        % Second quadrant -> upper-right: xi<X and yi>Y
        pos_Q = M_fea(1:x-1, y+1:end);
        pos_Q = pos_Q(:);
        if not(isempty(pos_Q)),
            if area,
                denominator = length(pos_Q);
            end
            
            temp_bof = sum(U(:, pos_Q), 2);
            if sum(temp_bof)~=0
                temp_bof = temp_bof/sum(temp_bof);
            end;
            vwQ2_number = vwQ2_number + temp_bof/denominator;
        end

        % Third quadrant -> bottom-right: xi>X and yi>Y
        pos_Q = M_fea(x+1:end, y+1:end);
        pos_Q = pos_Q(:);
        if not(isempty(pos_Q)),
            if area,
                denominator = length(pos_Q);
            end
            
            temp_bof = sum(U(:, pos_Q), 2);
            if sum(temp_bof)~=0
                temp_bof = temp_bof/sum(temp_bof);
            end;
            vwQ3_number = vwQ3_number + temp_bof/denominator;
        end

        % Fourth quadrant -> bottom-left: xi>X and yi<Y
        pos_Q = M_fea(x+1:end, 1:y-1);
        pos_Q = pos_Q(:);
        if not(isempty(pos_Q)),
            if area,
                denominator = length(pos_Q);
            end
            
            temp_bof = sum(U(:, pos_Q), 2);
            if sum(temp_bof)~=0
                temp_bof = temp_bof/sum(temp_bof);
            end;
            vwQ4_number = vwQ4_number + temp_bof/denominator;               
        end
    end
end

Pooling = [vwQ1_number vwQ2_number vwQ3_number vwQ4_number];
Pooling = reshape(Pooling',1,[]);

end
