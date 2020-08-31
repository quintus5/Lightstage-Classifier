function J = addnoise(I,type,value)
%ADDNOISE(I, type, value) add poisson and read noise to image
%   I should be 10 bit image 0~1023
%   type specify operating with gain or exposure time
%   gain should be db version of gain, e.g. 6 = 2x
%   expt is multiple of base exposure time, e.g. 0.5,0.4,0.3...

% image stats
im_mean = double(I(:));
imsiz = size(I);
dimmer = 20*log10(1);
if type == 'g'
    gain = 10^((value-15)/20);
    expt = 1/gain;
    gain = 10^((value+dimmer-15)/20); % dimmer only affects gain
    im_std = gain*(sqrt(0.7*expt*im_mean+66)); % at 15dB gain
%     gain = 10^(value/20);
%     expt = 1/gain;
%     gain = 10^((value+dimmer)/20); % account for image saturation
%     im_std = gain*(sqrt((0.1245*expt*im_mean)+2.08)); % at 0dB gain
elseif type == 'e'
    if value == 0
        fprintf('exposure zero');
        return;
    end
    expt = value;
    gain = 1/expt*1;      
    im_std = gain*(sqrt((0.1245*expt*im_mean)+2.087)); % at 0dB gain
end

% equation 3
r = normrnd(im_mean,im_std);
% clipping
r(r(:)>1023) = 1023;
r(r(:)<0) = 0;
J = reshape(r,imsiz);
end