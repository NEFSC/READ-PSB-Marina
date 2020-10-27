function postRegression(pathname_review,currentfile_review, lowest_num, highest_num)
%reads excel file and takes two numbers. Then assigns and writes 1's, 0's, and 4's to 
%the presence column in the excel file. Also adds some column headers in the
%excel file
% 
%Allison Stokoe 10/27/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%read ndet column
read_col = xlsread([pathname_review, currentfile_review],'HourlyPres','C:C');

%find numbers within ndet
find_lowest = find(read_col < lowest_num);
find_highest = find(read_col >= highest_num);
find_between = find(read_col >= lowest_num & read_col < highest_num);

%replace values in 'Presence' column with 1's, 0's, and a third number for manual review 
presence_column = xlsread([pathname_review, currentfile_review], 'HourlyPres', 'F:F'); %go to 'presence' column
presence_column(find_lowest) = 0; %assign zeros for no dolphins (values less than lowest_num)
presence_column(find_highest) = 1; %assign ones for positive detections (values higher than or equal to highest_num)
presence_column(find_between) = 4; %assign 4 to be manually reviewed (values greater than or equal to lowest_num and less than highest_num)
%transpose so the cells go into column vertically 
presence_column_transposed = transpose(presence_column);
%write to excel
xlswrite([pathname_review, currentfile_review],presence_column_transposed,'HourlyPres','F2');

%add labels to columns
col_header = {'Presence','Band1','Band2','Comments'};
xlswrite([pathname_review, currentfile_review],col_header,'HourlyPres','F1');
end

