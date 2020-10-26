function data4regression
%take hourly presence output from summarizeDolphinDetections.m and select
%only days 1,11,21 and of those days, hours 6,14,22 to browse for
%regression analysis. if dolphins were not detected in those combinations,
%insert a blank row

%saves output to an Excel file in the same directory as the Excel file from
%summarizeDolphinDetections.m (aka in same path as PG databases). File has
%extension _RegressionHours

%Annamaria DeAngelis
%3/12/2020
%modified 4/30/2020 to include days with no dolphin detections
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[filename,pathname]= uigetfile('*.xlsx','Select the Excel file with hourly presence');
hourlyPres= readtable([pathname,filename],'Sheet','HourlyPres');

[~,~,dsplit]= ymd(hourlyPres.Day); %just days
dinterest= [1,11,21];

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
hinterest= [0,6,12];%hours Local time: [6,14,22];
counter2= 1;
hourtemp= zeros(1,5)-999;
for h= 1:length(hinterest)
    indx2= find(selectDays(:,2)==hinterest(h));
    hourtemp(counter2:counter2+length(indx2)-1,:)= selectDays(indx2,:);
    counter2= counter2+length(indx2);
end

hourtempS= sortrows(hourtemp,1);

%now need to check that there are 3 instances of days
uDays= unique(hourtempS(:,1));
for u= 1:length(uDays)
   d3= find(hourtempS(:,1)==uDays(u)); 
   if length(d3)~= 3
       %if not, check to see what hours are present
       yHours= hourtempS(d3,2);
       whichHours= ismember(hinterest,yHours); %0 in a position= missing hour
            %add missing hours
            missingH= hinterest(whichHours==0);
            %put a 0 in column 3
            notPresent= zeros(length(missingH),1);
            extraDay= zeros(length(missingH),1)+uDays(u);
            freq= zeros(length(missingH),2);
            extraRow= [extraDay,missingH',notPresent,freq];
            hourtempS= [hourtempS;extraRow];
   end
end
   
%sort by column 1 then 2 again
toreview= sortrows(hourtempS,[1,2]);

%add column 6= Present?
[nrow,~]= size(toreview);
col6= zeros(nrow,1)-999;
toreview= [toreview,col6];

%convert to a table
toreview= array2table(toreview);
toreview.Properties.VariableNames= {'Day','Hour','nDet','MedLowFreq',...
    'MedHighFreq','Present'};

toreview.Day= datestr(toreview.Day,'yyyy-mm-dd');

%for days in which there were no detections in hrs 3,11,19, insert them
daterange= hourlyPres.Day(1):hourlyPres.Day(end);
getdays= day(daterange);

alldind= [];
for dd= 1:length(dinterest)
[~,dindx]= find(getdays==dinterest(dd));
alldind= [alldind,dindx];
end

alldint= daterange(alldind);
alldint= sort(alldint);

missingDays= ismember(alldint,unique(datetime(toreview.Day)));

noday= alldint(missingDays==0);
repdays= array2table(sort(repmat(noday',3,1)));
repdays.Properties.VariableNames= {'Day'};

toreview.Day= datetime(toreview.Day,'InputFormat','yyyy-MM-dd');

fillin= array2table([repmat(sort(hinterest)',length(noday),1),zeros(length(noday)*3,3),zeros(length(noday)*3,1)-999]);

fillin= horzcat(repdays,fillin);
fillin.Properties.VariableNames= toreview.Properties.VariableNames;
toreview= vertcat(toreview,fillin);

toreview= sortrows(toreview,{'Day','Hour'});

%export as a new Excel file
projectname= strsplit(filename,'.');
filename2= [pathname,projectname{1},'_RegressionHours2.xlsx'];
writetable(toreview,filename2);