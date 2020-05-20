% multiclass
clear;
bit = 1022;
%%
myFolder = 'C:\Users\user\Pictures\basler\paper\classtest\s\gar_rgbwi_p';
filePattern = fullfile(myFolder, '*.tiff');
realjPeg_ga = dir(filePattern);
count_gar = (length(realjPeg_ga)/8/5);
myFolder = 'C:\Users\user\Pictures\basler\paper\classtest\s\gar_rgbwi_p';
filePattern = fullfile(myFolder, '*.tiff');
fakejPeg_ga = dir(filePattern);
count_gaf = (length(fakejPeg_ga)/8/5);

myFolder = 'C:\Users\user\Pictures\basler\paper\classtest\s\rar_rgbwi_p';
filePattern = fullfile(myFolder, '*.tiff');
realjPeg_ra = dir(filePattern);
count_rar = (length(realjPeg_ra)/8/5);
myFolder = 'C:\Users\user\Pictures\basler\paper\classtest\s\raf_rgbwi_p';
filePattern = fullfile(myFolder, '*.tiff');
fakejPeg_ra = dir(filePattern);
count_raf = (length(fakejPeg_ra)/8/5);

myFolder = 'C:\Users\user\Pictures\basler\paper\classtest\s\ggr_rgbwi_p';
filePattern = fullfile(myFolder, '*.tiff');
realjPeg_gg = dir(filePattern);
count_ggr = (length(realjPeg_gg)/8/5);
myFolder = 'C:\Users\user\Pictures\basler\paper\classtest\s\ggf_rgbwi_p';
filePattern = fullfile(myFolder, '*.tiff');
fakejPeg_gg = dir(filePattern);
count_ggf = (length(fakejPeg_gg)/8/5);

myFolder = 'C:\Users\user\Pictures\basler\paper\classtest\s\bnr_rgbwi_p';
filePattern = fullfile(myFolder, '*.tiff');
realjPeg_bn = dir(filePattern);
count_bnr = (length(realjPeg_bn)/8/5);
myFolder = 'C:\Users\user\Pictures\basler\paper\classtest\s\bnf_rgbwi_p';
filePattern = fullfile(myFolder, '*.tiff');
fakejPeg_bn = dir(filePattern);
count_bnf = (length(fakejPeg_bn)/8/5);

myFolder = 'C:\Users\user\Pictures\basler\paper\classtest\s\orr_rgbwi_p';
filePattern = fullfile(myFolder, '*.tiff');
realjPeg_or = dir(filePattern);
count_orr = (length(realjPeg_or)/8/5);
myFolder = 'C:\Users\user\Pictures\basler\paper\classtest\s\orf_rgbwi_p';
filePattern = fullfile(myFolder, '*.tiff');
fakejPeg_or = dir(filePattern);
count_orf = (length(fakejPeg_or)/8/5);
%%
for c = 0
for i = 1:length(realajPeg)
    baseFileName = realajPeg(i).name;
    fullFileName = fullfile(realajPeg(i).folder, baseFileName);
    im = double(bitshift(imread(fullFileName),-6))/bit;
    a1 = imresize(im,[100,100]);     % resize
    [feata(i,:),~] = extractHOGFeatures(a1,'Cellsize',[2,2],'BlockSize',[4,4]); 
end
% realafeat(i,:) = [feata(i,:)];
%%
for k = 1:length(fakeajPeg)
    baseFileName = fakeajPeg(k).name;
    fullFileName = fullfile(fakeajPeg(k).folder, baseFileName);
    imt = double(bitshift(imread(fullFileName),-6))/bit;
    b1 = imresize(imt,[100,100]);
    [featta(k,:),~] = extractHOGFeatures(b1,'Cellsize',[2,2],'BlockSize',[4,4]);   
end
% fakeafeat(k,:) = [featta(k,:)];
%%
for k = 1:length(realpjPeg)
    baseFileName = realpjPeg(k).name;
    fullFileName = fullfile(realpjPeg(k).folder, baseFileName);
    imt = double(bitshift(imread(fullFileName),-6))/bit;
    c1 = imresize(imt,[20,20]);
    imagesc(c1);pause(0.001);
    [featp(k,:),~] = extractHOGFeatures(c1,'Cellsize',[4,4],'BlockSize',[4,4]);
%     realpfeat(k,:) = [featp(k,:),2];
end
%%
for k = 1:length(fakepjPeg)
    baseFileName = fakepjPeg(k).name;
    fullFileName = fullfile(fakepjPeg(k).folder, baseFileName);
    imt = double(bitshift(imread(fullFileName),-6))/bit;
    b1 = imresize(imt,[20,20]);
    imagesc(b1);pause(0.01);
    [feattp(k,:),~] = extractHOGFeatures(b1,'Cellsize',[4,4],'BlockSize',[4,4]);
%     fakepfeat(k,:) = [feattp(k,:),3];
end
%%
for epoch = 1:50
% training feature vector
traininds1 = randsample(size(realafeat,1),ceil(size(realafeat,1)*0.7)); % select some indices
train = [realafeat(traininds1,:);fakeafeat(traininds1,:);realpfeat(traininds1,:);fakepfeat(traininds1,:)];
traininds2 = randsample(size(train,1),4*ceil(size(realafeat,1)*0.7)); % shuffle again
trainfeature = train(traininds2,1:end-1); 
trainlabel = train(traininds2,end);

% testing feature vector
testinds = 1:size(realafeat,1);
testinds(traininds1) = [];
test = [realafeat(testinds,:);fakeafeat(testinds,:);realpfeat(testinds,:);fakepfeat(testinds,:)];
testfeature = test(:,1:end-1);
testlabel = test(:,end);
%%
% coeff = principalcomps(trainfeature',); % pca from gonzalez
% coeff1 = principalcomps(testfeature',12);

%%
% model=fitcsvm(trainfeature,trainlabel,'KernelScale','auto','KernelFunction','gaussian','Standardize',true,...
%     'OutlierFraction',0.05,'Verbose',false);
% model=fitcknn(trainfeature,trainlabel);
model = fitcecoc(trainfeature,trainlabel,'Coding','onevsall');
%% predict the training model

[label,score] = predict(model,trainfeature);
% fprintf('Accuracy = %.3f\n', sum(trainlabel == label)/length(label));
% table(trainlabel,label, score(1:end,2),'VariableNames',...
%     {'TrueLabel','PredictedLabel','Score'})
avgtrainacc(epoch) = sum(trainlabel == label)/length(label);
% fprintf('Accuracy = %.3f\n', sum(trainlabel == label)/length(label));
%% predict the testing set

[label,score] = predict(model,testfeature);
% table(testlabel,label,score(1:end,2),'VariableNames',...
%     {'TrueLabel','PredictedLabel','Score'})
avgtestacc(epoch) = sum(testlabel == label)/length(label);
% fprintf('Epoch = %d, Train Acc = %.3f, Test Acc = %.3f\n', epoch, avgtrainacc(epoch),avgtestacc(epoch));
end
fprintf('Avg Accuracy train: %.3f\n', mean(avgtrainacc));
fprintf('Avg Accuracy test: %.3f\n', mean(avgtestacc));
end
