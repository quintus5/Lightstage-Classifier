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
redtable =   [8,4,8,4,8,8,2,2];
bluetable =  [2,1,2,1,2,2,8,8];
greentable = [4,2,4,2,4,4,4,4];
NIRtable =   [1,8,1,8,1,1,1,1];

yellowtable = greentable+redtable;
lightbtable = greentable+bluetable;
purpletable = bluetable+redtable;
nirgrntable = greentable+NIRtable;
nirredtable = redtable+NIRtable;
nirblutable = bluetable+NIRtable;

whitetable = greentable+bluetable+redtable;
gbitable = greentable+bluetable+NIRtable;
gritable = greentable+redtable+NIRtable;
britable = bluetable+redtable+NIRtable;

alltable = greentable+bluetable+redtable+NIRtable;

randomtable = ceil(rand(1,8)*8);

customtable1 = [2,4,4,2,4,4,4,8];
customtable2 = [2,2,8,8,8,4,8,8];
customtable3 = [4,1,8,1,8,8,8,2];
customtable4 = [1,2,4,4,2,2,2,8];
customtable5 = [2,1,2,1,2,2,8,8];
customtable6 = [8,1,4,2,2,8,2,2];
customtable7 = [4,2,4,1,8,4,2,8];

%check error
if mod(no_led,1) || no_led > 9 || no_led <= 0
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
%                 mulmat = (1-hadamard(no_led))/2;
                mulmat = (1-mulmat(2:end,2:end))/2;
            elseif strcmp(varargin{i+1},'eye')
                mulmat = eye(no_led);
            elseif strcmp(varargin{i+1},'all')
                mulmat = ones(no_led);
            elseif strcmp(varargin{i+1},'stepall')
                mulmat = [1,1,1,1,1,1,1,1;
                          0,0,0,0,1,1,1,1;
                          0,1,1,1,1,1,1,1;
                          0,0,0,0,0,1,1,1;
                          0,0,1,1,1,1,1,1;
                          0,0,0,0,0,0,1,1;
                          0,0,0,1,1,1,1,1;
                          0,0,0,0,0,0,0,1];
            elseif strcmp(varargin{i+1},'lowerstep')
                mulmat = [0,0,0,0,0,0,0,0;
                          0,0,0,0,1,0,0,0;
                          0,0,0,0,0,0,0,0;
                          0,0,0,1,1,0,0,0;
                          0,0,0,0,0,0,0,0;
                          0,0,1,1,1,0,0,0;
                          0,0,0,0,0,0,0,0;
                          0,1,1,1,1,0,0,0];
            elseif strcmp(varargin{i+1},'lowerstep2')
                mulmat = [0,0,0,0,0,0,0,0;
                          0,1,1,1,1,0,0,0;
                          0,0,0,0,0,0,0,0;
                          0,0,1,1,1,0,0,0;
                          0,0,0,0,0,0,0,0;
                          0,0,0,1,1,0,0,0;
                          0,0,0,0,0,0,0,0;
                          0,0,0,0,1,0,0,0];
            elseif strcmp(varargin{i+1},'lowerstep3')
                mulmat = [0,0,0,0,0,0,0,0;
                          0,0,0,1,1,0,0,0;
                          0,0,0,0,0,0,0,0;
                          0,1,1,0,1,0,0,0;
                          0,0,0,0,0,0,0,0;
                          0,0,1,1,1,0,0,0;
                          0,0,0,0,0,0,0,0;
                          0,0,0,1,1,0,0,0];
            elseif strcmp(varargin{i+1},'lowerstep4')
                mulmat = [0,0,0,0,0,0,0,0;
                          0,0,1,1,1,0,0,0;
                          0,0,0,0,0,0,0,0;
                          0,0,0,1,1,0,0,0;
                          0,0,0,0,0,0,0,0;
                          0,1,0,0,1,0,0,0;
                          0,0,0,0,0,0,0,0;
                          0,0,1,1,1,0,0,0];
            elseif strcmp(varargin{i+1},'upperstep')
                mulmat = [0,1,1,1,1,0,0,0;
                          0,0,0,0,0,0,0,1;
                          0,0,1,1,1,0,0,0;
                          0,0,0,0,0,0,0,1;
                          0,0,0,1,1,0,0,0;
                          0,0,0,0,0,0,0,1;
                          0,0,0,0,1,0,0,0;
                          0,0,0,0,0,0,0,1]; 
            elseif strcmp(varargin{i+1},'upperstep2')
                mulmat = [0,0,0,1,1,0,0,0;
                          0,0,0,0,0,0,0,1;
                          0,1,1,1,1,0,0,0;
                          0,0,0,0,0,0,0,1;
                          0,0,1,0,1,0,0,0;
                          0,0,0,0,0,0,0,1;
                          0,0,0,1,1,0,0,0;
                          0,0,0,0,0,0,0,1];
            elseif strcmp(varargin{i+1},'upperstep3')
                mulmat = [0,0,0,1,1,0,0,0;
                          0,0,0,0,0,0,0,1;
                          0,0,0,0,1,0,0,0;
                          0,0,0,0,0,0,0,1;
                          0,1,1,1,1,0,0,0;
                          0,0,0,0,0,0,0,1;
                          0,0,1,1,1,0,0,0;
                          0,0,0,0,0,0,0,1];
            elseif strcmp(varargin{i+1},'upperstep4')
                mulmat = [0,0,1,0,1,0,0,0;
                          0,0,0,0,0,0,0,1;
                          0,0,0,1,1,0,0,0;
                          0,0,0,0,0,0,0,1;
                          0,0,0,1,1,0,0,0;
                          0,0,0,0,0,0,0,1;
                          0,1,1,1,1,0,0,0;
                          0,0,0,0,0,0,0,1];
            elseif strcmp(varargin{i+1},'optmse')
                mulmat = [1,1,1,0,0,1,0,0;
                          0,1,0,0,1,1,1,0;
                          0,0,1,0,1,1,0,1;
                          0,1,1,0,0,0,1,1;
                          1,0,0,1,1,0,1,1;
                          0,1,0,1,0,1,0,1;
                          0,1,1,1,1,0,0,0;
                          0,0,1,1,0,1,1,0];
            elseif strcmp(varargin{i+1},'newmat')
                mulmat = [1,0,1,1,1,1,1,1;
                          0,1,0,0,1,1,1,1;
                          1,0,0,1,1,1,1,1;
                          1,0,0,1,1,1,1,1;
                          1,1,1,1,1,1,1,1;
                          1,0,0,0,1,1,1,1;
                          0,0,1,1,1,1,1,1;
                          1,1,1,1,1,1,1,1];
            else
                error('no such multiplexing pattern')
            end
        else
            error('\nargument does not exist, see help for valid arguments');
        end  
    end
    for o = 1:length(pattern)
        if pattern(o) == 's'
            code(o*no_led-(no_led-1):o*no_led,:) = eye(no_led);%-diag([1,0,0,0]);
        elseif pattern(o) == 'm'
            code(o*no_led-(no_led-1):o*no_led,:) = mulmat;
        end
    end 
