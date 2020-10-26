%go through and insert 0s in dolphin spreadsheets that have already been
%created before 9/16/20

[filename,pathname]= uigetfile('*.xlsx','Select the dolphin presence tables',...
    'MultiSelect','on',...
    'Z:\DATA_ANALYSIS\SANCTSOUND_NOAA_NAVY\Detector_output\PAMGUARD_DOLPHINS');

if isa(filename,'cell')==1
    %multi
    nfiles= length(filename);
    for n= 1:nfiles
        msg= sprintf('Processing %s...',filename{n});
        disp(msg);
        data= readtable([pathname,filename{n}],'ReadVariableNames',1,...
            'Sheet','HourlyPres');
        
        hourlyResults= insertAbsences(data,'hourly');
        
        %need to remove pre and post deployment rows, query the user for
        %each start and end
        dlgtitle= sprintf('%s',filename{n});
        response= inputdlg({'Deployment hour', 'Recovery hour'},dlgtitle,[1,80]);
        hourlyResults= deploymentBoundaries(str2num(response{1}),str2num(response{2}),...
            hourlyResults);
        
        
        writetable(hourlyResults,[pathname,filename{n}],'Sheet','HourlyPres')
    end
else
    %single
    data= readtable([pathname,filename],'ReadVariableNames',1,'Sheet','HourlyPres');
    hourlyResults= insertAbsences(data,'hourly');
    
    %need to remove pre and post deployment rows, query the user for
        %each start and end
        dlgtitle= sprintf('%s',filename);
        response= inputdlg({'Deployment hour', 'Recovery hour'},dlgtitle,[1,80]);
        hourlyResults= deploymentBoundaries(str2num(response{1}),str2num(response{2}),...
            hourlyResults);
    
    writetable(hourlyResults,[pathname,filename],'Sheet','HourlyPres')
end