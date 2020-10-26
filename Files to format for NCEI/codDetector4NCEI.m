function dataOut= codDetector4NCEI(dataInput)
%Make sure to use readtable with ReadVariableNames, 1 in the function call

%Takes in the cod detector text file and checks to make sure only Ys and Ns
%were entered, converts presence from text to numeric, then converts the
%times to ISO format

%Created for the GUI4NCEI SanctSound project

%Annamaria DeAngelis
%9/10/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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
Presence(nos)= 0;
%Check for any other letter in Cod (Y/N)? Column,
otherLetters= isnan(Presence);

if otherLetters
    %there are other letters than Y and N
    %stop the operation and spit warning message
    disp('You have entered other letters besides Y and N for cod presence.');
    disp('Please check the following data entries:');
    toCheck= table(dataInput.Sel(otherLetters),...
        dataInput.BeginDate(otherLetters),dataInput.StartTime(otherLetters),...
        dataInput.Presence(otherLetters));
    toCheck.Properties.VariableNames= {'Sel','Date','StartTime','Labeled'};
    disp(toCheck);
else %can resume
    %Combine the Begin Date with the Begin Clock Time and End Clock Time
    %columns
    dataInput.BeginDate= datetime(dataInput.BeginDate,'InputFormat','yyyy/M/dd');
    dataInput.BeginDate.Format = 'MM/dd/yyyy HH:mm:ss';
    StartDateTime= dataInput.BeginDate+dataInput.StartTime;
    EndDateTime= dataInput.BeginDate+dataInput.EndTime;
    
    %then convert to ISO format
    serialDatetimeStart= datenum(StartDateTime);
    ISOStartTime= dbSerialDateToISO8601(serialDatetimeStart);
    serialDatetimeEnd= datenum(EndDateTime);
    ISOEndTime= dbSerialDateToISO8601(serialDatetimeEnd);
    
    dataOut= table(ISOStartTime,ISOEndTime,Presence);
end