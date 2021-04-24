function blankPres = insertAbsences2(presTable,startValue,endValue,sumType)
%get variable names from original table
varNames = presTable.Properties.VariableNames;
%convert Day column into datenum
presTable.Day = datenum(presTable.Day);

%make presTable into a matrix
%check to see if last variable name in table is a comments columns
lastColName = varNames{length(varNames)};
commentsCol_loc = strcmpi('comments',lastColName);
if commentsCol_loc == 1
    numCols = width(presTable)-1;
else
    numCols = width(presTable);
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
        blankPres = zeros(length(hrDayMatrix),numCols);

        %insert day and hour columns
        blankPres(:,1) = hrDayMatrix(:,1);
        blankPres(:,2) = hrDayMatrix(:,2);
        
        if commentsCol_loc == 1
            blankCol = strings(length(blankPres),1);
            blankCol = array2table(blankCol,'VariableNames',{'Comments'});
            vars = length(varNames)-1;
            blankPres = array2table(blankPres, 'VariableNames', varNames(1:vars));
            blankPres = [blankPres,blankCol];
        else
            blankPres = array2table(blankPres, 'VariableNames', varNames);
        end
        %insert correct row #(values in addrows) of pres table to correct 
        %row # (thisloc)
        [loca, locb] = ismember(blankPres(:,1:2),presTable(:,1:2),'rows');
        thisLoc = find(loca == 1);
        addrows = nonzeros(locb);
        for ii = 1:length(thisLoc)
            blankPres(thisLoc(ii),:) = presTable(addrows(ii),:);
        end
        
        %insert 0's for all nan values
        for ii = 1:height(blankPres)
            for k = 1:width(blankPres)
                if isnumeric(table2array(blankPres(ii,k))) == 1
                    if isnan(table2array(blankPres(ii,k))) == 1
                        blankPres{ii,k} = 0;
                    else
                        %do nothing, it's not a NaN value
                    end
                else
                    %do nothing, it's not a number
                end
            end
        end

        %revert day column back to format of final table
        blankPres.Day = datetime(blankPres.Day,'ConvertFrom','datenum');
        blankPres.Day.Format = 'MM/dd/yyyy';
        
    case 'daily'
        %make matrix of 0's
        blankPres = zeros(length(totalDays),numCols);

        %insert day and hour columns
        blankPres(:,1) = totalDays(:,1);
        if commentsCol_loc == 1
            blankCol = strings(length(blankPres),1);
            blankCol = array2table(blankCol,'VariableNames',{'Comments'});
            vars = length(varNames)-1;
            blankPres = array2table(blankPres, 'VariableNames', varNames(1:vars));
            blankPres = [blankPres,blankCol];
        else
            blankPres = array2table(blankPres, 'VariableNames', varNames);
        end
        %insert correct row #(values in addrows) of pres table to correct 
        %row # (thisloc) 
        [loca, locb] = ismember(blankPres(:,1),presTable(:,1),'rows');
        thisLoc = find(loca == 1);
        addrows = nonzeros(locb);
        for ii = 1:length(thisLoc)
                blankPres(thisLoc(ii),:) = presTable(addrows(ii),:);
        end
        %insert 0's for all nan values
        for ii = 1:height(blankPres)
            for k = 1:width(blankPres)
                if isnumeric(table2array(blankPres(ii,k))) == 1
                    if isnan(table2array(blankPres(ii,k))) == 1
                        blankPres{ii,k} = 0;
                    else
                        %do nothing, it's not a NaN value
                    end
                else
                    %do nothing, it's not a number
                end
            end
        end        
        %revert day column back to format of final table
        blankPres.Day = datetime(blankPres.Day,'ConvertFrom','datenum');
        blankPres.Day.Format = 'MM/dd/yyyy';
end
end

