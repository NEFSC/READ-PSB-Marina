function newPres = insertAbsences2(presTable,startValue,endValue,sumType)

%check to see if there are any entire columns where all cells are
%blank (value in cell will be "NaN" if blank)
todelete = [];
for ii = 1:width(presTable)
    currentCol = table2array(presTable(:,ii));
    if isa(currentCol,'numeric')
        if any(isnan(currentCol) == 1,'all')
            todelete = [todelete,ii];
        else
            %keep checking
        end
    else
        %keep checking
    end
end

presTable(:,todelete) = []; %delete the columns where every cell is "NaN"

%get variable names from original table
varNames = presTable.Properties.VariableNames;
%convert Day column into datenum
presTable.Day = datenum(presTable.Day);

%check to see which columns are numbers
numTypCols = [];
cellTypCols = [];
for ii = 1:width(presTable)
    if isnumeric(table2array(presTable(:,ii))) == 1
        numTypCols = [numTypCols,ii];
    else
        cellTypCols = [cellTypCols,ii];
    end
end

%take start datetime and end datetime, find complete list of days
startValue = char(startValue);
endValue = char(endValue);
startDate = datetime(startValue,'InputFormat','MM/dd/yyyy HH:mm:ss');
endDate = datetime(endValue,'InputFormat','MM/dd/yyyy HH:mm:ss');
startDate.Format = 'MM/dd/yy';
endDate.Format = 'MM/dd/yy';
startValue = cellstr(startDate);
endValue = cellstr(endDate);
startValue = datenum(startValue);
endValue = datenum(endValue);

totalDays = transpose(startValue:1:endValue);

