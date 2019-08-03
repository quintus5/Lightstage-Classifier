function [psnr,snr,mse] = snrcalc(A,ref)

peakval = diff(getrangefromclass(A));
% sum sum (f(x,y)-f_hat(x,y))^2
mse = mean2((A(:)-ref(:)).^2);
% sum sum f(x,y)^2 / mse
snr = 10*log10(mean2(ref(:).^2)/mse);
% 1/mse
psnr = 10*log10(peakval^2/mse);

end