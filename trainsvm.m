mulmat = single([1,0,0,1,1,0,0,0;
          0,1,1,0,1,0,0,0;
          1,0,1,0,0,1,1,0;
          0,0,1,1,0,1,0,0;
          0,0,1,1,0,0,1,1;
          0,0,0,0,1,1,0,1;
          0,1,0,1,0,1,1,0;
          1,1,0,0,0,0,0,1;
          eye(8);
          eye(8);
          1,0,0,1,0,1,0,1;
          1,1,0,0,1,0,0,0;
          0,1,1,1,0,1,0,0;
          0,0,0,1,1,0,1,0;
          0,0,1,0,1,0,0,1;
          0,0,0,0,1,1,1,0;
          1,0,1,0,0,0,1,0;
          0,1,0,0,0,0,1,1]);

% train svm
% folder = 'classtest\orange8pos';
% imds = imageDatastore(fullfile(folder),'IncludeSubfolders',true,'FileExtensions', ...
%     '.tiff','LabelSource','foldernames');
%%
% [train,test] = splitEachLabel(imds,0.7,'randomized');
% countEachLabel(imds)
%%
myFolder = 'C:\Users\user\Pictures\basler\classtest\orange8pos\real';
filePattern = fullfile(myFolder, '*.tiff');
realjPeg = dir(filePattern);
myFolder = 'C:\Users\user\Pictures\basler\classtest\orange8pos\fake';
filePattern = fullfile(myFolder, '*.tiff');
fakejPeg = dir(filePattern);
%%
for i = 1:length(realjPeg)
    baseFileName = realjPeg(i).name;
    fullFileName = fullfile(realjPeg(i).folder, baseFileName);
    im = double(imread(fullFileName))/65535;
    a1=dyaddown(im,'m',1);      % resize
    [feat(i,:),~] = extractHOGFeatures(a1,'Cellsize',[4,4],'BlockSize',[4,4]);
    realfeat(i,:) = [feat(i,:),mulmat(i,:),1];
%     label{i} = 'real';
end
% coeff = principalcomps(feat',20);
%%
for k = 1:length(fakejPeg)
    baseFileName = fakejPeg(i).name;
    fullFileName = fullfile(fakejPeg(i).folder, baseFileName);
    imt = double(imread(fullFileName))/65535;
    a1=dyaddown(imt,'m',1);  
    [featt(k,:),~] = extractHOGFeatures(a1,'Cellsize',[4,4],'BlockSize',[4,4]);
    fakefeat(k,:) = [featt(k,:),mulmat(k,:),0];
%     label{i+k} = 'fake';
end
%%
% training feature vector
traininds1 = randsample(size(realfeat,1),22); % select some indices
train = [realfeat(traininds1,:);fakefeat(traininds1,:)];
traininds2 = randsample(size(train,1),44); % shuffle again
trainfeature = train(traininds2,1:end-1); 
trainlabel = train(traininds2,end);

% testing feature vector
testinds = 1:size(realfeat,1);
testinds(traininds1) = [];
test = [realfeat(testinds,:);fakefeat(testinds,:)];
testfeature = test(:,1:end-1);
testlabel = test(:,end);
%%
coeff = principalcomps(trainfeature',20); % pca from gonzalez
coeff1 = principalcomps(testfeature',10);
% 
% [coeff,scr] = pca(trainfeature'); % pca from matlab
% [coeff1,scr1] = pca(testfeature');

%%
model=fitcsvm(coeff.X',trainlabel,'KernelScale','auto','Standardize',true,...
    'OutlierFraction',0.05,'Verbose',true);
%% predict the training model

[label,score] = predict(model,coeff.X');
% fprintf('Accuracy = %.3f\n', sum(trainlabel == label)/length(label));
table(trainlabel,label, score(1:end,2),'VariableNames',...
    {'TrueLabel','PredictedLabel','Score'})
%% predict the testing set

[label,score] = predict(model,coeff1.X');
table(testlabel,label,score(1:end,2),'VariableNames',...
    {'TrueLabel','PredictedLabel','Score'})
fprintf('Accuracy = %.3f\n', sum(testlabel == label)/length(label));
%%
% table(test.Labels,label,score,'VariableNames',...
%     {'TrueLabel','PredictedLabel','Score'})
% bag = bagOfFeatures(train);
% %%
% classifier = trainImageCategoryClassifier(train,bag,'Verbose',true);
% %%
% conf = evaluate(classifier,test);
