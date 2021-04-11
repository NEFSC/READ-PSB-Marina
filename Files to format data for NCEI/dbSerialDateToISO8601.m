function ISOStartTime = dbSerialDateToISO8601(serialDatetime)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    if numel(serialDatetime) > 1
        ISOStartTime = cell(size(serialDatetime));
        for t = 1:numel(serialDatetime)
            ISOStartTime{t} = SerialToISO(serialDatetime(t));
        end
    else
        ISOStartTime = SerialToISO(serialDatetime);
    end
end