else
    code = repmat(eye(no_led),length(color),1); %default pattern is single illum
end
 
% order the color
for i = 1:length(color)
    switch color(i)
        case 'r'
            table(i*no_led^2-(no_led^2-1):i*no_led^2,:) = double(dec2bin(code(i*no_led-(no_led-1):i*no_led,:).*redtable(1:no_led)'))-'0';
        case 'b'
            table(i*no_led^2-(no_led^2-1):i*no_led^2,:) = double(dec2bin(code(i*no_led-(no_led-1):i*no_led,:).*bluetable(1:no_led)'))-'0';
        case 'g'
            table(i*no_led^2-(no_led^2-1):i*no_led^2,:) = [zeros(no_led^2,1),double(dec2bin(code(i*no_led-(no_led-1):i*no_led,:).*greentable(1:no_led)'))-'0'];
        case 'i'
            table(i*no_led^2-(no_led^2-1):i*no_led^2,:) = [double(dec2bin(code(i*no_led-(no_led-1):i*no_led,:).*NIRtable(1:no_led)'))-'0'];
        case 'y'
            table(i*no_led^2-(no_led^2-1):i*no_led^2,:) = double(dec2bin(code(i*no_led-(no_led-1):i*no_led,:).*yellowtable(1:no_led)'))-'0';
        case 'w'
            table(i*no_led^2-(no_led^2-1):i*no_led^2,:) = double(dec2bin(code(i*no_led-(no_led-1):i*no_led,:).*whitetable(1:no_led)'))-'0';
        case 'l'
            table(i*no_led^2-(no_led^2-1):i*no_led^2,:) = double(dec2bin(code(i*no_led-(no_led-1):i*no_led,:).*lightbtable(1:no_led)'))-'0';
        case 'p'
            table(i*no_led^2-(no_led^2-1):i*no_led^2,:) = double(dec2bin(code(i*no_led-(no_led-1):i*no_led,:).*purpletable(1:no_led)'))-'0';
        case 'a'
            table(i*no_led^2-(no_led^2-1):i*no_led^2,:) = double(dec2bin(code(i*no_led-(no_led-1):i*no_led,:).*alltable(1:no_led)'))-'0';
        case 'h'
            table(i*no_led^2-(no_led^2-1):i*no_led^2,:) = double(dec2bin(code(i*no_led-(no_led-1):i*no_led,:).*nirgrntable(1:no_led)'))-'0';
        case 'v'
            table(i*no_led^2-(no_led^2-1):i*no_led^2,:) = double(dec2bin(code(i*no_led-(no_led-1):i*no_led,:).*nirredtable(1:no_led)'))-'0';
        case 'o'
            table(i*no_led^2-(no_led^2-1):i*no_led^2,:) = double(dec2bin(code(i*no_led-(no_led-1):i*no_led,:).*nirblutable(1:no_led)'))-'0';
        case 'q'
            table(i*no_led^2-(no_led^2-1):i*no_led^2,:) = double(dec2bin(code(i*no_led-(no_led-1):i*no_led,:).*britable(1:no_led)'))-'0';
        case 'z'
            table(i*no_led^2-(no_led^2-1):i*no_led^2,:) = double(dec2bin(code(i*no_led-(no_led-1):i*no_led,:).*gbitable(1:no_led)'))-'0';
        case 'k'
            table(i*no_led^2-(no_led^2-1):i*no_led^2,:) = double(dec2bin(code(i*no_led-(no_led-1):i*no_led,:).*gritable(1:no_led)'))-'0';
        case 'n'
            table(i*no_led^2-(no_led^2-1):i*no_led^2,:) = zeros(no_led^2,no_led/2);
        case '1'
            table(i*no_led^2-(no_led^2-1):i*no_led^2,:) = double(dec2bin(code(i*no_led-(no_led-1):i*no_led,:).*customtable1(1:no_led)'))-'0';
        case '2'
            table(i*no_led^2-(no_led^2-1):i*no_led^2,:) = double(dec2bin(code(i*no_led-(no_led-1):i*no_led,:).*customtable2(1:no_led)'))-'0';
        case '3'
            table(i*no_led^2-(no_led^2-1):i*no_led^2,:) = double(dec2bin(code(i*no_led-(no_led-1):i*no_led,:).*customtable3(1:no_led)'))-'0';
        case '4'
            table(i*no_led^2-(no_led^2-1):i*no_led^2,:) = double(dec2bin(code(i*no_led-(no_led-1):i*no_led,:).*customtable4(1:no_led)'))-'0';
        case '5'
            table(i*no_led^2-(no_led^2-1):i*no_led^2,:) = double(dec2bin(code(i*no_led-(no_led-1):i*no_led,:).*customtable5(1:no_led)'))-'0';
        case '6'
            table(i*no_led^2-(no_led^2-1):i*no_led^2,:) = double(dec2bin(code(i*no_led-(no_led-1):i*no_led,:).*customtable6(1:no_led)'))-'0';
        case '7'
            table(i*no_led^2-(no_led^2-1):i*no_led^2,:) = double(dec2bin(code(i*no_led-(no_led-1):i*no_led,:).*customtable7(1:no_led)'))-'0';
         otherwise
                error(['color ', color(i),' does not exist']);
    end
end
sequence = reshape(table',[4*no_led,i*no_led])';
end