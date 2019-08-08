function [C,m] = covmat(X)
K = size(X,1);
X = double(X);
m = sum(X,1)/K;
X = X-m(ones(K,1),:);
C = (X'*X)/(K-1);
m = m';

end