function ISOStartTime = SerialToISO(serialDatetime)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ISOStartTime = datestr(serialDatetime, 'YYYY-mm-ddTHH:MM:SSZ');
end

