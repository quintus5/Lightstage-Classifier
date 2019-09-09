clc;close all;
figure;
for i = 1:4
imsim = sim{i};
imdem = dem{i};
imnf = noisefreeim{i};
lines = imsim(350,:);
lined = imdem(350,:);
linen = imnf(350,:);
subplot(2,2,i);
plot(lines)
hold on
plot(lined)
plot(linen)
% ylim([-0.01,0.25]);
legend('sim12db','dem0db','nf')
end
%%
% load image, run hyperim first
imtest1 = double(imbl(:,:,3))/65535;
imtest2 = double(imtl(:,:,3))/65535;
imtest3 = double(imtr(:,:,3))/65535;
imtest4 = double(imbr(:,:,3))/65535;

% extract region with high contrast
regionim1 = imextendedmax(imtest1,0.03);
regionim2 = imextendedmax(imtest2,0.03);
regionim3 = imextendedmax(imtest3,0.03);
regionim4 = imextendedmax(imtest4,0.03);
%%
% plot the line with max contrast
[val,idx] = max(std(regionim1,[],2));
line1 = imtest1(idx,:);line2 = regionim1(idx,:);
subplot(4,2,2);plot(line1);hold on;plot(line2);

[val,idx] = max(std(regionim2,[],2));
line1 = imtest2(idx,:);line2 = regionim2(idx,:);
subplot(4,2,4);plot(line1);hold on;plot(line2);

[val,idx] = max(std(regionim3,[],2));
line1 = imtest3(idx,:);line2 = regionim3(idx,:);
subplot(4,2,6);plot(line1);hold on;plot(line2);

[val,idx] = max(std(regionim4,[],2));
line1 = imtest4(idx,:);line2 = regionim4(idx,:);
subplot(4,2,8);plot(line1);hold on;plot(line2);

%%
figure;
subplot(2,2,1);imshow(regionim1);
subplot(2,2,2);imshow(regionim2);
subplot(2,2,3);imshow(regionim3);
subplot(2,2,4);imshow(regionim4);
sgtitle('binarized image with regional peak detection');
%%
figure;
subplot(2,2,1);imshow(imtest1);
subplot(2,2,2);imshow(imtest2);
subplot(2,2,3);imshow(imtest3);
subplot(2,2,4);imshow(imtest4);
sgtitle('blue channel hole plate');

%% test image
bit = 65535;
myFolder = 'C:\Users\user\Pictures\basler\testimage\100ms0db';
% myFolder = 'C:\Users\user\Pictures\basler\fake\orange5';
filePattern = fullfile(myFolder, '*.tiff');
jpegFiles = dir(filePattern);

a = 1;
for k = 1:4:length(jpegFiles)
  baseFileName = jpegFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  im.tl{a} = double(imread(fullFileName))/bit;
  a = a+1;
end
a = 1;
for k = 2:4:length(jpegFiles)
  baseFileName = jpegFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  im.tr{a} = double(imread(fullFileName))/bit;
  a = a+ 1;
end
a = 1;
for k = 3:4:length(jpegFiles)
  baseFileName = jpegFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  im.br{a} = double(imread(fullFileName))/bit;
  a = a+ 1;
end
a = 1;
for k = 4:4:length(jpegFiles)
  baseFileName = jpegFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  im.b{a} = double(imread(fullFileName))/bit;
  a = a+ 1;
end

for i = 1:4
    avgim{i} = zeros(size(im.br{1}));
end
for i = 1:length(im.br)
    avgim{1} = avgim{1} + im.tl{i};
    avgim{2} = avgim{2} + im.tr{i};
    avgim{3} = avgim{3} + im.br{i};
    avgim{4} = avgim{4} + im.b{i};
end
for i = 1:4
    avgim{i} = avgim{i}/100;
end
%% test snr of single illum
myFolder = 'C:\Users\user\Pictures\basler\testimage\14ms17db';
filePattern = fullfile(myFolder, '*.tiff');
jpegFiles = dir(filePattern);
for i = 1:4
  baseFileName = jpegFiles(i).name;
  fullFileName = fullfile(myFolder, baseFileName);
  sim{i} = double(imread(fullFileName))/bit;
%   sim{i} = sim{i}.*1.04 + 0.021; % 14db
%   sim{i} = sim{i}*1.028+0.024; % 12db
%   sim{i} = sim{i}.*1.04 + 0.0009; % 6db

%   sim{i} = double((imread(fullFileName).*1.0928)+0.0122)/bit; % 12db
%   sim{i} = double(imread(fullFileName).*1.04+0.009)/bit;
end
figure;
for j = 2:4
    subplot(3,1,j-1);
%     imshowpair(sim{j},avgim{j},'montage');
    imagesc((abs(avgim{j}-sim{j})));
    [ps,sn] = snrcalc(sim{j},avgim{j});
    colorbar;
    colormap bone;
