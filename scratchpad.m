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
clear;bit = 65535;close all;
myFolder = 'C:\Users\user\Pictures\basler\testimage\step1209';
filePattern = fullfile(myFolder, '*.tiff');
jpegFiles = dir(filePattern);
for i = 1:24
  baseFileName = jpegFiles(i).name;
  fullFileName = fullfile(myFolder, baseFileName);
  im(:,:,i) = double(imread(fullFileName))/bit;
  redvar(i) = std2(im(:,:,i))^2;
  redmn(i) = mean2(im(:,:,i));
end
for green = 25:48
  baseFileName = jpegFiles(green).name;
  fullFileName = fullfile(myFolder, baseFileName);
  im(:,:,green) = double(imread(fullFileName))/bit;
  greenvar(green-24) = std2(im(:,:,green))^2;
  greenmn(green-24) = mean2(im(:,:,green));
end
for blue = 49:72
  baseFileName = jpegFiles(blue).name;
  fullFileName = fullfile(myFolder, baseFileName);
  im(:,:,blue) = double(imread(fullFileName))/bit;
  bluevar(blue-48) = std2(im(:,:,blue))^2;
  bluemn(blue-48) = mean2(im(:,:,blue));
end
for ir = 73:96
  baseFileName = jpegFiles(ir).name;
  fullFileName = fullfile(myFolder, baseFileName);
  im(:,:,ir) = double(imread(fullFileName))/bit;
  irvar(ir-72) = std2(im(:,:,ir))^2;
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
plot(redmn(1:4),redvar(1:4),'o');ylim([0,0.006]);xlim([0,1])
title('red');xlabel('Mean Intensity');ylabel('Variance');grid on;
subplot(222)
plot(greenmn(1:4),greenvar(1:4),'o');ylim([0,0.006]);xlim([0,1])
title('green');xlabel('Mean Intensity');ylabel('Variance');grid on;
subplot(223)
plot(bluemn(1:4),bluevar(1:4),'o');ylim([0,0.006]);xlim([0,1])
title('blue');xlabel('Mean Intensity');ylabel('Variance');grid on;
subplot(224)
plot(irmn(1:4),irvar(1:4),'o');ylim([0,0.006]);xlim([0,1])
title('nir');xlabel('Mean Intensity');ylabel('Variance');grid on;
sgtitle('Variance with Increasing Intensity of Upper sources')
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
bit = 65535;close all;clear immn imvar im;
myFolder = 'C:\Users\user\Pictures\basler\testimage\ustep110ms11g15';
filePattern = fullfile(myFolder, '*.tiff');
jpegFiles = dir(filePattern);
for i = 1:length(jpegFiles)
    baseFileName = jpegFiles(i).name;
    fullFileName = fullfile(myFolder, baseFileName);
    im = (bitshift(imread(fullFileName),-6));
    immn(i) = mean(im(:));
    imvar(i) = var(double(im(:)));
end
%% 4 pat 
clear redmn grnmn blumn nirmn redvr grnvr bluvr nirvr
for k = 1:5
    redmn(k)    =  mean(immn(k:5:150));
    redmn(k+5)  =  mean(immn(k+150:5:300));
    redmn(k+10) =  mean(immn(k+300:5:450));
    redmn(k+15) =  mean(immn(k+450:5:600));
    redvr(k)    =  mean(imvar(k:5:150));
    redvr(k+5)  =  mean(imvar(k+150:5:300));
    redvr(k+10) =  mean(imvar(k+300:5:450));
    redvr(k+15) =  mean(imvar(k+450:5:600));
    grnmn(k)    =  mean(immn(k+600:5:750));
    grnmn(k+5)  =  mean(immn(k+750:5:900));
    grnmn(k+10) =  mean(immn(k+900:5:1050));
    grnmn(k+15) =  mean(immn(k+1050:5:1200));
    grnvr(k)    =  mean(imvar(k+600:5:750));
    grnvr(k+5)  =  mean(imvar(k+750:5:900));
    grnvr(k+10) =  mean(imvar(k+900:5:1050));
    grnvr(k+15) =  mean(imvar(k+1050:5:1200));
    blumn(k)    =  mean(immn(k+1200:5:1350));
    blumn(k+5)  =  mean(immn(k+1350:5:1500));
    blumn(k+10) =  mean(immn(k+1500:5:1650));
    blumn(k+15) =  mean(immn(k+1650:5:1800));
    bluvr(k)    =  mean(imvar(k+1200:5:1350));
    bluvr(k+5)  =  mean(imvar(k+1350:5:1500));
    bluvr(k+10) =  mean(imvar(k+1500:5:1650));
    bluvr(k+15) =  mean(imvar(k+1650:5:1800));
    nirmn(k)    =  mean(immn(k+1800:5:1950));
    nirmn(k+5)  =  mean(immn(k+1950:5:2100));
    nirmn(k+10) =  mean(immn(k+2100:5:2250));
    nirmn(k+15) =  mean(immn(k+2250:5:2400));
    nirvr(k)    =  mean(imvar(k+1800:5:1950));
    nirvr(k+5)  =  mean(imvar(k+1950:5:2100));
    nirvr(k+10) =  mean(imvar(k+2100:5:2250));
    nirvr(k+15) =  mean(imvar(k+2250:5:2400));

