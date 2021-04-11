function data = noBlanks(data)
%
%Created by Annamaria DeAngelis 2020
%Modified by Allison Stokoe 4/11/2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    brows= isnan(data.Presence);
    data.Presence(brows)= 0; 
end

