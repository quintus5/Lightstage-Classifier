clear;
%  mulmat = single(repmat([1,1,1,0,0,1,0,0;
%                   0,1,0,0,1,1,1,0;
%                   0,0,1,0,1,1,0,1;
%                   0,1,1,0,0,0,1,1;
%                   1,0,0,1,1,0,1,1;
%                   0,1,0,1,0,1,0,1;
%                   0,1,1,1,1,0,0,0;
%                   0,0,1,1,0,1,1,0],1,16));
% mulmat = single(repmat(eye(8),1,16));
% % train svm
% folder = 'classtest\orange8pos';
% imds = imageDatastore(fullfile(folder),'IncludeSubfolders',true,'FileExtensions', ...
%     '.tiff','LabelSource','foldernames');

%%
myFolder = 'C:\Users\user\Pictures\basler\classtest\apple\real_rgbpylwi_p';
filePattern = fullfile(myFolder, '*.tiff');
realjPeg = dir(filePattern);
% realjPeg(25:56) = [];
% realjPeg(end-39:end) = [];
myFolder = 'C:\Users\user\Pictures\basler\classtest\apple\fake_rgbpylwi_p';
filePattern = fullfile(myFolder, '*.tiff');
fakejPeg = dir(filePattern);
% fakejPeg(25:56) = [];
% fakejPeg(end-39:end) = [];
myFolder = 'C:\Users\user\Pictures\basler\classtest\paprika\real_rgbpylwi_p';
filePattern = fullfile(myFolder, '*.tiff');
realjPeg = dir(filePattern);
% realjPeg(25:56) = [];
% realjPeg(end-39:end) = [];
myFolder = 'C:\Users\user\Pictures\basler\classtest\paprika\fake_rgbpylwi_p';
filePattern = fullfile(myFolder, '*.tiff');
fakejPeg = dir(filePattern);
% fakejPeg(25:56) = [];
% fakejPeg(end-39:end) = [];
%%
for i = 1:length(realjPeg)
    baseFileName = realjPeg(i).name;
    fullFileName = fullfile(realjPeg(i).folder, baseFileName);
    im = double(bitshift(imread(fullFileName),-6));
    a1 = imresize(im,[100,100]);     % resize
%     color(i,:) = reshape(a1,1,[]);

    [feat(i,:),~] = extractHOGFeatures(a1,'Cellsize',[4,4],'BlockSize',[4,4]);
    realfeat(i,:) = [feat(i,:),1];
%     label{i} = 'real';
end
%%
for k = 1:length(fakejPeg)
    baseFileName = fakejPeg(k).name;
    fullFileName = fullfile(fakejPeg(k).folder, baseFileName);
    imt = double(bitshift(imread(fullFileName),-6));
    b1 = imresize(imt,[100,100]);
%     color(k,:) = reshape(b1,1,[]);
%     spatial(k,:) = linspace(0,1,length(color(k,:)));
    [featt(k,:),~] = extractHOGFeatures(b1,'Cellsize',[4,4],'BlockSize',[4,4]);
    fakefeat(k,:) = [featt(k,:),0];
%     label{i+k} = 'fake';
end
%%
for epoch = 1:20
% training feature vector
traininds1 = randsample(size(realfeat,1),ceil(size(realfeat,1)*0.7)); % select some indices
train = [realfeat(traininds1,:);fakefeat(traininds1,:)];
traininds2 = randsample(size(train,1),2*ceil(size(realfeat,1)*0.7)); % shuffle again
trainfeature = train(traininds2,1:end-1); 
trainlabel = train(traininds2,end);

% testing feature vector
testinds = 1:size(realfeat,1);
testinds(traininds1) = [];
test = [realfeat(testinds,:);fakefeat(testinds,:)];
testfeature = test(:,1:end-1);
testlabel = test(:,end);
%%
% coeff = principalcomps(trainfeature',); % pca from gonzalez
% coeff1 = principalcomps(testfeature',12);
% 
% [coeff,scr] = pca(trainfeature'); % pca from matlab
% [coeff1,scr1] = pca(testfeature');

%%
% model=fitcsvm(trainfeature,trainlabel,'KernelScale','auto','KernelFunction','gaussian','Standardize',true,...
%     'OutlierFraction',0.05,'Verbose',false);
model=fitcknn(trainfeature,trainlabel);
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
fprintf('Epoch = %d, Train Acc = %.3f, Test Acc = %.3f\n', epoch, avgtrainacc(epoch),avgtestacc(epoch));
%%
% table(test.Labels,label,score,'VariableNames',...
%     {'TrueLabel','PredictedLabel','Score'})
% bag = bagOfFeatures(train);
% %%
% classifier = trainImageCategoryClassifier(train,bag,'Verbose',true);
% %%
% conf = evaluate(classifier,test);
end
fprintf('Avg Accuracy train: %.3f\n', mean(avgtrainacc));
fprintf('Avg Accuracy test: %.3f\n', mean(avgtestacc));