end
%%
for p = 1:5
   plot(immn(p+1200:5:1800),imvar(p+1200:5:1800),'.');
   hold on;
end
%%
for k = 1:8

    redmn(k)    =  median(immn(k:8:160));
    redmn(k+8)  =  median(immn(k+160:8:320));
    redmn(k+16) =  median(immn(k+320:8:480));
    redvr(k)    = median(imvar(k:8:160));
    redvr(k+8)  = median(imvar(k+160:8:320));
    redvr(k+16) = median(imvar(k+320:8:480));
    
    grnmn(k)    = median(immn(k+480:8:640));
    grnmn(k+8)  = median(immn(k+640:8:800));
    grnmn(k+16) = median(immn(k+800:8:960));
    grnvr(k)    = median(imvar(k+480:8:640));
    grnvr(k+8)  = median(imvar(k+640:8:800));
    grnvr(k+16) = median(imvar(k+800:8:960));
    
    blumn(k)    = median(immn(k+960:8:1120));
    blumn(k+8)  = median(immn(k+1120:8:1280));
    blumn(k+16) = median(immn(k+1280:8:1440));
    bluvr(k)    = median(imvar(k+960:8:1120));
    bluvr(k+8)  = median(imvar(k+1120:8:1280));
    bluvr(k+16) = median(imvar(k+1280:8:1440));
    
    nirmn(k)    = median(immn(k+1440:8:1600));
    nirmn(k+8)  = median(immn(k+1600:8:1760));
    nirmn(k+16) = median(immn(k+1760:8:1920));
    nirvr(k)    = median(imvar(k+1440:8:1600));
    nirvr(k+8)  = median(imvar(k+1600:8:1760));
    nirvr(k+16) = median(imvar(k+1760:8:1920));
end
%%
for k = 1:5
    rmn(k) = mean(redmn(k:5:20));
    gmn(k) = mean(grnmn(k:5:20));
    bmn(k) = mean(blumn(k:5:20));
    nmn(k) = mean(nirmn(k:5:20));
    rvr(k) = mean(redvr(k:5:20));
    gvr(k) = mean(grnvr(k:5:20));
    bvr(k) = mean(bluvr(k:5:20));
    nvr(k) = mean(nirvr(k:5:20));
