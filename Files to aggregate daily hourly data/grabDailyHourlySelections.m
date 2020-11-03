function dailyResults = grabDailyHourlySelections(Raven_table)
%Provide a Raven selection table to then have function grab all the unique
%days and hours/day with the corresponding selection number

%Written for the minke detector output (has 14 columns in which column 9
%has the date and column 10 has the begin clock time. Column 1 contains the
%selection number)

%output is of 2 tables, one of the daily results and the other of the
%hourly results

%Annamaria DeAngelis
%4/28/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%daily list
[M,I]= unique(Raven_table.Var9,'stable'); %contains all the unique dates and their indices
daily_ind= Raven_table.Var1(I);
dailyResults= table(M,daily_ind);
dailyResults.Properties.VariableNames= {'Day','SelNo'};
I= [I; length(Raven_table.Var9)]; %to be able to get all the hours per day

end