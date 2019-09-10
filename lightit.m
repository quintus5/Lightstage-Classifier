% sequenceTable = howtolight(8,'i','LightPattern','m','Multiplexingstyle','all');
sequenceTable = howtolight(8,'rgbi','LightPattern','mmmm','Multiplexingstyle','step');
images = 2;

tic;
for k = 1:images
    for count = 1:size(sequenceTable,1)
        write(reg,sequenceTable(count,:),'uint32');
        writeDigitalPin(ard,'D8',1);
        writeDigitalPin(ard,'D8',0);
        pause(1);
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

% hole plate test f/4
% set 1: 0db 96ms rgblpyi s 1400im
% set 2: 0db 72ms rgblpyi mh 28im
% set 3: 0db 72ms rgblpyi mt 28im
% set 4: 0db 48ms rgblpyi mh 28im
% set 5: 0db 48ms rgblpyi mt 28im
% set 6: 0db 48ms rgblpyi s 28im
% set 7: 6db 48ms rgblpyi s 28im
% set 8: 6db 36ms rgblpyi mh 28im
% set 9: 6db 36ms rgblpyi mt 28im
% set a: 6db 24ms rgblpyi mh 28im
% set b: 6db 24ms rgblpyi mt 28im
% set c: 12db 24ms rgbpyli s 28im

% bump plate test f/4
% set 1: 0db 96ms rgblpyi s 28im- 
% set 2: 0db 72ms rgblpyi mh 28im-
% set 3: 0db 72ms rgblpyi mt 28im-
% set 4: 0db 48ms rgblpyi mh 28im-
% set 5: 0db 48ms rgblpyi mt 28im-
% set 6: 0db 48ms rgblpyi s 28im-
% set 7: 6db 48ms rgblpyi s 28im
% set 8: 6db 36ms rgblpyi mh 28im
% set 9: 6db 36ms rgblpyi mt 28im
% set a: 6db 24ms rgblpyi mh 28im
% set b: 6db 24ms rgblpyi mt 28im


% exposure time for info calc
% r = 120000
% g = 100000
% b = 50000
% i = 38000

% 