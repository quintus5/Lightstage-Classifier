% train svm
folder = 'classtest\plate';
imds = imageDatastore(fullfile(folder),'IncludeSubfolders',true,'FileExtensions', ...
    '.tiff','LabelSource','foldernames');
%%
imds = splitEachLabel(imds,20);
countEachLabel(imds)
%%
[train,test] = splitEachLabel(imds,0.7);
%%
bag = bagOfFeatures(train);
%%
classifier = trainImageCategoryClassifier(train,bag,'Verbose',true);
%%
conf = evaluate(classifier,test);

%%


for i = 1:200
    imshow(lol(:,:,i));
    pause(0.1);
end
    