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
bit = 65535;close all;
myFolder = 'C:\Users\user\Pictures\basler\testimage\step1209';
filePattern = fullfile(myFolder, '*.tiff');
jpegFiles = dir(filePattern);
for i = 1:24
  baseFileName = jpegFiles(i).name;
  fullFileName = fullfile(myFolder, baseFileName);
  im(:,:,i) = double(imread(fullFileName))/bit;
  redvar(i) = std2(im(:,:,i));
  redmn(i) = mean2(im(:,:,i));
end
for green = 25:48
  baseFileName = jpegFiles(green).name;
  fullFileName = fullfile(myFolder, baseFileName);
  im(:,:,green) = double(imread(fullFileName))/bit;
  greenvar(green-24) = std2(im(:,:,green));
  greenmn(green-24) = mean2(im(:,:,green));
end
for blue = 49:72
  baseFileName = jpegFiles(blue).name;
  fullFileName = fullfile(myFolder, baseFileName);
  im(:,:,blue) = double(imread(fullFileName))/bit;
  bluevar(blue-48) = std2(im(:,:,blue));
  bluemn(blue-48) = mean2(im(:,:,blue));
end
for ir = 73:96
  baseFileName = jpegFiles(ir).name;
  fullFileName = fullfile(myFolder, baseFileName);
  im(:,:,ir) = double(imread(fullFileName))/bit;
  irvar(ir-72) = std2(im(:,:,ir));
  irmn(ir-72) = mean2(im(:,:,ir));
end
% nbmn = bluemn(1:8);nrmn = greenmn(1:8);ngmn = redmn(1:8);nimn = irmn(1:8);
% nbvar = bluevar(1:8);ngvar = greenvar(1:8);nrvar = redvar(1:8);nivar = irvar(1:8);
% for i = 2:8
%    nrmn = nrmn + redmn((i-1)*8+1:i*8);
%    ngmn = ngmn + greenmn((i-1)*8+1:i*8);
%    nbmn = nbmn + bluemn((i-1)*8+1:i*8);
%    nimn = nimn + irmn((i-1)*8+1:i*8);
%    nrvar = nrvar + redvar((i-1)*8+1:i*8);
%    ngvar = ngvar + greenvar((i-1)*8+1:i*8);
%    nbvar = nbvar + bluevar((i-1)*8+1:i*8);
%    nivar = nivar + irvar((i-1)*8+1:i*8);
% end
% nbmn = nbmn/8;ngmn = ngmn/8;nrmn = nrmn/8;nimn = nimn/8;
% nbvar = nbvar/8;ngvar = ngvar/8;nrvar = nrvar/8;nivar = nivar/8;
% plot(bluemn,bluevar,'o');ylim([0,0.2]);xlim([0,0.4]);title('Noise Calibration Red');xlabel('$\bar{I}$','Interpreter','latex');ylabel('\sigma^2');grid on;
% figure;plot(redmn,redvar,'o');ylim([0,0.4]);xlim([0,0.4]);title('Noise Calibration Green');xlabel('$\bar{I}$','Interpreter','latex');ylabel('\sigma');grid on;
% figure;plot(greenmn,greenvar,'o');ylim([0,0.4]);xlim([0,0.4]);title('Noise Calibration Green');xlabel('$\bar{I}$','Interpreter','latex');ylabel('\sigma');grid
% figure;plot(irmn,irvar,'o');ylim([0,0.4]);xlim([0,0.4]);title('Noise Calibration Green');xlabel('$\bar{I}$','Interpreter','latex');ylabel('\sigma');grid

subplot(221)
plot(redmn(1:4),redvar(1:4),'o');ylim([0,0.1]);xlim([0,1])
title('red');xlabel('Mean Intensity');ylabel('STD');grid on;
subplot(222)
plot(greenmn(1:4),greenvar(1:4),'o');ylim([0,0.1]);xlim([0,1])
title('green');xlabel('Mean Intensity');ylabel('STD');grid on;
subplot(223)
plot(bluemn(1:4),bluevar(1:4),'o');ylim([0,0.1]);xlim([0,1])
title('blue');xlabel('Mean Intensity');ylabel('STD');grid on;
subplot(224)
plot(irmn(1:4),irvar(1:4),'o');ylim([0,0.1]);xlim([0,1])
title('nir');xlabel('Mean Intensity');ylabel('STD');grid on;
sgtitle('standard deviation with increasing intensity of upper half')
%% color reproduction

