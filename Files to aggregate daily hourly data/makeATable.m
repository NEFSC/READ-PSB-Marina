function newTable = makeATable(matrix4table,presTable,tableType,varNames)
%
%Created for Marina GUI
%Allison Stokoe 4/16/2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
newTable = [];
switch tableType
    case 'new'
    %squish together columns of data and append columns of zeros to that 
    %needs to match number of columns in presTable

        %gets columns of actual data (can be either Day and hourly column or just Day)
        for ii = 1:size(matrix4table,2)
            extractedColumn = matrix4table(:,ii);
            newTable = [newTable,extractedColumn];
        end
        %now make array of 0's that will be added as columns to the table
        zeroCol = zeros(length(matrix4table),1);
        numColumns2add = size(presTable,2)-size(matrix4table,2);
        for ii = 1:numColumns2add
            newTable = [newTable,zeroCol];
        end
        %check to see if last variable name in table is a comments columns so we
        %don't add zeros into it
        lastColName = varNames{length(varNames)};
        commentsCol_loc = strcmpi('comments',lastColName);

        if commentsCol_loc == 1
            varNames = varNames(1:(length(varNames)-1)); %remove last variable name
        else
            %do nothign to variable names
        end
        newTable = array2table(newTable,'VariableNames',varNames);
    case 'reconstruct'
    %reconstructs a presence table column by column
        for ii = 1:size(presTable,2)
            extractedColumn = presTable(:,ii);
            newTable = [newTable,extractedColumn];
        end
        %check to see if last variable name in table is a comments columns so we
        %don't add zeros into it
        lastColName = varNames{length(varNames)};
        commentsCol_loc = strcmpi('comments',lastColName);

        if commentsCol_loc == 1
            varNames = varNames(1:(length(varNames)-1)); %remove last variable name
        else
            %do nothign to variable names
        end
        newTable = array2table(newTable,'VariableNames',varNames);
end



