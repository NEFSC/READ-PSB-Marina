function data4regression(pathname,filename,newfilename,species,dinterest,hinterest)
%take hourly presence output from summarizeDolphinDetections.m and select
%only days specified in dinterest and of those days, hours specified in hinterest
%to browse for regression analysis. 

%saves output to an Excel file in the same directory as the Excel file from
%summarizeDolphinDetections.m (aka in same path as PG databases). File has
%extension _RegressionHours

%Annamaria DeAngelis
%3/12/2020
%modified 8/20/2020 to just have the days/hours with dolphin detections
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hourlyPres= readtable([pathname,char(newfilename),'_',char(species),'.xlsx'],'Sheet','HourlyPres');


[~,~,dsplit]= ymd(hourlyPres.Day); %just days
%dinterest= [1,11,21];

counter= 1;
daytemp= zeros(1,4)-999;
for d= 1:length(dinterest)
   indx= find(dsplit==dinterest(d));
   daysnum(counter:counter+length(indx)-1)= datenum(hourlyPres.Day(indx));
   daytemp(counter:counter+length(indx)-1,:)= table2array(hourlyPres(indx,2:5));
   counter= counter+length(indx);
end

selectDays= [daysnum',daytemp];

%now select only the hours we want
%hinterest= [0,6,12];%hours Local time: [6,14,22];
counter2= 1;
hourtemp= zeros(1,5)-999;
for h= 1:length(hinterest)
    indx2= find(selectDays(:,2)==hinterest(h));
    hourtemp(counter2:counter2+length(indx2)-1,:)= selectDays(indx2,:);
    counter2= counter2+length(indx2);
end

hourtempS= sortrows(hourtemp,[1,2]);

%add column 6= Present?
[nrow,~]= size(hourtempS);
col6= zeros(nrow,1)-999;
toreview= [hourtempS,col6];

%convert to a table
toreview= array2table(toreview);
toreview.Properties.VariableNames= {'Day','Hour','nDet','MedLowFreq',...
    'MedHighFreq','Present'};

toreview.Day= datestr(toreview.Day,'yyyy-mm-dd');

%export as a new Excel file
projectname= strsplit(filename,'.');
filename2= [pathname,projectname{1},'_RegressionHours.xlsx'];
writetable(toreview,filename2);