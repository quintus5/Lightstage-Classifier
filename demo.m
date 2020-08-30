% demo.m


images = 1;
col = 'rgb';
stl = 'optmse';
% stl = 'eye';
for o = 1:length(col)
sequenceTable = howtolight(8,col(o),'LightPattern','m','Multiplexingstyle',stl);
for k = 1:images
    for count = 1:size(sequenceTable,1)
        write(reg, sequenceTable(count,:),'uint32');
        writeDigitalPin(ard,'D8',1);
        writeDigitalPin(ard,'D8',0);
        pause(0.7);
    end
end
pause;
end

myFolder = 'C:\Users\user\Pictures\basler\paper\greenapplereal';
filePattern = fullfile(myFolder, '*.tiff');
realjPeg_ga = dir(filePattern);
count_gar = (length(realjPeg_ga)/8/4);
myFolder = 'C:\Users\user\Pictures\basler\paper\greenapplefake';
filePattern = fullfile(myFolder, '*.tiff');
fakejPeg_ga = dir(filePattern);
count_gaf = (length(fakejPeg_ga)/8/4);

myFolder = 'C:\Users\user\Pictures\basler\paper\redapplereal';
filePattern = fullfile(myFolder, '*.tiff');
realjPeg_ra = dir(filePattern);
count_rar = (length(realjPeg_ra)/8/4);
myFolder = 'C:\Users\user\Pictures\basler\paper\redapplefake';
filePattern = fullfile(myFolder, '*.tiff');
fakejPeg_ra = dir(filePattern);
count_raf = (length(fakejPeg_ra)/8/4);

myFolder = 'C:\Users\user\Pictures\basler\paper\greengrapereal';
filePattern = fullfile(myFolder, '*.tiff');
realjPeg_gg = dir(filePattern);
count_ggr = (length(realjPeg_gg)/8/4);
myFolder = 'C:\Users\user\Pictures\basler\paper\greengrapefake';
filePattern = fullfile(myFolder, '*.tiff');
fakejPeg_gg = dir(filePattern);
count_ggf = (length(fakejPeg_gg)/8/4);

myFolder = 'C:\Users\user\Pictures\basler\paper\bananareal';
filePattern = fullfile(myFolder, '*.tiff');
realjPeg_bn = dir(filePattern);
count_bnr = (length(realjPeg_bn)/8/4);
myFolder = 'C:\Users\user\Pictures\basler\paper\bananafake';
filePattern = fullfile(myFolder, '*.tiff');
fakejPeg_bn = dir(filePattern);
count_bnf = (length(fakejPeg_bn)/8/4);

myFolder = 'C:\Users\user\Pictures\basler\paper\orangereal';
filePattern = fullfile(myFolder, '*.tiff');
realjPeg_or = dir(filePattern);
count_orr = (length(realjPeg_or)/8/4);
myFolder = 'C:\Users\user\Pictures\basler\paper\orangefake';
filePattern = fullfile(myFolder, '*.tiff');
fakejPeg_or = dir(filePattern);
count_orf = (length(fakejPeg_or)/8/4);