end
%%
subplot(221);
imagesc(im{281});colorbar;caxis([0,400]);title('1 souces');
subplot(222);
imagesc(im{282});colorbar;caxis([00,400]);title('2 souces');
subplot(223);
imagesc(im{283});colorbar;caxis([00,400]);title('3 souces');
subplot(224);
imagesc(im{284});colorbar;caxis([00,400]);title('4 souces');
%%
figure;
subplot(221);plot(reshape(redmn,4,6),'o');ylim([0,400]);title('red');
xlabel('C');ylabel('Mean');grid
subplot(222);plot(reshape(grnmn,4,6),'o');ylim([0,400]);title('grn');
xlabel('C');ylabel('Mean');grid
subplot(223);plot(reshape(blumn,4,6),'o');ylim([0,600]);title('blu');
xlabel('C');ylabel('Mean');grid
subplot(224);plot(reshape(nirmn,4,6),'o');ylim([0,1000]);title('nir')
xlabel('C');ylabel('Mean');grid
sgtitle('Upper half increasing intensity 6 patterns')
%%
figure;
subplot(2,2,1);
plot(rmn,rvr,'.');ylim([0,700]);xlim([0,500])
xlabel('Mean');ylabel('Variance');title('Red');grid
subplot(2,2,2);
plot(gmn,gvr,'.');ylim([0,700]);xlim([0,600])
xlabel('Mean');ylabel('Variance');title('Green');grid
subplot(2,2,3);
plot(bmn,bvr,'.');ylim([0,900]);xlim([0,700])
xlabel('Mean');ylabel('Variance');title('Blue');grid
subplot(2,2,4);
plot(nmn,nvr,'.');ylim([0,1500]);xlim([0,1000])
xlabel('Mean');ylabel('Variance');title('NIR');grid
sgtitle('Mean vs Variance with 15dB gain 11ms exp Upper-half');
%%
upperlim = max(redvr);
% figure;
subplot(2,2,1);
plot(redmn(1:5),redvr(1:5),'.');ylim([0,upperlim]);%hold on;
% xlabel('Mean');ylabel('Variance');title('pat 1');grid
subplot(2,2,2);hold on;
plot(redmn(6:10),redvr(6:10),'s');ylim([0,upperlim]);
% xlabel('Mean');ylabel('Variance');title('pat 2');grid
subplot(2,2,3);hold on;
plot(redmn(11:15),redvr(11:15),'^');ylim([0,upperlim]);
% xlabel('Mean');ylabel('Variance');title('pat 3');grid
subplot(2,2,4);hold on;
plot(redmn(16:20),redvr(16:20),'o');ylim([0,upperlim]);
% xlabel('Mean');ylabel('Variance');title('pat 4');grid
% subplot(2,3,5);
% plot(redmn(17:20),redvr(17:20),'v');ylim([0,upperlim]);
% xlabel('Mean');ylabel('Variance');title('pat 5');grid
% subplot(2,3,6);
% plot(redmn(21:24),redvr(21:24),'<');ylim([0,upperlim]);
% xlabel('Mean');ylabel('Variance');title('pat 6');grid
% sgtitle('Red')
%%
upperlim = max(redvr);
% figure;
subplot(2,2,1);
plot(mnmn(1:5),vrvr(1:5),'.');ylim([0,upperlim]);%hold on;
% xlabel('Mean');ylabel('Variance');title('pat 1');grid
subplot(2,2,2);hold on;
plot(mnmn(6:10),vrvr(6:10),'s');ylim([0,upperlim]);
% xlabel('Mean');ylabel('Variance');title('pat 2');grid
subplot(2,2,3);hold on;
plot(mnmn(11:15),vrvr(11:15),'^');ylim([0,upperlim]);
% xlabel('Mean');ylabel('Variance');title('pat 3');grid
subplot(2,2,4);hold on;
plot(mnmn(16:20),vrvr(16:20),'o');ylim([0,upperlim]);
%%

upperlim = max(grnvr);
figure;
subplot(2,2,1);
plot(grnmn(1:5),grnvr(1:5),'.');ylim([0,upperlim]);%hold on;
xlabel('Mean');ylabel('Variance');title('pat 1');grid
subplot(2,2,2);
plot(grnmn(6:10),grnvr(6:10),'s');ylim([0,upperlim]);
xlabel('Mean');ylabel('Variance');title('pat 2');grid
subplot(2,2,3);
plot(grnmn(11:15),grnvr(11:15),'^');ylim([0,upperlim]);
xlabel('Mean');ylabel('Variance');title('pat 3');grid
subplot(2,2,4);
plot(grnmn(16:20),grnvr(16:20),'o');ylim([0,upperlim]);
xlabel('Mean');ylabel('Variance');title('pat 4');grid
% subplot(2,3,5);
% plot(grnmn(17:20),grnvr(17:20),'v');ylim([0,upperlim]);
% xlabel('Mean');ylabel('Variance');title('pat 5');grid
% subplot(2,3,6);
% plot(grnmn(21:24),grnvr(21:24),'<');ylim([0,upperlim]);
% xlabel('Mean');ylabel('Variance');title('pat 6');grid
% sgtitle('grn')


upperlim = max(bluvr);
figure;
subplot(2,2,1);
plot(blumn(1:5),bluvr(1:5),'.');ylim([0,upperlim]);%hold on;
xlabel('Mean');ylabel('Variance');title('pat 1');grid
subplot(2,2,2);
plot(blumn(6:10),bluvr(6:10),'s');ylim([0,upperlim]);
xlabel('Mean');ylabel('Variance');title('pat 2');grid
subplot(2,2,3);
plot(blumn(11:15),bluvr(11:15),'^');ylim([0,upperlim]);
xlabel('Mean');ylabel('Variance');title('pat 3');grid
subplot(2,2,4);
plot(blumn(16:20),bluvr(16:20),'o');ylim([0,upperlim]);
xlabel('Mean');ylabel('Variance');title('pat 4');grid
% subplot(2,3,5);
% plot(blumn(17:20),bluvr(17:20),'v');ylim([0,upperlim]);
% xlabel('Mean');ylabel('Variance');title('pat 5');grid
% subplot(2,3,6);
% plot(blumn(21:24),bluvr(21:24),'<');ylim([0,upperlim]);
% xlabel('Mean');ylabel('Variance');title('pat 6');grid
% sgtitle('blu');

