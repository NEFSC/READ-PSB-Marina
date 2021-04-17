function [dailyPres, hourlyPresT, projectname]  = summarizeDolphinDetections4(wmd, currentfile, pathname_summary, species)
%creates daily and hourly presence tables based off the Whistle and Moan
%detector from Pamguard sqlite3 database. Raw detection table is also
%exported

%user selects the sqlite3 database to use and code does the rest.

%output is saved to the place where the sqlite3 file is with the same name

%call this function 2x if want a table each for humpback and dolphin
%species is a string variable that either is 'dolphin' or 'humpback'

%Annamaria DeAngelis 3/10/2020
%modified 8/20 for Excel row limit
%modified 9/16/20 to include absences in the dolphin hourly table
%modified 10/23/20 to work for either the humpback or dolphin WMD tables
%modified 11/4/20 by Allison Stokoe to work with GUI
%modified 4/15/21 by Allison Stokoe to fix presence table start and ends
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%suppress all warning when writing tables
warning('off','all');

Flow = wmd.lowFreq;
Fhigh = wmd.highFreq;

%combine same days
%format time in UTC column of database
dt = datetime(wmd.UTC,'InputFormat','yyyy-MM-dd HH:mm:ss.SSS');
%takes the date out and gives just the HH:mm:ss.SSS
t = timeofday(dt);
%converts just the dates to datenum
d = datenum(dt-t);

[uniqueDays,I] = unique(d); %contains all the unique dates and their indices
%%% uniqueDays = cellstr(datestr(M,'mm/dd/yyyy')); %just unique dates

%count the number of detections/day
ndetDaily = zeros(length(I),1)-999;
LFmed = zeros(length(I),1)-999;
HFmed = zeros(length(I),1)-999;

%hourly presence table
hourlyPres = zeros(1,5)-999; %going to append bc can't predict day/hr combination
presCounter = 1;
for i = 2:length(I)
    ndetDaily(i-1) = I(i)-I(i-1);
    rLowvals = Flow(I(i-1):I(i)-1);
    rHighvals = Fhigh(I(i-1):I(i)-1);
    %daily median frequencies
    LFmed(i-1) = median(rLowvals);
    HFmed(i-1) = median(rHighvals);
    
    %get the hours/day
    dtimes = t(I(i-1):I(i)-1);
    [h,~,~] = hms(dtimes);
    [unihours,hindex] = unique(h);
    ndet_hr = zeros(length(unihours),1)-999;
    medHrLow = zeros(length(unihours),1)-999;
    medHrHigh = zeros(length(unihours),1)-999;
    for u = 1:length(unihours)
       ndet_hr(u) = length(find(h == unihours(u))); %# det/hour
       [row,~,~] = find(h == unihours(u));
       medHrLow(u) = median(rLowvals(row));
       medHrHigh(u) = median(rHighvals(row));
    end
    
    %compile hourly into an array
    hourlyPres(presCounter:presCounter+u-1,1) = repmat(uniqueDays(i-1),u,1);
    hourlyPres(presCounter:presCounter+u-1,2) = unihours;
    hourlyPres(presCounter:presCounter+u-1,3) = ndet_hr;
    hourlyPres(presCounter:presCounter+u-1,4) = medHrLow;
    hourlyPres(presCounter:presCounter+u-1,5) = medHrHigh;
    presCounter = presCounter+u;
end

%do the last chunk manually as loop finishes length(I)-1
ndetDaily(i) = length(wmd.UTC)-I(i)+1;
LFmed(i) = median(Flow(I(i):end));
HFmed(i) = median(Fhigh(I(i):end));

dtimes = t(I(i):end);
[h,~,~] = hms(dtimes);
[unihours,hindex] = unique(h);
ndet_hr = zeros(length(unihours),1)-999;
medHrLow = zeros(length(unihours),1)-999;
medHrHigh = zeros(length(unihours),1)-999;
rLowvals = Flow(I(i):end);
rHighvals = Fhigh(I(i):end);
for u = 1:length(unihours)
    ndet_hr(u) = length(find(h == unihours(u))); %# det/hour
    [row,~,~] = find(h == unihours(u));
    medHrLow(u) = median(rLowvals(row));
    medHrHigh(u) = median(rHighvals(row));
end

hourlyPres(presCounter:presCounter+u-1,1) = repmat(uniqueDays(i),u,1);
hourlyPres(presCounter:presCounter+u-1,2) = unihours;
hourlyPres(presCounter:presCounter+u-1,3) = ndet_hr;
hourlyPres(presCounter:presCounter+u-1,4) = medHrLow;
hourlyPres(presCounter:presCounter+u-1,5) = medHrHigh;

%table of daily presence
dailyPres = table(uniqueDays,ndetDaily,LFmed,HFmed);
dailyPres.Properties.VariableNames = {'Day','nDet','MedLowFreq','MedHighFreq'};

%table of hourly presence
% % % dateS = cellstr(datestr(hourlyPres(:,1),'mm/dd/yyyy'));
hourlyPresT = table(hourlyPres(:,1),hourlyPres(:,2),hourlyPres(:,3),hourlyPres(:,4),...
    hourlyPres(:,5));
hourlyPresT.Properties.VariableNames = {'Day','Hour','nDet','MedLowFreq','MedHighFreq'};

%print out data to excel file
projectname = strsplit(currentfile,'.');

%check to see if raw detections exceeds Excel limit; if so, put raw
%detections on multiple tabs
Excel_lim = 1048576;
nrows = length(wmd.UTC);

if nrows >= Excel_lim
    %see how many tabs we have to create
    extrarows = nrows-Excel_lim;
    extratabs = ceil(extrarows/Excel_lim);
    startnum = 1;
    projectname = char(projectname{1});
    newfilename = strsplit(projectname,'_');
    newfilename = {char(newfilename{1}), char(newfilename{2}), char(newfilename{3})};
    newfilename = strjoin(newfilename, '_');
    newfilename = newfilename(~isspace(newfilename));
    for t = 1:extratabs+1
        w = (Excel_lim-1)*t <= nrows;
        if ~w
            row_indx = [startnum, nrows];
        else
           row_indx = [startnum, (Excel_lim-1)*t]; 
        end
        
        if strcmp(species,'dolphin')
            species = 'dolphins';
        else
            %do nothing
        end
        sheetname = sprintf('RawData%d',t);
        writetable(wmd(row_indx(1):row_indx(2),:),[char(pathname_summary)...
            ,char(newfilename),'_', char(species),'.xlsx'],'Sheet',sheetname)
    startnum = startnum+Excel_lim-1;
    end
else
    projectname = char(projectname{1});
    newfilename = strsplit(projectname,'_');
    newfilename = {char(newfilename{1}), char(newfilename{2}), ...
        char(newfilename{3})};
    newfilename = strjoin(newfilename, '_');
    newfilename = newfilename(~isspace(newfilename));
    writetable(wmd,[char(pathname_summary),char(newfilename),'_',char(species)...
        ,'.xlsx'],'Sheet','RawData')
end
end
