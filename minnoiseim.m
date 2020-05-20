myFolder = 'C:\Users\user\Pictures\basler\paper\test0805\nonoise';
filePattern = fullfile(myFolder, '*.tiff');
jpegFiles = dir(filePattern);
destfolder = 'C:\Users\user\Pictures\basler\paper\test0805\nononoise';

% how many photo per pose
ppp = 20;
%%

for pose = 0:1 %rmb to change
    
clear im imul imrnew imgnew imbnew iminew;

for i = 1:80  %rmb to change
    baseFileName = jpegFiles(640*pose+i).name;
    fullFileName = fullfile(myFolder, baseFileName);
    im(:,:,i) = imread(fullFileName);
end 

% average
for z = 1:1
    red1(:,:,z) = sum(im(:,:,z:8:ppp*8),3)/ppp;
    grn1(:,:,z) = sum(im(:,:,z+ppp*8:8:ppp*8*2),3)/ppp;
    blu1(:,:,z) = sum(im(:,:,z+ppp*8*2:8:ppp*8*3),3)/ppp;
    nir1(:,:,z) = sum(im(:,:,z+ppp*8*3:8:ppp*8*4),3)/ppp;
    
    
    namer = ['c1r_p',num2str(pose+11),'_l',num2str(z),'.tiff'];
    nameg = ['c2g_p',num2str(pose+11),'_l',num2str(z),'.tiff'];
    nameb = ['c3b_p',num2str(pose+11),'_l',num2str(z),'.tiff'];
    namei = ['c4i_p',num2str(pose+11),'_l',num2str(z),'.tiff'];
    fullFileName = fullfile(destfolder, namer);
    imwrite(uint16(red1(:,:,z)),fullFileName);
    fullFileName = fullfile(destfolder, nameg);
    imwrite(uint16(grn1(:,:,z)),fullFileName);    
    fullFileName = fullfile(destfolder, nameb);
    imwrite(uint16(blu1(:,:,z)),fullFileName);
    fullFileName = fullfile(destfolder, namei);
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


