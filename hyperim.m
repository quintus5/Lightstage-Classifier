% load hyperspectral im pryglbi
bit = 65535;
myFolder = 'C:\Users\user\Pictures\basler\classtest\plate\bump0db96ms_s';
filePattern = fullfile(myFolder, '*.tiff');
jpegFiles = dir(filePattern);
a = 1;
for i = 1:4:length(jpegFiles)
    baseFileName = jpegFiles(i).name;
    fullFileName = fullfile(myFolder, baseFileName);
    imbl(:,:,a) = imread(fullFileName); 
    a = a+1;
end
a = 1;
for i = 2:4:length(jpegFiles)
    baseFileName = jpegFiles(i).name;
    fullFileName = fullfile(myFolder, baseFileName);
    imtl2(:,:,a) = imread(fullFileName); 
    a = a+1;
end
a = 1;
for i = 3:4:length(jpegFiles)
    baseFileName = jpegFiles(i).name;
    fullFileName = fullfile(myFolder, baseFileName);
    imtr(:,:,a) = imread(fullFileName); 
    a = a+1;
end
a = 1;
for i = 4:4:length(jpegFiles)
    baseFileName = jpegFiles(i).name;
    fullFileName = fullfile(myFolder, baseFileName);
    imbr(:,:,a) = imread(fullFileName); 
    a = a+1;
end
%%
imred = (imbl(:,:,1)+imtl(:,:,1)+imtr(:,:,1)+imbr(:,:,1))/4;
imgrn = (imbl(:,:,2)+imtl(:,:,2)+imtr(:,:,2)+imbr(:,:,2))/4;
imblu = (imbl(:,:,3)+imtl(:,:,3)+imtr(:,:,3)+imbr(:,:,3))/4;
imnir = (imbl(:,:,7)+imtl(:,:,7)+imtr(:,:,7)+imbr(:,:,7))/4;
figure;
subplot(2,2,1);imshow(imblu);title('blue');
subplot(2,2,2);imshow(imgrn);title('green');
subplot(2,2,3);imshow(imred);title('red');
subplot(2,2,4);imshow(imnir);title('NIR');
%%
S = cat(3,imblu,imgrn,imred,imnir);
X = imstack2vectors(S);
P = princomp(X,4);
for i = 1:4
    subplot(2,2,i)
    g1 = P.Y(:,i);
    g1 = mat2gray(reshape(g1,416,416));
    imshow(g1);
    axis off;
end
sgtitle('pca of mulispectral image based on the intensity contrast, gonzalez et al.(2018)')

%%
S = cat(3,imbl(:,:,1),imbl(:,:,2),imbl(:,:,3),imbl(:,:,4),imbl(:,:,5),imbl(:,:,6),imbl(:,:,7));
X = imstack2vector(S);
P = pcacalc(X,7);
for i = 1:6
    subplot(2,3,i)
    g1 = P.Y(:,i);
    g1 = mat2gray(reshape(g1,416,416));
    imshow(g1);
    axis off;
end
sgtitle('pca of mulispectral image based on the covariance ')

%216