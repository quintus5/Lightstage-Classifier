% sequenceTable = howtolight(4,'w','LightPattern','m','Multiplexingstyle','all');
sequenceTable = howtolight(4,'rgbyplw','LightPattern','sssssss','Multiplexingstyle','all');
images = 1;
writeDigitalPin(ard,'D7',1);
writeDigitalPin(ard,'D7',0);
tic;
for k = 1:images
    for count = 1:size(sequenceTable,1)
        write(reg,sequenceTable(count,:),'uint16');
        pause(1);
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