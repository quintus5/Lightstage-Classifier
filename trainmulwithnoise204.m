clear
%% read image
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

%%
for i = 1:length(realjPeg_ga)
    fullFileName = fullfile(realjPeg_ga(i).folder, realjPeg_ga(i).name);
    raw_real_ga(:,:,i) = (bitshift(imread(fullFileName),-6));
    fullFileName = fullfile(fakejPeg_ga(i).folder, fakejPeg_ga(i).name);
    raw_fake_ga(:,:,i) = (bitshift(imread(fullFileName),-6));
end
for i = 1:length(realjPeg_ra)
    fullFileName = fullfile(realjPeg_ra(i).folder, realjPeg_ra(i).name);
    raw_real_ra(:,:,i) = (bitshift(imread(fullFileName),-6));
    fullFileName = fullfile(fakejPeg_ra(i).folder, fakejPeg_ra(i).name);
    raw_fake_ra(:,:,i) = (bitshift(imread(fullFileName),-6));
end
for i = 1:length(realjPeg_gg)
    fullFileName = fullfile(realjPeg_gg(i).folder, realjPeg_gg(i).name);
    raw_real_gg(:,:,i) = (bitshift(imread(fullFileName),-6));
    fullFileName = fullfile(fakejPeg_gg(i).folder, fakejPeg_gg(i).name);
    raw_fake_gg(:,:,i) = (bitshift(imread(fullFileName),-6));
end
for i = 1:length(realjPeg_bn)
    fullFileName = fullfile(realjPeg_bn(i).folder, realjPeg_bn(i).name);
    raw_real_bn(:,:,i) = (bitshift(imread(fullFileName),-6));
    fullFileName = fullfile(fakejPeg_bn(i).folder, fakejPeg_bn(i).name);
    raw_fake_bn(:,:,i) = (bitshift(imread(fullFileName),-6));
end
for i = 1:length(realjPeg_or)
    fullFileName = fullfile(realjPeg_or(i).folder, realjPeg_or(i).name);
    raw_real_or(:,:,i) = (bitshift(imread(fullFileName),-6));
    fullFileName = fullfile(fakejPeg_or(i).folder, fakejPeg_or(i).name);
    raw_fake_or(:,:,i) = (bitshift(imread(fullFileName),-6));
end
clear realjPeg_ra realjPeg_ga realjPeg_gg realjPeg_bn realjPeg_or
clear fakejPeg_ra fakejPeg_ga fakejPeg_gg fakejPeg_bn fakejPeg_or
%%
type1 = perms([0,0,0,0,0,0,1,1]);
type2 = perms([0,0,0,0,0,1,1,1]);
type3 = perms([0,0,0,0,1,1,1,1]);
type4 = perms([0,0,0,1,1,1,1,1]);
type5 = perms([0,0,1,1,1,1,1,1]);
type1 = unique(type1,'rows');
type2 = unique(type2,'rows');
type3 = unique(type3,'rows');
type4 = unique(type4,'rows');
type5 = unique(type5,'rows');
ledtype = {type1,type2,type3,type4,type5};
patvar=[28,56,70,56,28];

