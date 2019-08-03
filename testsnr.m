% clc;        % Clear the command window.
% close all;  % Close all figures (except those of imtool.)
% clear;      % Erase all existing variables.
% workspace;  % Make sure the workspace panel is showing.
% fontSize = 22;
% %Load single MRI image
% I = imread('testim.jpg'); 
% % addition of graininess (i.e. noise)
% I_noise = imnoise(I, 'gaussian', 0.09); 
% % the average of 3^2, or 9 values(filters the multidimensional array A with the multidimensional filter h)
%  h = ones(3,3) / 3^2; 
%  I2 = imfilter(I_noise,h); 
% % Measure signal-to-noise ratio
% img=I;
% img=double(img(:));
% ima=max(img(:))
% imi=min(img(:))
% mse=std(img(:))
% snr=20*log10((ima-imi)./mse)
% % Measure Peak SNR
% [peaksnr, snr] = psnr(I_noise, I);
% fprintf('\n The Peak-SNR value is %0.4f', peaksnr);
% fprintf('\n The SNR value is %0.4f \n', snr);
% fprintf('\n The MSE value is %0.4f \n', mse);
%    %Plot original & filtered figure
%    subplot(1,2,1), imshow(I_noise), title('Original image') 
%    subplot(1,2,2), imshow(I2), title('Filtered image')
%     text(size(I,2),size(I,1)+15, ...
%       'Gaussian = 0.09', ...
%       'FontSize',10,'HorizontalAlignment','right');


%%
clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures if you have the Image Processing Toolbox.
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 25;
brightImage = 200*ones(150, 800, 'uint8');
darkImage = 20*ones(150, 800, 'uint8');
grayImage = [brightImage;darkImage];
% Display the original gray scale image.
subplot(3, 1, 1);
imshow(grayImage, []);
title('Original Noise-Free Grayscale Image', 'FontSize', fontSize);
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% Give a name to the title bar.
set(gcf, 'Name', 'Demo by ImageAnalyst', 'NumberTitle', 'Off') 
noisyImage = imnoise(grayImage, 'gaussian');
% Display the image.
subplot(3, 1, 2);
imshow(noisyImage, []);
title('Noisy Image', 'FontSize', fontSize);
% Get the standard deviation of the bright and dark areas
% We'll define this as the noise.
noisyBright = double(noisyImage(1:150, :));
stdNoiseBright = std(noisyBright(:))
noisyDark = double(noisyImage(151:300, :));
stdNoiseDark = std(noisyDark(:))
% Get the SNR image
snrImage = zeros(size(noisyImage)); % Initialize
snrImage(1:150, :) = noisyImage(1:150, :) / stdNoiseBright;
snrImage(151:300, :) = noisyImage(1:150, :) / stdNoiseDark;
% Display the image.
subplot(3, 1, 3);
imshow(snrImage, []);
title('SNR Image', 'FontSize', fontSize);