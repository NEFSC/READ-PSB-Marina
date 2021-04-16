function compPres = bothDayHour(presTable,totalDays,lastDay,Hr_first,Hr_last,HourRange,sumType)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch sumType
    case 'hourly'
        %create first full day with correct num of days for hour
        Full_Hrs_Day1 = Hr_first:1:23; %range of full hours for first day only

        %first day with full range of hours
        firstCompDay = repmat(totalDays(1),length(Full_Hrs_Day1),1);

        %create the second full day & append to first full day 
        dayRangeFull= repmat(totalDays(2),24,1);
        dayRangeFull = [firstCompDay;dayRangeFull];

        %attach second full day to complete hours in first day
        hourRangeFull = [transpose(Full_Hrs_Day1);transpose(HourRange)];

        %do this for rest of days
        for ii = 3:length(totalDays)
        newDayRange = repmat(totalDays(ii),24,1);
        dayRangeFull = makeNewArray(dayRangeFull,newDayRange, 'append2column');
        end

        %do this for hours too
        for ii = 3:length(totalDays)
        hourRangeFull = makeNewArray(hourRangeFull,transpose(HourRange), 'append2column');
        end

        %make a table of "Days" and "Hours" with our complete lists
        completeTable = [dayRangeFull,hourRangeFull];
        numRows = length(completeTable); %num of rows in complete table
        compTrowidx = 1:1:numRows; %array of 1 to n rows

        %find dep end boundary and remove everything after it
        lastRow = [lastDay,Hr_last];
        loc_lastRow = ismember(completeTable,lastRow);
        lastRow_idx = find(loc_lastRow(:,1) == 1 & loc_lastRow(:,2) == 1);
        todelete =  transpose(compTrowidx) >= lastRow_idx;
        todelete = todelete == 1;
        completeTable(todelete,:) = [];

        %remove dep start boundary 
        completeTable(1,:) = [];

        %make a row of just zeros
        zeroCols = zeros(length(completeTable),1);

        %squish everything together to get a blank presence table with all values
        %for days and hours
        compPres = table(completeTable(:,1),completeTable(:,2),zeroCols,...
            zeroCols,zeroCols,'VariableNames',{'Day','Hour','nDet','MedLowFreq'...
            ,'MedHighFreq'});
        presTable = table(presTable(:,1),presTable(:,2),presTable(:,3),...
            presTable(:,4),presTable(:,5), 'VariableNames', ...
            {'Day','Hour','nDet','MedLowFreq','MedHighFreq'});
        %insert correct row #(values in addrows) of pres table to correct 
        %row # (thisloc) of compPres 
        [loca,locb] = ismember(compPres(:,[1 2]),presTable(:,[1 2]));
        thisLoc = find(loca == 1);
        addrows = nonzeros(locb);
        for ii = 1:length(thisLoc)
                compPres(thisLoc(ii),:) = presTable(addrows(ii),:);
        end
        
        %revert day column back to format of final table
        compPres.Day = datetime(compPres.Day,'ConvertFrom','datenum');
        compPres.Day.Format = 'MM/dd/yyyy';
    case 'daily'
        %remove dep start boundary 
        numVars = length(presTable);
        zeroCols = zeros(length(totalDays),1);
        for ii = 1:numVars
            totalDays = makeNewArray(totalDays,zeroCols, 'appendNewColumn');
        end
        compPres = table(totalDays(:,1),totalDays(:,2),totalDays(:,3),...
            totalDays(:,4),'VariableNames',{'Day','nDet',...
            'MedLowFreq','MedHighFreq'});
        presTable = table(presTable(:,1),presTable(:,2),presTable(:,3),...
            presTable(:,4), 'VariableNames', ...
            {'Day','nDet','MedLowFreq','MedHighFreq'});
        %insert correct row #(values in addrows) of pres table to correct 
        %row # (thisloc) of compPres 
        [loca,locb] = ismember(compPres(:,1),presTable(:,1));
        thisLoc = find(loca == 1);
        addrows = nonzeros(locb);
        for ii = 1:length(thisLoc)
                compPres(thisLoc(ii),:) = presTable(addrows(ii),:);
        end
        %revert day column back to format of final table
        compPres.Day = datetime(compPres.Day,'ConvertFrom','datenum');
        compPres.Day.Format = 'MM/dd/yyyy';
end

end

