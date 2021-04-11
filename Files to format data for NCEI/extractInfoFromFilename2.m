function [Sanctuary,Site,Deployment]= extractInfoFromFilename2(filename)
%Get the Sanctuary and site and deployment info from the filename
%
%For the Marina GUI
%Annamaria DeAngelis 9/11/2020
%Modified by Allison Stokoe 3/1/2021 to include more sanctuaries 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filenamesplit= strsplit(filename,'_');

%figure out sanctuary
    sanctuaries = {'SB','GR','FK','OC','MB','CI','HI','PM'};
    Sanctuary = '';
    for ii = 1:length(sanctuaries)
        if contains(filename,sanctuaries{ii}) == 1
            Sanctuary = sanctuaries{ii};
            break
        end
    end
    
    if isempty(Sanctuary)
        disp('Not a valid sanctuary')
        Sanctuary = 0;
    else
        %do nothing 
    end

%figure out site
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
end
    