myFolder = 'C:\Users\user\Pictures\basler\real\ball5';
filePattern = fullfile(myFolder, '*.tiff');
jpegFiles = dir(filePattern);
bit16 = 65535;
for i = 1:16
  baseFileName = jpegFiles(i).name;
  fullFileName = fullfile(myFolder, baseFileName);
  sim{i} = double(imread(fullFileName))/bit16;
end
redchan = zeros(size(sim{1}));
grnchan = zeros(size(sim{1}));
bluchan = zeros(size(sim{1}));
nirchan = zeros(size(sim{1}));
for j = 1:4
   redchan = redchan + sim{j}; 
   grnchan = grnchan + sim{j+4};
   bluchan = bluchan + sim{j+8};
   nirchan = nirchan + sim{j+12};
end
redchan = redchan/4;
grnchan = grnchan/4;
bluchan = bluchan/5;
nirchan = nirchan/4;

colim(:,:,1) = redchan;colim(:,:,2) = grnchan;colim(:,:,3) = bluchan;
hsvim = rgb2hsv(colim);
hsvim(:,:,3) = nirchan;
colim2 = hsv2rgb(hsvim);