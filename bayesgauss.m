function d = bayesgauss(X,CA,MA,P)

error(nargchk(2,4,nargin));
n = size(CA,1);

X = double(X(:,1:n));
W = size(CA,3); % number of pattern class
K = size(X,1); % number of pattern

if nargin == 3
    P(1:W) = 1/W;
else 
    if sum(P) ~= 1
        error('Elements of P must sum to 1');
    end
end
for j = 1:W
    DM(j) = det(CA(:,:,j));
    
end

MA = MA';
for j = 1:W
    C = CA(:,:,j);
    M = MA(j,:);
    L(1:K,1) = log(P(j));
    DET(1:K,1) = 0.5*log(DM(j));
    if P(j) == 0
        D(1:K,j) = -inf;
    else
        D(:,j) = L-DET - 0.5*mahalanobis(X,C,M);
    end
end

[i,j] = find(bsxfun(@eq,D,max(D,[],2)));
X = [i,j];
X = sortrows(X);
[b,m] = unique(X(:,1));
X = X(m,:);
d = X(:,2);
end
end