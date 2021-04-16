function  dispMsg(title,msg)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(title)
if isa(msg,'double')
    disp(msg)
else
    msg = cellstr(msg);
    for ii = 1:length(msg)
        disp(msg{ii})
    end
end
end

