%% ============READ IMAGE======================
% Folder containing the images
ParentFolder = 'C:\Users\user\Pictures\basler\paper\';
FileFormat = "*.tiff";
jPeg.real_ga = dir(fullfile([ParentFolder,'greenapplereal'], FileFormat));
jPeg.fake_ga = dir(fullfile([ParentFolder,'greenapplefake'], FileFormat));
jPeg.real_ra = dir(fullfile([ParentFolder,'redapplereal'], FileFormat));
jPeg.fake_ra = dir(fullfile([ParentFolder,'redapplefake'], FileFormat));
jPeg.real_gg = dir(fullfile([ParentFolder,'greengrapereal'], FileFormat));
jPeg.fake_gg = dir(fullfile([ParentFolder,'greengrapefake'], FileFormat));
jPeg.real_bn = dir(fullfile([ParentFolder,'bananareal'], FileFormat));
jPeg.fake_bn = dir(fullfile([ParentFolder,'bananafake'], FileFormat));
jPeg.real_or = dir(fullfile([ParentFolder,'orangereal'], FileFormat));
jPeg.fake_or = dir(fullfile([ParentFolder,'orangefake'], FileFormat));

%% ============store images into groups=========
for i = 1:length(jPeg.real_ga)
    fullFileName = fullfile(jPeg.real_ga(i).folder, jPeg.real_ga(i).name);
    Raw.real_ga(:,:,i) = (bitshift(imread(fullFileName),-6));
    fullFileName = fullfile(jPeg.fake_ga(i).folder, jPeg.fake_ga(i).name);
    Raw.fake_ga(:,:,i) = (bitshift(imread(fullFileName),-6));
end  
for i = 1:length(jPeg.real_ra)
    fullFileName = fullfile(jPeg.real_ra(i).folder, jPeg.real_ra(i).name);
    Raw.real_ra(:,:,i) = (bitshift(imread(fullFileName),-6));
    fullFileName = fullfile(jPeg.fake_ra(i).folder, jPeg.fake_ra(i).name);
    Raw.fake_ra(:,:,i) = (bitshift(imread(fullFileName),-6));
end
for i = 1:length(jPeg.real_gg)
    fullFileName = fullfile(jPeg.real_gg(i).folder, jPeg.real_gg(i).name);
    Raw.real_gg(:,:,i) = (bitshift(imread(fullFileName),-6));
    fullFileName = fullfile(jPeg.fake_gg(i).folder, jPeg.fake_gg(i).name);
    Raw.fake_gg(:,:,i) = (bitshift(imread(fullFileName),-6));
end
for i = 1:length(jPeg.real_bn)
    fullFileName = fullfile(jPeg.real_bn(i).folder, jPeg.real_bn(i).name);
    Raw.real_bn(:,:,i) = (bitshift(imread(fullFileName),-6));
    fullFileName = fullfile(jPeg.fake_bn(i).folder, jPeg.fake_bn(i).name);
    Raw.fake_bn(:,:,i) = (bitshift(imread(fullFileName),-6));
end
for i = 1:length(jPeg.real_or)
    fullFileName = fullfile(jPeg.real_or(i).folder, jPeg.real_or(i).name);
    Raw.real_or(:,:,i) = (bitshift(imread(fullFileName),-6));
    fullFileName = fullfile(jPeg.fake_or(i).folder, jPeg.fake_or(i).name);
    Raw.fake_or(:,:,i) = (bitshift(imread(fullFileName),-6));
end