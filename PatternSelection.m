ImageLoader();
%% =============System Config===================
LightingPattern = Column_Permutation(8); % derive all permutation   
Dimmer = 0.45;          % Prevent multiplexing saturation
Gain = 12;              % Simulation gain (dB)
NPose = 20;             % Total number of available pose
NColor = 4;             % Number of colors
NMsnt = 8;              % Number of measurement;
BestMatrix = [];        % Resulting matrix
%% ============Pattern Selection Loop===============
for column_i = 1:NMsnt  
    
for on_i = 1:size(LightingPattern,2)
    Pattern = LightingPattern{on_i};  
    fprintf('%d %d\n', column_i, on_i);
    
for pat_i = 1:length(Pattern)
    
    % concatenate with previous best matrix
    MUXMAT = [BestMatrix;Pattern(pat_i,:)]';
    N = size(MUXMAT,2);
    
    % Image rendering, feature extraction and vector forming
    Feat = FeatExtract(MUXMAT,Raw,NPose,NColor,NMsnt,N,Gain,Dimmer);
    
    % ================Classification==================
    AVGAccuracy = 0;

    % Repeating the test makes the most of the dataset
    for rep_i = 1:400
    % training feature vector
    TrainInds_1 = randsample(size(Feat.real_ga,1),ceil(size(Feat.real_ga,1)*0.75)); % select some indices
    TrainFeature = [Feat.real_ga(TrainInds_1,:);Feat.fake_ga(TrainInds_1,:);
                    Feat.real_ra(TrainInds_1,:);Feat.fake_ra(TrainInds_1,:);
                    Feat.real_gg(TrainInds_1,:);Feat.fake_gg(TrainInds_1,:);
                    Feat.real_bn(TrainInds_1,:);Feat.fake_bn(TrainInds_1,:);
                    Feat.real_or(TrainInds_1,:);Feat.fake_or(TrainInds_1,:)];
    TrainInds_2 = randsample(size(TrainFeature,1),size(TrainFeature,1)); % shuffle again
    TrainLabel = TrainFeature(TrainInds_2,end);
    TrainFeature = TrainFeature(TrainInds_2,1:end-1); 

    TestInds_1= 1:size(Feat.real_ga,1);
    TestInds_1(TrainInds_1) = [];
    TestFeature = [Feat.real_ga(TestInds_1,:);Feat.fake_ga(TestInds_1,:);
                    Feat.real_ra(TestInds_1,:);Feat.fake_ra(TestInds_1,:);
                    Feat.real_gg(TestInds_1,:);Feat.fake_gg(TestInds_1,:);
                    Feat.real_bn(TestInds_1,:);Feat.fake_bn(TestInds_1,:);
                    Feat.real_or(TestInds_1,:);Feat.fake_or(TestInds_1,:)];

    TestLabel = TestFeature(:,end);
    TestFeature = TestFeature(:,1:end-1);

    % training function
    Model = fitcecoc(TrainFeature,TrainLabel,'Coding','onevsall');

    % predict the testing set
    [label,~] = predict(Model,TestFeature);
    AVGAccuracy(rep_i) = sum(TestLabel == label)/length(label);
    end 
    
    % Do a stochastic descend
    if mean(AVGAccuracy) > HighestAccuracy 
        Currentbest = MUXMAT;
        fprintf('Avg Accuracy test: %.3f\n', mean(AVGAccuracy)*100);
        HighestAccuracy = mean(AVGAccuracy);
    end

end
end
    % update best matrix
    BestMatrix = Currentbest';
end
