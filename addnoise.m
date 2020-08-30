function J = addnoise(I,type,value)
%ADDNOISE(I, type, value) add poisson and read noise to image
%   I should be 10 bit image 0~1023
%   type specify operating with gain or exposure time
%   gain should be db version of gain, e.g. 6 = 2x
%   expt is multiple of base exposure time, e.g. 0.5,0.4,0.3...

im_mean = double(I(:));
imsiz = size(I);
im_len = 1:length(im_mean);

if type == 'g'
    gain = 10^((value-15)/20);
    expt = 1/gain;
    im_std = gain*(sqrt((0.7*expt*im_mean)+66)); % at 15dB gain
elseif type == 'e'
    expt = value;
    gain = 1/expt;      
    im_std = gain*(sqrt((0.1244*expt*im_mean)+2.806)); % at 0dB gain
end
% equation
r = normrnd(im_mean,im_std);
% clipping
r(r(:)>1023) = 1023;
r(r(:)<0) = 0;
J = reshape(r,imsiz);
end