%     caxis([-10,0]);
end
% sgtitle('100ms 0db vs 14ms 17db ln')
%%
figure;
for i = 2:4
im1 = avgim{i};
im2 = sim{i};
im3 = dem{i};
line = im1(230,206:266);
line2 = im2(230,206:266);
line3 = im3(230,206:266);
subplot(1,3,i-1)
plot((line));hold on; plot(line2);%plot(line3);
legend('noisefree','single illum')
hline(mean(line(33:61)),'b:',num2str(mean(line(33:61))));
hline(mean(line2(33:61)),'r:',num2str(mean(line2(33:61))));
hline(mean(line(1:27)),'b:',num2str(mean(line(1:27))));
hline(mean(line2(1:27)),'r:',num2str(mean(line2(1:27))));
% xlabel([num2str(mean(line)-mean(line2)),' ',num2str(mean(line)-mean(line3))]);
end

%% multiplexed
myFolder = 'C:\Users\user\Pictures\basler\testimage\50ms6dbm';
filePattern = fullfile(myFolder, '*.tiff');
jpegFiles = dir(filePattern);
for i = 1:4
  baseFileName = jpegFiles(i).name;
  fullFileName = fullfile(myFolder, baseFileName);
  mr{i} = double(imread(fullFileName))/bit;
%   mr{i} = mr{i}.*1.025+0.003;
  mrmat(i,:) = reshape(mr{i},1,size(mr{i},1)*size(mr{i},2));
end
demulmat = [1,0,1;
            0,1,1;
            1,1,0];
demim = demulmat\mrmat(2:4,:);
dem{1} = mr{1};
dem{2} = reshape(demim(1,:),416,416);
dem{3} = reshape(demim(2,:),416,416);
dem{4} = reshape(demim(3,:),416,416);
figure;
for j = 2:4
    subplot(3,1,j-1);
%     imshowpair(dem{j},avgim{j},'montage');
    imagesc(log(abs(avgim{j}-dem{j})));
    [ps,sn] = snrcalc(dem{j},avgim{j});
    colorbar;
    colormap bone
    caxis([-10,0]);
end
% todo: make a linear interpolation from 4 points in sim and avgim to scale
% the sim to match avgim. 0.022, 0.0009, 0.3, 0.34


%% spectral intensiy map
% x axis = wavelength
% y axis = intensity
% legend pixels
imtest1  = reshape(imtest1,1,40401);
imtest2  = reshape(imtest2,1,40401);
imtest3  = reshape(imtest3,1,40401);

%% HOG
% [feat,vis,pvis] = extractHOGFeatures(sim{2},p);
% p = detectSURFFeatures(sim{2});
% pp = detectHarrisFeatures(noisefreeim{3});
for i = 1:8
    [feat(i,:),vis] = extractHOGFeatures(noisefreeim{3},'Cellsize',[4,4],'BlockSize',[4,4]);
end

% p = detectSURFFeatures(sim{2});
% imshow(noisefreeim{3})
% hold on;
% plot(vis)

%%
bit = 65535;
myFolder = 'C:\Users\user\Pictures\basler\testimage\nt2\100ms0db';
filePattern = fullfile(myFolder, '*.tiff');
jpegFiles = dir(filePattern);

for k = 1:length(jpegFiles)
  baseFileName = jpegFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  im(:,:,k) = double(imread(fullFileName))/bit;
end
aim = sum(im,3)/100;
figure;plot(aim);hold on;
% sim
myFolder = 'C:\Users\user\Pictures\basler\testimage\nt2\20ms14db';
filePattern = fullfile(myFolder, '*.tiff');
jpegFiles = dir(filePattern);
for k = 1:length(jpegFiles)
  baseFileName = jpegFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  sim(:,:,k) = double(imread(fullFileName))/bit;
end
plot(sim(:,:,2));

%% edge test
subplot(2,6,1);[g,t] = edge(noisefreeim{1},'log',0.003,2.1);imshow(g)
subplot(2,6,2);[g,t] = edge(noisefreeim{1},'canny',[0.04,0.1],1.5);imshow(g)
subplot(2,6,3);[g,t] = edge(noisefreeim{1},'zerocross');imshow(g)
subplot(2,6,4);[g,t] = edge(noisefreeim{2},'log',0.003,2.1);imshow(g)
subplot(2,6,5);[g,t] = edge(noisefreeim{2},'canny',[0.04,0.1],1.5);imshow(g)
subplot(2,6,6);[g,t] = edge(noisefreeim{2},'zerocross');imshow(g)
subplot(2,6,7);[g,t] = edge(noisefreeim{3},'log',0.003,2.1);imshow(g)
subplot(2,6,8);[g,t] = edge(noisefreeim{3},'canny',[0.04,0.1],1.5);imshow(g)
subplot(2,6,9);[g,t] = edge(noisefreeim{3},'zerocross');imshow(g)
subplot(2,6,10);[g,t] = edge(noisefreeim{5},'log',0.003,2.1);imshow(g)
subplot(2,6,11);[g,t] = edge(noisefreeim{5},'canny',[0.04,0.1],1.5);imshow(g)
subplot(2,6,12);[g,t] = edge(noisefreeim{5},'zerocross');imshow(g)

%% fuzzy edge detection
 a1=dyaddown(noisefreeim{1},'m',1);
 
%% 8 light test
table = ones(32);
write(reg,table(3,:),'uint32');

