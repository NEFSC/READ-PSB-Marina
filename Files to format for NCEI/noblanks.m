function data= noblanks(data)
%make sure no presence rows are blank
%to be run after data converted to NCEI format
%(Presence column will always be the last column. Do not have to worry
%about column names)

%written for the data2NCEI GUI SanctSound project

%Annamaria DeAngelis
%9/21/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

brows= isempty(data(:,end));
data(brows)= 0;
