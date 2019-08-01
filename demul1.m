%% red
% r1 = double(imread('real\orange2\Basler acA1920-150um (40026510)_20190712_231243034_0001.tiff'))/65535;
% r2 = double(imread('real\orange2\Basler acA1920-150um (40026510)_20190712_231243034_0002.tiff'))/65535;
% r3 = double(imread('real\orange2\Basler acA1920-150um (40026510)_20190712_231243034_0003.tiff'))/65535;
% r4 = double(imread('real\orange2\Basler acA1920-150um (40026510)_20190712_231243034_0004.tiff'))/65535;
r1 = double(imread('real\orange3\Basler acA1920-150um (40026510)_20190716_220603101_0001.tiff'))/255;
r2 = double(imread('real\orange3\Basler acA1920-150um (40026510)_20190716_220603101_0002.tiff'))/255;
r3 = double(imread('real\orange3\Basler acA1920-150um (40026510)_20190716_220603101_0003.tiff'))/255;
r4 = double(imread('real\orange3\Basler acA1920-150um (40026510)_20190716_220603101_0004.tiff'))/255;

fr1 = double(imread('fake\orange3\Basler acA1920-150um (40026510)_20190716_220306711_0001.tiff'))/255;
fr2 = double(imread('fake\orange3\Basler acA1920-150um (40026510)_20190716_220306711_0002.tiff'))/255;
fr3 = double(imread('fake\orange3\Basler acA1920-150um (40026510)_20190716_220306711_0003.tiff'))/255;
fr4 = double(imread('fake\orange3\Basler acA1920-150um (40026510)_20190716_220306711_0004.tiff'))/255;
% fr1 = double(imread('real\orange\Basler acA1920-150um (40026510)_20190716_220933616_0001.tiff'))/255;
% fr2 = double(imread('real\orange\Basler acA1920-150um (40026510)_20190716_220933616_0002.tiff'))/255;
% fr3 = double(imread('real\orange\Basler acA1920-150um (40026510)_20190716_220933616_0003.tiff'))/255;
% fr4 = double(imread('real\orange\Basler acA1920-150um (40026510)_20190716_220933616_0004.tiff'))/255;

rr1 = reshape(r1,1,350*352);
rr2 = reshape(r2,1,350*352);
rr3 = reshape(r3,1,350*352);
rr4 = reshape(r4,1,350*352);
f1 = reshape(fr1,1,350*352);
f2 = reshape(fr2,1,350*352);
f3 = reshape(fr3,1,350*352);
f4 = reshape(fr4,1,350*352);
demulmat = [1,1,0,1;
            1,1,1,0;
            0,1,1,1;
            1,0,1,1];
rrmat = [rr1;rr2;rr3;rr4];
frmat = [f1;f2;f3;f4];
demulr = (demulmat\rrmat)*2;
demulf = (demulmat\frmat)*2;
dr1 = reshape(demulr(1,:),350,352);
dr2 = reshape(demulr(2,:),350,352);
dr3 = reshape(demulr(3,:),350,352);
dr4 = reshape(demulr(4,:),350,352);
df1 = reshape(demulf(1,:),350,352);
df2 = reshape(demulf(2,:),350,352);
df3 = reshape(demulf(3,:),350,352);
df4 = reshape(demulf(4,:),350,352);
% figure;
% subplot(2,4,1);
% imshow(df1);
% subplot(2,4,2);
% imshow(df2);
% subplot(2,4,3);
% imshow(df3);
% subplot(2,4,4);
% imshow(df4);
% subplot(2,4,5);
% imshow(dr1);
% subplot(2,4,6)
% imshow(dr2);
% subplot(2,4,7)
% imshow(dr3);
% subplot(2,4,8)
% imshow(dr4);
% sgtitle('RED LED demultiplexed photos, fake orange on top, real on bottom');

