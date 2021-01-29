**Marina 1.01.01**

**compatible with Matlab 2019 and beyond**

Release Notes:
1. Does not report day/hour combinations with 0 detections in the regression tables 

**Base Marina 1.00.00**

*Features*
- Converting data to NCEI format: Format Data for NCEI boat has user select detector type and GUI will output correctly formatted presence tables for NCEI. Presence tables are stored in folders with sanctuary names. If a folder already exists the code will check for it and place the file there. If the folder doesn't exist then a new folder will be created. 
- Hourly and daily presence sheets: Aggregate Data Daily and Hourly boat compiles detections for dolphin, humpback, and minke into hourly presence tables. Input is either pamguard database or raven selection table. 
- Implement regression analysis results: Aggregate Data Daily and Hourly boat has a tab where user inputs results from regression analysis. The presence tables that were created will then be modified to include numbers that indicate which hours the analyst needs to manually review.  



