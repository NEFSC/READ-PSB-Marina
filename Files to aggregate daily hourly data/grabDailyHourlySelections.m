function [dailyResults, hourlyResults]= grabDailyHourlySelections(Raven_table)
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

%hourly list
hourlyResults= table(1,2,3);
hourlyResults.Properties.VariableNames= {'Var1','unihours','sel_ind'};
for i= 1:length(I)-1
       
    %get the unique hours/day
    dtimes= Raven_table.Var10(I(i):I(i+1)-1);
    selno= Raven_table.Var1(I(i):I(i+1)-1);
    [h,~,~]= hms(dtimes);
    [unihours,hindex]= unique(h);
    sel_ind= selno(hindex);
    
    %put into hourly variable
   dayrep0= table(repmat(dailyResults.Day(i),length(sel_ind),1),unihours,sel_ind);
   hourlyResults= vertcat(hourlyResults,dayrep0);
   
end
hourlyResults(1,:)=[];
hourlyResults.Properties.VariableNames= {'Day','Hours','SelNo'};

end