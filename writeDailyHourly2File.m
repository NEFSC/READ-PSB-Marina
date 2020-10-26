function writeDailyHourly2File
%Function asks user to select the Raven selection tables that were output
%from the minke detector. Can select one or multiple

%Output is an excel file with the daily selection numbers and hourly
%selection numbers for the analyst to review. Excel file is stored in the
%same folder as the input file(s)

%Note: if using the 'multi' option, you will need to have all of your minke
%detector selection tables in one folder

%Annamaria DeAngelis
%4/28/20
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Annamaria playing around with GUI creation before realizing she
%overcomplicated things and that uigetfile will do the trick. Keeping this
%for reference later

% %create GUI with buttons for batch or single option
% fig= uifigure('Name','Do you have a single file or multiple?',...
%     'Position',[300 400 400 100]); %left bottom width height
% multi= uibutton(fig,'push','Text','Multiple','Position',[25,50,100,22],...
%     @multi,event) multifiles(multi,fig));
% sgl= uibutton(fig,'push','Text','Single','Position',[250,50,100,22]);
% 
% fig=figure
% uicontrol('Style','pushbutton','String','Start',...
%     'Callback','uigetfile',...
%     'Units','Normalized','Position',[0.5 0.5 0.1 0.1],...
%     'Parent',fig)

%actual code starts here
[filename,pathname]= uigetfile('*.txt','Select one or more Raven selection tables','MultiSelect','on');

%test to see if need to write a batch process or not
if isa(filename,'cell')==1
    %multi
    nfiles= length(filename);
    for n= 1:nfiles
        data= readtable([pathname,filename{n}],'ReadVariableNames',0);
        [dailyResults,hourlyResults]= grabDailyHourlySelections(data);
        Present= cell(length(dailyResults.Day),1);
        Present= cell2table(Present);
        dailyResults= horzcat(dailyResults,Present);
        
        Present= cell(length(hourlyResults.Day),1);
        Present= cell2table(Present);
        hourlyResults= horzcat(hourlyResults,Present);
        
        dailyResults= insertAbsences(dailyResults,'daily');
        
        singlefile= filename{n};
        p0= strfind(singlefile,'Minke');f
        projectname= singlefile(1:p0-1);
        filenamenew= [pathname,projectname,'Minke_cheatSheet.xlsx'];
        writetable(dailyResults,filenamenew,'Sheet','DailyResults')
        writetable(hourlyResults,filenamenew,'Sheet','HourlyResults')
   end
else
    %single
    data= readtable([pathname,filename],'ReadVariableNames',0);
    [dailyResults,hourlyResults]= grabDailyHourlySelections(data);
     Present= cell(length(dailyResults.Day),1);
     Present= cell2table(Present);
     dailyResults= horzcat(dailyResults,Present);
        
     Present= cell(length(hourlyResults.Day),1);
     Present= cell2table(Present);
     hourlyResults= horzcat(hourlyResults,Present);
    
     dailyResults= insertAbsences(dailyResults,'daily');
     
    p0= strfind(filename,'Minke');
    projectname= filename(1:p0-1);
    filenamenew= [pathname,projectname,'Minke_cheatSheet.xlsx'];
    writetable(dailyResults,filenamenew,'Sheet','DailyResults')
    writetable(hourlyResults,filenamenew,'Sheet','HourlyResults')
end