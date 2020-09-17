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