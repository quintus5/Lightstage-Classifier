% sequenceTable = howtolight(4,'w','LightPattern','m','Multiplexingstyle','all');
sequenceTable = howtolight(4,'lpw','LightPattern','sss','Multiplexingstyle','hadamard');
images = 1;
writeDigitalPin(ard,'D7',1);
writeDigitalPin(ard,'D7',0);
tic;
for k = 1:images
    for count = 1:size(sequenceTable,1)
        write(reg,sequenceTable(count,:),'uint16');
        pause(0.4);
        writeDigitalPin(ard,'D7',1);
        pause(0.001);
        writeDigitalPin(ard,'D7',0);
    end
end
toc;

% dist lens to object - 19cm
% cam setting - f11
% operation orange 1 - fake upside,downside,up to right,up to front,up to
% left, up to back, up to leftback, up to rightback, up to leftfront, up to
% right front
% real - upside, downside, up to right, up to front, up to left, up to
% back, up to leftback, up to rightback, up to left front, up to rightfront


% new noise test
% set 01: 0db gain                  - 50 image rgb et: 1     ball13
% set 02: 6db gain                  - 12 image rgb et: 0.5   ball14
% set 03: 0db gain mult             - 12 image rgb et: 1     ball15
% set 04: 12db gain                 - 12 image rgb et: 0.25  ball16
% set 05: 12db gain 2xpost          - 12 image rgb et: 0.125 ball17
% set 06: 12db gain mult            - 12 image rgb et: 0.25  ball18
% set 07: 6db gain mult             - 12 image rgb et: 0.5   ball19
% set 08: 12db gain 2xpost mult     - 12 image rgb et: 0.125 ball20
% set 09: 6db gain 2xpost           - 12 image rgb et: 0.25  ball21
% set 10: 6db gain 2xpost mult      - 12 image rgb et: 0.25  ball22
% set 11: 6db gain 4xpost           - 12 image rgb et: 0.125 ball23
% set 12: 6db gain 4xpost mult      - 12 image rgb et: 0.125 ball24
% set 11: 12db gain 4xpost          - 12 image rgb et: 0.075 ball25
% set 12: 12db gain 4xpost mult     - 12 image rgb et: 0.075 ball26
% set 13: 12db gain 0.75gam         - 12 image rgb et: 0.125 ball27