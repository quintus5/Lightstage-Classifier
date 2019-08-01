myFolder = 'C:\Users\user\Pictures\basler\real\orange2';
% myFolder = 'C:\Users\user\Pictures\basler\fake\orange5';
filePattern = fullfile(myFolder, '*.tiff');
jpegFiles = dir(filePattern);
for k = 1:length(jpegFiles)
  baseFileName = jpegFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  pic = imread(fullFileName);
  [idx,score] = predict(classifier,pic);
  disp(classifier.Labels(idx));
end