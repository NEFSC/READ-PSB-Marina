**Marina 1.02.00** In progress...

**Compatible with Matlab 2019a and beyond**

Release Notes:
1. New Marina boat added! Marina users can now create spectrograms from wav files using the "Generate Spectrogram" boat under the "Visualization" dock 
2. Major update to Aggregate Data Daily and Hourly boat interface
3. Bug fix for inserting absences according to deployment boundaries (dolphins and humpback files only for now)
4. Deployment boundaries for aggregating data now input on main window of Aggregate Data boat. 
5. Check boxes in Aggregate Data boat only for humpback files, dolphin and minke are fixed to hourly (for dolphin) and daily (for minke) only. 
6. New mini-boat for creating regression tables. Try checking the check box in Aggregate Data boat to see it!


**Base Marina 1.00.00**

*Features*
- Converting data to NCEI format: Format Data for NCEI boat has user select detector type and GUI will output correctly formatted presence tables for NCEI. Presence tables are stored in folders with sanctuary names. If a folder already exists the code will check for it and place the file there. If the folder doesn't exist then a new folder will be created. 
- Hourly and daily presence sheets: Aggregate Data Daily and Hourly boat compiles detections for dolphin, humpback, and minke into hourly presence tables. Input is either pamguard database or raven selection table. 
- Implement regression analysis results: Aggregate Data Daily and Hourly boat has a tab where user inputs results from regression analysis. The presence tables that were created will then be modified to include numbers that indicate which hours the analyst needs to manually review.  



