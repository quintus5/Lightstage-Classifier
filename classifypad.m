%% HOG
% [feat,vis,pvis] = extractHOGFeatures(sim{2},p);
% p = detectSURFFeatures(sim{2});
% pp = detectHarrisFeatures(noisefreeim{3});
% imt = imresize(mr{2},[100,100]);
pic(1,:) = mr;
pic(2,:) = mg;
pic(3,:) = mb;
pic(4,:) = mn;
for j = 1:4
    figure;
    for i = 1:8
        imt = imresize(pic{j,i},[100,100]);
        [feat(i+(j-1)*8,:),vis] = extractHOGFeatures(imt,'Cellsize',[3,3],'BlockSize',[4,4]);
        subplot(2,4,i);
        imagesc(imt);
        colormap hot;axis off;colorbar;
        hold on;
        plot(vis);
    end
end

%% pca
[coeff, score, latent, tsquared, explained] = pca(feat');

%%
