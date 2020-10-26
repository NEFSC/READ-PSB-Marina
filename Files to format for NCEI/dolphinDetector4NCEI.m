function dataOut= dolphinDetector4NCEI(dataInput)
%Function requires readtable to read in the Excel file of dolphin presence
%(dataInput). It then goes and filters the presence sheet for only rows
%that were used (have numbers in the Presence column), then makes sure
%everything matches 1/0. If not it either coerces to 0 (2/3) or spits out
%the rows where the user has some other whole number (ie: 4s- user missed
%that row and needs to redo)

%Result is a table with columns in the NCEI format

%Created as part of the GUI4NCEIFormat SanctSound project

%Annamaria DeAngelis
%9/10/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%some variable names may be different between users. Coerce all variable
%names in table to be the same
dataInput.Properties.VariableNames= {'Day','Hour','nDet','MedLowFreq',...
    'MedHighFreq','Presence','Band1','Band2','Comments'};

%go through the data and remove any blank rows
dataInput = rmmissing(dataInput,'DataVariables','Presence');

%coerce all 2/3 to 0s
unsure= find(dataInput.Presence==2);
clicks= find(dataInput.Presence==3);
dataInput.Presence(unsure)= 0;
dataInput.Presence(clicks)= 0;
    %if any number besides 0-3, sprintf them for the user to go back and
    %fix. Don't continue the conversion
    notAccepted= find(dataInput.Presence>3);
    if ~isempty(notAccepted)
       disp('You have entered presence values that are not accepted (0-3).')
       errMsg2= fprintf('Please go back to the Excel file and check rows %d \n',...
           notAccepted+1);
    else
        %if all ok, go ahead and apply the ISO format
            %combine Day and Hour column
            nRows= length(dataInput.Hour);
            temp= cell(nRows,1);
            for i= 1:nRows
                %if hours 0-9 need to convert them to 2 digits
                if dataInput.Hour(i)<10 
                temp{i}= datestr(datetime([num2str(dataInput.Hour(i)),':00:00'],...
                    'InputFormat','H:mm:ss'));
                else
                    temp{i}= datestr(datetime([num2str(dataInput.Hour(i)),':00:00'],...
                    'InputFormat','HH:mm:ss'));
                end
            end
           
            dataInput.Time= temp;
            dataInput.Day.Format = 'MM/dd/yyyy HH:mm:ss';
            dataInput.Time= datetime(dataInput.Time, 'Format', 'MM/dd/yyyy HH:mm:ss');
            findMidnight= isnat(dataInput.Time);
            dataInput.Time(findMidnight)= datetime('00:00:00','Format', 'MM/dd/yyyy HH:mm:ss');
            dataInput.Datetime = dataInput.Day + timeofday(dataInput.Time);
            
            %need Matlab serial dates to go into ISO conversion function
            serialDatetime= datenum(dataInput.Datetime);
            ISOStartTime= dbSerialDateToISO8601(serialDatetime);
            Presence= dataInput.Presence;
            dataOut= table(ISOStartTime,Presence);
    end
    
    