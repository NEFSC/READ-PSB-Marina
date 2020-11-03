function [dataHourly, dataDaily] = deploymentBoundaries(startArray,endArray,data, sumtype, timeFormat)

%read in the dolphin Excel table and truncate the start and end to be
%within the deployment (use the first complete hour and last complete hour)
%So...startHour= the hour the unit was deployed (not to be analyzed and
%will be removed), and endHour= hour the unit was recovered (not to be
%analyzed and will be removed). This allows only complete hours of data to
%be analyzed

%Annamaria DeAngelis
%9/17/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmp(sumtype,'hourly')
    deployed= find(data.Hour(1:24)==startArray);
    recovered= find(data.Hour(end-23:end)==endArray);
    nrows= length(data.Hour);

    todelete= [1:deployed,nrows-(24-recovered):nrows];

    data(todelete,:)= [];
    dataHourly = data;
    dataDaily = 0;
else
   %do nothing    
end


if strcmp(sumtype,'daily')

    startArray = char(startArray);
    endArray = char(endArray);
    
    convertedDay = datetime(data.Day, 'InputFormat', timeFormat);
    convertedStart = datetime(startArray, 'InputFormat', 'yyyy/MM/dd'); 
    deployed = find(convertedDay == convertedStart);
    data(deployed,:) = [];
    convertedDay(deployed,:) = [];
    
    convertedEnd = datetime(endArray, 'InputFormat', 'yyyy/MM/dd');
    recovered = find(convertedDay == convertedEnd);
    data(recovered,:) = [];
    dataHourly = 0;
    dataDaily = data;
else
    %do nothing
end
