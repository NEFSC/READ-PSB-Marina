function rowNames = getRowNames(filenames)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
rowNames = {};
    for c = 1:length(filenames)
        currentfile = filenames{c};

        [~,Site,Deployment]= extractInfoFromFilename2(currentfile);
        Species = getSpecies(currentfile);

        composite_name = [Site,'_', Deployment,'_',Species];
        rowNames = [rowNames, composite_name];
    end
end

