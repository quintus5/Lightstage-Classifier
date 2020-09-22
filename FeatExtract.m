function feature = FeatExtract(MUXMAT,Raw,NPose,NColor,NMsnt,N,Gain,Dimmer)
%FEATEXTRACT returns a struct containing feature vector of all categories extracted from
% multiplexed images. The features are sorted in [RGB-NIR] order.
% Inputs: 
%     'MUXMAT'    - NxM multiplexing matrix
%     'Raw'       - raw 10 bit image files, struct
%     'NPose'     - number of pose in the dataset, int
%     'NColor'    - number of illumination bands in the dataset, int
%     'NMsnt'     - number of total acquisition M in the dataset, int
%     'N'         - number of required acquisition m, int
%     'Gain'      - artificial noise gain in dB, double
%     'Dimmer'    - scale to prevent saturation, double
% Outputs:
%     'feature'   - sorted feature vector, struct
%     
% Copyright 2020 Taihua Wang

% preallocating feature array
Feat.real_ga = zeros(NPose,FeatSize*NColor*N+1);
Feat.fake_ga = zeros(NPose,FeatSize*NColor*N+1); 
Feat.real_ra = zeros(NPose,FeatSize*NColor*N+1);
Feat.fake_ra = zeros(NPose,FeatSize*NColor*N+1);
Feat.real_gg = zeros(NPose,FeatSize*NColor*N+1);
Feat.fake_gg = zeros(NPose,FeatSize*NColor*N+1);
Feat.real_bn = zeros(NPose,FeatSize*NColor*N+1);
Feat.fake_bn = zeros(NPose,FeatSize*NColor*N+1);
Feat.real_or = zeros(NPose,FeatSize*NColor*N+1);
Feat.fake_or = zeros(NPose,FeatSize*NColor*N+1);

