% This program searches for multiplexing matrices W that yield optimal MSE or information
% These two metrics sometimes give different results
% Information seems like a smoother space, so better matrices are easier to find
% Interestingly, this often leads to matrices that also have better MSE
% This does not saturation into consideration -- todo!
% All tunable parameters are in the top part of the file
clearvars

%---
NChans = 10;        % how many things are we estimating
NMeas = NChans;    % how many measurements do we get; Must be >= NChans
SigStrength = 10;  % how strong is the signal, for noise strength sigma_n = 1
SatFloor = repmat(floor(NChans/2),NChans,1); % upperbound of saturation 
SatCeil = repmat(ceil(NChans/2+1),NChans,1); % lower bound of noisy data
% SatPixel = 0.96;   % signal intensity 0->1 with 0=darkness, 1=saturate.
SatPixel = NChans/SatCeil(1)*0.96; % saturate at certain number of light on

% Any prior information we have on the signal covariance goes here
Rpp = eye(NChans); % if everthing's equally likely leave as the eye matrix
Rpp = Rpp ./ det(Rpp).^(1/NChans);        % normalize energy
Rpp = Rpp .* SigStrength.^(1/NChans);     % and scale to SigStrength
SigVar = Rpp;

%---Optimisation parameters---
DoSidesteps = true; % all else equal, take the route that optimizes the info metric
BinaryOnly = true;  % true for binary masks, false for grayscale

%---Initialise the weigth matrix---
W = zeros(NMeas, NChans);
W(1:NChans,1:NChans) = eye(NChans);

%---Setup the optimisation---
BestMSE = inf;
BestInfo = 0;

iIter = 1;
WhichEval = 'both';
fprintf('     iIter, BestMSE, BestInfo, sum(BestMSEW(:)),sum(BestInfoW(:))\n');
while( 1 )
	NewBest = false;
	
    % find the mean intensity
    % assume all light sources are on, N = NChans, we hit 96% of saturation,
    % for 10 bit image, that is 1024*0.96 = 973. Actual value should be
    % measured during experiment as a function of exposure and gain.
    % Therefore, when N sources are on, the intensity should be
    % 0.96*N/NChans, assume that intensity scale linearly with sources.
    MeanIntensity = SatPixel*sum(W,2)/NChans;
%     MeanIntensity(MeanIntensity >= 1) = 1;
	% Evaluate the current W matrix
    % Each diagonal element is variance of each measurement. 
%     SigmaNoise = diag(MeanIntensity) + 0.1;
    SigmaNoise = 0.0916*eye(NChans)+diag(MeanIntensity);
    % from schechner, Multiplexed Fluorescence Unmixing, 2010
    if iIter > 0
        NoiseVar = (W'*SigmaNoise*W)^-1;   % from schechner, for noise variance = 1	
    else 
        NoiseVar = (W'*W)^-1;
    end

    MSE = 1/NChans * trace(NoiseVar);
    Info = sqrt(det( SigVar + NoiseVar ) ./ det( NoiseVar )); % info
	
	if( strcmp(WhichEval, 'mse') || strcmp(WhichEval,'both') )
		if( (MSE < BestMSE)  || (DoSidesteps && (abs(MSE-BestMSE) == 0 ) && (Info > BestMSEInfo)))
			BestMSEW = W;
			BestMSE = MSE;
			BestMSENoiseVar = NoiseVar;
			BestMSEInfo = Info;
			NewBest = true;
		end
	end
	
	if( strcmp(WhichEval, 'info') || strcmp(WhichEval,'both'))
		if( ( (Info > BestInfo) )  || (DoSidesteps && (abs(Info-BestInfo) == 0 ) && (MSE < BestInfoMSE)))
			BestInfoW = W;
			BestInfo = Info;
			BestInfoNoiseVar = NoiseVar;
			BestInfoMSE = MSE;
			NewBest = true;
		end
	end
	
	if( NewBest )
		disp([iIter, BestMSE, BestInfo, sum(BestMSEW(:)),sum(BestInfoW(:))])
		figure(1);
		subplot(231);
		imagesc(BestMSEW);
		axis image
		colorbar
		title('optimise MSE');
		subplot(232);
		imagesc(BestMSENoiseVar);
		axis image
		title(sprintf('MSE: %6.5f, Info: %6.5e', BestMSE, BestMSEInfo ));
		colorbar
        subplot(233);
		imagesc(SigVar);
        hold on;
		subplot(234)
		imagesc(BestInfoW);
		axis image
		colorbar
		title('optimise Info');
		subplot(235);
		imagesc(BestInfoNoiseVar);
		axis image
		title(sprintf('MSE: %6.5f, Info: %6.5e', BestInfoMSE, BestInfo ));
		colorbar
		subplot(236);
        imagesc(SigmaNoise);
%         hold on;
		drawnow
	end
	
	%---Perturb W to see if we can do better---
	while( 1 ) % keep trying until we get a nonsingular W
		% alternatively start with the best W from MSE or Info metric
		switch( mod(iIter,2) )
			case 0
				W = BestMSEW;
			case 1
				W = BestInfoW;
		end
		
		% flip random bits
		NBits = numel(W);
		MaxNToFlip = NBits;
		NToFlip = floor( 1 + MaxNToFlip.*rand(1) );
		WhichToFlip = floor( 1 + NBits.*rand(1,NToFlip) );
		WhichToFlip = unique(WhichToFlip);

		if( BinaryOnly )
			% binary only: only flip binary bits
			W( WhichToFlip ) = 1-W( WhichToFlip );
            w1 = sum(W,2);
%             figure(2);
%             imagesc(W);
%             axis image
%             colorbar
%             drawnow;
		else
			% continuous: allow grayscale masks
			W( WhichToFlip ) = min(1, max(0, W( WhichToFlip ) + 0.5.*randn(size(WhichToFlip))));
		end
		
		% check for a well-conditioned matrix W
		% i.e. one that inverts well.  If it doesn't try again.
		if( cond(W) <1e6)%  && (sum((w1 >= SatFloor) & (w1 <= SatCeil)) == NChans))
            break
		end
		
	end
% 	if ((isequal(sum(BestInfoW,1),sum(BestInfoW,2)') || isequal(sum(BestMSEW,1),sum(BestMSEW,2)')) && iIter > 2)
%         break;
%     end
	iIter = iIter + 1;
    
end
