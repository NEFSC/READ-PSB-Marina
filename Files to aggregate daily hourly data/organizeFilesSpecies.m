function [humpbackArray,minkeArray,dolphinArray,MnandOdontocetesArray,organizedFileArray] = organizeFilesSpecies(filenames)
%UNTITLED Summary of this function goes here
%   
%Created by Allison Stokoe 4/13/2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
humpbackArray = {};
minkeArray = {};
dolphinArray = {};
MnandOdontocetesArray = {};
for ii = 1:length(filenames)
   if contains(filenames{ii},'.txt') 
       minkeArray = [minkeArray, cellstr(filenames{ii})];
   else
       Species = getSpecies(filenames{ii});
       switch Species
           case 'humpback'
               humpbackArray = [humpbackArray, cellstr(filenames{ii})];  
           case 'dolphins'
               dolphinArray = [dolphinArray, cellstr(filenames{ii})];
           case 'MnandOdontocetes'
               MnandOdontocetesArray = [MnandOdontocetesArray,cellstr(filenames{ii})];
           otherwise
               disp('unknown species')
       end
   end
end

organizedFileArray = [dolphinArray, minkeArray, humpbackArray, MnandOdontocetesArray];
organizedFileArray = cellstr(organizedFileArray);
end