bim(:,:,1) = double(imread('C:\Users\user\Pictures\basler\testimage\ppp\Basler acA1920-150um (40026510)_20190911_224751474_0008.tiff'))/bit;
bim(:,:,2) = double(imread('C:\Users\user\Pictures\basler\testimage\ppp\Basler acA1920-150um (40026510)_20190911_224751474_0016.tiff'))/bit;
bim(:,:,3) = double(imread('C:\Users\user\Pictures\basler\testimage\ppp\Basler acA1920-150um (40026510)_20190911_224751474_0024.tiff'))/bit;
iim(:,:,1) = double(imread('C:\Users\user\Pictures\basler\testimage\ppp\Basler acA1920-150um (40026510)_20190911_224751474_0032.tiff'))/bit;

newim = rgb2hsv(bim);
newim(:,:,3) = iim;
him = hsv2rgb(newim);
%% signal calculation
Fstop = 1/4;
Expt = 0.110;
Isrc = 150;
Ref = 0.5;
quant = 0.7;
delta = 4.8e-6;
J = 10e15*Fstop^-2*Expt*Isrc*Ref*quant*delta^2;

%% equalize intensities
bit = 65535;close all;
myFolder = 'C:\Users\user\Pictures\basler\testimage\t1209';
filePattern = fullfile(myFolder, '*.tiff');
jpegFiles = dir(filePattern);
for i = 1:64
  baseFileName = jpegFiles(i).name;
  fullFileName = fullfile(myFolder, baseFileName);
  red(:,:,i) = double(imread(fullFileName))/bit*2.2138+0.0660;
  baseFileName = jpegFiles(i+64).name;
  fullFileName = fullfile(myFolder, baseFileName);
  grn(:,:,i) = double(imread(fullFileName))/bit*2.0330+0.0841;
  baseFileName = jpegFiles(i+128).name;
  fullFileName = fullfile(myFolder, baseFileName);
  blu(:,:,i) = double(imread(fullFileName))/bit*1.1327+0.1273;
  baseFileName = jpegFiles(i+192).name;
  fullFileName = fullfile(myFolder, baseFileName);
  nir(:,:,i) = double(imread(fullFileName))/bit;
%   redmn(i) = mean2(red(:,:,i))*2.2138+0.0660;
%   grnmn(i) = mean2(grn(:,:,i))*2.0330+0.0841;
%   blumn(i) = mean2(blu(:,:,i))*1.1327+0.1273;
%   nirmn(i) = mean2(nir(:,:,i));
  imt(:,:,1,i) = red(:,:,i);
  imt(:,:,2,i) = grn(:,:,i);
  imt(:,:,3,i) = blu(:,:,i);
  imshow(imt(:,:,:,i));
  pause(0.1);
end

redmn = sort(redmn);
grnmn = sort(grnmn);
blumn = sort(blumn);
nirmn = sort(nirmn);
% plot(redmn,'r');hold on;plot(grnmn,'g');plot(blumn,'b');plot(nirmn,'k')

%% test stepping light upper and lower
clear;bit = 65535;close all;
myFolder = 'C:\Users\user\Pictures\basler\testimage\step1309ms40';
filePattern = fullfile(myFolder, '*.tiff');
jpegFiles = dir(filePattern);
for i = 1:length(jpegFiles)
    baseFileName = jpegFiles(i).name;
    fullFileName = fullfile(myFolder, baseFileName);
    im(:,:,i) = double(imread(fullFileName))/65536;
    immn(i) = mean2(im(:,:,i));
    imvar(i) = std2(im(:,:,i));
end

subplot(221)
plot(immn(1:4),imvar(1:4),'o');ylim([0,0.06]);xlim([0,1])
title('red');xlabel('Mean Intensity');ylabel('STD');grid on;
subplot(222)
plot(immn(9:12),imvar(9:12),'o');ylim([0,0.06]);xlim([0,1])
title('green');xlabel('Mean Intensity');ylabel('STD');grid on;
subplot(223)
plot(immn(17:20),imvar(17:20),'o');ylim([0,0.06]);xlim([0,1])
title('blue');xlabel('Mean Intensity');ylabel('STD');grid on;
subplot(224)
plot(immn(25:28),imvar(25:28),'o');ylim([0,0.06]);xlim([0,1])
title('nir');xlabel('Mean Intensity');ylabel('STD');grid on;
sgtitle('standard deviation with increasing intensity of upper half')
figure;
subplot(221)
plot(immn(5:8),imvar(5:8),'o');ylim([0,0.02]);xlim([0,0.3])
title('red');xlabel('Mean Intensity');ylabel('STD');grid on;
subplot(222)
plot(immn(13:16),imvar(13:16),'o');ylim([0,0.02]);xlim([0,0.3])
title('green');xlabel('Mean Intensity');ylabel('STD');grid on;
subplot(223)
plot(immn(21:24),imvar(21:24),'o');ylim([0,0.02]);xlim([0,0.3])
title('blue');xlabel('Mean Intensity');ylabel('STD');grid on;
subplot(224)
plot(immn(29:32),imvar(29:32),'o');ylim([0,0.02]);xlim([0,0.3])
title('nir');xlabel('Mean Intensity');ylabel('STD');grid on;
sgtitle('standard deviation with increasing intensity of lower half')