for c_i = 0:NColor-1 % 4 colors
    for p_i = 0:NPose-1 % pose   
        
        % ========Green apple===========
        % real fruit
        ImSIN = Raw.real_ga(:,:,NMsnt*(p_i+NPose*c_i)+1:NMsnt*(p_i+NPose*c_i+1));
        ImVect = reshape(ImSIN,ImSize*ImSize,NMsnt)*Dimmer;
        ImMUX = double(ImVect)*MUXMAT;
        ImMUX_r = reshape(ImMUX,ImSize,ImSize,[]);
        % fake fruit
        ImSIN = Raw.fake_ga(:,:,NMsnt*(p_i+NPose*c_i)+1:NMsnt*(p_i+NPose*c_i+1));
        ImVect = reshape(ImSIN,ImSize*ImSize,NMsnt)*Dimmer;
        ImMUX = double(ImVect)*MUXMAT;
        ImMUX_f = reshape(ImMUX,ImSize,ImSize,[]);

        % resize image -> add artificial noise -> extract feature 
        for l_i = 1:N
            SmallIm = imresize(addnoise(ImMUX_r(:,:,l_i),'g',Gain,Dimmer),[SmallImSize,SmallImSize]);
            [feature,~] = extractHOGFeatures(SmallIm,'Cellsize',[CellSize,CellSize],'BlockSize',[BlkSize,BlkSize]);
            Feat.real_ga(p_i+1,FeatSize*(c_i*N+l_i-1)+1:FeatSize*(c_i*N+l_i)) = feature;

            SmallIm = imresize(addnoise(ImMUX_f(:,:,l_i),'g',Gain,Dimmer),[SmallImSize,SmallImSize]);
            [feature,~] = extractHOGFeatures(SmallIm,'Cellsize',[CellSize,CellSize],'BlockSize',[BlkSize,BlkSize]);
            Feat.fake_ga(p_i+1,FeatSize*(c_i*N+l_i-1)+1:FeatSize*(c_i*N+l_i)) = feature;
        end
        
        % ========Red apple===========
        ImSIN = Raw.real_ra(:,:,NMsnt*(p_i+NPose*c_i)+1:NMsnt*(p_i+NPose*c_i+1));
        ImVect = reshape(ImSIN,ImSize*ImSize,NMsnt)*Dimmer;
        ImMUX = double(ImVect)*MUXMAT;
        ImMUX_r = reshape(ImMUX,ImSize,ImSize,[]);

        ImSIN = Raw.fake_ra(:,:,NMsnt*(p_i+NPose*c_i)+1:NMsnt*(p_i+NPose*c_i+1));
        ImVect = reshape(ImSIN,ImSize*ImSize,NMsnt)*Dimmer;
        ImMUX = double(ImVect)*MUXMAT;
        ImMUX_f = reshape(ImMUX,ImSize,ImSize,[]);
        
        for l_i = 1:N
            SmallIm = imresize(addnoise(ImMUX_r(:,:,l_i),'g',Gain,Dimmer),[SmallImSize,SmallImSize]);
            [feature,~] = extractHOGFeatures(SmallIm,'Cellsize',[CellSize,CellSize],'BlockSize',[BlkSize,BlkSize]);
            Feat.real_ra(p_i+1,FeatSize*(c_i*N+l_i-1)+1:FeatSize*(c_i*N+l_i)) = feature;

            SmallIm = imresize(addnoise(ImMUX_f(:,:,l_i),'g',Gain,Dimmer),[SmallImSize,SmallImSize]);
            [feature,~] = extractHOGFeatures(SmallIm,'Cellsize',[CellSize,CellSize],'BlockSize',[BlkSize,BlkSize]);
            Feat.fake_ra(p_i+1,FeatSize*(c_i*N+l_i-1)+1:FeatSize*(c_i*N+l_i)) = feature;
        end  
        
        % ========Green grape===========
        ImSIN = Raw.real_gg(:,:,NMsnt*(p_i+NPose*c_i)+1:NMsnt*(p_i+NPose*c_i+1)); %
        ImVect = reshape(ImSIN,ImSize*ImSize,NMsnt)*Dimmer;
        ImMUX = double(ImVect)*MUXMAT;
        ImMUX_r = reshape(ImMUX,ImSize,ImSize,[]);

        ImSIN = Raw.fake_gg(:,:,NMsnt*(p_i+NPose*c_i)+1:NMsnt*(p_i+NPose*c_i+1));%
        ImVect = reshape(ImSIN,ImSize*ImSize,NMsnt)*Dimmer;
        ImMUX = double(ImVect)*MUXMAT;
        ImMUX_f = reshape(ImMUX,ImSize,ImSize,[]);
        
        for l_i = 1:N
            SmallIm = imresize(addnoise(ImMUX_r(:,:,l_i),'g',Gain,Dimmer),[SmallImSize,SmallImSize]);
            [feature,~] = extractHOGFeatures(SmallIm,'Cellsize',[CellSize,CellSize],'BlockSize',[BlkSize,BlkSize]);
            Feat.real_gg(p_i+1,FeatSize*(c_i*N+l_i-1)+1:FeatSize*(c_i*N+l_i)) = feature; 
            
            SmallIm = imresize(addnoise(ImMUX_f(:,:,l_i),'g',Gain,Dimmer),[SmallImSize,SmallImSize]);
            [feature,~] = extractHOGFeatures(SmallIm,'Cellsize',[CellSize,CellSize],'BlockSize',[BlkSize,BlkSize]);
            Feat.fake_gg(p_i+1,FeatSize*(c_i*N+l_i-1)+1:FeatSize*(c_i*N+l_i)) = feature;
        end
        
        % ========Orange===========
        ImSIN = Raw.real_or(:,:,NMsnt*(p_i+NPose*c_i)+1:NMsnt*(p_i+NPose*c_i+1)); %
        ImVect = reshape(ImSIN,ImSize*ImSize,NMsnt)*Dimmer;
        ImMUX = double(ImVect)*MUXMAT;
        ImMUX_r = reshape(ImMUX,ImSize,ImSize,[]);

        ImSIN = Raw.fake_or(:,:,NMsnt*(p_i+NPose*c_i)+1:NMsnt*(p_i+NPose*c_i+1));%
        ImVect = reshape(ImSIN,ImSize*ImSize,NMsnt)*Dimmer;
        ImMUX = double(ImVect)*MUXMAT;
        ImMUX_f = reshape(ImMUX,ImSize,ImSize,[]);
        
        for l_i = 1:N
            SmallIm = imresize(addnoise(ImMUX_r(:,:,l_i),'g',Gain,Dimmer),[SmallImSize,SmallImSize]);
            [feature,~] = extractHOGFeatures(SmallIm,'Cellsize',[CellSize,CellSize],'BlockSize',[BlkSize,BlkSize]);
            Feat.real_or(p_i+1,FeatSize*(c_i*N+l_i-1)+1:FeatSize*(c_i*N+l_i)) = feature; 
            
            SmallIm = imresize(addnoise(ImMUX_f(:,:,l_i),'g',Gain,Dimmer),[SmallImSize,SmallImSize]);
            [feature,~] = extractHOGFeatures(SmallIm,'Cellsize',[CellSize,CellSize],'BlockSize',[BlkSize,BlkSize]);
            Feat.fake_or(p_i+1,FeatSize*(c_i*N+l_i-1)+1:FeatSize*(c_i*N+l_i)) = feature;
        end
        
        % ========Banana===========
        ImSIN = Raw.real_bn(:,:,NMsnt*(p_i+NPose*c_i)+1:NMsnt*(p_i+NPose*c_i+1)); %
        ImVect = reshape(ImSIN,800*800,NMsnt)*Dimmer;
        ImMUX = double(ImVect)*MUXMAT;
        ImMUX_r = reshape(ImMUX,800,800,[]);

        ImSIN = Raw.fake_bn(:,:,NMsnt*(p_i+NPose*c_i)+1:NMsnt*(p_i+NPose*c_i+1));%
        ImVect = reshape(ImSIN,800*800,NMsnt)*Dimmer;
        ImMUX = double(ImVect)*MUXMAT;
        ImMUX_f = reshape(ImMUX,800,800,[]);
        
        for l_i = 1:N
            SmallIm = imresize(addnoise(ImMUX_r(:,:,l_i),'g',Gain,Dimmer),[SmallImSize,SmallImSize]);
            [feature,~] = extractHOGFeatures(SmallIm,'Cellsize',[CellSize,CellSize],'BlockSize',[BlkSize,BlkSize]);
            Feat.real_bn(p_i+1,FeatSize*(c_i*N+l_i-1)+1:FeatSize*(c_i*N+l_i)) = feature;  %

            SmallIm = imresize(addnoise(ImMUX_f(:,:,l_i),'g',Gain,Dimmer),[SmallImSize,SmallImSize]);
            [feature,~] = extractHOGFeatures(SmallIm,'Cellsize',[CellSize,CellSize],'BlockSize',[BlkSize,BlkSize]);
            Feat.fake_bn(p_i+1,FeatSize*(c_i*N+l_i-1)+1:FeatSize*(c_i*N+l_i)) = feature;
        end
    end 
end 

Feat.fake_ga(:,end) = 0;
Feat.real_ga(:,end) = 1; 
Feat.fake_ra(:,end) = 2;
Feat.real_ra(:,end) = 3;
Feat.fake_gg(:,end) = 4; 
Feat.real_gg(:,end) = 5; 
Feat.fake_bn(:,end) = 6; 
Feat.real_bn(:,end) = 7;
Feat.fake_or(:,end) = 8;
Feat.real_or(:,end) = 9;
end