function [Sanctuary,Site,Deployment,Species]= extractInfoFromFilename(filename)
%get the Sanctuary and site and deployment info from the filename
%This won't work for cod detector

%Examples I used to test this code:
%NEFSC_SBNMS_201908_SB03_05_OnBank_humpback_daily_det.csv
%NEFSC_SBNMS_201908_SB03_05_OnBank_RW_DAILY_PRESENCE.csv
%SanctSound_SB01_01_dolphins.xlsx
%SanctSound_SB01_02_Minke_cheatSheetA.xlsx

%For the detector4NCEI GUI SanctSound project

%check out line 22 for adding more species to the list (maybe this gets
%converted to an input to this function as opposed to it being created
%within this function?)

%Annamaria DeAngelis
%9/11/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%databank of species
    specieslist= {'Minke','dolphins','RW','fin','sei','blue','humpback','cod','Ship'};
    
%figure out sanctuary

if contains(filename,'SB','IgnoreCase',true)
    Sanctuary= 'SB';
elseif contains(filename,'GR','IgnoreCase',true)
    Sanctuary= 'GR';
elseif contains(filename,'FK','IgnoreCase',true)
    Sanctuary= 'FK';
else
    disp('Not an E Coast sanctuary')
    Sanctuary= [];
end
%figure out site
filenamesplit= strsplit(filename,'_');
sanctOptions= strfind(filenamesplit,Sanctuary);
findSanctPos= cellfun(@isempty,sanctOptions);
possibilities= filenamesplit(~findSanctPos);
    %now figure it out based on length and whether there are numbers and
    %letters
    Site= char(possibilities(~cellfun(@isempty,regexp(possibilities, '\d'))));
%figure out deployment
sitePos= regexp(filename,[Site,'_']);
partialname= filename(sitePos:sitePos+6);
partialname2= strsplit(partialname,'_');
Deployment= char(partialname2(2));
%figure out species
    whichspeciesPos= ismember(filenamesplit,specieslist);
    if ~whichspeciesPos
       %need to also separate by .
       splitagain= strsplit(filenamesplit{end},'.');
       whichspeciesPos= ismember(splitagain,specieslist);
        Species= char(splitagain(whichspeciesPos));
    else
         Species= char(filenamesplit(whichspeciesPos));
    end
    