figure;
subplot(2,4,1);
BW = imbinarize(df1,'adaptive');
lbpf1 = extractLBPFeatures(BW,'Upright',false);
imshow(BW);
subplot(2,4,2);
BW = imbinarize(df2,'adaptive');
lbpf2 = extractLBPFeatures(BW,'Upright',false);
imshow(BW);
subplot(2,4,3);
BW = imbinarize(df3,'adaptive');
lbpf3 = extractLBPFeatures(BW,'Upright',false);
imshow(BW);
subplot(2,4,4);
BW = imbinarize(df4,'adaptive');
lbpf4 = extractLBPFeatures(BW,'Upright',false);
imshow(BW);
subplot(2,4,5);
BW = imbinarize(dr1,'adaptive');
lbpr1 = extractLBPFeatures(BW,'Upright',false);
imshow(BW);
subplot(2,4,6);
BW = imbinarize(dr2,'adaptive');
lbpr2 = extractLBPFeatures(BW,'Upright',false);
imshow(BW);
subplot(2,4,7);
BW = imbinarize(dr3,'adaptive');
lbpr3 = extractLBPFeatures(BW,'Upright',false);
imshow(BW);
subplot(2,4,8);
BW = imbinarize(dr4,'adaptive');
lbpr4 = extractLBPFeatures(BW,'Upright',false);
imshow(BW);
sgtitle('binarized red LED illuminated orange fake top real bottom adaptive method');

