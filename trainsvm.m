% train svm
folder = 'classtest\orange';
imds = imageDatastore(fullfile(folder),'IncludeSubfolders',true,'FileExtensions', ...
    '.tiff','LabelSource','foldernames');
%%
imds = splitEachLabel(imds,240,'randomized');
countEachLabel(imds)
%%
[train,test] = splitEachLabel(imds,0.7,'randomized');
%%
for i = 1:length(train.Files)
%     fullFileName = fullfile(myFolder, baseFileName)
    im = double(imread(train.Files{i}));
    im = im/255;
    a1=dyaddown(im,'m',1);
    imshow(a1);pause(0.001);
    [feat(i,:),vis] = extractHOGFeatures(a1,'Cellsize',[4,4],'BlockSize',[4,4]);
end
for k = 1:length(test.Files)
    imt = double(imread(test.Files{k}));
    imt = imt/255;
    a1=dyaddown(imt,'m',1);  
    [featt(k,:),vis] = extractHOGFeatures(a1,'Cellsize',[4,4],'BlockSize',[4,4]);
end
% parameter=sprintf('-c %f -g %f -m 500 -t 2 -q',Ccv,Gcv);
model=fitcsvm(feat,train.Labels,'KernelScale','auto','Standardize',true,...
    'OutlierFraction',0.05,'Verbose',true);
%%
% [label,score] = predict(CompactSVMModel,XTest);
[label,score] = predict(model,feat);

table(train.Labels(1:end),label(1:end),score(1:end,2),'VariableNames',...
    {'TrueLabel','PredictedLabel','Score'})

[label,score] = predict(model,featt);

table(test.Labels(1:end),label(1:end),score(1:end,2),'VariableNames',...
    {'TrueLabel','PredictedLabel','Score'})
% table(test.Labels,label,score,'VariableNames',...
%     {'TrueLabel','PredictedLabel','Score'})
% bag = bagOfFeatures(train);
%%
% classifier = trainImageCategoryClassifier(train,model,'Verbose',true);
%%
conf = evaluate(classifier,test);