upperlim = max(nirvr);
figure;
subplot(2,2,1);
plot(nirmn(1:5),nirvr(1:5),'.');ylim([0,upperlim]);%hold on;
xlabel('Mean');ylabel('Variance');title('pat 1');grid
subplot(2,2,2);
plot(nirmn(6:10),nirvr(6:10),'s');ylim([0,upperlim]);
xlabel('Mean');ylabel('Variance');title('pat 2');grid
subplot(2,2,3);
plot(nirmn(11:15),nirvr(11:15),'^');ylim([0,upperlim]);
xlabel('Mean');ylabel('Variance');title('pat 3');grid
subplot(2,2,4);
plot(nirmn(16:20),nirvr(16:20),'o');ylim([0,upperlim]);
xlabel('Mean');ylabel('Variance');title('pat 4');grid
% subplot(2,3,5);
% plot(nirmn(17:20),nirvr(17:20),'v');ylim([0,upperlim]);
% xlabel('Mean');ylabel('Variance');title('pat 5');grid
% subplot(2,3,6);
% plot(nirmn(21:24),nirvr(21:24),'<');ylim([0,upperlim]);
% xlabel('Mean');ylabel('Variance');title('pat 6');grid
% sgtitle('nir')

%%
% ylim([0,0.0001]);xlim([0,0.5]);title('red');xlabel('Mean');ylabel('\sigma^2');grid
subplot(222);plot(grnmn(1:4),grnvr(1:4),'.');hold on;
% plot(grnmn(5:8),grnvr(5:8),'o');
% ylim([0,0.0002]);xlim([0,0.5]);title('green');xlabel('Mean');ylabel('\sigma^2');grid
subplot(223);plot(blumn(1:4),bluvr(1:4),'.');hold on;
% plot(blumn(5:8),bluvr(5:8),'o');
% ylim([0,0.0002]);xlim([0,0.5]);title('blue');xlabel('Mean');ylabel('\sigma^2');grid
subplot(224);plot(nirmn(1:4),nirvr(1:4),'.');hold on;
% plot(nirmn(5:8),nirvr(5:8),'o');
% ylim([0,0.0003]);xlim([0,1]);title('nir');xlabel('Mean');ylabel('\sigma^2');grid 
% figure;
% subplot(221);plot(redmn(5:8),redvr(5:8),'.');ylim([0,0.001])
% subplot(222);plot(grnmn(5:8),grnvr(5:8),'.');ylim([0,0.0002])
% subplot(223);plot(blumn(5:8),bluvr(5:8),'.');ylim([0,0.0005])
% subplot(224);plot(nirmn(5:8),nirvr(5:8),'.');ylim([0,0.002])
%%
% figure;
% plot(immn(1:5),imvar(1:5),'o');%ylim([0,0.005]);xlim([0,1])
% title('Variance with Increasing Sources of Upper Red sources');
% xlabel('Source Activated');ylabel('Variance');grid on;
figure;
subplot(221)
plot(immn(1:5),imvar(1:5),'o');ylim([0,0.005]);xlim([0,1])
title('red');xlabel('Mean Intensity');ylabel('Variance');grid on;
subplot(222)
plot(immn(10:14),imvar(10:14),'o');ylim([0,0.005]);xlim([0,1])
title('green');xlabel('Mean Intensity');ylabel('Variance');grid on;
subplot(223)
plot(immn(19:23),imvar(19:23),'o');ylim([0,0.005]);xlim([0,1])
title('blue');xlabel('Mean Intensity');ylabel('Variance');grid on;
subplot(224)
plot(immn(28:32),imvar(28:32),'o');ylim([0,0.005]);xlim([0,1])
title('nir');xlabel('Mean Intensity');ylabel('Variance');grid on;
sgtitle('Variance with Increasing Intensity of Upper sources')
% figure;
% subplot(221)
% plot(immn(1:4),imvar(1:4),'o');ylim([0,0.005]);xlim([0,1])
% title('red');xlabel('Mean Intensity');ylabel('Variance');grid on;
% subplot(222)
% plot(immn(5:8),imvar(5:8),'o');ylim([0,0.005]);xlim([0,1])
% title('green');xlabel('Mean Intensity');ylabel('Variance');grid on;
% subplot(223)
% plot(immn(9:12),imvar(9:12),'o');ylim([0,0.005]);xlim([0,1])
% title('blue');xlabel('Mean Intensity');ylabel('Variance');grid on;
% subplot(224)
% plot(immn(13:16),imvar(13:16),'o');ylim([0,0.005]);xlim([0,1])
% title('nir');xlabel('Mean Intensity');ylabel('Variance');grid on;
% sgtitle('Variance with Increasing Intensity of Lower sources')

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
clear immn imvar;
bit = 65535;close all;
myFolder = 'C:\Users\user\Pictures\basler\testimage\sin2309ms110';
filePattern = fullfile(myFolder, '*.tiff');
jpegFiles = dir(filePattern);
for i = 1:length(jpegFiles)
    baseFileName = jpegFiles(i).name;
    fullFileName = fullfile(myFolder, baseFileName);
    im = bitshift(imread(fullFileName),-6);
    imvar(i) = var(double(im(:)));
    immn(i) = median(im(:));
