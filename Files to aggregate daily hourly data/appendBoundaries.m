function presTable = appendBoundaries(data,startValue,endValue,sumType)
%Appends deployment start and end date (& hours depending on sumType)to top 
%and bottom of presence table.
%
%Created for Marina GUI.
%
%Original 'deploymentBoundaries.m' by Annamaria DeAngelis
%Allison Stokoe 4/15/2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

switch sumType
    case 'hourly'
            %find if start hour input by user is the same as what's already 
            %in the table
            startDate.Format = 'HH';
            endDate.Format = 'HH';
            startHour = cellstr(startDate);
            endHour = cellstr(endDate);
            startHour = str2num(cell2mat(startHour));
            endHour = str2num(cell2mat(endHour));

            %get numbers to check if start and end values are already there
            uiStartVal = startValue;
            uiStartHr = startHour;
            uiEndVal = endValue;
            uiEndHr = endHour;
            dataStartVal = table2array(data(1,1)); 
            dataStartHr = table2array(data(1,2));
            dataStartVal = datenum(dataStartVal);
            dataEndVal = table2array(data(height(data),1));
            dataEndHr = table2array(data(height(data),2));
            dataEndVal = datenum(dataEndVal);
            dayCol = datenum(data.Day);            
            hourCol = table2array(data(:,2));
            nDetCol = table2array(data(:,3));
            LowFreqCol = table2array(data(:,4));%need to change this for minke
            HighFreqCol = table2array(data(:,5));
            if uiStartVal == dataStartVal && uiStartHr == dataStartHr
               %don't add anything because it's already there
            else
               %append values into a matrix
               dayCol = [startValue;dayCol];
               hourCol = [startHour;hourCol];
               nDetCol = [zeros(1,1);nDetCol];
               LowFreqCol = [zeros(1,1);LowFreqCol];
               HighFreqCol = [zeros(1,1);HighFreqCol];                 
            end
            
            if uiEndVal == dataEndVal && uiEndHr == dataEndHr
               %don't add anything because it's already there
            else
                dayCol = [dayCol;endValue];
                hourCol = [hourCol;endHour];
                nDetCol = [nDetCol;zeros(1,1)];
                LowFreqCol = [LowFreqCol;zeros(1,1)];
                HighFreqCol = [HighFreqCol;zeros(1,1)];                
            end
            
            presTable = [dayCol,hourCol,nDetCol,LowFreqCol,HighFreqCol];
    case 'daily'
            %define table columsn
            nDetCol = table2array(data(:,2));
            LowFreqCol = table2array(data(:,3));%need to change this for minke
            HighFreqCol = table2array(data(:,4));
            dayCol = table2array(data(:,1));
            dayCol = datetime(dayCol,'InputFormat','yyyy-MM-dd');
            dayCol = datenum(dayCol);   
            
            %get numbers to check if start and end values are already there
            uiStartVal = startValue;
            uiEndVal = endValue;
            dataStartVal = table2array(data(1,1)); 
            dataStartVal = datenum(dataStartVal);
            dataEndVal = table2array(data(height(data),1));
            dataEndVal = datenum(dataEndVal);

            if uiStartVal == dataStartVal
               %don't add anything because it's already there
            else
               %append values into a matrix
               dayCol = [startValue;dayCol]; 
               nDetCol = [zeros(1);nDetCol];
               LowFreqCol = [zeros(1);LowFreqCol];
               HighFreqCol = [zeros(1);HighFreqCol];          
            end
            
            if uiEndVal == dataEndVal
               %don't add anything because it's already there
            else
                dayCol = [dayCol;endValue];
                nDetCol = [nDetCol;zeros(1)];
                LowFreqCol = [LowFreqCol;zeros(1)];
                HighFreqCol = [HighFreqCol;zeros(1)];            
            end
            presTable = [dayCol,nDetCol,LowFreqCol,HighFreqCol];
    otherwise
end
end