%% low light gray level compare
bit = 65535;
myFolder = 'G:\work\matlab\basler\testimage\grey';
filePattern = fullfile(myFolder, '*.tiff');
jpegFiles = dir(filePattern);
im20 = zeros(100,416);
for k = 1:length(jpegFiles)
  baseFileName = jpegFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  im(:,:,k) = double(imread(fullFileName))/bit;
  im20 = im20 + im(:,:,k);
end
myFolder = 'G:\work\matlab\basler\testimage\grey10ms6db';
filePattern = fullfile(myFolder, '*.tiff');
jpegFiles = dir(filePattern);
im10 = zeros(100,416);
for k = 1:length(jpegFiles)
  baseFileName = jpegFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  im(:,:,k) = double(imread(fullFileName))/bit;
  im10 = im10 + im(:,:,k);
end
myFolder = 'G:\work\matlab\basler\testimage\grey5ms12db';
filePattern = fullfile(myFolder, '*.tiff');
jpegFiles = dir(filePattern);
im5 = zeros(100,416);
for k = 1:length(jpegFiles)
  baseFileName = jpegFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  im(:,:,k) = double(imread(fullFileName))/bit;
  im5 = im5 + im(:,:,k);
end

im20 = im20/20; im10 = im10/20;im5= im5/20;
im5 = im5*1.0225+0.014;im10 = im10*1.0216+0.005;
im10(im10(:,:) > 1) = 1; 
im5(im5(:,:) > 1) = 1;
imn = imnoise(im20, 'poisson' );
subplot(3,1,1);imagesc(log(abs(im20-imn)));colorbar;title('20ms vs poisson noise added')
subplot(3,1,2);imagesc(log(abs(im20-im10)));colorbar;title('20ms vs 10')
subplot(3,1,3);imagesc(log(abs(im20-im5)));title('20ms vs 5')
colorbar
colormap gray
% trace a row
line20 = im20(50,:);line10 = im10(50,:);line5 = im5(50,:);
figure;
plot(line20);hold on;plot(line10);plot(line5);

%% noise model
bit = 65535;
myFolder = 'C:\Users\roboticimaging\Documents\kronoslightstage\testimage\hhh';
filePattern = fullfile(myFolder, '*.tiff');
jpegFiles = dir(filePattern);
for red = 1:8
  baseFileName = jpegFiles(red).name;
  fullFileName = fullfile(myFolder, baseFileName);
  im(:,:,red) = double(imread(fullFileName))/bit;
  redvar(red) = std2(im(:,:,red).^2);
  redmn(red) = mean2(im(:,:,red));
end
for green = 9:16
  baseFileName = jpegFiles(green).name;
  fullFileName = fullfile(myFolder, baseFileName);
  im(:,:,green) = double(imread(fullFileName))/bit;
  greenvar(green-8) = std2(im(:,:,green).^2);
  greenmn(green-8) = mean2(im(:,:,green));
end
for blue = 17:24
  baseFileName = jpegFiles(blue).name;
  fullFileName = fullfile(myFolder, baseFileName);
  im(:,:,blue) = double(imread(fullFileName))/bit;
  bluevar(blue-16) = std2(im(:,:,blue).^2);
  bluemn(blue-16) = mean2(im(:,:,blue));
end
for ir = 25:32
  baseFileName = jpegFiles(ir).name;
  fullFileName = fullfile(myFolder, baseFileName);
  im(:,:,ir) = double(imread(fullFileName))/bit;
  irvar(ir-24) = std2(im(:,:,ir).^2);
  irmn(ir-24) = mean2(im(:,:,ir));
end
baseim = double(imread('C:\Users\roboticimaging\Documents\kronoslightstage\testimage\hhh\zbase.tiff'));
figure;noisecalibrationplot(redmn);
figure;noisecalibrationplot(greenmn);
figure;noisecalibrationplot(bluemn);
figure;noisecalibrationplot(irmn);

%% color reproduction

bim(:,:,1) = double(imread('C:\Users\roboticimaging\Documents\kronoslightstage\testimage\hhh\Basler_acA1920-150um__40026510__20190905_205232082_8.tiff'))/bit;
bim(:,:,2) = double(imread('C:\Users\roboticimaging\Documents\kronoslightstage\testimage\hhh\Basler_acA1920-150um__40026510__20190905_205232082_16.tiff'))/bit;
bim(:,:,3) = double(imread('C:\Users\roboticimaging\Documents\kronoslightstage\testimage\hhh\Basler_acA1920-150um__40026510__20190905_205232082_24.tiff'))/bit;
iim(:,:,1) = double(imread('C:\Users\roboticimaging\Documents\kronoslightstage\testimage\hhh\Basler_acA1920-150um__40026510__20190905_205232082_32.tiff'))/bit;

newim = rgb2hsv(bim);
newim(:,:,3) = iim;
bim = hsv2rgb(newim);
lim = rgb2lab(bim);

%% signal calculation
Fstop = 1/4;
Expt = 0.110;
Isrc = 150;
Ref = 0.5;
quant = 0.7;
delta = 4.8e-6;
J = 10e15*Fstop^-2*Expt*Isrc*Ref*quant*delta^2