end
%%
for k = 1:8
    redmn(k) = mean(immn(k:8:i/4));
    grnmn(k) = mean(immn(i/4+k:8:i/2));
    blumn(k) = mean(immn(i/2+k:8:i/4*3));
    nirmn(k) = mean(immn(i/4*3+k:8:i));
    redvr(k) = mean(imvar(k:8:i/4));
    grnvr(k) = mean(imvar(i/4+k:8:i/2));
    bluvr(k) = mean(imvar(i/2+k:8:i/4*3));
    nirvr(k) = mean(imvar(i/4*3+k:8:i));
end

figure;
subplot(2,2,1);
plot(redmn(1:2:8),'o');title('Upper 4');grid
ylabel('Mean Intensity');xlabel('Position');ylim([0,1022]);
subplot(2,2,2); 
plot(redmn(2:2:8),'o');title('Lower 4');grid
ylabel('Mean Intensity');xlabel('Position');ylim([0,1022]);
subplot(2,2,3);
plot(redvr(1:2:8),'o');title('Upper 4');grid
xlabel('Position');ylabel('Variance');ylim([0,3000]);
subplot(2,2,4);
plot(redvr(2:2:8),'o');title('Lower 4');grid
xlabel('Position');ylabel('Variance');ylim([0,3000]);
sgtitle('Red') 

figure; % green
subplot(2,2,1);
plot(grnmn(1:2:8),'o');title('Upper 4');grid
ylabel('Mean Intensity');xlabel('Position');ylim([0,1022]);
subplot(2,2,2);
plot(grnmn(2:2:8),'o');title('Lower 4');grid
ylabel('Mean Intensity');xlabel('Position');ylim([0,1022]);
subplot(2,2,3);
plot(grnvr(1:2:8),'o');title('Upper 4');grid
xlabel('Position');ylabel('Variance');ylim([0,3000]);
subplot(2,2,4);
plot(grnvr(2:2:8),'o');title('Lower 4');grid
xlabel('Position');ylabel('Variance');ylim([0,3000]);
sgtitle('Green');

figure; % blue
subplot(2,2,1);
plot(blumn(1:2:8),'o');title('Upper 4');grid
ylabel('Mean Intensity');xlabel('Position');ylim([0,1022]);
subplot(2,2,2);
plot(blumn(2:2:8),'o');title('Lower 4');grid
ylabel('Mean Intensity');xlabel('Position');ylim([0,1022]);
subplot(2,2,3);
plot(bluvr(1:2:8),'o');title('Upper 4');grid
xlabel('Position');ylabel('Variance');ylim([0,3000]);
subplot(2,2,4);
plot(bluvr(2:2:8),'o');title('Lower 4');grid
xlabel('Position');ylabel('Variance');ylim([0,3000]);
sgtitle('Blue');

figure; % nir
subplot(2,2,1);
plot(nirmn(1:2:8),'o');title('Upper 4');grid
ylabel('Mean Intensity');xlabel('Position');ylim([0,1022]);
subplot(2,2,2);
plot(nirmn(2:2:8),'o');title('Lower 4');grid
ylabel('Mean Intensity');xlabel('Position');ylim([0,1022]);
subplot(2,2,3);
plot(nirvr(1:2:8),'o');title('Upper 4');grid
xlabel('Position');ylabel('Variance');ylim([0,3000]);
subplot(2,2,4);
plot(nirvr(2:2:8),'o');title('Lower 4');grid
xlabel('Position');ylabel('Variance');ylim([0,3000]);
sgtitle('NIR');

%% black level test
clear immn imvar
bit = 65535;close all;
myFolder = 'C:\Users\user\Pictures\basler\testimage\blacklevel';
filePattern = fullfile(myFolder, '*.tiff');
jpegFiles = dir(filePattern);
for i = 1:length(jpegFiles)
    baseFileName = jpegFiles(i).name;
    fullFileName = fullfile(myFolder, baseFileName);
    im = double(bitshift(imread(fullFileName),-6))/1022;
    imvar(i) = var(double(im(:)));
    immn(i) = mean(im(:));
