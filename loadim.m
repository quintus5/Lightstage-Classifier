% test snr of single source illum and multiplex
% clc;clear;close all;
bit16 = 65535;
bit8 = 255;
myFolder = 'C:\Users\user\Pictures\basler\real\ball11';
% myFolder = 'C:\Users\user\Pictures\basler\fake\orange5';
filePattern = fullfile(myFolder, '*.tiff');
jpegFiles = dir(filePattern);
% for k = 1:length(jpegFiles)
%   baseFileName = jpegFiles(k).name;
%   fullFileName = fullfile(myFolder, baseFileName);
%   oim(:,:,k) = double(imread(fullFileName))/bit16;
% end

a = 1;
for k = 1:4:length(jpegFiles)
  baseFileName = jpegFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  im.bl{a} = double(imread(fullFileName))/bit16;
  a = a+1;
end
a = 1;
for k = 2:4:length(jpegFiles)
  baseFileName = jpegFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  im.tl{a} = double(imread(fullFileName))/bit16;
  a = a+ 1;
end
a = 1;
for k = 3:4:length(jpegFiles)
  baseFileName = jpegFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  im.tr{a} = double(imread(fullFileName))/bit16;
  a = a+ 1;
end
a = 1;
for k = 4:4:length(jpegFiles)
  baseFileName = jpegFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  im.br{a} = double(imread(fullFileName))/bit16;
  a = a+ 1;
end
a = 1;
for j = 1:3:length(im.bl)
   redim.bl{a} = im.bl{j};
   redim.br{a} = im.br{j};
   redim.tr{a} = im.tr{j};
   redim.tl{a} = im.tl{j};
   a = a + 1;
end
a = 1;
for j = 2:3:length(im.bl)
   grnim.bl{a} = im.bl{j}; 
   grnim.br{a} = im.br{j};
   grnim.tr{a} = im.tr{j};
   grnim.tl{a} = im.tl{j};
   a = a + 1;
end
a = 1;
for j = 3:3:length(im.bl)
   bluim.bl{a} = im.bl{j};
   bluim.br{a} = im.br{j};
   bluim.tr{a} = im.tr{j};
   bluim.tl{a} = im.tl{j};
   a = a + 1;
end

% find average image for noise
for i = 1:12
    noisefreeim{i} = zeros(size(redim.bl{1}));
end

for i = 1:length(redim.bl)
    noisefreeim{1} = noisefreeim{1} + redim.bl{i};
    noisefreeim{2} = noisefreeim{2} + redim.tl{i};
    noisefreeim{3} = noisefreeim{3} + redim.tr{i};
    noisefreeim{4} = noisefreeim{4} + redim.br{i};
    noisefreeim{5} = noisefreeim{5} + grnim.bl{i};
    noisefreeim{6} = noisefreeim{6} + grnim.tl{i};
    noisefreeim{7} = noisefreeim{7} + grnim.tr{i};
    noisefreeim{8} = noisefreeim{8} + grnim.br{i};
    noisefreeim{9} = noisefreeim{9} + bluim.bl{i};
    noisefreeim{10} = noisefreeim{10} + bluim.tl{i};
    noisefreeim{11} = noisefreeim{11} + bluim.tr{i};
    noisefreeim{12} = noisefreeim{12} + bluim.br{i};
end
for j = 1:12
    noisefreeim{j} = noisefreeim{j}/i;
%     fprintf('estimate noise pic%d: %.7f \n',j,NoiseLevel(noisefreeim{j}));
end

%% test snr of single illum
myFolder = 'C:\Users\user\Pictures\basler\real\ball11';
filePattern = fullfile(myFolder, '*.tiff');
jpegFiles = dir(filePattern);
for i = 1:12
  baseFileName = jpegFiles(i).name;
  fullFileName = fullfile(myFolder, baseFileName);
  sim{i} = double(imread(fullFileName))/bit16;
end

