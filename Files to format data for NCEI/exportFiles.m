function exportFiles(suprafolder, dataOut, new_filename, Sanctuary, site_deployment)
%Exports .csv files into this folder structure:
%Sanctuary Abbreviation\Site Deployment\presence table formated for NCEI.csv 
%
%For Format_Data_For_NCEI boat in Marina GUI
%Created by Allison Stokoe 4/11/2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%find current Matlab folder
originalFolder = pwd;

%change directory to suprafolder
cd(suprafolder)

if Sanctuary == 0
    disp('Cannot export files with this sanctuary type')
else
    %check if Sanctuary folder exists
    if  isfolder(Sanctuary) == 1
        currentfolder = pwd;
        newfoldername = [char(currentfolder),'\',Sanctuary]; %add this folder to path
        cd(newfoldername) %navigate into folder

        %if it exists then check if site_deployment folder exists
        if isfolder(site_deployment) == 1
           sitefoldername = [char(newfoldername),'\',site_deployment]; %add this folder to path
           cd(sitefoldername) %navigate into folder
           save_path = pwd;
           full_pathfilename = fullfile(save_path, new_filename);

           %write the NCEI formatted table to folder
           writetable(dataOut,full_pathfilename);

        %and check if site_deploymnet folder doesn't exist   
        elseif isfolder (site_deployment) == 0 
           mkdir(site_deployment); %if it does not exist, create the folder
           sitefoldername = [char(newfoldername),'\',site_deployment]; %add this folder to path
           cd(sitefoldername) %navigate into newly created folder
           save_path = pwd;
           full_pathfilename = fullfile(save_path, new_filename);

           %write file to folder
           writetable(dataOut,full_pathfilename);
        end

    %check if Sanctuary folder doesn't exist    
    elseif isfolder(Sanctuary) == 0
        mkdir(Sanctuary) %if it doesn't make the folder
        currentfolder = pwd;
        newfoldername = [char(currentfolder),'\',Sanctuary]; %add this folder to path
        cd(newfoldername)

        if isfolder(site_deployment) == 1 %check if site_deployment folder exists
           sitefoldername = [char(newfoldername),'\',site_deployment]; %add this folder to path
           cd(sitefoldername) %navigate into folder
           save_path = pwd;
           full_pathfilename = fullfile(save_path, new_filename);

           writetable(dataOut,full_pathfilename);
        elseif isfolder (site_deployment) == 0 %check if site_deployment folder doesn't exist
           mkdir(site_deployment); %if it doesn't then make the folder
           sitefoldername = [char(newfoldername),'\',site_deployment]; %add this folder to path
           cd(sitefoldername) %navigate into folder
           save_path = pwd;
           full_pathfilename = fullfile(save_path, new_filename);

           %write file to folder
           writetable(dataOut,full_pathfilename);
        end
    end
end

%return Matlab path to original current folder
cd(originalFolder)
end

