function lighting_pattern = Column_Permutation(N)
%Column_Permutation(N) returns all possible permutation (2^N-1) of a 1xN
%binary vector in cell format.
% N should be interger. e.g. N = 8, returns 255 possible permutations

mat = tril(ones(N));

for count = 1:N-1
    type = perms(mat(count,:));
    ledtype{count} = unique(type,'rows');
end
lighting_pattern = ledtype;
end
