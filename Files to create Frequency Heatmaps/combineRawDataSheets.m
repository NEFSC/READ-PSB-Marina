function rawData = combineRawDataSheets(pathname, currentfile, sheetArray)
%input is table of hourly presene with multiple RawData sheets. Output is a
%single table with all RawData

%read first RawData sheet
rawData = readtable([pathname, currentfile], 'Sheet', 'RawData1');

%go through the rest of the sheets
for n = 2:length(sheetArray)
    name = sheetArray{n};
    newdata = readtable([pathname, currentfile],'Sheet', name);
    %combine sheets
    rawData = [rawData; newdata];
end



end

