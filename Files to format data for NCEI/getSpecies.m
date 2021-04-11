function Species = getSpecies(filename)
%finds species from a filename
%update specieslist to allow code to look for more species
%Created from extractInfoFromFilename by Annamaria DeAngelis 2020
%Modified by Allison Stokoe 4/11/2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%databank of species
specieslist= {'Minke','dolphins','dolphin','RW','fin','sei','blue','humpback','atlanticcod','cod','Ship'};

%figure out species
filenamesplit = strsplit(filename,'_');
whichspeciesPos = ismember(filenamesplit,specieslist);
    if ~whichspeciesPos
       %need to also separate by .
       splitagain= strsplit(filenamesplit{end},'.');
       whichspeciesPos= ismember(splitagain,specieslist);
        Species = char(splitagain(whichspeciesPos));    
    else
        Species = char(filenamesplit(whichspeciesPos));
    end

    %to account for different spelling with species in original filename
    switch Species 
        case'dolphin'
           Species = 'dolphins';
        case 'Ship'
            Species = 'ships';
        case 'cod'
            Species = 'atlanticcod';
        otherwise
           %do nothing
    end
end

