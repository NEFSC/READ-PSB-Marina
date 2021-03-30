function presTable= insertAbsencesFin(data,startdate,enddate)
%User provides a table of data (from LFDCS fin hourly presence) and the 
%start and end dates of the deployment and fills in the missing dates with
%NaNs as fins aren't always detected on the first/last day of deployments

%Created for the detector2NCEI GUI SanctSound project

%Annamaria DeAngelis
%3/22/2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
        data.Matdates= datenum(data.start_date);
        %are all days represented? (assuming detector detects something on the
        %first and last days of data)
        nDetDays= datenum(enddate)-datenum(startdate)+1;
        nDataDays= data.Matdates(end)-data.Matdates(1)+1;
        
        if nDetDays~=nDataDays
            %find what days are missing
            allDays= datenum(startdate):datenum(enddate);
            missingDays= ismember(allDays,data.Matdates);
            missingDays2= allDays(~missingDays);
            
            %day format is not recognized by Matlab, need to convert it to something
            %recognizable
            %data.Day= datetime(data.Day,'InputFormat','yyyy/m/d'); **this
            %line was causing a bug 
            data.start_date= datestr(data.start_date,'mm/dd/yyyy');
            %I have the missing days, now I need to insert it back into the table with
            %0s in the other columns
            %create matrix of 0s
            missingDays2= missingDays2';
            nblanks= length(missingDays2);
            nodata= array2table(nan(nblanks,2));
            nodata2= horzcat(nodata,array2table(missingDays2));
            nodata2.Properties.VariableNames= data.Properties.VariableNames;
            nodata2.start_date= datestr(nodata2.Matdates,'mm/dd/yyyy');
           
            %data.Present= str2double(data.Present);
            
            data= vertcat(data,nodata2);
        end
        
        presTable= sortrows(data,'Matdates');
        presTable.Matdates= [];
        presTable.start_date= datestr(presTable.start_date,'mm/dd/yy');       