im_size = 512;
smsiz = 120; % imresize size
celsiz = 12;
blksiz = 10;
dimmer = 0.45;  
gain = 17.5;
[feat,viz] = extractHOGFeatures(zeros(smsiz,smsiz),'Cellsize',[celsiz,celsiz],'BlockSize',[blksiz,blksiz]);
fs = length(feat); % feature vector size
bestacc = 0;
bestmat2 = [];
%%
for matcol = 3
%     multiplier = size(bestmat2,1)+1;
bestacc = 0;
for pattype = 2:5
mat = ledtype{pattype};  
fprintf('%d %d\n', matcol, pattype);
tic; % record time
for pattern = 2:patvar(pattype)-2
%     if randi(3) == 2
%         continue;
%     end
% snrmat = [bestmat2;mat(pattern,:)]';
% snrmat = [1,0,1,1,0,1,1,0;
%           0,1,0,0,0,0,0,1;
%           1,0,0,1,1,1,1,0;
%           1,0,0,1,0,1,0,0;
%           1,1,1,1,1,1,1,0;
%           1,0,0,0,1,0,1,1;
%           0,0,1,1,0,0,1,0;
%           1,1,1,1,0,1,1,1];
% snrmat = snrmat(:,1:8);
% snrmat = [1,1,1,1,1,1,1,0;
%           0,1,1,0,0,1,0,0;
%           1,0,1,1,0,0,0,1;
%           0,1,0,1,1,0,0,1;
%           1,0,0,0,1,1,0,1;
%           1,1,0,0,0,0,1,1;
%           0,0,1,0,1,0,1,0;
%           0,0,0,1,0,1,1,0]; gain 12
% snrmat = bestmat2';
% snrmat = [0,1,1,0,0,1,1,1;
%           0,1,1,1,1,0,0,1;
%           1,0,1,1,0,1,0,1;
%           1,1,1,0,1,1,1,0;
%           1,1,0,1,0,0,1,1;
%           0,0,1,1,0,0,1,0;
%           0,0,0,1,1,1,1,1;
%           0,1,0,1,0,1,0,0]; % gain 6
snrmat = [1,1,1,0,0,1,0,0;
          0,1,0,0,1,1,1,0;
          0,0,1,0,1,1,0,1;
          0,1,1,0,0,0,1,1;
          1,0,0,1,1,0,1,1;
          0,1,0,1,0,1,0,1;
          0,1,1,1,1,0,0,0;
          0,0,1,1,0,1,1,0];
multiplier = size(snrmat,2);
% preallocating feature array
feat_real_ga = zeros(count_gaf,fs*4*multiplier+1);
feat_fake_ga = zeros(count_gaf,fs*4*multiplier+1); 
feat_real_ra = zeros(count_gaf,fs*4*multiplier+1);
feat_fake_ra = zeros(count_gaf,fs*4*multiplier+1);
feat_real_gg = zeros(count_gaf,fs*4*multiplier+1);
feat_fake_gg = zeros(count_gaf,fs*4*multiplier+1);
feat_real_bn = zeros(count_gaf,fs*4*multiplier+1);
feat_fake_bn = zeros(count_gaf,fs*4*multiplier+1);
feat_real_or = zeros(count_gaf,fs*4*multiplier+1);
feat_fake_or = zeros(count_gaf,fs*4*multiplier+1);
for col = 0:3 % color
    for s = 0:count_gaf-1 % pose   
        % make single source illuminated sample into multiplexed
        im_sing_illum = raw_real_ga(:,:,8*s+8*count_gaf*col+1 :8*s+8*count_gaf*col+8);
        imre = reshape(im_sing_illum,im_size*im_size,8)*dimmer;
        imul = double(imre)*snrmat;
        im_mul_r = reshape(imul,im_size,im_size,[]);

        im_sing_illum = raw_fake_ga(:,:,8*s+8*count_gar*col+1 :8*s+8*count_gar*col+8);
        imre = reshape(im_sing_illum,im_size*im_size,8)*dimmer;
        imul = double(imre)*snrmat;
        im_mul_f = reshape(imul,im_size,im_size,[]);

        % extract feature and sort into [RGBI]
        for arr = 1:multiplier
            realsmall = imresize(addnoise(im_mul_r(:,:,arr),'g',gain),[smsiz,smsiz]);
%             subplot(2,5,1);imshow(realsmall/1022);pause(0.01);
            [feat,viz] = extractHOGFeatures(realsmall,'Cellsize',[celsiz,celsiz],'BlockSize',[blksiz,blksiz]);
            feat_real_ga(s+1,col*fs*multiplier+(arr-1)*fs+1:col*fs*multiplier+(arr-1)*fs+fs) = feat;

            fakesmall = imresize(addnoise(im_mul_f(:,:,arr),'g',gain),[smsiz,smsiz]);
