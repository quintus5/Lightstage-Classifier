function sequence = howtolight(no_led,color,varargin)
%HOWTOLIGHT specify the color and lighting pattern of light stage
% HOWTOLIGHT(no_led, color, 'param')
%   1) no_led: *int 
%                   total number of light direction used
%   2) color : *char array 
%                   color of light: 
%                   red green blue yellow lightblue purple white infrared
%                    r    g    b     y         l      p      w       i
%                                 
%    BL    TL    TR    BR
%   rgbir bgrir rgbir bgrir

% need to change pattern, its M = (1-H(2:end,2:end))/2
% number of light source is 1,3,7,15
redtable = [8,2,8,2];
bluetable = [2,8,2,8];
greentable = [4,4,4,4];
NIRtable = [1,1,1,1];
yellowtable = greentable+redtable;
lightbtable = greentable+bluetable;
whitetable = greentable+bluetable+redtable;
purpletable = bluetable+redtable;
alltable = greentable+bluetable+redtable+NIRtable;

%check error
if mod(no_led,1) || no_led > 4 || no_led <= 0
    error('please specify number of Light source direction'); 
end

if ~ischar(color) 
   error('please specify color of Light source'); 
end

if nargin > 2
    [varargin{:}] = convertStringsToChars(varargin{:});
    if mod(length(varargin),2)
        error('recheck your function input');
    end
    for i = 1:2:length(varargin)
        if strcmp(varargin{i},'LightPattern') %if pattern is given
            pattern = varargin{i+1};
            if length(pattern) ~= length(color)
                error('pattern length and color length does not match');
            end 
        elseif strcmp(varargin{i},'Multiplexingstyle') %is pattern style is given
            if strcmp(varargin{i+1},'hadamard')
%                 mulmat = hadamard(no_led)+(hadamard(no_led)<0);
                mulmat = (1-hadamard(no_led))/2;
%                 mulmat = (1-mulmat(2:end,2:end))/2;
            elseif strcmp(varargin{i+1},'three')
                mulmat = ones(4)-eye(4);
            elseif strcmp(varargin{i+1},'all')
                mulmat = ones(4);
            else
                error('no such multiplexing pattern')
            end
        else
            error('\nargument does not exist, see help for valid arguments');
        end  
    end
    for o = 1:length(pattern)
        if pattern(o) == 's'
            code(o*4-3:o*4,:) = eye(no_led)-diag([1,0,0,0]);
        elseif pattern(o) == 'm'
            code(o*4-3:o*4,:) = mulmat;
        end
    end 
else
    code = repmat(eye(no_led),length(color),1); %default pattern is single illum
end
 
% order the color
for i = 1:length(color)
    switch color(i)
        case 'r'
            table(i*16-15:i*16,:) = double(dec2bin(code(i*4-3:i*4,:).*redtable'))-'0';
        case 'b'
            table(i*16-15:i*16,:) = double(dec2bin(code(i*4-3:i*4,:).*bluetable'))-'0';
        case 'g'
            table(i*16-15:i*16,:) = [zeros(16,1),double(dec2bin(code(i*4-3:i*4,:).*greentable'))-'0'];
        case 'i'
            table(i*16-15:i*16,:) = [zeros(16,3),double(dec2bin(code(i*4-3:i*4,:).*NIRtable'))-'0'];
        case 'y'
            table(i*16-15:i*16,:) = double(dec2bin(code(i*4-3:i*4,:).*yellowtable'))-'0';
        case 'w'
            table(i*16-15:i*16,:) = double(dec2bin(code(i*4-3:i*4,:).*whitetable'))-'0';
        case 'l'
            table(i*16-15:i*16,:) = double(dec2bin(code(i*4-3:i*4,:).*lightbtable'))-'0';
        case 'p'
            table(i*16-15:i*16,:) = double(dec2bin(code(i*4-3:i*4,:).*purpletable'))-'0';
        case 'a'
            table(i*16-15:i*16,:) = double(dec2bin(code(i*4-3:i*4,:).*alltable'))-'0';
        case 'n'
            table(i*16-15:i*16,:) = zeros(16,4);
        otherwise
                error(['color ', color(i),' does not exist']);
    end
end
sequence = reshape(table',16,size(table,1)/size(table,2))';
end