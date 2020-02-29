clear;clc;

%% load image
myFolder = 'C:\Users\user\Pictures\basler\paper\noisefreereal';
filePattern = fullfile(myFolder, '*.tiff');
realjPeg = dir(filePattern);

myFolder = 'C:\Users\user\Pictures\basler\paper\noisefreefake';
filePattern = fullfile(myFolder, '*.tiff');
fakejPeg = dir(filePattern);

%%
for i = 1:length(realjPeg)
    baseFileName = realjPeg(i).name;
    fullFileName = fullfile(realjPeg(i).folder, baseFileName);
    im = double(bitshift(imread(fullFileName),-6));
    
end
%%
for k = 1:length(fakejPeg)
    baseFileName = fakejPeg(k).name;
    fullFileName = fullfile(fakejPeg(k).folder, baseFileName);
    imt = double(bitshift(imread(fullFileName),-6));
end
%% multiplexing pattern generation

type1 = perms([0,0,0,0,0,0,1,1]);
type2 = perms([0,0,0,0,0,1,1,1]);
type3 = perms([0,0,0,0,1,1,1,1]);
type4 = perms([0,0,0,1,1,1,1,1]);
type8 = perms([1,1,1,1,1,1,1,1]);

type1 = unique(type1,'rows');
type2 = unique(type2,'rows');
type3 = unique(type3,'rows');
type4 = unique(type4,'rows');
type8 = unique(type8,'rows');

ledtype = {type1,type2,type3,type4,type8};


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

