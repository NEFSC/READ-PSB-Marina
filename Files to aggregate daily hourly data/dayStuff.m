function  [lastDay,totalDays] = dayStuff(presTable)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%find unique days
uniDays = unique(presTable(:,1));

%extract the first and last day of table
totalDays = length(uniDays);
firstDay = uniDays(1,1);
lastDay = uniDays(totalDays,1);

%create array of all days that should be there
totalDays = transpose(firstDay:1:lastDay);
end

