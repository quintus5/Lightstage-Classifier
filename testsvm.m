addpath ('function');
addpath (genpath('.\libsvm-3.22'))
%%
folder = 'classtest\orange';
imds = imageDatastore(fullfile(folder),'IncludeSubfolders',true,'FileExtensions', ...
    '.tiff','LabelSource','foldernames');
for i = 1:length(imds.Files)
    oimg(:,:,i) = double(imread(imds.Files{i}))/255;
    rimg(:,:,i) = imresize(oimg(:,:,i),[100,100]);
%     imshow(rimg(:,:,i));
%     pause(0.0001);
end
[no_lines, no_rows, no_bands] = size(rimg);

gt = ones(480,2);gt(241:end,2) = 2;
gt(:,1) = find(rimg(1,1,:)); % column 1 is the index of each images.
crossval_matrix = randi(480,[200,2]);
% bim2 = average_fusion(bim,16);
% fimg1=spatial_feature(bim2,5,0.05);
% fimg2=spatial_feature(bim2,10,0.1);
% fimg3=spatial_feature(bim2,30,0.3);
% f_fimg=cat(3,fimg1,fimg2,fimg3);
gt = gt';
limg = ToVector(oimg)';
for i = 1:1
    idx = crossval_matrix(:,i);
    train_SL = gt(:,idx);
    train_sample = limg(:,train_SL(1,:))';
    train_label = train_SL(2,:)';
    test_SL = gt;
    test_SL(:,idx) = [];    % empty the non testing index
    test_sample = limg(:,test_SL(1,:))';
    test_label = test_SL(2,:)';
    
    [train_sample,M,m] = scale_func(train_sample);
    limg = scale_func(limg',M,m);
    [Ccv Gcv cv cv_t]=cross_validation_svm(train_label,train_sample);
    parameter=sprintf('-c %f -g %f -m 500 -t 2 -q',Ccv,Gcv);
    model=svmtrain(train_label,train_sample,parameter);
    Result = svmpredict(test_label,test_sample,model); %%%
end
% need to reduce dimension
%limg = 230400x480 -> 100-300x480
%% load original image
path='.\Datasets\';
inputs = 'IndiaP';%145*145*200/10249/16 
location = [path,inputs];
load (location);

%%% size of image 
[no_lines, no_rows, no_bands] = size(oimg);
GroundT=GroundT';
load (['.\training_indexes\in_1.mat']) %for cross validation
%% Spectral dimension Reduction
 img2=average_fusion(oimg,15);
for i=1:10
    indexes=XX(:,i);
%% Normalization
no_bands=size(img2,3);
fimg=reshape(img2,[no_lines*no_rows no_bands]);
[fimg] = scale_new(fimg);
fimg=reshape(fimg,[no_lines no_rows no_bands]);
%% Feature extraction
 fimg1=spatial_feature(fimg,115,0.6);
 fimg2=spatial_feature(fimg,200,0.9);
 fimg3=spatial_feature(fimg,30,0.3);
 f_fimg=cat(3,fimg1,fimg2,fimg3);
%% Feature fusion with the PCA
 fimg=PCA_img(f_fimg, 30);
%% SVM classification
    fimg = ToVector(fimg);
    fimg = fimg';
    fimg=double(fimg);
%%%
train_SL = GroundT(:,indexes);
train_samples = fimg(:,train_SL(1,:))';
train_labels= train_SL(2,:)';
%%%
test_SL = GroundT;
test_SL(:,indexes) = [];
test_samples = fimg(:,test_SL(1,:))';
test_labels = test_SL(2,:)';
% Normalizing Training and original img 
[train_samples,M,m] = scale_func(train_samples);
[fimg ] = scale_func(fimg',M,m);
% Selecting the paramter for SVM
[Ccv Gcv cv cv_t]=cross_validation_svm(train_labels,train_samples);
% Training using a Gaussian RBF kernel
parameter=sprintf('-c %f -g %f -m 500 -t 2 -q',Ccv,Gcv);
model=svmtrain(train_labels,train_samples,parameter);
% Testing
Result = svmpredict(ones(no_lines*no_rows,1),fimg,model); %%%
% Evaluation
% GroudTest = double(test_labels(:,1));
% ResultTest = Result(test_SL(1,:),:);
% [OA_i,AA_i,kappa_i,CA_i]=confusion(GroudTest,ResultTest)%
Result = reshape(Result,no_lines,no_rows);
VClassMap=label2colord(Result,'india');
figure,imshow(VClassMap);
end


