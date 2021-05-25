**Marina 1.02.01**

**Compatible with Matlab 2019a and beyond**

You should also include additional information relevant to the work by answering these questions: who worked on this project, when this project was created, what the project does, why the project is useful, how users can get started with the project, where users can get help with your project, and who maintains and contributes to the project.

Marina was built to host the data manipulation tools commonly used by the Passive Acoustic Research Group at the Northeast Fisheries Science Center. By having it all in one app, all tools are organized and easier to use, especially for intro Matlab users.

Currently the app is created and maintained by the Passive Acoustic Research Group. To get started, you can download the app and open it within Matlab. Additional help can be found

Release Notes:
1. Updates made for new NEFSC Github guidelines

*If user does not have Matlab, but would like to view the code, please open .m files in Notepad app or TextEdit. All .mlapp files are also exported as a .m file for this reason*

**Base Marina 1.00.00**

*Features*
- Converting data to NCEI format: Format Data for NCEI boat has user select detector type and GUI will output correctly formatted presence tables for NCEI. Presence tables are stored in folders with sanctuary names. If a folder already exists the code will check for it and place the file there. If the folder doesn't exist then a new folder will be created. 
- Hourly and daily presence sheets: Aggregate Data Daily and Hourly boat compiles detections for dolphin, humpback, and minke into hourly presence tables. Input is either pamguard database or raven selection table. 
- Implement regression analysis results: Aggregate Data Daily and Hourly boat has a tab where user inputs results from regression analysis. The presence tables that were created will then be modified to include numbers that indicate which hours the analyst needs to manually review.  

**Disclaimer**

*This repository is a scientific product and is not official communication of the National Oceanic and
Atmospheric Administration, or the United States Department of Commerce. All NOAA GitHub project code is
provided on an ‘as is’ basis and the user assumes responsibility for its use. Any claims against the Department of
Commerce or Department of Commerce bureaus stemming from the use of this GitHub project will be governed
by all applicable Federal law. Any reference to specific commercial products, processes, or services by service
mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or
favoring by the Department of Commerce. The Department of Commerce seal and logo, or the seal and logo of a
DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by
DOC or the United States Government.*