r1vr21 = (lbpr1-lbpr2).^2;
f1vf21 = (lbpf1-lbpf2).^2;
r1vr22 = (lbpr2-lbpr3).^2;
f1vf22 = (lbpf2-lbpf3).^2;
r1vr23 = (lbpr3-lbpr4).^2;
f1vf23 = (lbpf3-lbpf4).^2;
r1vr24 = (lbpr4-lbpr1).^2;
f1vf24 = (lbpf4-lbpf1).^2;
figure;
subplot(2,2,1)
bar([r1vr21;f1vf21]','grouped');
legend('real orange','fake orange')
title('top right to bot right')
subplot(2,2,2)
bar([r1vr22;f1vf22]','grouped');
legend('real orange','fake orange')
title('bot right to top left')
subplot(2,2,3)
bar([r1vr23;f1vf23]','grouped');
title('top left to bot left')
legend('real orange','fake orange')
subplot(2,2,4)
bar([r1vr24;f1vf24]','grouped');
title('bot left to top right')
sgtitle('using LBP to measure how change in light direction affect texture')
legend('real orange','fake orange')
%% green

g1 = double(imread('fake\orange2\Basler acA1920-150um (40026510)_20190712_231007596_0005.tiff'))/65535;
g2 = double(imread('fake\orange2\Basler acA1920-150um (40026510)_20190712_231007596_0006.tiff'))/65535;
g3 = double(imread('fake\orange2\Basler acA1920-150um (40026510)_20190712_231007596_0007.tiff'))/65535;
g4 = double(imread('fake\orange2\Basler acA1920-150um (40026510)_20190712_231007596_0008.tiff'))/65535;
fg1 = double(imread('fake\orange1\Basler acA1920-150um (40026510)_20190712_010638720_0003.tiff'))/255;
fg2 = double(imread('fake\orange1\Basler acA1920-150um (40026510)_20190712_010638720_0004.tiff'))/255;
fg3 = double(imread('fake\orange1\Basler acA1920-150um (40026510)_20190712_010638720_0011.tiff'))/255;
fg4 = double(imread('fake\orange1\Basler acA1920-150um (40026510)_20190712_010638720_0012.tiff'))/255;

gg1 = reshape(g1,1,350*352);
gg2 = reshape(g2,1,350*352);
gg3 = reshape(g3,1,350*352);
gg4 = reshape(g4,1,350*352);

demulmat = [1,1,1,1;
            1,0,1,0;
            1,1,0,0;
            1,0,0,1];
ggmat = [gg1;gg2;gg3;gg4];

demulg = (demulmat\ggmat)*2;
dg1 = reshape(demulg(1,:),350,352);
dg2 = reshape(demulg(2,:),350,352);
dg3 = reshape(demulg(3,:),350,352);
dg4 = reshape(demulg(4,:),350,352);

figure;
subplot(2,4,1);

imshow(fg1.*2);
subplot(2,4,2);
imshow(fg2.*2);
subplot(2,4,3);
imshow(fg4.*2);
subplot(2,4,4);
imshow(fg3.*2);
subplot(2,4,5);
imshow(dg1);
subplot(2,4,6)
imshow(dg2);
subplot(2,4,7)
imshow(dg3);
subplot(2,4,8)
imshow(dg4);

sgtitle('Green single light on top, demultiplexed on bottom (brightness x 2)');

%% ir
i1 = double(imread('fake\orange4\Basler acA1920-150um (40026510)_20190712_231007596_0013.tiff'))/65535;
i2 = double(imread('fake\orange4\Basler acA1920-150um (40026510)_20190712_231007596_0014.tiff'))/65535;
i3 = double(imread('fake\orange4\Basler acA1920-150um (40026510)_20190712_231007596_0015.tiff'))/65535;
i4 = double(imread('fake\orange4\Basler acA1920-150um (40026510)_20190712_231007596_0016.tiff'))/65535;
fi1 = double(imread('fake\orange4\Basler acA1920-150um (40026510)_20190712_010638720_0007.tiff'))/255;
fi2 = double(imread('fake\orange4\Basler acA1920-150um (40026510)_20190712_010638720_0008.tiff'))/255;
fi3 = double(imread('fake\orange4\Basler acA1920-150um (40026510)_20190712_010638720_0015.tiff'))/255;
fi4 = double(imread('fake\orange4\Basler acA1920-150um (40026510)_20190712_010638720_0016.tiff'))/255;

ii1 = reshape(i1,1,350*352);
ii2 = reshape(i2,1,350*352);
ii3 = reshape(i3,1,350*352);
ii4 = reshape(i4,1,350*352);

demulmat = [1,1,1,1;
            1,0,1,0;
            1,1,0,0;
            1,0,0,1];
iimat = [ii1;ii2;ii3;ii4];

demuli = (demulmat\iimat);
di1 = reshape(demuli(1,:),350,352);
di2 = reshape(demuli(2,:),350,352);
di3 = reshape(demuli(3,:),350,352);
di4 = reshape(demuli(4,:),350,352);

figure;
subplot(2,4,1);
imshow(fi1);
subplot(2,4,2);
imshow(fi2);
subplot(2,4,3);
imshow(fi4);
subplot(2,4,4);
imshow(fi3);
subplot(2,4,5);
imshow(di1);
subplot(2,4,6)
imshow(di2);
subplot(2,4,7)
imshow(di3);
subplot(2,4,8)
imshow(di4);

sgtitle('NIR single light on top, demultiplexed on bottom');

%% nir
fi1 = imread('fake\orange4\Basler acA1920-150um (40026510)_20190716_222027208_0013.tiff');
fi2 = imread('fake\orange4\Basler acA1920-150um (40026510)_20190716_222027208_0014.tiff');
fi3 = imread('fake\orange4\Basler acA1920-150um (40026510)_20190716_222027208_0015.tiff');
fi4 = imread('fake\orange4\Basler acA1920-150um (40026510)_20190716_222027208_0016.tiff');
ri1 = imread('real\orange4\Basler acA1920-150um (40026510)_20190716_222218885_0013.tiff');
ri2 = imread('real\orange4\Basler acA1920-150um (40026510)_20190716_222218885_0014.tiff');
ri3 = imread('real\orange4\Basler acA1920-150um (40026510)_20190716_222218885_0015.tiff');
ri4 = imread('real\orange4\Basler acA1920-150um (40026510)_20190716_222218885_0016.tiff');

figure;
subplot(2,4,1);
imshow(fi1);
subplot(2,4,2);
imshow(fi2);
subplot(2,4,3);
imshow(fi3);
subplot(2,4,4);
imshow(fi4);
subplot(2,4,5);
imshow(ri1);
subplot(2,4,6)
imshow(ri2);
subplot(2,4,7)
imshow(ri3);
subplot(2,4,8)
imshow(ri4);

sgtitle('NIR illumination, fake on top, real on bottom');


figure;
subplot(2,4,1);
BW = imbinarize(fi1,'adaptive');
lbpf1 = extractLBPFeatures(BW,'Upright',false);
imshow(BW);
subplot(2,4,2);
BW = imbinarize(fi2,'adaptive');
lbpf2 = extractLBPFeatures(BW,'Upright',false);
imshow(BW);
subplot(2,4,3);
BW = imbinarize(fi3,'adaptive');
lbpf3 = extractLBPFeatures(BW,'Upright',false);
imshow(BW);
subplot(2,4,4);
BW = imbinarize(fi4,'adaptive');
lbpf4 = extractLBPFeatures(BW,'Upright',false);
imshow(BW);
subplot(2,4,5);
BW = imbinarize(ri1,'adaptive');
lbpr1 = extractLBPFeatures(BW,'Upright',false);
imshow(BW);
subplot(2,4,6);
BW = imbinarize(ri2,'adaptive');
lbpr2 = extractLBPFeatures(BW,'Upright',false);
imshow(BW);
subplot(2,4,7);
BW = imbinarize(ri3,'adaptive');
lbpr3 = extractLBPFeatures(BW,'Upright',false);
imshow(BW);
subplot(2,4,8);
BW = imbinarize(ri4,'adaptive');
lbpr4 = extractLBPFeatures(BW,'Upright',false);
imshow(BW);
sgtitle('binarized NIR LED illuminated orange fake top real bottom adaptive method');

r1vr21 = (lbpr1-lbpr2).^2;
f1vf21 = (lbpf1-lbpf2).^2;
r1vr22 = (lbpr2-lbpr3).^2;
f1vf22 = (lbpf2-lbpf3).^2;
r1vr23 = (lbpr3-lbpr4).^2;
f1vf23 = (lbpf3-lbpf4).^2;
r1vr24 = (lbpr4-lbpr1).^2;
f1vf24 = (lbpf4-lbpf1).^2;
figure;
subplot(2,2,1)
bar([r1vr21;f1vf21]','grouped');
legend('real orange','fake orange')
title('top right to bot right')
subplot(2,2,2)
bar([r1vr22;f1vf22]','grouped');
legend('real orange','fake orange')
title('bot right to top left')
subplot(2,2,3)
bar([r1vr23;f1vf23]','grouped');
title('top left to bot left')
legend('real orange','fake orange')
subplot(2,2,4)
bar([r1vr24;f1vf24]','grouped');
title('bot left to top right')
sgtitle('using LBP to measure how change in light direction affect texture')
legend('real orange','fake orange')
%% blue
fb1 = double(imread('fake\orange4\Basler acA1920-150um (40026510)_20190716_222027208_0009.tiff'))/255;
fb2 = double(imread('fake\orange4\Basler acA1920-150um (40026510)_20190716_222027208_0010.tiff'))/255;
fb3 = double(imread('fake\orange4\Basler acA1920-150um (40026510)_20190716_222027208_0011.tiff'))/255;
fb4 = double(imread('fake\orange4\Basler acA1920-150um (40026510)_20190716_222027208_0012.tiff'))/255;
rb1 = double(imread('real\orange4\Basler acA1920-150um (40026510)_20190716_222218885_0009.tiff'))/255;
rb2 = double(imread('real\orange4\Basler acA1920-150um (40026510)_20190716_222218885_0010.tiff'))/255;
rb3 = double(imread('real\orange4\Basler acA1920-150um (40026510)_20190716_222218885_0011.tiff'))/255;
rb4 = double(imread('real\orange4\Basler acA1920-150um (40026510)_20190716_222218885_0012.tiff'))/255;

drb1 = reshape(rb1,1,350*352);
drb2 = reshape(rb2,1,350*352);
drb3 = reshape(rb3,1,350*352);
drb4 = reshape(rb4,1,350*352);
dfb1 = reshape(fb1,1,350*352);
dfb2 = reshape(fb2,1,350*352);
dfb3 = reshape(fb3,1,350*352);
dfb4 = reshape(fb4,1,350*352);
demulmat = [1,1,1,1;
            1,0,1,0;
            1,1,0,0;
            1,0,0,1];
rbmat = [drb1;drb2;drb3;drb4];
fbmat = [dfb1;dfb2;dfb3;dfb4];
demulfb = (demulmat\fbmat)*2;
demulrb = (demulmat\rbmat)*2;
drb1 = reshape(demulrb(1,:),350,352);
drb2 = reshape(demulrb(2,:),350,352);
drb3 = reshape(demulrb(3,:),350,352);
drb4 = reshape(demulrb(4,:),350,352);
dfb1 = reshape(demulfb(1,:),350,352);
dfb2 = reshape(demulfb(2,:),350,352);
dfb3 = reshape(demulfb(3,:),350,352);
dfb4 = reshape(demulfb(4,:),350,352);
figure;
subplot(2,4,1);
imshow(dfb1);
subplot(2,4,2);
imshow(dfb2);
subplot(2,4,3);
imshow(dfb3);
subplot(2,4,4);
imshow(dfb4);
subplot(2,4,5);
imshow(drb1);
subplot(2,4,6)
imshow(drb2);
subplot(2,4,7)
imshow(drb3);
subplot(2,4,8)
imshow(drb4);
sgtitle('BLUE LED demultiplexed photos, fake orange on top, real on bottom');

figure;
subplot(2,4,1);
BW = imbinarize(dfb1,0.364);
lbpf1 = extractLBPFeatures(BW,'Upright',false);
imshow(BW);
subplot(2,4,2);
BW = imbinarize(dfb2,0.364);
lbpf2 = extractLBPFeatures(BW,'Upright',false);
imshow(BW);
subplot(2,4,3);
BW = imbinarize(dfb3,0.364);
lbpf3 = extractLBPFeatures(BW,'Upright',false);
imshow(BW);
subplot(2,4,4);
BW = imbinarize(dfb4,0.364);
lbpf4 = extractLBPFeatures(BW,'Upright',false);
imshow(BW);
subplot(2,4,5);
BW = imbinarize(drb1,0.364);
lbpr1 = extractLBPFeatures(BW,'Upright',false);
imshow(BW);
subplot(2,4,6);
BW = imbinarize(drb2,0.364);
lbpr2 = extractLBPFeatures(BW,'Upright',false);
imshow(BW);
subplot(2,4,7);
BW = imbinarize(drb3,0.364);
lbpr3 = extractLBPFeatures(BW,'Upright',false);
imshow(BW);
subplot(2,4,8);
BW = imbinarize(drb4,0.364);
lbpr4 = extractLBPFeatures(BW,'Upright',false);
imshow(BW);
sgtitle('binarized BLUE LED illuminated orange fake top real bottom threshold 0.364');

r1vr21 = (lbpr1-lbpr2).^2;
f1vf21 = (lbpf1-lbpf2).^2;
r1vr22 = (lbpr2-lbpr3).^2;
f1vf22 = (lbpf2-lbpf3).^2;
r1vr23 = (lbpr3-lbpr4).^2;
f1vf23 = (lbpf3-lbpf4).^2;
r1vr24 = (lbpr4-lbpr1).^2;
f1vf24 = (lbpf4-lbpf1).^2;
figure;
subplot(2,2,1)
bar([r1vr21;f1vf21]','grouped');
legend('real orange','fake orange')
% title('top right to bot right')
subplot(2,2,2)
bar([r1vr22;f1vf22]','grouped');
legend('real orange','fake orange')
% title('bot right to top left')
subplot(2,2,3)
bar([r1vr23;f1vf23]','grouped');
% title('top left to bot left')
legend('real orange','fake orange')
subplot(2,2,4)
bar([r1vr24;f1vf24]','grouped');
% title('bot left to top right')
sgtitle('using LBP to measure how change in light direction affect texture')
legend('real orange','fake orange');
%% color image
% colr = imread('fake\orange4\Basler acA1920-150um (40026510)_20190716_222027208_0001.tiff');
% colg = imread('fake\orange4\Basler acA1920-150um (40026510)_20190716_222027208_0005.tiff');
% colb = imread('fake\orange4\Basler acA1920-150um (40026510)_20190716_222027208_0009.tiff');
% colr = imread('fake\apple2\Basler acA1920-150um (40026510)_20190712_231540876_0001.tiff');
% colg = imread('fake\apple2\Basler acA1920-150um (40026510)_20190712_231540876_0005.tiff');
% colb = imread('fake\apple2\Basler acA1920-150um (40026510)_20190712_231540876_0009.tiff');
colr = imread('fake\paprika\Basler acA1920-150um (40026510)_20190712_231630062_0001.tiff');
colg = imread('fake\paprika\Basler acA1920-150um (40026510)_20190712_231630062_0005.tiff');
colb = imread('fake\paprika\Basler acA1920-150um (40026510)_20190712_231630062_0009.tiff');
colim1(:,:,1) = colr;
colim1(:,:,2) = colg;
colim1(:,:,3) = colb;
imshow(colim1);
title('orange colored');

% colim1(:,:,1) = dr1;
% colim1(:,:,2) = dg1;
% colim1(:,:,3) = db1;
% colim2(:,:,1) = dr2;
% colim2(:,:,2) = dg2;
% colim2(:,:,3) = db2;
% colim3(:,:,1) = dr3;
% colim3(:,:,2) = dg3;
% colim3(:,:,3) = db3;
% colim4(:,:,1) = dr4;
% colim4(:,:,2) = dg4;
% colim4(:,:,3) = db4;
% figure;
% subplot(1,4,1);
% imshow(colim1);
% subplot(1,4,2);
% imshow(colim2);
% subplot(1,4,3);
% imshow(colim3);
% subplot(1,4,4);
% imshow(colim4);

