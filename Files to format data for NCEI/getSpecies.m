function Species = getSpecies(filename)
%finds species from a filename
%update specieslist to allow code to look for more species
%Created from extractInfoFromFilename by Annamaria DeAngelis 2020
%Modified by Allison Stokoe 4/11/2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%databank of species
specieslist= {'MnandOdontocetes','Minke','dolphins','dolphin','RW','fin','sei','blue','humpback','atlanticcod','cod','Ship'};

%figure out species
for ii = 1:length(specieslist)
    currentListItem = string(specieslist(ii));
    if contains(lower(filename),lower(currentListItem)) == 1
        Species = specieslist(ii);
        break
    else
        %keep looping through list
    end
end
    %to account for different spelling with species in original filename
    Species = char(Species);
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

