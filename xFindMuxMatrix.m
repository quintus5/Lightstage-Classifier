% This program searches for multiplexing matrices W that yield optimal MSE or information
% These two metrics sometimes give different results
% Information seems like a smoother space, so better matrices are easier to find
% Interestingly, this often leads to matrices that also have better MSE
% This does not saturation into consideration -- todo!
% All tunable parameters are in the top part of the file
clearvars

%---
NChans = 8;        % how many things are we estimating
NMeas = NChans;    % how many measurements do we get; Must be >= NChans

% SigStrengthI = [0.96,0.50,0.96,0.5,0.96,0.5,0.96,0.50]/8; % NIR
% SigStrengthI = ones(1,8)/8;
SatFloor = repmat(floor(NChans/2-1),NChans,1); % upperbound of saturation 
SatCeil = repmat(ceil(NChans/2+1),NChans,1); % lower bound of noisy data
SatPixel = NChans/SatCeil(1)*0.96; % saturate at certain number of light on 0=darkness, 1=saturate.
GrayLvlVar = 66;
PhotonVar = 0.7;

% Any prior information we have on the signal covariance goes here
Rpp = eye(NChans)*0.5; % if everthing's equally likely leave as the eye matrix
Rpp = Rpp ./ det(Rpp).^(1/NChans);        % normalize energy
Rpp = Rpp .* SigStrengthI.^(1/NChans);     % and scale to SigStrength
SigVar = Rpp;

%---Optimisation parameters---
DoSidesteps = true; % all else equal, take the route that optimizes the info metric
BinaryOnly = true;  % true for binary masks, false for grayscale

%---Initialise the weigth matrix---
W = zeros(NMeas, NChans);
W(1:NChans,1:NChans) = eye(NChans);

%---Find mmse for Identity mat
SigmaNoise = PhotonVar.*diag(SigStrengthI*W)+GrayLvlVar.*eye(NChans);
NoiseVar = (W'*SigmaNoise^-1*W)^-1;
MSEI = (1/NChans)*trace(NoiseVar);
InfoI = sqrt(det( SigVar + NoiseVar ) ./ det( NoiseVar )); % info

%---Setup the optimisation---
BestMSE = inf;
BestInfo = 0;

iIter = 1;
WhichEval = 'both';
fprintf('     iIter, BestMSE, BestInfo, sum(BestMSEW(:)),sum(BestInfoW(:))\n');
while( 1 )
	NewBest = false;

	% Evaluate the current W matrix
    % Each diagonal element is variance of each measurement. 

    
    SigmaNoise = PhotonVar*diag(SigStrengthI*W)+GrayLvlVar*eye(NChans);
    % from schechner, Multiplexed Fluorescence Unmixing, 2010
    NoiseVar = (W'*SigmaNoise^-1*W)^-1;   % from schechner
%     NoiseVarP = (W'*W)^-1;
    MSE = 1/NChans * trace(NoiseVar);
%     G0 = sqrt(NChans/trace(NoiseVarP));
%     X = 0.1/0.11; 
%     G = G0*sqrt((1+X^2)/1+sum(W(1,:))*X^2);

    SigStrength = diag(SigStrengthI*W);

    Rpp = eye(NChans)*0.5;                    % everything is grayscale.
    Rpp = Rpp ./ det(Rpp).^(1/NChans);        % normalize energy
    Rpp = Rpp .* SigStrength.^(1/NChans);     % and scale to SigStrength
    SigVar = Rpp; 	
    

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
		subplot(221);
		imagesc(BestMSEW);
		axis image
		colorbar
		title(['optimise MSE, MSEI: ',num2str(MSEI)]);
		subplot(222);
		imagesc(BestMSENoiseVar);
		axis image
		title(sprintf('MSE: %6.5f, Gain: %6.5e', BestMSE, (MSEI/BestMSE) ));
		colorbar

		subplot(223)
		imagesc(BestInfoW);
		axis image
		colorbar
		title(['optimise Info InfoI: ',num2str(InfoI)]);
		subplot(224);
		imagesc(BestInfoNoiseVar);
		axis image
		title(sprintf('Info: %6.5f, Gain: %6.5e', BestInfo, (BestInfo/InfoI) ));
		colorbar

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
		else
			% continuous: allow grayscale masks
			W( WhichToFlip ) = min(1, max(0, W( WhichToFlip ) + 0.5.*randn(size(WhichToFlip))));
		end
		
		% check for a well-conditioned matrix W
		% i.e. one that inverts well.  If it doesn't try again.
		if( cond(W) <1e2)%  && (sum((w1 >= SatFloor) & (w1 <= SatCeil)) == NChans))
            break
		end
		
    end
	iIter = iIter + 1;
    
end