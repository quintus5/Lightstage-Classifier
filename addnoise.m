function J = addnoise(I,type,value,dim)
%ADDNOISE(I, type, value) add poisson and read noise to image
% 
% Inpuuts:
%     'I'         - 10bit image,double
%     'type'      - camera parameter to operate on, 'g' for gain, 'e' for
%                   exposure time.
%     'value'     - numerical camera settings for 'type'
%     'dim'       - scale to prevent over saturation from multiplexing
%     
% Output:
%     'J'         - 10bit image with artificial noise,double
%
% Note:
%   - This function mimics noise based off calibration on Basler
%     acA1920-150um camera
%   - The base calibration was done on 15dB gain 30ms setting.
%   - gain should be dB version of gain, e.g. 6dB = 2x, 12dB = 4x
%   - exposure time is relative to base exposure time, e.g. 0.5,0.4,0.3...
%   - For equivalent brightness, gain = 1/exposure
%
% Example:
%   J = addnoise(I, 'g', 11, 1);
%   add normal distributed noise with gain 11dB(2.5x), 0.28x exposure to image I,
%   without brightness scaling.
%
%   J = addnoise(I, 'e', 0.1, 0.5);
%   add normal distributed noise with exposure 0.1x of input image, 10x gain, 
%   with additinal 0.5x brightness scaling.
%
% Copyright 2020 Taihua Wang

% image stats
im_mean = double(I(:));
imsiz = size(I);
dimmer = 20*log10(dim);

if type == 'g'
    gain = 10^((value-15)/20);
    expt = 1/gain;
    gain = 10^((value+dimmer-15)/20); % dimmer only affects gain
    im_std = gain*(sqrt(0.7*expt*im_mean+66)); 

elseif type == 'e'
    if value == 0
        fprintf('exposure zero');
        return;
    end
    expt = value;
    gain = 1/expt*1;      
    im_std = gain*(sqrt((0.1245*expt*im_mean)+2.087)); % at 0dB gain
end

% generate gaussian distributed noise
r = normrnd(im_mean,im_std);

% clipping
r(r(:)>1023) = 1023;
r(r(:)<0) = 0;
J = reshape(r,imsiz);
end