end
immn2 = reshape(immn,15,11)';
immn3 = mean(immn2);
imvar2 = reshape(imvar,15,11)';
imvar3 = mean(imvar2);
% plot(immn3(1:5),'.');figure;
plot(immn3(2:5),imvar3(2:5),'.k');hold on;
plot(immn3(7:10),imvar3(7:10),'ob');
plot(immn3(12:15),imvar3(12:15),'xr');grid minor;

xlabel('Mean Intensity');ylabel('\sigma^2');
legend('0db gain','12db gain','18db gain');
title('Black Level (64,128,192,256)');
%% ignore this
bit = 65535;close all;
myFolder = 'D:\Tailong';
filePattern = fullfile(myFolder, '*.PNG');
jpegFiles = dir(filePattern);
for i = 33:length(jpegFiles)
    baseFileName = jpegFiles(i).name;
    fullFileName = fullfile(myFolder, baseFileName);
    im = (imread(fullFileName));
    cim(:,:,i-32) = rgb2gray(imcrop(im,rect));
%     pause;
    rim(:,:,i-32) = imresize(cim(:,:,i-32),[100,100]);
    name = ['ls',num2str(i-32),'.png'];
    imwrite(rim(:,:,i-32),name);
end
%% per pixel mean and variance analysis
clear immn imvar im impixm impixv
bit = 65535;close all;
myFolder = 'C:\Users\user\Pictures\basler\testimage\lstep110ms32g15';
filePattern = fullfile(myFolder, '*.tiff');
jpegFiles = dir(filePattern);
for i = 1:length(jpegFiles)
    baseFileName = jpegFiles(i).name;
    fullFileName = fullfile(myFolder, baseFileName);
    im(:,:,i) = double(bitshift(imread(fullFileName),-6));
    immn(i) = mean2(im(:,:,i));
    imvar(i) = std2((im(:,:,i))).^2;
end
%%
figure;
subplot(1,5,1);imagesc(im(:,:,1));
subplot(1,5,2);imagesc(im(:,:,2));
subplot(1,5,3);imagesc(im(:,:,3));
subplot(1,5,4);imagesc(im(:,:,4));
subplot(1,5,5);imagesc(im(:,:,5));
figure
subplot(1,5,1);imagesc(im(:,:,6));
subplot(1,5,2);imagesc(im(:,:,7));
subplot(1,5,3);imagesc(im(:,:,8));
subplot(1,5,4);imagesc(im(:,:,9));
subplot(1,5,5);imagesc(im(:,:,10));
%%
final = []; %                 im per pat
start = []; %           im per mat |  im per mat
for p = 1:16 %color*patpcol     v  v   v
    final =     [final,repmat(p*5*30,1,5)];
    start =     [start,repmat((p-1)*5*29,1,5)];
end

for k = 1:80 % image per 2 patterns
    for r = 1:96
    for c = 1:96
        impixm(r,c,k) = mean(im(r,c,start(k)+k:5:final(k)));
        impixv(r,c,k) = var(im(r,c,start(k)+k:5:final(k)));
        
    end
    end
    mnmn(k) = mean2(impixm(:,:,k));
    vrvr(k) = std2(impixm(:,:,k))^2;
%     imm(:,:,k) = dyaddown(impixm(:,:,k),'c');
%     imv(:,:,k) = dyaddown(impixv(:,:,k),'c');
%     imm(:,:,k) = imresize(impixm(:,:,k),[1,96]);
%     imv(:,:,k) = imresize(impixv(:,:,k),[1,96]);
%     subplot(1,2,1)
%     imagesc(imm(:,:,k));
%     subplot(1,2,2)
%     imagesc(imv(:,:,k));drawnow;
end
%% binning
% 4 color 4 patterns 5 image each
for i = 1:80
   a = impixm(:,:,i);
   a = a(:);
   b = impixv(:,:,i);
   b = b(:);
   ab = [a,b];
   ab = sortrows(((ab)));

   % 10 bins across the pixels
   for j = 1:10       
        amn(i,j) = mean(ab(1+(j-1)*921:j*921,1));
        avr(i,j) = mean(ab(1+(j-1)*921:j*921,2)); 
%         plot(amn(i,j),avr(i,j),'.');hold on;
%         drawnow;
   end
end
% plot
for o = 1:4
    omn(o,:) = reshape(amn(1+20*(o-1):20*o,:),1,200);
    ovr(o,:) = reshape(avr(1+20*(o-1):20*o,:),1,200);
end

