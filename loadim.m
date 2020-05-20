% test snr of single source illum and multiplex
% clc;clear;close all;
bit = 65535;
myFolder = 'C:\Users\user\Pictures\basler\classtest\plate3\100ms0db';
% myFolder = 'C:\Users\user\Pictures\basler\fake\orange5';
filePattern = fullfile(myFolder, '*.tiff');
jpegFiles = dir(filePattern);

a = 1;
for k = 1:4:length(jpegFiles)
  baseFileName = jpegFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  im.bl{a} = double(imread(fullFileName))/bit;
  a = a+1;
end
a = 1;
for k = 2:4:length(jpegFiles)
  baseFileName = jpegFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  im.tl{a} = double(imread(fullFileName))/bit;
  a = a+ 1;
end
a = 1;
for k = 3:4:length(jpegFiles)
  baseFileName = jpegFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  im.tr{a} = double(imread(fullFileName))/bit;
  a = a+ 1;
end
a = 1;
for k = 4:4:length(jpegFiles)
  baseFileName = jpegFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  im.br{a} = double(imread(fullFileName))/bit;
  a = a+ 1;
end
a = 1;
for j = 1:7:length(im.bl)
   redim.bl{a} = im.bl{j};
   redim.br{a} = im.br{j};
   redim.tr{a} = im.tr{j};
   redim.tl{a} = im.tl{j};
   a = a + 1;
end
a = 1;
for j = 2:7:length(im.bl)
   grnim.bl{a} = im.bl{j}; 
   grnim.br{a} = im.br{j};
   grnim.tr{a} = im.tr{j};
   grnim.tl{a} = im.tl{j};
   a = a + 1;
end
a = 1;
for j = 3:7:length(im.bl)
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
    fprintf('estimate noise pic%d: %.7f \n',j,NoiseLevel(noisefreeim{j}));
end

%% test snr of single illum
myFolder = 'C:\Users\user\Pictures\basler\classtest\plate\hole12db24ms_s';
% myFolder = 'C:\Users\user\Pictures\basler\fake\orange7';
filePattern = fullfile(myFolder, '*.tiff');
jpegFiles = dir(filePattern);
for i = 1:12
  baseFileName = jpegFiles(i).name;
  fullFileName = fullfile(myFolder, baseFileName);
  sim{i} = double(imread(fullFileName).*1.1)/bit;
end

for i = 1:3
    figure(i);
    for j = 1:4
        subplot(2,4,j*2-1);
%         imshow(sim{(i-1)*4+j});
%         imshowpair(sim{(i-1)*4+j},noisefreeim{(i-1)*4+j},'montage');
        imagesc(log(abs(noisefreeim{(i-1)*4+j}-sim{(i-1)*4+j})));
        [ipsnr,isnr,imse] = snrcalc(sim{(i-1)*4+j},noisefreeim{(i-1)*4+j},0);
        name = ['psnr: ',num2str(ipsnr)];
        title(name);
        axis off;
        colorbar;
        colormap bone;
        caxis([-20,0]);
    end
%     sgtitle('single illumination at 6db gain 48ms');
%     saveas(gcf,['sim',chan(i,:),num2str(i),'.png']);
end

%% test snr of multiplex image
% myFolder = 'C:\Users\user\Pictures\basler\classtest\plate\hole0db48ms_mt';
bit = 65535;
myFolder = 'C:\Users\user\Pictures\basler\real\orange1609ms300';
filePattern = fullfile(myFolder, '*.tiff');
jpegFiles = dir(filePattern);
for i = 1:8
  baseFileName = jpegFiles(i).name;
  fullFileName = fullfile(myFolder, baseFileName);
  mr{i} = double(imread(fullFileName))/bit; 
%   mr{i} = mr{i}*2;
  mrmat(i,:) = reshape(mr{i},1,size(mr{i},1)*size(mr{i},2));
end
for i = 9:16
  baseFileName = jpegFiles(i).name;
  fullFileName = fullfile(myFolder, baseFileName);
  mg{i-8} = double(imread(fullFileName))/bit;
%   mg{i-4} = mg{i-4}*2;
  mgmat(i-8,:) = reshape(mg{i-8},1,size(mg{i-8},1)*size(mg{i-8},2));