for i = 1:3
    figure(i);
    for j = 1:4
        subplot(2,2,j);
        imshowpair(noisefreeim{(i-1)*4+j},sim{(i-1)*4+j},'montage');
        [multpsnr,multsnr] = psnr(sim{(i-1)*4+j},noisefreeim{(i-1)*4+j});
%         meansq = immse(sim{(i-1)*4+j},noisefreeim{(i-1)*4+j});
%         name = strcat('MSE =',num2str(meansq));
        name = strcat('peak SNR :',num2str(multpsnr),'. SNR : ',num2str(multsnr));
        title(name);
        axis off;
        colorbar;
    end
    sgtitle('single illumination source');
end

%% test snr of multiplex image
myFolder = 'C:\Users\user\Pictures\basler\real\ball12';
filePattern = fullfile(myFolder, '*.tiff');
jpegFiles = dir(filePattern);
for i = 1:4
  baseFileName = jpegFiles(i).name;
  fullFileName = fullfile(myFolder, baseFileName);
  mr{i} = double(imread(fullFileName))/bit16;
  mrmat(i,:) = reshape(mr{i},1,size(mr{i},1)*size(mr{i},2));
end
for i = 5:8
  baseFileName = jpegFiles(i).name;
  fullFileName = fullfile(myFolder, baseFileName);
  mg{i-4} = double(imread(fullFileName))/bit16;
  mgmat(i-4,:) = reshape(mg{i-4},1,size(mg{i-4},1)*size(mg{i-4},2));
end
for i = 9:12
  baseFileName = jpegFiles(i).name;
  fullFileName = fullfile(myFolder, baseFileName);
  mb{i-8} = double(imread(fullFileName))/bit16;
  mbmat(i-8,:) = reshape(mb{i-8},1,size(mb{i-8},1)*size(mb{i-8},2));
end
% 
% demulmat = [1,1,1,0;
%             1,1,0,1;
%             0,1,1,1;
%             1,0,1,1];
demulmat = [1,1,1,1;
            1,0,1,0;
            1,1,0,0;
            1,0,0,1];
demulr = (demulmat\mrmat);
demulg = (demulmat\mgmat);
demulb = (demulmat\mbmat);
for i = 1:4
    dem{i} = reshape(demulr(i,:),size(mr{i},1),size(mr{i},2));
    dem{i+4} = reshape(demulg(i,:),size(mg{i},1),size(mg{i},2));
    dem{i+8} = reshape(demulb(i,:),size(mb{i},1),size(mb{i},2));
end

for i = 1:3
    figure(i+3);
    for j = 1:4
        subplot(2,2,j);
        imshowpair(dem{(i-1)*4+j},noisefreeim{(i-1)*4+j},'diff');
        [multpsnr,multsnr] = psnr(dem{(i-1)*4+j},noisefreeim{(i-1)*4+j});
%         meansq = immse(dem{(i-1)*4+j},noisefreeim{(i-1)*4+j});
%         name = strcat('MSE =',num2str(meansq));
        name = strcat('peak SNR is ',num2str(multpsnr),'. SNR is ',num2str(multsnr));
        title(name);
        axis off;
    end
    sgtitle('demultiplexed at 500ms,f/11');
end

%% check multiplexed image form sillum psnr 

% rednf = (noisefreeim{1}+noisefreeim{2}+noisefreeim{3}+noisefreeim{4})/2;
% reds = (sim{1}+sim{2}+sim{3}+sim{4})/2;
% figure;
% subplot(1,2,1);
% imshowpair(reds,rednf,'montage');
% name = strcat('MSE :',num2str(immse(reds,rednf)));
% title(name);
% subplot(1,2,2);
% imshowpair(mr{1},rednf,'montage');
% name = strcat('MSE :',num2str(immse(mr{1},rednf)));
% title(name);
% sgtitle('multiplex single illumination images vs multiplexed illumination image')

