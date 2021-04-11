function ISOStartTime = SerialToISO(serialDatetime)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ISOStartTime = datestr(serialDatetime, 'YYYY-mm-ddTHH:MM:SSZ');
end