% subplot(2,2,1)
plot(omn(1,:),ovr(1,:),'.r');grid;xlim([0,500]);ylim([0,500]);
fitcoeff = polyfit(omn(1,:),ovr(1,:),1)
xfit = linspace(0,500,500);
yfit = polyval(fitcoeff,xfit);
hold on;%plot(xfit,yfit,'k-');
xlabel('Mean');ylabel('\sigma^2');%title('Red');
% subplot(2,2,2)
plot(omn(2,:),ovr(2,:),'.g');grid;xlim([0,600]);ylim([0,600]);
fitcoeff = polyfit(omn(2,:),ovr(2,:),1)
xfit = linspace(0,600,600);
yfit = polyval(fitcoeff,xfit);
hold on;%plot(xfit,yfit,'k-');
% xlabel('Mean');ylabel('\sigma^2');title('Green');
% subplot(2,2,3)
plot(omn(3,:),ovr(3,:),'.b');grid;xlim([0,700]);ylim([0,700]);
fitcoeff = polyfit(omn(3,:),ovr(3,:),1)
xfit = linspace(0,700,700);
yfit = polyval(fitcoeff,xfit);
hold on;%plot(xfit,yfit,'k-');
% xlabel('Mean');ylabel('\sigma^2');title('Blue');
% subplot(2,2,4)
plot(omn(4,:),ovr(4,:),'.m');grid;xlim([0,1000]);ylim([0,1000]);
fitcoeff = polyfit(omn(4,:),ovr(4,:),1)
xfit = linspace(0,1000,1000);
yfit = polyval(fitcoeff,xfit);
hold on;%plot(xfit,yfit,'k-');
% xlabel('Mean');ylabel('\sigma^2');title('NIR');
sgtitle('Average Intensity vs Variance across 4 LEDs on Upper-half')
%%
% mean per pixel
for i = 1:80
    pixmn(i,:) = reshape(impixm(:,:,i),[1,96^2]);
    pixvr(i,:) = reshape(impixv(:,:,i),[1,96^2]);
%     subplot(3,8,i)
%     plot(pixmn(i,:),pixvr(i,:),'.');xlim([0,500]);ylim([0,600]);grid
%     xlabel('Mean');ylabel('\sigma^2');
end
% sgtitle('Var vs Mean per pixel')

redmn = mean(pixmn,2);
redvr = mean(pixvr,2);
%%
subplot(221);
imagesc((impixv(:,:,4)));colorbar;caxis([0,500])
subplot(222);
imagesc((impixv(:,:,3)));colorbar;caxis([0,500])
subplot(223);
imagesc((impixv(:,:,2)));colorbar;caxis([0,500])
subplot(224);
imagesc((impixv(:,:,1)));colorbar;caxis([0,500])
figure;
subplot(221);
imagesc((impixm(:,:,4)));colorbar;caxis([280,380])
subplot(222);
imagesc((impixm(:,:,3)));colorbar;caxis([200,300])
subplot(223);
imagesc((impixm(:,:,2)));colorbar;caxis([120,220])
subplot(224);
imagesc((impixm(:,:,1)));colorbar;caxis([60,160])

%%
for o = 1:4
    subplot(2,2,o)
    plot((pixmn(1+5*(o-1),:)),(pixvr(1+5*(o-1),:)),'.','MarkerSize',2);hold on;
    plot((pixmn(2+5*(o-1),:)),(pixvr(2+5*(o-1),:)),'.','MarkerSize',2);
    plot((pixmn(3+5*(o-1),:)),(pixvr(3+5*(o-1),:)),'.','MarkerSize',2);
    plot((pixmn(4+5*(o-1),:)),(pixvr(4+5*(o-1),:)),'.','MarkerSize',2);
    plot((pixmn(5+5*(o-1),:)),(pixvr(5+5*(o-1),:)),'.','MarkerSize',2);
    plot(amn(1+5*(o-1):5*o,:),avr(1+5*(o-1):5*o,:),'o','MarkerSize',4,'MarkerFaceColor','k','MarkerEdgeColor','k');
%     legend('no light','1 Light','2 Lights','3 Lights','4 Lights','Average');
    grid;xlabel('Mean');ylabel('\sigma^2');
