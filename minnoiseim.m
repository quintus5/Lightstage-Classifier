myFolder = 'E:\work\2019\matlab\basler\paper\test2502\gaprf1_4100ms';
filePattern = fullfile(myFolder, '*.tiff');
jpegFiles = dir(filePattern);

% create random matrix
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

% how many photo per pose
ppp = 50;
%%

for pose = 0:10
    
clear im imul imrnew imgnew imbnew iminew;

for i = 1:1600
    baseFileName = jpegFiles(1600*pose+i).name;
    fullFileName = fullfile(myFolder, baseFileName);
    im(:,:,i) = imread(fullFileName);
end

% average
for z = 1:8
    red1(:,:,z) = sum(im(:,:,z:8:ppp*8),3)/ppp;
    grn1(:,:,z) = sum(im(:,:,z+ppp*8:8:ppp*8*2),3)/ppp;
    blu1(:,:,z) = sum(im(:,:,z+ppp*8*2:8:ppp*8*3),3)/ppp;
    nir1(:,:,z) = sum(im(:,:,z+ppp*8*3:8:ppp*8*4),3)/ppp;
    
    
    namer = ['c1_li',num2str(z),'r_po',num2str(pose),'.tiff'];
    nameg = ['c2_li',num2str(z),'g_po',num2str(pose),'.tiff'];
    nameb = ['c3_li',num2str(z),'b_po',num2str(pose),'.tiff'];
    namei = ['c4_li',num2str(z),'i_po',num2str(pose),'.tiff'];
    fullFileName = fullfile('C:\Users\user\Pictures\basler\paper\noisefreereal', namer);
    imwrite(uint16(red1(:,:,z)),fullFileName);
    fullFileName = fullfile('C:\Users\user\Pictures\basler\paper\noisefreereal', nameg);
    imwrite(uint16(grn1(:,:,z)),fullFileName);    
    fullFileName = fullfile('C:\Users\user\Pictures\basler\paper\noisefreereal', nameb);
    imwrite(uint16(blu1(:,:,z)),fullFileName);
    fullFileName = fullfile('C:\Users\user\Pictures\basler\paper\noisefreereal', namei);
    imwrite(uint16(nir1(:,:,z)),fullFileName);
end

end

% for a = 1:5
%     % brightness of each led on fruit as observed
%     bright = [0.7,0.4,0.7,0.4,0.7,0.4,0.7,0.4]*ledtype{a}';
%     % bright = 3.5;
%     imredre = reshape(red1,512*512,8);
%     imul = imredre*ledtype{a}';
%     imul = floor(imul./bright);
%     imrnew{a} = reshape(imul,512,512,size(ledtype{a},1));
% 
%     imgre = reshape(grn1,512*512,8);
%     imul = imgre*ledtype{a}';
%     imul = floor(imul./bright);
%     imgnew{a} = reshape(imul,512,512,size(ledtype{a},1));
% 
%     imbre = reshape(blu1,512*512,8);
%     imul = imbre*ledtype{a}';
%     imul = floor(imul./bright);
%     imbnew{a} = reshape(imul,512,512,size(ledtype{a},1));
% 
%     imire = reshape(nir1,512*512,8);
%     imul = imire*ledtype{a}';
%     imul = floor(imul./bright);
%     iminew{a} = reshape(imul,512,512,size(ledtype{a},1));
%     
%     for o = 1:size(ledtype{a},1)
%     %     subplot(1,3,1);
%         rim = imrnew{a};
%     %     imshow(rim(:,:,o));
%     %     subplot(1,3,2);
%         gim = imgnew{a};
%     %     imshow(gim(:,:,o));
%     %     subplot(1,3,3);
%         bim = imbnew{a};
%     %     imshow(bim(:,:,o));
%     %     pause(0.1)
%         iim = iminew{a};
% 
%         namer = ['c1_li',num2str(a),'r_po',num2str(pose),'_pa',num2str(o),'.tiff'];
%         nameg = ['c2_li',num2str(a),'g_po',num2str(pose),'_pa',num2str(o),'.tiff'];
%         nameb = ['c3_li',num2str(a),'b_po',num2str(pose),'_pa',num2str(o),'.tiff'];
%         namei = ['c4_li',num2str(a),'i_po',num2str(pose),'_pa',num2str(o),'.tiff'];
%         fullFileName = fullfile('C:\Users\user\Pictures\basler\paper\noisefreer', namer);
%         imwrite(uint16(rim(:,:,o)),fullFileName);
%         fullFileName = fullfile('C:\Users\user\Pictures\basler\paper\noisefreer', nameg);
%         imwrite(uint16(gim(:,:,o)),fullFileName);    
%         fullFileName = fullfile('C:\Users\user\Pictures\basler\paper\noisefreer', nameb);
%         imwrite(uint16(bim(:,:,o)),fullFileName);
%         fullFileName = fullfile('C:\Users\user\Pictures\basler\paper\noisefreer', namei);
%         imwrite(uint16(iim(:,:,o)),fullFileName);
%     end
% end
% 
% end