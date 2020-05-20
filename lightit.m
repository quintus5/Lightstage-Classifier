% sequenceTable = howtolight(8,'i','LightPattern','m','Multiplexingstyle','all');
% sequenceTable = howtolight(8,'rgbi','LightPattern','mmmm','Multiplexingstyle','step');
images = 1;
% writeDigitalPin(ard,'D8',0);
% writeDigitalPin(ard,'D8',1);pause(0.2);
% writeDigitalPin(ard,'D8',0);
col = 'rgbwi';
% 'hvoqzk'
% pat = ['m','m','m','m'];
stl = {'optmse'};
% stl = {'lowerstep','lowerstep2','lowerstep3','lowerstep4'};
% pause(10);
% for c = 1:images
% for j = 1:length(stl)
    for o = 1:length(col)
        sequenceTable = howtolight(8,col(o),'LightPattern','m','Multiplexingstyle','newmat');
        for count = 1:size(sequenceTable,1)-4
            write(reg, sequenceTable(count,:),'uint32');
            writeDigitalPin(ard,'D8',1);
            writeDigitalPin(ard,'D8',0);
            pause(0.02);
        end
    end
% end
%pause;
beep
% end
%%
sequenceTable = howtolight(8,'n','LightPattern','m','Multiplexingstyle','newmat');
write(reg, sequenceTable(4,:),'uint32');
%%
% col = '1234567';
% for i = 1:7
%     sequenceTable = howtolight(8,col(i),'LightPattern','m','Multiplexingstyle','newmat');
%     write(reg, sequenceTable(i,:),'uint32');
%     writeDigitalPin(ard,'D8',1);
%     writeDigitalPin(ard,'D8',0);
%     pause(1);
% end

%%
time = 0.04;
for o = 1:length(col)
    sequenceTable = howtolight(8,col(o),'LightPattern','m','Multiplexingstyle','newmat');
    for count = 1:size(sequenceTable,1)-1
        write(reg, sequenceTable(count,:),'uint32');
        writeDigitalPin(ard,'D8',1);
        writeDigitalPin(ard,'D8',0);
        pause(time);
    end
end
%pause;
beep

% toc;
% col1 = 332
% col2 = 331
% col3 = 2211
% col4 = 32232
% col5 = 33333
% col6 = 32333
% col 7 = 323223
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

% r = 100000
% g = 80000
% b = 34000
% i = 32000

% r = 90000
% g = 80000
% b = 40000
% i = 45000

% t1209 = 45000

% r = 390ms
% g = 340ms
% b = 270ms
%i = 180ms



% single illum 200 ms 15db
% i mux 80 ms 15db
% rgb mux 200ms
