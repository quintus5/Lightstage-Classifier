function P = pcacalc(X,q)
K = size(X, 1);
X = double(X);

[P.Cx, P.mx] = covmat(X);
P.mx = P.mx';

[V,D] = eig(P.Cx);

d = diag(D);
[d,idx] = sort(d);
d = flipud(d);
idx = flipud(idx);
D = diag(d);
V = V(:,idx);

P.A = V(:,1:q)';

Mx = repmat(P.mx,K,1);
P.Y = P.A*(X-Mx)';

P.X = (P.A'*P.Y)' + Mx;

P.Y = P.Y';

P.mx = P.mx';

d = diag(D);
P.ems = sum(d(q+1:end));

P.Cy = P.A*P.Cx*P.A';

end