end
for i = 17:24
  baseFileName = jpegFiles(i).name;
  fullFileName = fullfile(myFolder, baseFileName);
  mb{i-16} = double(imread(fullFileName))/bit;
%   mb{i-8} = mb{i-8}*2;
  mbmat(i-16,:) = reshape(mb{i-16},1,size(mb{i-16},1)*size(mb{i-16},2));
end
for i = 25:32
  baseFileName = jpegFiles(i).name;
  fullFileName = fullfile(myFolder, baseFileName);
  mn{i-24} = double(imread(fullFileName))/bit;
%   mb{i-8} = mb{i-8}*2;
  mnmat(i-24,:) = reshape(mn{i-24},1,size(mn{i-24},1)*size(mn{i-24},2));
end
% demulmat = ones(4)-eye(4);
% demulmat = hadamard(4);
% demulmat = [1,1,1,1;
%             1,0,1,0;
%             1,1,0,0;
%             1,0,0,1];
demulmat = [1,0,0,1,1,0,0,0;
          0,1,1,0,1,0,0,0;
          1,0,1,0,0,1,1,0;
          0,0,1,1,0,1,0,0;
          0,0,1,1,0,0,1,1;
          0,0,0,0,1,1,0,1;
          0,1,0,1,0,1,1,0;
          1,1,0,0,0,0,0,1];
demulmat2 = [1,0,0,1,0,1,0,1;
            1,1,0,0,1,0,0,0;
            0,1,1,1,0,1,0,0;
            0,0,0,1,1,0,1,0;
            0,0,1,0,1,0,0,1;
            0,0,0,0,1,1,1,0;
            1,0,1,0,0,0,1,0;
            0,1,0,0,0,0,1,1];
demulr = ((demulmat'\mrmat));
% demulg = ((demulmat\mgmat));
% demulb = ((demulmat\mbmat));
demuln = (demulmat2'\mnmat);
for i = 1:8
    dem{i} = reshape(demulr(i,:),size(mr{i},1),size(mr{i},2));
    dem{i+8} = mr{i};
    dem{i+16} = mb{i};
    dem{i+24} = reshape(demuln(i,:),size(mn{i},1),size(mn{i},2));
%     dem{i+8} = reshape(demulg(i,:),size(mg{i},1),size(mg{i},2));
%     dem{i+16} = reshape(demulb(i,:),size(mb{i},1),size(mb{i},2));
end
%%
for i = 4
    figure(i);
    for j = 1:8
        subplot(2,4,j);
%         imshowpair(dem{(i-1)*4+j},noisefreeim{(i-1)*4+j},'montage');
        imagesc((abs(dem{(i-1)*8+j})));
%         [ipsnrm,isnr,imse] = snrcalc(dem{(i-1)*4+j},noisefreeim{(i-1)*4+j},1);
%         name = ['psnr: ',num2str(ipsnrm),' MG: ',num2str(ipsnrm/ipsnr)];
%         title(name);
        axis off;
        colorbar;
        colormap jet;
%         caxis([-20,0]);
    end
    sgtitle('Fake Orange Red Channel Demultiplexed');
%     iptsetpref('ImshowBorder','tight');
%     saveas(gcf,['dem',chan(i,:),num2str(i),'.png']);
end

%% check multiplexed image form sillum psnr 

rednf = (noisefreeim{1}+noisefreeim{2}+noisefreeim{3}+noisefreeim{4})/4;
reds = (sim{1}+sim{2}+sim{3}+sim{4})/4;
figure;
subplot(1,2,1);
% imshowpair(reds,rednf,'montage');
imagesc(reds-rednf);
[ipsnr,isnr,imse] = snrcalc(reds,rednf,0);
name = ['snr: ',num2str(isnr)];
title(name);
colorbar;
subplot(1,2,2);
% imshowpair(mr{1},rednf,'montage');
imagesc(mr{1}-rednf);
[ipsnr,isnr,imse] = snrcalc(rednf,mr{1},1);
name = ['snr: ',num2str(isnr)];
title(name);
sgtitle('multiplex single illumination images vs multiplexed illumination image');
colorbar;
colormap bone;

caxis([-1,1]);