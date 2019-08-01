r1 = imread('C:\Users\user\Pictures\basler\classtest\plate\bump\Basler acA1920-150um (40026510)_20190730_162329941_0005.tiff');
r2 = imread('C:\Users\user\Pictures\basler\classtest\plate\bump\Basler acA1920-150um (40026510)_20190730_162329941_0006.tiff');
f1 = imread('C:\Users\user\Pictures\basler\classtest\plate\hole\Basler acA1920-150um (40026510)_20190730_162723832_0005.tiff');
f2 = imread('C:\Users\user\Pictures\basler\classtest\plate\hole\Basler acA1920-150um (40026510)_20190730_162723832_0006.tiff');
lbpr1 = extractLBPFeatures(r1,'Upright', true);
lbpr2 = extractLBPFeatures(r2,'Upright', true);
lbpf1 = extractLBPFeatures(f1,'Upright', true);
lbpf2 = extractLBPFeatures(f2,'Upright', true);
% ptr = detectSURFFeatures(r1,'MetricThreshold',300);
% prf = detectSURFFeatures(f2,'MetricThreshold',300);

% figure
% imshow(r1);hold on;
% plot(ptr);
% figure
% imshow(f1); hold on;
% plot(ptf);
r1vr2 = (lbpr1 - lbpr2).^2;
f1vf2 = (lbpf1 - lbpf2).^2;
y = [r1vr2;f1vf2];
% figure;
bar(y');
legend('bump','holes')
xlabel('histogram bins');
ylabel('squared error');