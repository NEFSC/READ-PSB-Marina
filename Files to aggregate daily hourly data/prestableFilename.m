function newfilename = prestableFilename(pathname,projectname,species)
%For aggregate data GUI. Works with SanctSound file formats to creat new
%name for exported presence tables. 
% Allison Stokoe 4/16/2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 newfilename = strsplit(projectname,'_');
 newfilename = {char(newfilename{1}), char(newfilename{2}), char(newfilename{3})};
 newfilename = strjoin(newfilename, '_');
 newfilename = newfilename(~isspace(newfilename));
 switch species
     case 'dolphin'
         species = 'dolphins';
     otherwise
         %species name is fine, don't change it
 end
 newfilename = [char(pathname),char(newfilename),'_', char(species),'.xlsx'];
end

