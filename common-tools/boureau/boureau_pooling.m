function [Pooling]=boureau_pooling(U,locs,pyramid,img_width, img_height,Codewords, pool_method, normFact_pool_method, norm_factor)

k=size(Codewords,2);
idx=findCluster(U,Codewords);
sizeF=size(U,1);


	pLevels = length(pyramid);
	% spatial bins on each level
	pBins = pyramid.^2;
	% total spatial bins
	tBins = sum(pBins);

	Pooling=zeros(sizeF,k*tBins);
	bId=1;
	for iter1 = 1:pLevels,

		nBins = pBins(iter1);

		wUnit = img_width / pyramid(iter1);
		hUnit = img_height / pyramid(iter1);

		% find to which spatial bin each local descriptor belongs
		xBin = ceil(locs(1,:) / wUnit);
		yBin = ceil(locs(2,:) / hUnit);
		idxBin = (yBin - 1)*pyramid(iter1) + xBin;

		for iter2 = 1:nBins,     
			sidxBin = find(idxBin == iter2);
			if isempty(sidxBin)
				bId=bId+1;
				continue;
			end      
			
	 
		   U2=U(:,sidxBin);
		   idx2=idx(sidxBin);
           % configuration space assignment
			for i=1:k
			   id=idx2==i;
			   if(sum(id)==0)
				   bId=bId+1;
				   continue;
			   end
% 	ORGINAL LINE	u = max(U2(:,idx2==i), [], 2); % u = sum(U2(:,idx2==i), 2); u = max(U2(:,idx2==i), [], 2);
               switch pool_method
                   case 'avg'
                       u = mean(U2(:,idx2==i), 2);
                   case 'sum'
                       u = sum(U2(:,idx2==i), 2);
                   case 'max'
                       u = max(U2(:,idx2==i), [], 2);
                   case 'min'
                       u = min(U2(:,idx2==i), [], 2);
               end

               if(sum(u)==0)
				   bId=bId+1;
				   continue;
			   end
			   if(isempty(u))
				   bId=bId+1;
				   continue;
			   end
% 	ORGINAL LINE	Pooling(:,bId)=u; % Pooling(:,bId)=u; u./norm(u,2);
               Pooling(:,bId)=u./norm(u, normFact_pool_method);               
			   bId=bId+1;    
			end
			
			
		end
		
	end


Pooling=Pooling(:);
Pooling=Pooling./norm(Pooling,norm_factor);


end

function [Idx]=findCluster(U,Codewords)

    Idx=zeros(size(U,2),1);
    for i=1:size(U,2)
        dist=10^100;
        id=-1;
        curr=U(:,i);
        for k=1:size(Codewords,2)
            currW=Codewords(:,k);
            
            if(norm(curr-currW)<dist)
               dist=norm(curr-currW);
               id=k;               
            end            
        end
        Idx(i)=id;
    end

end