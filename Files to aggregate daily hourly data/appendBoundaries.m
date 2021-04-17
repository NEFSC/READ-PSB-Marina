function compPres = appendBoundaries(data,startValue,endValue,sumType,species,varNames)
%Appends deployment start and end date (& hours depending on sumType)to top 
%and bottom of presence table.
%
%Created for Marina GUI.
%Allison Stokoe 4/16/2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%define necessary variables 
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
uiStartVal = startValue;
uiEndVal = endValue;
dataStartVal = table2array(data(1,1));
dataStartVal = datenum(dataStartVal);
dataEndVal = table2array(data(height(data),1));
dataEndVal = datenum(dataEndVal);

%extract common columns between all sumTypes
Col1 = table2array(data(:,1));
Col2 = table2array(data(:,2));
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
            startDate.Format = 'mm';
            StartMinute = cellstr(startDate);
            StartMinute = str2num(cell2mat(StartMinute));
            
            %get numbers to check if start and end values are already there
            uiStartHr = startHour;
            uiEndHr = endHour;
            dataStartHr = table2array(data(1,2));
            dataEndHr = table2array(data(height(data),2));

            Col3 = table2array(data(:,3));
            Col4 = table2array(data(:,4));
            Col5 = table2array(data(:,5));
            
            if width(data) > 5
                Col6 = table2array(data(:,6));
                Col7 = table2array(data(:,7));
                Col8 = table2array(data(:,8));
                %don't need to add zeros into comments columns 
            else
                %don't add columns for presence 
            end
            
            if uiStartVal == dataStartVal && uiStartHr == dataStartHr
               %don't add anything because it's already there
            else
               %append values into a matrix
               Col1 = [startValue;Col1];
               Col2 = [startHour;Col2];
               Col3 = [zeros(1,1);Col3];
               Col4 = [zeros(1,1);Col4];
               Col5 = [zeros(1,1);Col5];
               if width(data) > 5 %check if this is a completed presence table
                   Col6 = [zeros(1,1);Col6];
                   Col7 = [zeros(1,1);Col7];
                   Col8 = [zeros(1,1);Col8];
               else
                   %don't add columns for presence
               end
            end
            
            if uiEndVal == dataEndVal && uiEndHr == dataEndHr
               %don't add anything because it's already there
            else
                Col1 = [Col1;endValue];
                Col2 = [Col2;endHour];
                Col3 = [Col3;zeros(1,1)];
                Col4 = [Col4;zeros(1,1)];
                Col5 = [Col5;zeros(1,1)];
                if width(data) > 5 %check if this is a completed presence table
                    Col6 = [Col6;zeros(1,1)];
                    Col7 = [Col7;zeros(1,1)];
                    Col8 = [Col8;zeros(1,1)];
                else
                    %don't add columns for presence
                end
            end
            presTable = [Col1,Col2,Col3,Col4,Col5];
            if width(data) > 5
                presTable = [presTable,Col6,Col7,Col8];
            else
                %do nothing
            end
        [Hr_first,Hr_last,HourRange]= hourstuff(presTable); %hour only
        [lastDay,totalDays] = dayStuff(presTable); %hour and day sumTypes
        compPres = bothDayHour(presTable,totalDays,lastDay,Hr_first,Hr_last,HourRange,StartMinute,varNames,sumType);
    case 'daily'
            switch species
                case 'Minke'
                    if width(data) > 2 
                       Col3 = table2array(data(:,3));     
                    else
                        %do nothing
                    end
                case 'humpback'
                Col3 = table2array(data(:,3));
                Col4 = table2array(data(:,4));
                    if width(data) > 4 
                        Col3 = table2array(data(:,3));
                        Col4 = table2array(data(:,4));
                        Col5 = table2array(data(:,5));
                    else 
                        %do nothing
                    end
            end
            if uiStartVal == dataStartVal
               %don't add anything because it's already there
            else  
               Col1 = [startValue;Col1];
               switch species
                   case 'Minke'
                       Col2 = [zeros(1,1);Col2];
                       if width(data) > 2
                           Col3 = [zeros(1,1);Col3];
                       else                 
                          %it's not a completed table. Don't need to do anything else 
                       end
                   case 'humpback'
                       Col2 = [zeros(1,1);Col2];
                       Col3 = [zeros(1,1);Col3];
                       Col4 = [zeros(1,1);Col4];                       
                       if width(data) > 4
                          Col5 = [zeros(1,1);Col5];
                       else
                          %it's not a completed table. Don't need to do anything else 
                       end
               end
            end
            
            if uiEndVal == dataEndVal
               %don't add anything because it's already there
            else
                Col1 = [Col1;endValue];
                switch species
                    case 'Minke'
                      Col2 = [Col2;zeros(1,1)];
                      presTable = [Col1,Col2];
                       if width(data) > 2
                          Col3 = [Col3;zeros(1,1)];
                          presTable = [presTable,Col3]; 
                       else                
                           %it's not a completed table. Don't need to do anything else 
                       end
                       [lastDay,totalDays] = dayStuff(presTable);
                        compPres = bothDayHour(presTable,totalDays,lastDay,'',''...
                       ,'','',varNames,sumType);
                    case 'humpback'
                       Col2 = [Col2;zeros(1,1)];
                       Col3 = [Col3;zeros(1,1)];
                       Col4 = [Col4;zeros(1,1)];
                       presTable = [Col1,Col2,Col3,Col4];    
                       if width(data) > 4
                           Col5 = [Col5;zeros(1,1)];
                           presTable = [presTable,Col5];
                       else
                           %it's not a completed table. Don't need to do anything else 
                       end
                       [lastDay,totalDays] = dayStuff(presTable);
                        compPres = bothDayHour(presTable,totalDays,lastDay,'',''...
                       ,'','',varNames,sumType);
                end
            end
            [lastDay,totalDays] = dayStuff(table2array(data));
            compPres = bothDayHour(table2array(data),totalDays,lastDay,'',''...
           ,'','',varNames,sumType);
    otherwise
end
end