%             subplot(2,5,6);imshow(fakesmall/1022);pause(0.01);
            [feat,~] = extractHOGFeatures(fakesmall,'Cellsize',[celsiz,celsiz],'BlockSize',[blksiz,blksiz]);
            feat_fake_ga(s+1,col*fs*multiplier+(arr-1)*fs+1:col*fs*multiplier+(arr-1)*fs+fs) = feat;
        end
        
        im_sing_illum = raw_real_ra(:,:,8*s+8*count_rar*col+1 :8*s+8*count_rar*col+8);
        imre = reshape(im_sing_illum,im_size*im_size,8)*dimmer;
        imul = double(imre)*snrmat;
        im_mul_r = reshape(imul,im_size,im_size,[]);
        % fake
        im_sing_illum = raw_fake_ra(:,:,8*s+8*count_raf*col+1 :8*s+8*count_raf*col+8);
        imre = reshape(im_sing_illum,im_size*im_size,8)*dimmer;
        imul = double(imre)*snrmat;
        im_mul_f = reshape(imul,im_size,im_size,[]);
        
        for arr = 1:multiplier
            realsmall = imresize(addnoise(im_mul_r(:,:,arr),'g',gain),[smsiz,smsiz]);
%             subplot(2,5,2);imshow(realsmall/1022);pause(0.01);
            [feat,~] = extractHOGFeatures(realsmall,'Cellsize',[celsiz,celsiz],'BlockSize',[blksiz,blksiz]);
            feat_real_ra(s+1,col*fs*multiplier+(arr-1)*fs+1:col*fs*multiplier+(arr-1)*fs+fs) = feat;

            fakesmall = imresize(addnoise(im_mul_f(:,:,arr),'g',gain),[smsiz,smsiz]);
%             subplot(2,5,7);imshow(fakesmall/1022);pause(0.01);
            [feat,~] = extractHOGFeatures(fakesmall,'Cellsize',[celsiz,celsiz],'BlockSize',[blksiz,blksiz]);
            feat_fake_ra(s+1,col*fs*multiplier+(arr-1)*fs+1:col*fs*multiplier+(arr-1)*fs+fs) = feat;
        end
         % real
        im_sing_illum = raw_real_gg(:,:,8*s+8*count_ggr*col+1 :8*s+8*count_ggr*col+8); %
        imre = reshape(im_sing_illum,im_size*im_size,8)*dimmer;
        imul = double(imre)*snrmat;
        im_mul_r = reshape(imul,im_size,im_size,[]);
        % fake
        im_sing_illum = raw_fake_gg(:,:,8*s+8*count_ggf*col+1 :8*s+8*count_ggf*col+8);%
        imre = reshape(im_sing_illum,im_size*im_size,8)*dimmer;
        imul = double(imre)*snrmat;
        im_mul_f = reshape(imul,im_size,im_size,[]);
        
        for arr = 1:multiplier
            realsmall = imresize(addnoise(im_mul_r(:,:,arr),'g',gain),[smsiz,smsiz]);
%             subplot(2,5,3);imshow(realsmall/1022);pause(0.01);
            [feat,~] = extractHOGFeatures(realsmall,'Cellsize',[celsiz,celsiz],'BlockSize',[blksiz,blksiz]);
            feat_real_gg(s+1,col*fs*multiplier+(arr-1)*fs+1:col*fs*multiplier+(arr-1)*fs+fs) = feat; 
            
            fakesmall = imresize(addnoise(im_mul_f(:,:,arr),'g',gain),[smsiz,smsiz]);
