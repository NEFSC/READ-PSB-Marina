**Marina 1.02.00**

**Compatible with Matlab 2019a and beyond**

Release Notes:
1. New Marina boat added! Marina users can now create spectrograms from wav files using the "Generate Spectrogram" boat under the "Visualization" dock 
2. Major update to Aggregate Data Daily and Hourly boat interface and a fresh look for Marina
3. Bug fix for inserting absences according to deployment boundaries
4. Deployment boundaries for aggregating data now input on main window of Aggregate Data boat. 
5. Check boxes in Aggregate Data boat only for humpback files, dolphin and minke are fixed to hourly (for dolphin) and daily (for minke). 
6. New mini boat for creating regression tables. Try checking the check box in Aggregate Data boat to see it!

**Base Marina 1.00.00**

*Features*
- Converting data to NCEI format: Format Data for NCEI boat has user select detector type and GUI will output correctly formatted presence tables for NCEI. Presence tables are stored in folders with sanctuary names. If a folder already exists the code will check for it and place the file there. If the folder doesn't exist then a new folder will be created. 
- Hourly and daily presence sheets: Aggregate Data Daily and Hourly boat compiles detections for dolphin, humpback, and minke into hourly presence tables. Input is either pamguard database or raven selection table. 
- Implement regression analysis results: Aggregate Data Daily and Hourly boat has a tab where user inputs results from regression analysis. The presence tables that were created will then be modified to include numbers that indicate which hours the analyst needs to manually review.  

Disclaimer: This repository is a scientific product and is not official communication of the National Oceanic and
Atmospheric Administration, or the United States Department of Commerce. All NOAA GitHub project code is
provided on an ‘as is’ basis and the user assumes responsibility for its use. Any claims against the Department of
Commerce or Department of Commerce bureaus stemming from the use of this GitHub project will be governed
by all applicable Federal law. Any reference to specific commercial products, processes, or services by service
mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or
favoring by the Department of Commerce. The Department of Commerce seal and logo, or the seal and logo of a
DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by
DOC or the United States Government.

