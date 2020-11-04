function [dataHourly, dataDaily] = deploymentBoundaries(startArray,endArray,data, sumtype, timeFormat)

%read in the dolphin Excel table and truncate the start and end to be
%within the deployment (use the first complete hour and last complete hour)
%So...startHour= the hour the unit was deployed (not to be analyzed and
%will be removed), and endHour= hour the unit was recovered (not to be
%analyzed and will be removed). This allows only complete hours of data to
%be analyzed

%Annamaria DeAngelis
%9/17/2020
%modified by Allison Stokoe 11/4/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmp(sumtype,'hourly')
    deployed= find(data.Hour(1:24)==startArray);
    recovered= find(data.Hour(end-23:end)==endArray);
    nrows= length(data.Hour);

    todelete= [1:deployed,nrows-(24-recovered):nrows];

    data(todelete,:)= [];
    dataHourly = data;
    dataDaily = 0;  
end


if strcmp(sumtype,'daily')

    startArray = char(startArray);
    endArray = char(endArray);
    
    %make arrays of converted dates
    convertedDay = datetime(data.Day, 'InputFormat', timeFormat);
    convertedStart = datetime(startArray, 'InputFormat', 'yyyy/MM/dd'); 
    convertedEnd = datetime(endArray, 'InputFormat', 'yyyy/MM/dd');
    
    %find matching dates
    recovered = find(convertedDay == convertedEnd);
    deployed = find(convertedDay == convertedStart);
    
    %delete matching dates from data
    nrows = length(data.Day);
    todelete = [1:deployed,recovered:nrows];
    data(todelete,:) = [];
    
    %make output variables
    dataHourly = 0;
    dataDaily = data;
end
