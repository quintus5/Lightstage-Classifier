% bit16 = 65535;
% myFolder = 'C:\Users\user\Pictures\basler\real\ball11';
% % ball 11 - bl tl tr br rgb
% filePattern = fullfile(myFolder, '*.tiff');
% jpegFiles = dir(filePattern);
% read all image into a stack
% for k = 1:length(jpegFiles)
%   baseFileName = jpegFiles(k).name;
%   fullFileName = fullfile(myFolder, baseFileName);
%   imarray(:,:,k) = double(imread(fullFileName))/bit16;
% end

a = 1;
% for p = 1:4
%     for i = p:4:length(jpegFiles)
%         baseFileName = jpegFiles(i).name;
%         fullFileName = fullfile(myFolder, baseFileName);
%         imarray(:,:,a) = double(imread(fullFileName))/bit16;  
%         a = a+1;
%     end
% end

array(:,:,1) = noisefreeim{1};
array(:,:,2) = noisefreeim{5} ;
array(:,:,3) = noisefreeim{9} ;
array(:,:,4) = noisefreeim{2} ;
array(:,:,5) = noisefreeim{6} ;
array(:,:,6) = noisefreeim{10};
array(:,:,7) = noisefreeim{3};
array(:,:,8) = noisefreeim{7} ;
array(:,:,9) = noisefreeim{11};
array(:,:,10) = noisefreeim{4} ;
array(:,:,11) = noisefreeim{8};
array(:,:,12) = noisefreeim{12} ;

%stacking rgb images
% layer | color | lightcode |
%-------|-------|-----------|
%   6   |   b   |   tl      |
%   5   |   g   |   tl      |
%   4   |   r   |   tl      |
%   3   |   b   |   bl      |
%   2   |   g   |   bl      |
%   1   |   r   |   bl      |