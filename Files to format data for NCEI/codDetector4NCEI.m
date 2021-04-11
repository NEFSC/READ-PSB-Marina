function [dataOut, needsZeros] = codDetector4NCEI(pathname,currentfile)
%
%Created by Annamaria DeAngelis 2020 Modified by Allison Stokoe 4/11/21
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    dataInput = readtable([pathname, currentfile], 'ReadVariableNames', true);

    %Get the column names correct
    dataInput.Properties.VariableNames= {'Sel','View','NotImportant','Channel',...
    'BeginSec','EndSec','LowFreq','HighFreq','BeginDate','StartTime','EndTime',...
    'SNR','Confidence','Class','Presence'};

    %Convert Y/Ns to 1/0
    nRow= length(dataInput.Presence);
    yeses= strcmp(dataInput.Presence,'Y');
    Presence= NaN(nRow,1);
    Presence(yeses)= 1;
    nos= strcmp(dataInput.Presence,'N');
    Presence(nos)= [];
    dataInput(nos,:)= [];
    %Check for any other letter in Cod (Y/N)? Column,
    otherLetters= isnan(Presence);


    if otherLetters
        needsZeros = 0;
        %there are other letters than Y and N
        %stop the operation and spit warning message
        disp('You have entered other letters besides Y and N for cod presence.')
        disp('Please check the following data entries:')
        toCheck= table(dataInput.Sel(otherLetters),...
            dataInput.BeginDate(otherLetters),dataInput.StartTime(otherLetters),...
            dataInput.Presence(otherLetters));
        toCheck.Properties.VariableNames= {'Sel','Date','StartTime','Labeled'};
        disp(toCheck);
    else 
        if isempty(dataInput)
            needsZeros = 1; %when this goes back to GUI, GUI knows that the current file needs 0's entered
        else
            needsZeros = 0;
            %Combine the Begin Date with the Begin Clock Time and End Clock Time columns
            dataInput.BeginDate= datetime(dataInput.BeginDate,'InputFormat','yyyy/M/dd');
            dataInput.BeginDate.Format = 'MM/dd/yyyy HH:mm:ss';
            StartDateTime= dataInput.BeginDate+dataInput.StartTime;
            EndDateTime= dataInput.BeginDate+dataInput.EndTime;

            %then convert to ISO format
            serialDatetimeStart= datenum(StartDateTime);
            ISOStartTime = dbSerialDateToISO8601(serialDatetimeStart);
            serialDatetimeEnd= datenum(EndDateTime);
            ISOEndTime = dbSerialDateToISO8601(serialDatetimeEnd);

            if length(Presence)~= 1
                dataOut= table(ISOStartTime,ISOEndTime,Presence);
                dataOut = noBlanks(dataOut);
            else
                cellOut= {ISOStartTime,ISOEndTime,Presence};
                dataOut= cell2table(cellOut,'VariableNames',{'ISOStartTime','ISOEndTime','Presence'});
            end
        end
    end
end

