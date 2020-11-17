function [freqMat,daterange,daterangeN]= computeFreqMatrix(ExcelPresenceFile)

%read in Excel table
detections= readtable(ExcelPresenceFile,'Sheet','RawData');

hourlyPres= readtable(ExcelPresenceFile,'Sheet','HourlyPres');
hourlyPres.Datenumeric= datenum(hourlyPres.Day);

%take the detections table and extract the hour from the UTC column
detections.HourUTC= hour(detections.UTC);

%take the detections table and extract the date from the UTC column
sepdate= datevec(detections.UTC);
dnum= datenum(sepdate);
detections.Dates= cellstr(datestr(dnum,'mm/dd/yyyy'));
detections.Datenumeric= datenum(detections.Dates);

%get my date range
daterange= unique(hourlyPres.Day);
daterangeN= datenum(daterange);

%within the hourly presence table, keep only the positive presence hours
hourlyPres.Properties.VariableNames{6}= 'Present';
yesHours= hourlyPres(hourlyPres.Present==1,:);

%now go through the detections table and only pull out the days/hours of
%positive detections
yesDays= unique(yesHours.Datenumeric);

freqMat= zeros(24000/100,length(daterange)); %rows= dates, columns= freq
for n= 1:length(yesDays)
    TPs= table;
    dinx= find(detections.Datenumeric==yesDays(n));
    correctDay= detections(dinx,:);
    TP_hours= yesHours.Hour(yesHours.Datenumeric==yesDays(n));
    for t= 1:length(TP_hours)
    TPs= vertcat(TPs,correctDay(correctDay.HourUTC==TP_hours(t),:));
    end
    %now that I have all the detections for the day, I need to count up how
    %many freq bins are used in a day
    TP_lowFreq= round(TPs.lowFreq,-2);
    TP_highFreq= round(TPs.highFreq,-2);
    matindx= find(daterangeN==yesDays(n)); %x-axis index, goes on the rows
    for f= 1:length(TP_lowFreq)
        freqRange= TP_lowFreq(f):100:TP_highFreq(f);
        freqMat(freqRange/100,matindx)= freqMat(freqRange/100,matindx)+1;
    end
        
end

%freqMatU= flipud(freqMat); %flip it to display properly


