% make single source illuminated sample into multiplexed
% extract features and sort features into [RGBI]

% preallocating feature array
Feat_real_ga = zeros(NPose,FeatSize*NColor*N+1);
Feat_fake_ga = zeros(NPose,FeatSize*NColor*N+1); 
Feat_real_ra = zeros(NPose,FeatSize*NColor*N+1);
Feat_fake_ra = zeros(NPose,FeatSize*NColor*N+1);
Feat_real_gg = zeros(NPose,FeatSize*NColor*N+1);
Feat_fake_gg = zeros(NPose,FeatSize*NColor*N+1);
Feat_real_bn = zeros(NPose,FeatSize*NColor*N+1);
Feat_fake_bn = zeros(NPose,FeatSize*NColor*N+1);
Feat_real_or = zeros(NPose,FeatSize*NColor*N+1);
Feat_fake_or = zeros(NPose,FeatSize*NColor*N+1);

for c_i = 0:NColor-1 % 4 colors
    for p_i = 0:NPose-1 % pose   
        
        % ========Green apple===========
        % real fruit
        ImSIN = raw_real_ga(:,:,NMsnt*(p_i+NPose*c_i)+1:NMsnt*(p_i+NPose*c_i+1));
        ImVect = reshape(ImSIN,ImSize*ImSize,NMsnt)*Dimmer;
        ImMUX = double(ImVect)*snrmat;
        ImMUX_r = reshape(ImMUX,ImSize,ImSize,[]);
        % fake fruit
        ImSIN = raw_fake_ga(:,:,NMsnt*(p_i+NPose*c_i)+1:NMsnt*(p_i+NPose*c_i+1));
        ImVect = reshape(ImSIN,ImSize*ImSize,NMsnt)*Dimmer;
        ImMUX = double(ImVect)*snrmat;
        ImMUX_f = reshape(ImMUX,ImSize,ImSize,[]);

        % resize image -> add artificial noise -> extract feature 
        for l_i = 1:N
            SmallIm = imresize(addnoise(ImMUX_r(:,:,l_i),'g',Gain),[SmallImSize,SmallImSize]);
            [Feat,~] = extractHOGFeatures(SmallIm,'Cellsize',[CellSize,CellSize],'BlockSize',[BlkSize,BlkSize]);
            Feat_real_ga(p_i+1,FeatSize*(c_i*N+l_i-1)+1:FeatSize*(c_i*N+l_i)) = Feat;

            SmallIm = imresize(addnoise(ImMUX_f(:,:,l_i),'g',Gain),[SmallImSize,SmallImSize]);
            [Feat,~] = extractHOGFeatures(SmallIm,'Cellsize',[CellSize,CellSize],'BlockSize',[BlkSize,BlkSize]);
            Feat_fake_ga(p_i+1,FeatSize*(c_i*N+l_i-1)+1:FeatSize*(c_i*N+l_i)) = Feat;
        end
        
        % ========Red apple===========
        ImSIN = raw_real_ra(:,:,NMsnt*(p_i+NPose*c_i)+1:NMsnt*(p_i+NPose*c_i+1));
        ImVect = reshape(ImSIN,ImSize*ImSize,NMsnt)*Dimmer;
        ImMUX = double(ImVect)*snrmat;
        ImMUX_r = reshape(ImMUX,ImSize,ImSize,[]);

        ImSIN = raw_fake_ra(:,:,NMsnt*(p_i+NPose*c_i)+1:NMsnt*(p_i+NPose*c_i+1));
        ImVect = reshape(ImSIN,ImSize*ImSize,NMsnt)*Dimmer;
        ImMUX = double(ImVect)*snrmat;
        ImMUX_f = reshape(ImMUX,ImSize,ImSize,[]);
        
        for l_i = 1:N
            SmallIm = imresize(addnoise(ImMUX_r(:,:,l_i),'g',Gain),[SmallImSize,SmallImSize]);
            [Feat,~] = extractHOGFeatures(SmallIm,'Cellsize',[CellSize,CellSize],'BlockSize',[BlkSize,BlkSize]);
            Feat_real_ra(p_i+1,FeatSize*(c_i*N+l_i-1)+1:FeatSize*(c_i*N+l_i)) = Feat;

            SmallIm = imresize(addnoise(ImMUX_f(:,:,l_i),'g',Gain),[SmallImSize,SmallImSize]);
            [Feat,~] = extractHOGFeatures(SmallIm,'Cellsize',[CellSize,CellSize],'BlockSize',[BlkSize,BlkSize]);
            Feat_fake_ra(p_i+1,FeatSize*(c_i*N+l_i-1)+1:FeatSize*(c_i*N+l_i)) = Feat;
        end  
        
        % ========Green grape===========
        ImSIN = raw_real_gg(:,:,NMsnt*(p_i+NPose*c_i)+1:NMsnt*(p_i+NPose*c_i+1)); %
        ImVect = reshape(ImSIN,ImSize*ImSize,NMsnt)*Dimmer;
        ImMUX = double(ImVect)*snrmat;
        ImMUX_r = reshape(ImMUX,ImSize,ImSize,[]);

        ImSIN = raw_fake_gg(:,:,NMsnt*(p_i+NPose*c_i)+1:NMsnt*(p_i+NPose*c_i+1));%
        ImVect = reshape(ImSIN,ImSize*ImSize,NMsnt)*Dimmer;
        ImMUX = double(ImVect)*snrmat;
        ImMUX_f = reshape(ImMUX,ImSize,ImSize,[]);
        
        for l_i = 1:N
            SmallIm = imresize(addnoise(ImMUX_r(:,:,l_i),'g',Gain),[SmallImSize,SmallImSize]);
            [Feat,~] = extractHOGFeatures(SmallIm,'Cellsize',[CellSize,CellSize],'BlockSize',[BlkSize,BlkSize]);
            Feat_real_gg(p_i+1,FeatSize*(c_i*N+l_i-1)+1:FeatSize*(c_i*N+l_i)) = Feat; 
            
            SmallIm = imresize(addnoise(ImMUX_f(:,:,l_i),'g',Gain),[SmallImSize,SmallImSize]);
            [Feat,~] = extractHOGFeatures(SmallIm,'Cellsize',[CellSize,CellSize],'BlockSize',[BlkSize,BlkSize]);
            Feat_fake_gg(p_i+1,FeatSize*(c_i*N+l_i-1)+1:FeatSize*(c_i*N+l_i)) = Feat;
        end
        
        % ========Orange===========
        ImSIN = raw_real_or(:,:,NMsnt*(p_i+NPose*c_i)+1:NMsnt*(p_i+NPose*c_i+1)); %
        ImVect = reshape(ImSIN,ImSize*ImSize,NMsnt)*Dimmer;
        ImMUX = double(ImVect)*snrmat;
        ImMUX_r = reshape(ImMUX,ImSize,ImSize,[]);

        ImSIN = raw_fake_or(:,:,NMsnt*(p_i+NPose*c_i)+1:NMsnt*(p_i+NPose*c_i+1));%
        ImVect = reshape(ImSIN,ImSize*ImSize,NMsnt)*Dimmer;
        ImMUX = double(ImVect)*snrmat;
        ImMUX_f = reshape(ImMUX,ImSize,ImSize,[]);
        
        for l_i = 1:N
            SmallIm = imresize(addnoise(ImMUX_r(:,:,l_i),'g',Gain),[SmallImSize,SmallImSize]);
            [Feat,~] = extractHOGFeatures(SmallIm,'Cellsize',[CellSize,CellSize],'BlockSize',[BlkSize,BlkSize]);
            Feat_real_or(p_i+1,FeatSize*(c_i*N+l_i-1)+1:FeatSize*(c_i*N+l_i)) = Feat; 
            
            SmallIm = imresize(addnoise(ImMUX_f(:,:,l_i),'g',Gain),[SmallImSize,SmallImSize]);
            [Feat,vizf] = extractHOGFeatures(SmallIm,'Cellsize',[CellSize,CellSize],'BlockSize',[BlkSize,BlkSize]);
            Feat_fake_or(p_i+1,FeatSize*(c_i*N+l_i-1)+1:FeatSize*(c_i*N+l_i)) = Feat;
        end
        
        % ========Banana===========
        ImSIN = raw_real_bn(:,:,NMsnt*(p_i+NPose*c_i)+1:NMsnt*(p_i+NPose*c_i+1)); %
        ImVect = reshape(ImSIN,800*800,NMsnt)*Dimmer;
        ImMUX = double(ImVect)*snrmat;
        ImMUX_r = reshape(ImMUX,800,800,[]);

        ImSIN = raw_fake_bn(:,:,NMsnt*(p_i+NPose*c_i)+1:NMsnt*(p_i+NPose*c_i+1));%
        ImVect = reshape(ImSIN,800*800,NMsnt)*Dimmer;
        ImMUX = double(ImVect)*snrmat;
        ImMUX_f = reshape(ImMUX,800,800,[]);
        
        for l_i = 1:N
            SmallIm = imresize(addnoise(ImMUX_r(:,:,l_i),'g',Gain),[SmallImSize,SmallImSize]);
            [Feat,~] = extractHOGFeatures(SmallIm,'Cellsize',[CellSize,CellSize],'BlockSize',[BlkSize,BlkSize]);
            Feat_real_bn(p_i+1,FeatSize*(c_i*N+l_i-1)+1:FeatSize*(c_i*N+l_i)) = Feat;  %

            SmallIm = imresize(addnoise(ImMUX_f(:,:,l_i),'g',Gain),[SmallImSize,SmallImSize]);
            [Feat,~] = extractHOGFeatures(SmallIm,'Cellsize',[CellSize,CellSize],'BlockSize',[BlkSize,BlkSize]);
            Feat_fake_bn(p_i+1,FeatSize*(c_i*N+l_i-1)+1:FeatSize*(c_i*N+l_i)) = Feat;
        end
    end 
end 

Feat_fake_ga(:,end) = 0;
Feat_real_ga(:,end) = 1; 
Feat_fake_ra(:,end) = 2;
Feat_real_ra(:,end) = 3;
Feat_fake_gg(:,end) = 4; 
Feat_real_gg(:,end) = 5; 
Feat_fake_bn(:,end) = 6; 
Feat_real_bn(:,end) = 7;
Feat_fake_or(:,end) = 8;
Feat_real_or(:,end) = 9;