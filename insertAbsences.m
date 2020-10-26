function presTable= insertAbsences(data,sumType)
%User provides a table of data (from minke or dolphin detector) and lets
%the function know via sumType whether or not it's hourly or daily presence
%tables. The function then goes and fills in 0s (absences) where the
%detector did not detect anything based on what temporal resolution the
%user wants.

%Created for the detector2NCEI GUI SanctSound project

%Annamaria DeAngelis
%9/16/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%first need to see if daily or hourly is needed

switch sumType
    case 'daily'
        data.Matdates= datenum(data.Day);
        %are all days represented? (assuming detector detects something on the
        %first and last days of data)
        nDetDays= length(data.Matdates);
        nDataDays= data.Matdates(end)-data.Matdates(1)+1;
        
        if nDetDays~=nDataDays
            %find what days are missing
            allDays= data.Matdates(1):data.Matdates(end);
            missingDays= ismember(allDays,data.Matdates);
            missingDays2= allDays(~missingDays);
            
            %day format is not recognized by Matlab, need to convert it to something
            %recognizable
            data.Day= datetime(data.Day,'InputFormat','yyyy/m/d');
            data.Day= datestr(data.Day,'yyyy/mm/dd');
            %I have the missing days, now I need to insert it back into the table with
            %0s in the other columns
            %create matrix of 0s
            missingDays2= missingDays2';
            nblanks= length(missingDays2);
            nodata= array2table(nan(nblanks,3));
            nodata2= horzcat(nodata,array2table(missingDays2));
            nodata2.Properties.VariableNames= data.Properties.VariableNames;
            nodata2.Day= datestr(nodata2.Matdates,'yyyy/mm/dd');
            data.Present= str2double(data.Present);
            
            data= vertcat(data,nodata2);
        end
        
        presTable= sortrows(data,'Matdates');
        presTable.Matdates= [];
        presTable.Day= datestr(presTable.Day,'yyyy/mm/dd');
        
        
    case 'hourly'
        presTable= data;
        presTable.Matdates= datenum(presTable.Day);
        uDays= unique(presTable.Matdates);
        hinterest= 0:23;
        for u= 1:length(uDays)
            d24= find(presTable.Matdates==uDays(u));
            if length(d24)~= 24
                %if not, check to see what hours are present
                yHours= presTable.Hour(d24);
                whichHours= ismember(hinterest,yHours); %0 in a position= missing hour
                %add missing hours
                missingH= hinterest(whichHours==0);
                %put a 0 in column 3
                notPresent= zeros(length(missingH),1);
                extraDay= zeros(length(missingH),1)+uDays(u);
                extraDayStr= cellstr(datestr(extraDay,'yyyy-mm-dd'));
                freq= array2table(zeros(length(missingH),2));
                [~,ncol]= size(presTable);
                if ncol>6
                    Present= zeros(length(missingH),1);
                    Band1= zeros(length(missingH),1);
                    Band2= zeros(length(missingH),1);
                    Comments= cellstr(repmat(' ',[length(missingH),1]));
                    extraRow= table(extraDayStr,missingH',notPresent,freq.Var1,...
                    freq.Var2,Present,Band1,Band2,Comments,extraDay);
                extraRow.Properties.VariableNames= presTable.Properties.VariableNames;
                else
                 extraRow= table(extraDayStr,missingH',notPresent,freq.Var1,...
                    freq.Var2,extraDay);
                extraRow.Properties.VariableNames= presTable.Properties.VariableNames;   
                end
                
                presTable= vertcat(presTable,extraRow);
            end
        end
        %sort by column 1 then 2 again
        presTable= sortrows(presTable,{'Matdates','Hour'});
        presTable.Matdates= [];
        
    otherwise
        disp('I cannot aggregate the data the way you want me to.');
        disp('Please tell me daily or hourly and try again.');
end