%             subplot(2,5,8);imshow(fakesmall/1022);pause(0.01);
            [feat,~] = extractHOGFeatures(fakesmall,'Cellsize',[celsiz,celsiz],'BlockSize',[blksiz,blksiz]);
            feat_fake_gg(s+1,col*fs*multiplier+(arr-1)*fs+1:col*fs*multiplier+(arr-1)*fs+fs) = feat;
        end
        % real orange
        im_sing_illum = raw_real_or(:,:,8*s+8*count_orr*col+1 :8*s+8*count_orr*col+8); %
        imre = reshape(im_sing_illum,im_size*im_size,8)*dimmer;
        imul = double(imre)*snrmat;
        im_mul_r = reshape(imul,im_size,im_size,[]);
        % fake
        im_sing_illum = raw_fake_or(:,:,8*s+8*count_orf*col+1 :8*s+8*count_orf*col+8);%
        imre = reshape(im_sing_illum,im_size*im_size,8)*dimmer;
        imul = double(imre)*snrmat;
        im_mul_f = reshape(imul,im_size,im_size,[]);
        
        for arr = 1:multiplier
            realsmall = imresize(addnoise(im_mul_r(:,:,arr),'g',gain),[smsiz,smsiz]);
%             subplot(2,5,4);imshow(realsmall/1022);pause(0.01);
            [feat,~] = extractHOGFeatures(realsmall,'Cellsize',[celsiz,celsiz],'BlockSize',[blksiz,blksiz]);
            feat_real_or(s+1,col*fs*multiplier+(arr-1)*fs+1:col*fs*multiplier+(arr-1)*fs+fs) = feat; 
            
            fakesmall = imresize(addnoise(im_mul_f(:,:,arr),'g',gain),[smsiz,smsiz]);
%             subplot(2,5,9);imshow(fakesmall/1022);pause(0.01);
            [feat,~] = extractHOGFeatures(fakesmall,'Cellsize',[celsiz,celsiz],'BlockSize',[blksiz,blksiz]);
            feat_fake_or(s+1,col*fs*multiplier+(arr-1)*fs+1:col*fs*multiplier+(arr-1)*fs+fs) = feat;
%             subplot(1,2,2);imagesc(fakesmall);hold on;plot(vizf);hold off;pause(0.01);
        end
        
        % real banana
        im_sing_illum = raw_real_bn(:,:,8*s+8*count_bnr*col+1 :8*s+8*count_bnr*col+8); %
        imre = reshape(im_sing_illum,800*800,8)*dimmer;
        imul = double(imre)*snrmat;
        im_mul_r = reshape(imul,800,800,[]);
        % fake
        im_sing_illum = raw_fake_bn(:,:,8*s+8*count_bnf*col+1 :8*s+8*count_bnf*col+8);%
        imre = reshape(im_sing_illum,800*800,8)*dimmer;
        imul = double(imre)*snrmat;
        im_mul_f = reshape(imul,800,800,[]);
        
        for arr = 1:multiplier
            realsmall = imresize(addnoise(im_mul_r(:,:,arr),'g',gain),[smsiz,smsiz]);
%             subplot(2,5,5);imshow(realsmall/1022);pause(0.01);
            [feat,~] = extractHOGFeatures(realsmall,'Cellsize',[celsiz,celsiz],'BlockSize',[blksiz,blksiz]);
            feat_real_bn(s+1,col*fs*multiplier+(arr-1)*fs+1:col*fs*multiplier+(arr-1)*fs+fs) = feat;  %

            fakesmall = imresize(addnoise(im_mul_f(:,:,arr),'g',gain),[smsiz,smsiz]);
%             subplot(2,5,10);imshow(fakesmall/1022);pause(0.01);
            [feat,~] = extractHOGFeatures(fakesmall,'Cellsize',[celsiz,celsiz],'BlockSize',[blksiz,blksiz]);
            feat_fake_bn(s+1,col*fs*multiplier+(arr-1)*fs+1:col*fs*multiplier+(arr-1)*fs+fs) = feat;
        end
    end 
