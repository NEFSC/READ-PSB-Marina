function dataOut= LFDCS4NCEI(data,filename)
%use this function after running removeLFDCSHeader.m
%takes the LFDCS table and converts it to NCEI format

%For the detectorGUI4NCEI SanctSound project

%Annamaria DeAngelis
%9/11/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nrows= length(data.Manual_Review);
%Use columns start date and Manual_Review
%Insert the Sanctuarysite_deployment column (SB_01_01)
[~,Site,Deployment,Species]= extractInfoFromFilename(filename);
ssd= cellstr([Site(1:2),'_',Site(3:4),'_',Deployment]);
Sanctuarysite_deployment= repmat(ssd,nrows,1);
%Coerce all 2s to 0s
data.Manual_Review= str2double(data.Manual_Review);
maybes= find(data.Manual_Review== 2);
data.Manual_Review(maybes)= 0;
if strcmp(Species,'fin')
    %Has an if statement for finwhale to do the extra step Find the days 
%without presence (blanks) and autofill as 0
data.Manual_Review(isnan(data.Manual_Review))= 0;
end
Presence= data.Manual_Review;
%Convert start date to ISO
%yyyy-mm-dd 
ISO_Date= datetime(data.start_date,'InputFormat','M/d/yy','Format',...
    'yyyy-MM-dd');

dataOut= table(ISO_Date,Sanctuarysite_deployment,Presence);
%dataOut.Properties.VariableNames{1}= 'ISO Date'; %can't have a space in
%the column name...now what?




