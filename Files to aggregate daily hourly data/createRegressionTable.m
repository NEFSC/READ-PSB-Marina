function createRegressionTable(pathname,filename,newfilename,species,dinterest,hinterest)
%Makes a regression table for SanctSound dolphin analysis 
%Inspired by Annamaria DeAngelis' code 'data4regression_simplified.m'
%Created by Allison Stokoe 4/14/2021 for Marina GUI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Step 1: Extract rows from presence table so only data with the desired day
%        numbers (aka. dinterest) are left
%Step 2: Take resulting table from step 1 and filter it a second time so 
%        that only days with the hours we desire (aka. hinterest) are left
%Step 3: Since the presence table (which is the input of this function) is 
%        ran through insertAbsences.m before hand we need to remove all the 
%        rows with no data in them
%Step 4: Append a column called "Presence" to the table and fill
%        every cell in the new column with '-999'
%Step 5: Write the table to an excel file with the correct name format:
%        'SanctSound_Site_Dep_Species_RegressionHours.xlsx'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load the presence table
PresTable = readtable([pathname,char(newfilename),'_',char(species),...
    '.xlsx'],'Sheet','HourlyPres');

% need to convert dinterest and hinterest into an array of numbers for ismember 
% to work (the values in both variable were selected from a list box in the 
% 'regressionAnalysisDataSelector' app which ouputs values into a cell array)

dinterest = str2double(dinterest);
hinterest = str2double(hinterest);

%%%Step 1 starts here:
%%Extract 'Day' column of presence table
dayCol = PresTable(:,1);

%%Extract just the day numbers
dayColArray = table2array(dayCol);
%convert Day column of spreadsheet into datetime format
datetime_dayCol = datetime(dayColArray,'InputFormat','MM/dd/yyyy'); 
%dayNums = just the day numbers of dates in Day column
[~,~,dayNums] = ymd(datetime_dayCol); 

%%Find all dates that match values chosen in dinterest
%get the location of cells in Day column that match dinterest
loc_dayNums = ismember(dayNums,dinterest); 
days_Table = PresTable(loc_dayNums,:);

%%%Step 2 starts here:
%%Find all dates that have hours of interest
%extracts hour column from the table created from only days of interest
hourCol = days_Table(:,2);
%need to convert to array so ismember works
hourCol = table2array(hourCol);
%get the location of values in hour column that match hinterest
loc_Hours = ismember(hourCol,hinterest);
%make new table with only rows that have appropriate hours
hoursdays_Table = days_Table(loc_Hours,:); 

%%%Step 3 starts here:
%%Filter out rows that insertAbsences.m put in (nDet needs to be > 0)
nDetCol = hoursdays_Table(:,3);
nDetCol = table2array(nDetCol);
loc_Zeros = find(nDetCol > 0);
regressionTable = hoursdays_Table(loc_Zeros,:);

%%%Step 4 starts here:
%%Append 'Presence' column and fill it with -999's 
regressionTable.Presence = repmat(-999,height(regressionTable),1);

%%%Step 5 starts here:
%%Writing regression table
%take out file extension of original database
projectname = strsplit(string(filename),'.');  
%append '_RegressionHours.xlsx' to form the new name
Newname = [pathname,projectname{1},'_RegressionHours.xlsx']; 
writetable(regressionTable,Newname); %write regression table with the new name
end