end
sgtitle('Variance vs Mean of Red LED across 4 Illumination Patterns');
%%
for o = 5:8
    subplot(2,2,o-4)
    plot((pixmn(1+5*(o-1),:)),(pixvr(1+5*(o-1),:)),'.','MarkerSize',1);hold on;
    plot((pixmn(2+5*(o-1),:)),(pixvr(2+5*(o-1),:)),'.','MarkerSize',1);
    plot((pixmn(3+5*(o-1),:)),(pixvr(3+5*(o-1),:)),'.','MarkerSize',1);
    plot((pixmn(4+5*(o-1),:)),(pixvr(4+5*(o-1),:)),'.','MarkerSize',1);
    plot((pixmn(5+5*(o-1),:)),(pixvr(5+5*(o-1),:)),'.','MarkerSize',1);
    plot(amn(1+5*(o-1):5*o,:),avr(1+5*(o-1):5*o,:),'o','MarkerSize',4,'MarkerFaceColor','k','MarkerEdgeColor','k');
    legend('no light','1 Light','2 Lights','3 Lights','4 Lights','Average');
    grid;xlabel('Mean');ylabel('\sigma^2');%ylim([0,600])
end
sgtitle('Variance vs Mean of Green LED across 4 Illumination Patterns');
%%
for o = 9:9
%     subplot(2,2,o-8)
    plot((pixmn(1+5*(o-1),:)),(pixvr(1+5*(o-1),:)),'.','MarkerSize',3);hold on;
    plot((pixmn(2+5*(o-1),:)),(pixvr(2+5*(o-1),:)),'.','MarkerSize',3);
    plot((pixmn(3+5*(o-1),:)),(pixvr(3+5*(o-1),:)),'.','MarkerSize',3);
    plot((pixmn(4+5*(o-1),:)),(pixvr(4+5*(o-1),:)),'.','MarkerSize',3);
    plot((pixmn(5+5*(o-1),:)),(pixvr(5+5*(o-1),:)),'.','MarkerSize',3);
    plot(amn(1+5*(o-1):5*o,:),avr(1+5*(o-1):5*o,:),'o','MarkerSize',3,'MarkerFaceColor','k','MarkerEdgeColor','k');
    legend('no light','1 Light','2 Lights','3 Lights','4 Lights','Average');
    grid;xlabel('Mean');ylabel('\sigma^2');%ylim([0,800])
end
sgtitle('Variance vs Mean of Blue LED across 4 Illumination Patterns');
%%
for o = 13:16
    subplot(2,2,o-12)
    plot((pixmn(1+5*(o-1),:)),(pixvr(1+5*(o-1),:)),'.','MarkerSize',2);hold on;
    plot((pixmn(2+5*(o-1),:)),(pixvr(2+5*(o-1),:)),'.','MarkerSize',2);
    plot((pixmn(3+5*(o-1),:)),(pixvr(3+5*(o-1),:)),'.','MarkerSize',2);
    plot((pixmn(4+5*(o-1),:)),(pixvr(4+5*(o-1),:)),'.','MarkerSize',2);
    plot((pixmn(5+5*(o-1),:)),(pixvr(5+5*(o-1),:)),'.','MarkerSize',2);
    plot(amn(1+5*(o-1):5*o,:),avr(1+5*(o-1):5*o,:),'o','MarkerSize',4,'MarkerFaceColor','k','MarkerEdgeColor','k');
    legend('no light','1 Light','2 Lights','3 Lights','4 Lights','Average');
    grid;xlabel('Mean');ylabel('\sigma^2');%ylim([0,1022]);xlim([0,1022])
end
sgtitle('Variance vs Mean of NIR LED across 4 Illumination Patterns');
%%
for a = 1:4
    redm(a) = mean(redmn(a:8:24));
    grnm(a) = mean(redmn(a+24:8:48));
    blum(a) = mean(redmn(a+48:8:72));
    nirm(a) = mean(redmn(a+72:8:96));
    redv(a) = mean(redvr(a:8:24));
    grnv(a) = mean(redvr(a+24:8:48));
    bluv(a) = mean(redvr(a+48:8:72));
    nirv(a) = mean(redvr(a+72:8:96));
    
end
subplot(221);
plot(redm,redv,'.','MarkerSize',9);grid;xlabel('Mean');ylabel('\sigma^2');
title('Red');ylim([0,200]);xlim([0,300])
subplot(222);
plot(grnm,grnv,'.','MarkerSize',9);grid;xlabel('Mean');ylabel('\sigma^2');
title('Green');ylim([0,200]);xlim([0,300])
subplot(223);
plot(blum,bluv,'.','MarkerSize',9);grid;xlabel('Mean');ylabel('\sigma^2');
title('Blue');ylim([0,300]);xlim([0,500])
subplot(224);
plot(nirm,nirv,'.','MarkerSize',9);grid;xlabel('Mean');ylabel('\sigma^2');
title('NIR');ylim([0,500]);xlim([0,900])
sgtitle('Average Intensity Mean vs Variance across 4 LEDs')


