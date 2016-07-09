clear *;
megaMillionCell = MegaMillion();

csvfile = 'megamillionsFrom20131020.csv';
csvfid = fopen(csvfile, 'r');

C = textscan(csvfid, ['%s', repmat('%d', [1 10])], 'Delimiter',','); 
numEntry = length(C{1});
for ee = 1:numEntry
    month = C{2}(ee);
    day = C{3}(ee);
    year = C{4}(ee);
    balls = [C{5}(ee) C{6}(ee) C{7}(ee) C{8}(ee) C{9}(ee)];
    megaball = C{10}(ee);
    megaplier = C{11}(ee);
    megaMillionCell.addNewDraw(year, month, day, balls, megaball, megaplier);
end

