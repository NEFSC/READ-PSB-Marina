function [startValue,endValue] = getDepBounds(data,file)
%takes table of file names and start/end datetimes. Matches correct 
%start/end values in table with the filename being proccessed.
%Works with 'insertAbsences2.m' and 'deploymentBoundaires2.m'
%
%Made for Marina GUI
%Created by Allison Stokoe 4/15/2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fileCol = data(:,1);
fileCol = table2array(fileCol);
loc_file = contains(fileCol,file);
fileValues = data(loc_file,:);

startValue = fileValues.startValues;
endValue = fileValues.endValues;
end