end 
feat_fake_ga(:,end) = 0;
feat_real_ga(:,end) = 1; 
feat_fake_ra(:,end) = 2;
feat_real_ra(:,end) = 3;
feat_fake_gg(:,end) = 4; 
feat_real_gg(:,end) = 5; 
feat_fake_bn(:,end) = 6; 
feat_real_bn(:,end) = 7;
feat_fake_or(:,end) = 8;
feat_real_or(:,end) = 9;
%
% extractor();
%% classification
true_label = [];pred_label = [];allinds = [];avgtestacc = 0;
figure;hold on;
for epoch = 1:2000
% training feature vector
% trainfeature1 = [feat_real_ga;feat_fake_ga;
%                 feat_real_ra;feat_fake_ra;
%                 feat_real_gg;feat_fake_gg;
%                 feat_real_bn;feat_fake_bn;
%                 feat_real_or;feat_fake_or];       
% traininds1 = randsample(size(trainfeature1,1),ceil(size(trainfeature1,1)*0.75));
% trainlabel = trainfeature1(traininds1,end);
% trainfeature = trainfeature1(traininds1,1:end-1); 

traininds1 = randsample(size(feat_real_ga,1),ceil(size(feat_real_ga,1)*0.75)); % select some indices
trainfeature = [feat_real_ga(traininds1,:);feat_fake_ga(traininds1,:);
                feat_real_ra(traininds1,:);feat_fake_ra(traininds1,:);
                feat_real_gg(traininds1,:);feat_fake_gg(traininds1,:);
                feat_real_bn(traininds1,:);feat_fake_bn(traininds1,:);
                feat_real_or(traininds1,:);feat_fake_or(traininds1,:)];
traininds2 = randsample(size(trainfeature,1),size(trainfeature,1)); % shuffle again
trainlabel = trainfeature(traininds2,end);
trainfeature = trainfeature(traininds2,1:end-1); 

% testing feature vector
% testinds1 = 1:size(trainfeature1,1);
% testinds1(traininds1) = [];
% testfeature = trainfeature1(testinds1,:);
% 
testinds1= 1:size(feat_real_ga,1);
testinds1(traininds1) = [];
testfeature = [feat_real_ga(testinds1,:);feat_fake_ga(testinds1,:);
                feat_real_ra(testinds1,:);feat_fake_ra(testinds1,:);
                feat_real_gg(testinds1,:);feat_fake_gg(testinds1,:);
                feat_real_bn(testinds1,:);feat_fake_bn(testinds1,:);
                feat_real_or(testinds1,:);feat_fake_or(testinds1,:)];

testlabel = testfeature(:,end);
testfeature = testfeature(:,1:end-1);

true_label = [true_label;testlabel];
%%
model = fitcecoc(trainfeature,trainlabel,'Coding','onevsall');
% predict the testing set
[label,score] = predict(model,testfeature);
pred_label = [pred_label;label]; % make confusion mat with it
% allinds(:,epoch) = repmat(testinds1,1,10)'; % collect all mismatched image
% allinds(:,epoch) = testinds1;
% mismatch = testlabel ~= label;
% allinds2(:,epoch) = allinds(:,epoch).*mismatch;
avgtestacc(epoch) = sum(testlabel == label)/length(label);
plot(epoch,mean(avgtestacc),'m.');
% plot(epoch,median(avgtestacc),'r.');
pause(0.00001);
end 
% do a stochastic descend
if mean(avgtestacc) > bestacc 
%     best_label2 = [pred_label,true_label];
    bestmat = snrmat;
%     bestinds2 = allinds;
    fprintf('Avg Accuracy test: %.3f\n', mean(avgtestacc)*100);
    bestacc = mean(avgtestacc);
end

end
toc;
end
bestmat2 = bestmat';
end
%%
% making conf mat
figure
cm = confusionmat(pred_label,true_label);
lab = {'fake greenapple';'real greenapple';
       'fake redapple';'real redapple';
       'fake greengrape';'real greengrape';
       'fake banana';'real banana';
       'fake orange';'real orange'};
cm2 = confusionchart(cm,lab);
cm2.RowSummary = "row-normalized";
cm2.ColumnSummary = 'column-normalized';
% best column = 10101001
% best col2 = 0 1 0 0 1 0 0 0 