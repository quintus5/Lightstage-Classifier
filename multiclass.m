% multiclass
clear;
bit = 1022;
%%
myFolder = 'C:\Users\user\Pictures\basler\classtest\apple\real_rgbpylwi_p';
filePattern = fullfile(myFolder, '*.tiff');
realajPeg = dir(filePattern);
realajPeg(25:56) = [];
% realjPeg(end-39:end) = [];
myFolder = 'C:\Users\user\Pictures\basler\classtest\apple\fake_rgbpylwi_p';
filePattern = fullfile(myFolder, '*.tiff');
fakeajPeg = dir(filePattern);
fakeajPeg(25:56) = [];
% fakejPeg(end-39:end) = [];
myFolder = 'C:\Users\user\Pictures\basler\classtest\paprika\real_rgbpylwi_p';
filePattern = fullfile(myFolder, '*.tiff');
realpjPeg = dir(filePattern);
realpjPeg(25:56) = [];
% realjPeg(end-39:end) = [];
myFolder = 'C:\Users\user\Pictures\basler\classtest\paprika\fake_rgbpylwi_p';
filePattern = fullfile(myFolder, '*.tiff');
fakepjPeg = dir(filePattern);
fakepjPeg(25:56) = [];
% fakejPeg(end-39:end) = [];
%%
for c = 0:3
for i = 1+c*8:length(realajPeg)-(24-c*8)
    baseFileName = realajPeg(i).name;
    fullFileName = fullfile(realajPeg(i).folder, baseFileName);
    im = double(bitshift(imread(fullFileName),-6))/bit;
    a1 = imresize(im,[20,20]);     % resize
    imagesc(a1);pause(0.001);
    [feata(i,:),~] = extractHOGFeatures(a1,'Cellsize',[4,4],'BlockSize',[4,4]);
    realafeat(i,:) = [feata(i,:),1];
end
%%
for k = 1+c*8:length(fakeajPeg)-(24-c*8)
    baseFileName = fakeajPeg(k).name;
    fullFileName = fullfile(fakeajPeg(k).folder, baseFileName);
    imt = double(bitshift(imread(fullFileName),-6))/bit;
    b1 = imresize(imt,[20,20]);
    [featta(k,:),~] = extractHOGFeatures(b1,'Cellsize',[4,4],'BlockSize',[4,4]);
    fakeafeat(k,:) = [featta(k,:),0];
end
%%
for k = 1+c*8:length(realpjPeg)-(24-c*8)
    baseFileName = realpjPeg(k).name;
    fullFileName = fullfile(realpjPeg(k).folder, baseFileName);
    imt = double(bitshift(imread(fullFileName),-6))/bit;
    c1 = imresize(imt,[20,20]);
    [featp(k,:),~] = extractHOGFeatures(c1,'Cellsize',[4,4],'BlockSize',[4,4]);
    realpfeat(k,:) = [featp(k,:),2];
end
%%
for k = 1+c*8:length(fakepjPeg)-(24-c*8)
    baseFileName = fakepjPeg(k).name;
    fullFileName = fullfile(fakepjPeg(k).folder, baseFileName);
    imt = double(bitshift(imread(fullFileName),-6))/bit;
    b1 = imresize(imt,[20,20]);
    [feattp(k,:),~] = extractHOGFeatures(b1,'Cellsize',[4,4],'BlockSize',[4,4]);
    fakepfeat(k,:) = [feattp(k,:),3];
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
