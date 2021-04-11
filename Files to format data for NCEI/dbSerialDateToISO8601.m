function ISOStartTime = dbSerialDateToISO8601(serialDatetime)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if numel(serialDatetime) > 1
        ISOStartTime = cell(size(serialDatetime));
        for t = 1:numel(serialDatetime)
            ISOStartTime{t} = SerialToISO(serialDatetime(t));
        end
    else
        ISOStartTime = SerialToISO(serialDatetime);
    end
end

