function data= deploymentBoundaries(startHour,endHour,data)

%read in the dolphin Excel table and truncate the start and end to be
%within the deployment (use the first complete hour and last complete hour)
%So...startHour= the hour the unit was deployed (not to be analyzed and
%will be removed), and endHour= hour the unit was recovered (not to be
%analyzed and will be removed). This allows only complete hours of data to
%be analyzed

%Annamaria DeAngelis
%9/17/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

deployed= find(data.Hour(1:24)==startHour);
recovered= find(data.Hour(end-23:end)==endHour);
nrows= length(data.Hour);

todelete= [1:deployed,nrows-(24-recovered):nrows];

data(todelete,:)= [];