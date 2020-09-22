function J = addnoise(I,type,value,dim)
%ADDNOISE(I, type, value) add poisson and read noise to image
% 
% Inpuuts:
%     'I'         - 10bit image
%     'type'      - 'g' or 'e' to selection which parameter to operate on, char
%     'value'     - camera settings for 'type'
%     'dim'       - scale to prevent over saturation from multiplexing
%     
% Output:
%     'J'         - image with artificial noise
%
% Note:
%   gain should be db version of gain, e.g. 6 = 2x
%   expt is multiple of base exposure time, e.g. 0.5,0.4,0.3...
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