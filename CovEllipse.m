function CovEllipse(sigma,p)
    s = -2*log(1-p);
    [V,D] = eig(sigma(1:2,1:2)*s);
    t = linspace(0,2*pi);
    a = (V*sqrt(D))*[cos(t(:))';sin(t(:))'];
    plot(a(1,:),a(2,:),'g');    

end