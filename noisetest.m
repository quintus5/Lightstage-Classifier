%% noisefree image
bit = 65535;
myFolder = 'C:\Users\roboticimaging\Documents\kronoslightstage\classtest\plate3\100ms0db';
filePattern = fullfile(myFolder, '*.tiff');
jpegFiles = dir(filePattern);
numpos = 8; % light position taken
numcolor = 1;
for j = 1:numpos
    ima = zeros(288,288,numpos);
    a = 1;
    for k = j:numpos:length(jpegFiles)
      baseFileName = jpegFiles(k).name;
      fullFileName = fullfile(myFolder, baseFileName);
      im(:,:,a,j) = double(imread(fullFileName))/bit;
      ima(:,:,j) = ima(:,:,j)+im(:,:,a,j);
      a = a+1;
    end
    noisefreeim{j} = ima(:,:,j)/50;
    imagesc(noisefreeim{j});
    pause(0.001);
end

%% single illum
myFolder = 'C:\Users\roboticimaging\Documents\kronoslightstage\classtest\plate3\step';
filePattern = fullfile(myFolder, '*.tiff');
jpegFiles = dir(filePattern);
figure;
for i = 1:numpos
    %read image
    baseFileName = jpegFiles(i).name;
    fullFileName = fullfile(myFolder, baseFileName);
    sim{i} = double(imread(fullFileName).*1)/bit;
    
    % display image
    subplot(2,4,i);
    imagesc((abs(noisefreeim{i})));
    axis off;colorbar;colormap bone;%caxis([-15,0]);
    title([' photon to read ratio ',num2str((mean2(sim{i})/std2(sim{i})^2))]);pause(0.01);
    var1(i) = std2(sim{i})^2;
end
%%
c = [8,7,6,5,4,3,2,1];
plot(c,var1,'o');
coefficients = polyfit(c, var1, 1);
yFit = polyval(coefficients , c);
hold on;
plot(c, yFit, 'r-', 'LineWidth', 2);
ylabel('\sigma');xlabel('light activated');title('noise variance increase linearly with activated source')
%%
sgtitle('noise test comparing 100ms 0db and 50ms 6db');
%% multipelxed 
demulmat = [    1     1     0     1     1     1     0     0;
                0     0     1     1     0     1     0     1;
                1     0     0     1     0     0     1     1;
                1     0     1     0     0     1     1     0;
                0     0     0     0     1     1     1     1;
                0     0     1     1     1     0     1     0;
                1     0     1     0     1     0     0     1;
                0     1     1     0     0     0     1     1;
           ];
% demulmat = triu(ones(8));
myFolder = 'C:\Users\roboticimaging\Documents\kronoslightstage\classtest\plate3\100ms0dbm';
filePattern = fullfile(myFolder, '*.tiff');
jpegFiles = dir(filePattern);
for j = 1:numcolor
    figure;
    % read image
    for i = 1:numpos
      baseFileName = jpegFiles(i).name;
      fullFileName = fullfile(myFolder, baseFileName);
      imm{i} = double(imread(fullFileName))/bit;
      mrmat(i,:) = reshape(imm{i},1,size(imm{i},1)*size(imm{i},2));
    end   
    % demultiplex
    demul = demulmat\mrmat;
    for k = 1:numpos
        dem{k+(j-1)*numpos} = reshape(demul(k,:),size(imm{i},1),size(imm{i},2));
        
        % display image
        subplot(2,4,k);
%         imshowpair(dem{k},noisefreeim{k},'montage');
        imagesc(noisefreeim{k});
%         imagesc(log(abs(noisefreeim{k}-dem{k})));
%         axis off;colorbar;colormap bone;%caxis([-20,0]);
        title(['ptnr: ',num2str(mean2(noisefreeim{k})/std2(noisefreeim{k})^2)]);pause(0.01);
        
    end
    sgtitle('noise test comparing 100ms 0db and 50ms 6dbm');
end

 