switch sumType
    case 'hourly'
        %find complete list of hours
        startDate.Format = 'HH';
        endDate.Format = 'HH';
        startHour = cellstr(startDate);
        endHour = cellstr(endDate);
        startHour = str2num(cell2mat(startHour));
        endHour = str2num(cell2mat(endHour));
        startDate.Format = 'mm';
        StartMinute = cellstr(startDate);
        StartMinute = str2num(cell2mat(StartMinute));

        if StartMinute > 0
            startHour = startHour + 1;
        else
            %start hour starts at top of hour
        end

        %make an array for a day that has all hours 0-23
        startHrRange = transpose(startHour:1:23);
        endHrRange = transpose(0:1:(endHour-1));
        FullhrRange = transpose(0:1:23); %an array starting at 0, incrementing by 1, ending at 23

        %repeat day # for hours in that day
        firstCompDay = repmat(totalDays(1),length(startHrRange),1);
        lastCompDay = repmat(totalDays(length(totalDays)),length(endHrRange),1);

        %attach hours to days 
        firstCompDayHr = [firstCompDay,startHrRange];
        lastCompDayHr = [lastCompDay,endHrRange];
        hrDayMatrix = firstCompDayHr;

        %do everything in between
        for ii = 2:length(totalDays)-1
            fullDay = repmat(totalDays(ii),length(FullhrRange),1);
            fullDayHr = [fullDay,FullhrRange];
            hrDayMatrix = [hrDayMatrix;fullDayHr];
        end

        %append last day/hour to table
        hrDayMatrix = [hrDayMatrix;lastCompDayHr];

        %make matrix of 0's
        blankPres = zeros(length(hrDayMatrix),length(numTypCols));

        %insert day and hour columns
        blankPres(:,1) = hrDayMatrix(:,1);
        blankPres(:,2) = hrDayMatrix(:,2);
        
        if ~isempty(cellTypCols) == 1
            blankPres = array2table(blankPres);
            newPres = [];
            if length(numTypCols) > length(cellTypCols)
                longerArray = numTypCols;
                shorterArray = cellTypCols;
            else
                longerArray = cellTypCols;
                shorterArray = numTypCols;
            end
            n = 1;
            k = 1;
            for ii = 1:(length(longerArray)+length(shorterArray))
                if longerArray(k) < shorterArray(n)
                    newPres = [newPres,blankPres(:,k)];
                    k = k+1;
                    if k > length(longerArray)
                        k = length(longerArray);
                        for c = n:length(shorterArray)
                            varN = strcat('blankCol',string(n));
                            newPres = [newPres,array2table(strings(height(blankPres),1),'VariableNames',cellstr(varN))];
                            n = n+1;
                        end
                        break
                    else
                        %keep going
                    end
                else
                    varN = strcat('blankCol',string(n));
                    newPres = [newPres,array2table(strings(height(blankPres),1),'VariableNames',cellstr(varN))];
                    n = n+1;
                end
            end
        else
            newPres = array2table(blankPres, 'VariableNames', varNames);
        end
        newPres.Properties.VariableNames = presTable.Properties.VariableNames;
        %insert correct row #(values in addrows) of pres table to correct 
        %row # (thisloc)
        [loca, locb] = ismember(newPres(:,1:2),presTable(:,1:2),'rows');
        thisLoc = find(loca == 1);
        addrows = nonzeros(locb);
        for ii = 1:length(thisLoc)
            newPres(thisLoc(ii),:) = presTable(addrows(ii),:);
        end
        
        %insert 0's for all nan values
        for ii = 1:height(newPres)
            for k = 1:width(newPres)
                if isnumeric(table2array(newPres(ii,k))) == 1
                    if isnan(table2array(newPres(ii,k))) == 1
                        newPres{ii,k} = 0;
                    else
                        %do nothing, it's not a NaN value
                    end
                else
                    %do nothing, it's not a number
                end
            end
        end

        %revert day column back to format of final table
        newPres.Day = datetime(newPres.Day,'ConvertFrom','datenum');
        newPres.Day.Format = 'MM/dd/yyyy';
        
    case 'daily'
        %make matrix of 0's
        blankPres = zeros(length(totalDays),width(presTable));

        %insert day column
        blankPres(:,1) = totalDays(:,1);
        if ~isempty(cellTypCols) == 1
            blankPres = array2table(blankPres);
            newPres = [];
            if length(numTypCols) > length(cellTypCols)
                longerArray = numTypCols;
                shorterArray = cellTypCols;
            else
                longerArray = cellTypCols;
                shorterArray = numTypCols;
            end
            n = 1;
            k = 1;
            for ii = 1:(length(longerArray)+length(shorterArray))
                if longerArray(k) < shorterArray(n)
                    newPres = [newPres,blankPres(:,k)];
                    k = k+1;
                    if k > length(longerArray)
                        k = length(longerArray);
                        for c = n:length(shorterArray)
                            varN = strcat('blankCol',string(n));
                            newPres = [newPres,array2table(strings(height(blankPres),1),'VariableNames',cellstr(varN))];
                            n = n+1;
                        end
                        break
                    else
                        %keep going
                    end
                else
                    varN = strcat('blankCol',string(n));
                    newPres = [newPres,array2table(strings(height(blankPres),1),'VariableNames',cellstr(varN))];
                    n = n+1;
                end
            end
        else
            newPres = array2table(blankPres, 'VariableNames', varNames);
        end
        newPres.Properties.VariableNames = presTable.Properties.VariableNames;
        
        %insert correct row #(values in addrows) of pres table to correct 
        %row # (thisloc) 
        [loca, locb] = ismember(newPres(:,1),presTable(:,1),'rows');
        thisLoc = find(loca == 1);
        addrows = nonzeros(locb);
        for ii = 1:length(thisLoc)
                newPres(thisLoc(ii),:) = presTable(addrows(ii),:);
        end
        %insert 0's for all nan values
        for ii = 1:height(newPres)
            for k = 1:width(newPres)
                if isnumeric(table2array(newPres(ii,k))) == 1
                    if isnan(table2array(newPres(ii,k))) == 1
                        newPres{ii,k} = 0;
                    else
                        %keep checking, it's not a NaN value
                    end
                else
                    %keep checking, it's not a number
                end
            end
        end        
        %revert day column back to format of final table
        newPres.Day = datetime(newPres.Day,'ConvertFrom','datenum');
        newPres.Day.Format = 'MM/dd/yyyy';
end
end

