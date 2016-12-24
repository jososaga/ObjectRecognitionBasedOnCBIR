% U: Quantized features. Column-wise vectors
% Codewords: Visual words dictionary.
function [Pooling]=vwdist_repr(U,locs, Codewords, area, border_filter)

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

for j=1:locs_number,
    X = locsX(j);
    Y = locsY(j);

    if border_filter(j)
        denominator = 1;

        % First quadrant -> upper-left: xi<X and yi<Y
        filter_columns = locsX<X & locsY<Y ; % Select the columns of the matrix "locs" that satify the condition, belongs to the specific quadrant
        pos_Q = find(filter_columns > 0);        
        if not(isempty(pos_Q)),
            if area,
                denominator = size(pos_Q, 2);
            end
            
            temp_bof = sum(U(:, pos_Q), 2);
            if sum(temp_bof)~=0
                temp_bof = temp_bof/sum(temp_bof);
            end;
            vwQ1_number = vwQ1_number + temp_bof/denominator;
        end

        % Second quadrant -> upper-right: xi<X and yi>Y
        filter_columns = locsX<X & locsY>Y ; % Select the columns of the matrix "locs" that satify the condition, belongs to the specific quadrant
        pos_Q = find(filter_columns > 0);        
        if not(isempty(pos_Q)),
            if area,
                denominator = size(pos_Q, 2);
            end
            
            temp_bof = sum(U(:, pos_Q), 2);
            if sum(temp_bof)~=0
                temp_bof = temp_bof/sum(temp_bof);
            end;
            vwQ2_number = vwQ2_number + temp_bof/denominator;
        end

        % Third quadrant -> bottom-right: xi>X and yi>Y
        filter_columns = locsX>X & locsY>Y ; % Select the columns of the matrix "locs" that satify the condition, belongs to the specific quadrant
        pos_Q = find(filter_columns > 0);        
        if not(isempty(pos_Q)),
            if area,
                denominator = size(pos_Q, 2);
            end
            
            temp_bof = sum(U(:, pos_Q), 2);
            if sum(temp_bof)~=0
                temp_bof = temp_bof/sum(temp_bof);
            end;
            vwQ3_number = vwQ3_number + temp_bof/denominator;
        end

        % Fourth quadrant -> bottom-left: xi>X and yi<Y
        filter_columns = locsX>X & locsY<Y ; % Select the columns of the matrix "locs" that satify the condition, belongs to the specific quadrant
        pos_Q = find(filter_columns > 0);        
        if not(isempty(pos_Q)),
            if area,
                denominator = size(pos_Q, 2);
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
