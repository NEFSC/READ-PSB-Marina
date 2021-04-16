function [filenamenew, dailyResults] = writeDailyHourly2File (currentfile_minke, pathname_minke)
%Output is an excel file with the daily selection numbers and hourly
%selection numbers for the analyst to review. Excel file is stored in the
%same folder as the input file(s)

%Annamaria DeAngelis
%4/28/20
%modified for GUI by Allison Stokoe 11/1/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%suppress all warning when writing tables
warning('off','all');

data= readtable([pathname_minke,currentfile_minke],'ReadVariableNames',0);
dailyResults = grabDailyHourlySelections(data);
Present= cell(length(dailyResults.Day),1);
Present= cell2table(Present);
dailyResults= horzcat(dailyResults,Present);

dailyResults= insertAbsences(dailyResults,'daily');

singlefile= currentfile_minke;
p0= strfind(singlefile,'Minke');
projectname= singlefile(1:p0-1);
filenamenew= [pathname_minke,projectname,'Minke_cheatSheet.xlsx'];

end