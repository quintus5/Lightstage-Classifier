function [X,R] = imstack2vector(S,MASK)

[M,N,n] = size(S);

if nargin == 1
    MASK = true(M,N);
else
    MASK = MASK ~= 0;
end

R = find(MASK);
Q = M*N;
X = reshape(S,Q,n);
MASK = reshape(MASK,Q,1);
X = X(MASK,:);

end