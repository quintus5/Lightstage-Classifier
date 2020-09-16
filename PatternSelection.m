%% ============READ IMAGE======================
% Folder containing the images
ParentFolder = 'C:\Users\user\Pictures\basler\paper\';
FileFormat = "*.tiff";
realjPeg_ga = dir(fullfile([ParentFolder,'greenapplereal'], FileFormat));
fakejPeg_ga = dir(fullfile([ParentFolder,'greenapplefake'], FileFormat));
realjPeg_ra = dir(fullfile([ParentFolder,'redapplereal'], FileFormat));
fakejPeg_ra = dir(fullfile([ParentFolder,'redapplefake'], FileFormat));
realjPeg_gg = dir(fullfile([ParentFolder,'greengrapereal'], FileFormat));
fakejPeg_gg = dir(fullfile([ParentFolder,'greengrapefake'], FileFormat));
realjPeg_bn = dir(fullfile([ParentFolder,'bananareal'], FileFormat));
fakejPeg_bn = dir(fullfile([ParentFolder,'bananafake'], FileFormat));
realjPeg_or = dir(fullfile([ParentFolder,'orangereal'], FileFormat));
fakejPeg_or = dir(fullfile([ParentFolder,'orangefake'], FileFormat));


%% ============store images into groups=========
for i = 1:length(realjPeg_ga)
    fullFileName = fullfile(realjPeg_ga(i).folder, realjPeg_ga(i).name);
    Raw_real_ga(:,:,i) = (bitshift(imread(fullFileName),-6));
    fullFileName = fullfile(fakejPeg_ga(i).folder, fakejPeg_ga(i).name);
    Raw_fake_ga(:,:,i) = (bitshift(imread(fullFileName),-6));
end  
for i = 1:length(realjPeg_ra)
    fullFileName = fullfile(realjPeg_ra(i).folder, realjPeg_ra(i).name);
    Raw_real_ra(:,:,i) = (bitshift(imread(fullFileName),-6));
    fullFileName = fullfile(fakejPeg_ra(i).folder, fakejPeg_ra(i).name);
    Raw_fake_ra(:,:,i) = (bitshift(imread(fullFileName),-6));
end
for i = 1:length(realjPeg_gg)
    fullFileName = fullfile(realjPeg_gg(i).folder, realjPeg_gg(i).name);
    Raw_real_gg(:,:,i) = (bitshift(imread(fullFileName),-6));
    fullFileName = fullfile(fakejPeg_gg(i).folder, fakejPeg_gg(i).name);
    Raw_fake_gg(:,:,i) = (bitshift(imread(fullFileName),-6));
end
for i = 1:length(realjPeg_bn)
    fullFileName = fullfile(realjPeg_bn(i).folder, realjPeg_bn(i).name);
    Raw_real_bn(:,:,i) = (bitshift(imread(fullFileName),-6));
    fullFileName = fullfile(fakejPeg_bn(i).folder, fakejPeg_bn(i).name);
    Raw_fake_bn(:,:,i) = (bitshift(imread(fullFileName),-6));
end
for i = 1:length(realjPeg_or)
    fullFileName = fullfile(realjPeg_or(i).folder, realjPeg_or(i).name);
    Raw_real_or(:,:,i) = (bitshift(imread(fullFileName),-6));
    fullFileName = fullfile(fakejPeg_or(i).folder, fakejPeg_or(i).name);
    Raw_fake_or(:,:,i) = (bitshift(imread(fullFileName),-6));
end

%% =============System Config===================
LightingPattern = Column_Permutation(8); % derive all permutation
ImSize = 512;           % read image size
SmallImSize = 120;      % small image size
CellSize = 12;          % HOG cell size
BlkSize = 10;           % HOG block size
Dimmer = 0.45;          % Prevent multiplexing saturation
Gain = 12;              % Simulation gain (dB)
[feat,~] = extractHOGFeatures(zeros(SmallImSize,SmallImSize),'Cellsize',[CellSize,CellSize],'BlockSize',[BlkSize,BlkSize]);
FeatSize = length(feat);  % feature vector size
NPose = 20;             % Total number of available pose
NColor = 4;             % Number of colors
NMsnt = 8;              % Number of measurement;
%% ============Pattern Selection Loop===============
%     multiplier = size(bestmat2,1)+1;
for Column_i = 1:NMsnt

for PatternType = 1:7
mat = LightingPattern{PatternType};  
fprintf('%d %d\n', matcol, PatternType);
for i = 1:length(mat)

Pattern = mat(i);
N = size(snrmat,2);

FeatExtract();

%% ================Classification==================
% initialize for confusin matrix
true_label = [];pred_label = [];avgtestacc = 0;

for rep_i = 1:400
% training feature vector
traininds1 = randsample(size(Feat_real_ga,1),ceil(size(Feat_real_ga,1)*0.75)); % select some indices
trainfeature = [Feat_real_ga(traininds1,:);Feat_fake_ga(traininds1,:);
                Feat_real_ra(traininds1,:);Feat_fake_ra(traininds1,:);
                Feat_real_gg(traininds1,:);Feat_fake_gg(traininds1,:);
                Feat_real_bn(traininds1,:);Feat_fake_bn(traininds1,:);
                Feat_real_or(traininds1,:);Feat_fake_or(traininds1,:)];
traininds2 = randsample(size(trainfeature,1),size(trainfeature,1)); % shuffle again
trainlabel = trainfeature(traininds2,end);
trainfeature = trainfeature(traininds2,1:end-1); 

testinds1= 1:size(Feat_real_ga,1);
testinds1(traininds1) = [];
testfeature = [Feat_real_ga(testinds1,:);Feat_fake_ga(testinds1,:);
                Feat_real_ra(testinds1,:);Feat_fake_ra(testinds1,:);
                Feat_real_gg(testinds1,:);Feat_fake_gg(testinds1,:);
                Feat_real_bn(testinds1,:);Feat_fake_bn(testinds1,:);
                Feat_real_or(testinds1,:);Feat_fake_or(testinds1,:)];

testlabel = testfeature(:,end);
testfeature = testfeature(:,1:end-1);
true_label = [true_label;testlabel];

% training function
model = fitcecoc(trainfeature,trainlabel,'Coding','onevsall');

% predict the testing set
[label,score] = predict(model,testfeature);
pred_label = [pred_label;label]; % make confusion mat with it
avgtestacc(rep_i) = sum(testlabel == label)/length(label);
end 
% do a stochastic descend
    if mean(avgtestacc) > bestacc 
        best_label2 = [pred_label,true_label];
        bestmat = snrmat;
        fprintf('Avg Accuracy test: %.3f\n', mean(avgtestacc)*100);
        bestacc = mean(avgtestacc);
    end

end
end
bestmat2 = bestmat';
end