%%
maxy = max(imvar);
maxx = max(immn);
figure;
subplot(1,2,1);
plot(immn(1:4),imvar(1:4),'o');title('upper 4');grid
xlabel('Mean Intensity');ylabel('Variance');ylim([0,maxy]);
subplot(1,2,2);
plot(immn(5:8),imvar(5:8),'o');title('lower 4');grid
xlabel('Mean Intensity');ylabel('Variance');ylim([0,maxy]);
sgtitle('red')
figure;
subplot(1,2,1);
plot(immn(9:12),imvar(9:12),'o');title('upper 4');grid
xlabel('Mean Intensity');ylabel('Variance');ylim([0,maxy]);
subplot(1,2,2);
plot(immn(13:16),imvar(13:16),'o');title('lower 4');grid
xlabel('Mean Intensity');ylabel('Variance');ylim([0,maxy]);
sgtitle('green')
figure;
subplot(1,2,1);
plot(immn(17:20),imvar(17:20),'o');title('upper 4');grid
xlabel('Mean Intensity');ylabel('Variance');ylim([0,maxy]);
subplot(1,2,2);
plot(immn(21:24),imvar(21:24),'o');title('lower 4');grid
xlabel('Mean Intensity');ylabel('Variance');ylim([0,maxy]);
sgtitle('blue')
figure;
subplot(1,2,1);
plot(immn(25:28),imvar(25:28),'o');title('upper 4');grid
xlabel('Mean Intensity');ylabel('Variance');ylim([0,maxy]);
subplot(1,2,2);
plot(immn(29:32),imvar(29:32),'o');title('lower 4');grid
xlabel('Mean Intensity');ylabel('Variance');ylim([0,maxy]);
sgtitle('Nir')

%% test single light
clear;
bit = 65535;close all;
myFolder = 'C:\Users\user\Pictures\basler\testimage\sin1309ms100';
filePattern = fullfile(myFolder, '*.tiff');
jpegFiles = dir(filePattern);
for i = 1:length(jpegFiles)
    baseFileName = jpegFiles(i).name;
    fullFileName = fullfile(myFolder, baseFileName);
%     if i == 5 || 13 || 21 || 29
%         im(:,:,i) = (imread(fullFileName));
%     else 
        im(:,:,i) = double(imread(fullFileName))/bit;
%     end
    imvar(i) = std2(im(:,:,i))^2;
    immn(i) = mean2(im(:,:,i));
end

figure;
subplot(1,2,1);
plot(immn(1:2:8),'o');title('upper 4');grid
xlabel('Position');ylabel('Mean Intensity');ylim([0,1]);
subplot(1,2,2);
plot(immn(2:2:8),'o');title('lower 4');grid
xlabel('Position');ylabel('Mean Intensity');ylim([0,1]);
sgtitle('red')
figure;
subplot(1,2,1);
plot(immn(9:2:16),'o');title('upper 4');grid
xlabel('Position');ylabel('Mean Intensity');ylim([0,1]);
subplot(1,2,2);
plot(immn(10:2:16),'o');title('lower 4');grid
xlabel('Position');ylabel('Mean Intensity');ylim([0,1]);
sgtitle('green');
figure;
subplot(1,2,1);
plot(immn(17:2:24),'o');title('upper 4');grid
xlabel('Position');ylabel('Mean Intensity');ylim([0,1]);
subplot(1,2,2);
plot(immn(18:2:24),'o');title('lower 4');grid
xlabel('Position');ylabel('Mean Intensity');ylim([0,1]);
sgtitle('blue');
figure;
subplot(1,2,1);
plot(immn(25:2:32),'o');title('upper 4');grid
xlabel('Position');ylabel('Mean Intensity');ylim([0,1]);
subplot(1,2,2);
plot(immn(26:2:32),'o');title('lower 4');grid
xlabel('Position');ylabel('Mean Intensity');ylim([0,1]);
sgtitle('NIR');

