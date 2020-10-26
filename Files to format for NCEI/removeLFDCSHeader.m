function trncData= removeLFDCSHeader(detectorType, data)
%based on the detector remove the header info in the file, spit out only 
%the tabular data

%Written for the GUI4NCEI SanctSound project

%Annamaria DeAngelis
%9/11/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch detectorType
    case {'sei', 'blue'}
        %sei and blue are the same (start at row 18)
        trncData= data(17:end,:);
    case 'fin'
        %fin is at 16
        trncData= data(15:end,:);
    case 'right'
        %narw is at 20
        trncData= data(19:end,:);
    case 'hump'
        %hump is at 24
        trncData= data(23:end,:);
    otherwise
        disp('Invalid detector type selected');
end

%get the column headers from the table
colnames= table2cell(trncData(1,:));

%check to see if the column names are in Matlab format
Mformat= cellfun(@isvarname,colnames);

    %if not, change them to be
    %probably because there's spaces- remove them
       newNames= strrep(colnames(Mformat==0),' ','_');
       colnames(Mformat==0)= newNames;
    %remove ?
    findquest= contains(colnames,'?');
    colnames(findquest)= strrep(colnames(findquest),'?','');
    %remove /
    findslash= contains(colnames,'/');
    colnames(findslash)= strrep(colnames(findslash),'/','_');
    
%once done, remove the column names from the table and we're done
trncData(1,:)= [];
trncData.Properties.VariableNames= colnames;