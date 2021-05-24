classdef Aggregate_Data_Daily_and_Hourly_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        RunButton                       matlab.ui.control.Button
        PressruntoprocessfilesLabel     matlab.ui.control.Label
        StatusReadyLampLabel            matlab.ui.control.Label
        StatusReadyLamp                 matlab.ui.control.Lamp
        Image                           matlab.ui.control.Image
        UITable                         matlab.ui.control.Table
        AggregateDataDailyandHourlyLabel  matlab.ui.control.Label
        LoadDataButton                  matlab.ui.control.Button
        AggregateDataOptionsButtonGroup  matlab.ui.container.ButtonGroup
        SummarizeHumpbackDataPanel      matlab.ui.container.Panel
        HourlyCheckBox                  matlab.ui.control.CheckBox
        DailyCheckBox                   matlab.ui.control.CheckBox
        RegressionAnalysisOptionsPanel  matlab.ui.container.Panel
        PostRegressionAnalysisPanel     matlab.ui.container.Panel
        HigherValueEditFieldLabel       matlab.ui.control.Label
        HigherValueEditField            matlab.ui.control.NumericEditField
        LowerValueEditFieldLabel        matlab.ui.control.Label
        LowerValueEditField             matlab.ui.control.NumericEditField
        LoadTablesButton                matlab.ui.control.Button
        PreRegressionAnalysisPanel      matlab.ui.container.Panel
        CreateregressiontablesCheckBox  matlab.ui.control.CheckBox
        TextArea                        matlab.ui.control.TextArea
    end

    
    properties (Access = private)
        datafiles % source data (can be one or multiple files)
        pathname % pathname
        pathname_review % path for review_table function
        filename_review %filename for review_table function
        rowTitles % 
        regressionAnalysisApp %
        humpbackArray % 
        minkeArray %
        dolphinArray %
        MnandOdontocetesArray %
        presenceFiles % xlsx files loaded into load data button will be presence tables
        database_array % Description
    end
    
    properties (Access = public)
        dinterest
        hinterest
        files
    end

    
    methods (Access = private)
        
        function processMinkeFiles(app, filename, pathname,depBoundsT)
            for ii = 1:length(filename)
                currentfile = filename{ii};
                msg= sprintf('Processing %s',currentfile);
                app.PressruntoprocessfilesLabel.Text = msg;
                drawnow;   
                
                dispMsg('Summarizing presence for:', currentfile);
                [newfilename, dailyResults] = writeDailyHourly2File (currentfile, pathname);
                
                dispMsg('Inserting absences for:', currentfile);
                [startValue,endValue] = getDepBounds(depBoundsT,currentfile);
                dailyResults = insertAbsences2(dailyResults,startValue,endValue,'daily');

                msg= sprintf('Creating presence table for %s',currentfile);
                app.PressruntoprocessfilesLabel.Text = msg;
                drawnow;                            
                
                dispMsg('Writing daily presence for:', currentfile);
                writetable(dailyResults,newfilename,'Sheet','DailyResults');
            end
        end

        function ProcessFilesDolphin(app, pathname, filenames, species,depBoundsT)
            for  ii = 1:length(filenames)
                 currentfile = filenames{ii};
                 
                 msg= sprintf('Processing %s',currentfile);
                 app.PressruntoprocessfilesLabel.Text = msg;
                 drawnow;
                 
                 %read database
                 wmd = readWMD_SQLiteTable_2inputs(pathname,currentfile,species);
                 
                 %summarize into presence tables
                 dispMsg('Summarizing hourlypres for:', currentfile);
                 [~, hourlyPresT, projectname] = summarizeDolphinDetections4(wmd, currentfile, pathname, species);
                 
                 dispMsg('Inserting absences for:', currentfile);
                 [startValue,endValue] = getDepBounds(depBoundsT,currentfile);
                 hourlyPresT = insertAbsences2(hourlyPresT,startValue,endValue,'hourly');

                 msg= sprintf('Writing hourly presence for %s',currentfile);
                 app.PressruntoprocessfilesLabel.Text = msg;
                 drawnow;
            
                 dispMsg('Writing hourly presence for:', currentfile);
                 newfilename = prestableFilename(pathname,projectname,species); 
                 writetable(hourlyPresT,newfilename,'Sheet','HourlyPres');
                 regressionTable(app,pathname,currentfile,newfilename,species);
            end
        end
        
        function ProcessFilesHumpback(app, pathname, filenames, species,depBoundsT)
            for  ii = 1:length(filenames)
                 currentfile = filenames{ii};
                 
                 msg= sprintf('Processing %s',currentfile);
                 app.PressruntoprocessfilesLabel.Text = msg;
                 drawnow;
                 
                 %read database
                 wmd = readWMD_SQLiteTable_2inputs(pathname,currentfile,species);
                 
                 dispMsg('Summarizing presence for:', currentfile);
                 [dailyPres, hourlyPresT, projectname] = summarizeDolphinDetections4(wmd, currentfile, pathname, species);
                 [startValue,endValue] = getDepBounds(depBoundsT,currentfile);
                 newfilename = prestableFilename(pathname,projectname,species);
                
                 %write tables depending on checkbox values
                 if app.HourlyCheckBox.Value == 1 
                    msg= sprintf('Writing hourly presence for %s',currentfile);
                    app.PressruntoprocessfilesLabel.Text = msg;
                    drawnow;                    
                    
                    dispMsg('Inserting absences for:', currentfile);
                    hourlyPresT = insertAbsences2(hourlyPresT,startValue,endValue,'hourly');
                    
                    dispMsg('Writing hourly presence for:', currentfile);
                    writetable(hourlyPresT,newfilename,'Sheet','HourlyPres');
                    
                    regressionTable(app,pathname,currentfile,newfilename,species);
                 end
                 %it wasn't working with if elseis for some reason so I put
                 %it in two separate if statements
                 if app.DailyCheckBox.Value == 1
                    msg= sprintf('Writing daily presence for %s',currentfile);
                    app.PressruntoprocessfilesLabel.Text = msg;
                    drawnow;                           
                    
                    dispMsg('Inserting absences for:', currentfile);
                    dailyPres = insertAbsences2(dailyPres,startValue,endValue,'daily');

                    dispMsg('Writing daily presence for:', currentfile);
                    writetable(dailyPres,newfilename,'Sheet','DailyPres'); 
                 end
            end
        end
        
        function regressionTable(app,pathname,currentfile,newfilename,species)
            if ~isempty(app.files)
                UIfiles = cellstr(app.files);
                lia = ismember(UIfiles,currentfile);
                currentfile = UIfiles(lia);
                if ~isempty(currentfile)
                    msg= sprintf('Creating regression table for %s',string(currentfile));
                    app.PressruntoprocessfilesLabel.Text = msg;
                    drawnow;                       
                    
                    dispMsg('Writing regression table for:',currentfile);
                    
                    createRegressionTable(pathname,currentfile,newfilename,species,app.dinterest,app.hinterest)
                else
                    %don't create presence table
                end
            else
            end
        end
    end
    
    methods (Access = public)
        function getDatafromApp(app,dinterest,hinterest,files)
            app.dinterest = dinterest;
            app.hinterest = hinterest;
            app.files = files;
            dispMsg('Days chosen for regression:',str2double(app.dinterest));
            dispMsg('Hours Chosen for regression:',str2double(app.hinterest));
            dispMsg('Files chosen for regression:',app.files);
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            app.UITable.ColumnFormat = {'char' 'char'};
        end

        % Button pushed function: RunButton
        function RunButtonPushed(app, event)
            %make the run light red and change text to busy
            app.StatusReadyLamp.Color = 'red';
            app.StatusReadyLampLabel.Text = 'Status: Busy';
            drawnow;
            
            if ~isempty(app.MnandOdontocetesArray) || ~isempty(app.humpbackArray)
                    if app.DailyCheckBox.Value == 0 && app.HourlyCheckBox.Value == 0
                        msgbox('Please check a box for either "hourly" or "daily" before running');
                        %set status lamp to green and say status  
                        app.StatusReadyLamp.Color = 'green';
                        app.StatusReadyLampLabel.Text = 'Status: Ready';
                        drawnow;
                        return
                    else
                        %continue into run function
                    end
            else
                %continue into run function
            end

            if ~isempty(app.datafiles) == 1 && isempty(app.filename_review) == 1
                whichfiles = 'datafiles';
            elseif ~isempty(app.filename_review) == 1 && ~isempty(app.datafiles) == 1
                whichfiles = 'both';
            else
                whichfiles = 'postRegression';
            end
            
            switch whichfiles
                case 'datafiles'
                    depBounds = app.UITable.Data;
                    startValues = depBounds(:,1);
                    endValues = depBounds(:,2);
                    depNames = cellstr(app.datafiles);
                    depBoundsT = table(transpose(depNames),startValues,endValues);
                    uiStart = strcmp(startValues,'M/d/yyyy HH:mm:ss');
                    uiEnd = strcmp(endValues,'M/d/yyyy HH:mm:ss');
                    if any(uiStart(:) > 0) || any(uiEnd(:) > 0)
                       msgbox('Please add deployment start and end times to table before running');
                       %set status lamp to green and say status  
                        app.StatusReadyLamp.Color = 'green';
                        app.StatusReadyLampLabel.Text = 'Status: Ready';
                        drawnow;
                       return %don't continue to run
                    else
                        %nothing, keep going
                    end

                    app.CreateregressiontablesCheckBox.Enable = 'off';
                    %call regression app if check box is checked
                    if app.CreateregressiontablesCheckBox.Value == 1
                        dispMsg('Called regression app','');
                        if app.HourlyCheckBox.Value == 0 && app.DailyCheckBox.Value == 0
                            app.database_array = cellstr(app.dolphinArray); 
                        else
                            app.database_array = [cellstr(app.MnandOdontocetesArray),cellstr(app.dolphinArray)];
                        end
                        app.regressionAnalysisApp = regressionAnalysisDataSelector(app, app.database_array);
                    
                        %wait for pop-up window to close when user presses enter
                        waitfor(app.regressionAnalysisApp);
                        dispMsg('Closed regression app','');
                    end
                    %process any databases that were loaded
                    if ~isempty(app.database_array)
                        %display message in command window
                        dispMsg('Started processing files:',app.database_array);
                        %start processing files
                        ProcessFilesDolphin(app, app.pathname, cellstr(app.dolphinArray), 'dolphins',depBoundsT); 
                        ProcessFilesHumpback(app, app.pathname, cellstr(app.humpbackArray),'humpback',depBoundsT);           
                        ProcessFilesHumpback(app, app.pathname, cellstr(app.MnandOdontocetesArray),'humpback',depBoundsT);                
                        processMinkeFiles(app, cellstr(app.minkeArray), app.pathname, depBoundsT);
                    else
                        %do nothing
                    end
                    %what to do with presence tables that need to have absences
                    %inserted
                    loc_presT = contains(cellstr(app.datafiles),'.xlsx');
                    data = cellstr(app.datafiles);
                    app.presenceFiles = data(loc_presT);
                    if ~isempty(app.presenceFiles)
                        presenceT = cellstr(app.presenceFiles);
                        for ii = 1:length(presenceT)
                            currentfile =  presenceT{ii};
                            
                            msg= sprintf('Inserting absences for %s',currentfile);
                            app.PressruntoprocessfilesLabel.Text = msg;
                            drawnow;
                            
                            species = getSpecies(currentfile);
                            switch species
                                case 'dolphins'
                                    sumType = 'hourly';
                                    dispMsg('Reading table:',currentfile);
                                    presTable = readtable([app.pathname,currentfile],'Sheet','HourlyPres','ReadVariableNames',true);
                                case 'Minke'
                                    sumType = 'daily';
                                    sheetName = 'DailyResults';
                                    dispMsg('Reading table:',currentfile);
                                    presTable = readtable([app.pathname,currentfile],'Sheet',sheetName,'ReadVariableNames',true);
                                case 'humpback'
                                    sumType = 'either';
                                otherwise
                                    
                            end
                            [startValue,endValue] = getDepBounds(depBoundsT,currentfile);
                            switch sumType
                                case 'hourly'
                                    sheetName = 'HourlyPres';
                                    dispMsg('Inserting abesences for:',currentfile);
                                    compPres = insertAbsences2(presTable,startValue,endValue,sumType);
                                    writetable(compPres,[app.pathname,currentfile],'Sheet',sheetName);
                                case 'either'
                                    [~,sheets] = xlsfinfo([app.pathname,currentfile]);
                                    sheetNameDaily = strcmp(string(sheets),{'DailyPres'});
                                    sheetNameHourly = strcmp(string(sheets),{'HourlyPres'});
                                    if any(sheetNameDaily > 0) && any(sheetNameHourly > 0)
                                        sheetName = [{'DailyPres'},{'HourlyPres'}];
                                    elseif any(sheetNameDaily > 0) && any(sheetNameHourly == 0)
                                        sheetName = {'DailyPres'};
                                    elseif any(sheetNameDaily == 0) && any(sheetNameHourly > 0)
                                        sheetName = {'HourlyPres'};
                                    else
                                        %neither
                                    end
                                    
                                    for k = 1:length(sheetName)
                                        if strcmp(sheetName(k),'DailyPres') == 1
                                            sumtype2 = 'daily';
                                        else
                                            sumtype2 = 'hourly';
                                        end
                                        dispMsg('Reading table:',currentfile);
                                        presTable = readtable([app.pathname,currentfile],'Sheet',char(sheetName(k)),'ReadVariableNames',true);
                                        dispMsg('Inserting abesences for:',currentfile);
                                        compPres = insertAbsences2(presTable,startValue,endValue,sumtype2);
                                        writetable(compPres,[app.pathname,currentfile],'Sheet',char(sheetName(k)));
                                    end
                                otherwise
                                    dispMsg('Inserting abesences for:',currentfile);
                                    compPres = insertAbsences2(presTable,startValue,endValue,sumType);
                                    writetable(compPres,[app.pathname,currentfile],'Sheet',sheetName);
                            end
                                
                        end
                    end
                case 'postRegression'
                    dispMsg('Started processing files:',app.filename_review);
                      app.filename_review = cellstr(app.filename_review);
                      for  k = 1:length(app.filename_review)
                            %read array of files
                            currentfile_review = app.filename_review{k};
                             
                            %change label to the current file that's being processed
                            msg= sprintf('Applying regression results to %s',currentfile_review);
                            app.PressruntoprocessfilesLabel.Text = msg;
                            drawnow;
                            
                            dispMsg('Applying regression results to:',currentfile_review);
                            
                            %set the range of numbers to look at
                            lowest_num = app.LowerValueEditField.Value;
                            highest_num = app.HigherValueEditField.Value;
                            
                            %call the postRegression function
                            postRegression(app.pathname_review,currentfile_review, lowest_num, highest_num)  
                       end 
                case 'both'
                    depBounds = app.UITable.Data;
                    startValues = depBounds(:,1);
                    endValues = depBounds(:,2);
                    depNames = cellstr(app.datafiles);
                    depBoundsT = table(transpose(depNames),startValues,endValues);
                    uiStart = strcmp(startValues,'M/d/yyyy HH:mm:ss');
                    uiEnd = strcmp(endValues,'M/d/yyyy HH:mm:ss');
                    if any(uiStart(:) > 0) || any(uiEnd(:) > 0)
                       msgbox('Please add deployment start and end times to table before running');
                       %set status lamp to green and say status  
                        app.StatusReadyLamp.Color = 'green';
                        app.StatusReadyLampLabel.Text = 'Status: Ready';
                        drawnow;
                       return %don't continue to run
                    else
                        %nothing, keep going
                    end
                    %make the run light red and change text to busy
                    app.StatusReadyLamp.Color = 'red';
                    app.StatusReadyLampLabel.Text = 'Status: Busy';
                    drawnow;
                    
                    app.CreateregressiontablesCheckBox.Enable = 'off';
                    
                    if app.CreateregressiontablesCheckBox.Value == 1
                        dispMsg('Called regression app','');
                        if app.HourlyCheckBox.Value == 0 && app.DailyCheckBox.Value == 0
                            app.database_array = cellstr(app.dolphinArray); 
                        else
                            app.database_array = [cellstr(app.MnandOdontocetesArray),cellstr(app.dolphinArray)];
                        end
                        app.regressionAnalysisApp = regressionAnalysisDataSelector(app, app.database_array);
                    
                        %wait for pop-up window to close when user presses enter
                        waitfor(app.regressionAnalysisApp);
                        dispMsg('Closed regression app','');
                    end
                    
            
                    if ~isempty(app.database_array)
                        dispMsg('Started processing files:',app.database_array);
            
                        ProcessFilesDolphin(app, app.pathname, cellstr(app.dolphinArray), 'dolphins',depBoundsT); 
                       
                        ProcessFilesHumpback(app, app.pathname, cellstr(app.humpbackArray),'humpback',depBoundsT);
                                          
                        ProcessFilesHumpback(app, app.pathname, cellstr(app.MnandOdontocetesArray),'humpback',depBoundsT);
                                         
                        processMinkeFiles(app, cellstr(app.minkeArray), app.pathname, depBoundsT);
                    else
                        %do nothing
                    end
                    
                    %what to do with presence tables that need to have absences
                    %inserted
                    loc_presT = contains(cellstr(app.datafiles),'.xlsx');
                    data = cellstr(app.datafiles);
                    app.presenceFiles = data(loc_presT);
                    if ~isempty(app.presenceFiles)
                        presenceT = cellstr(app.presenceFiles);
                        for ii = 1:length(presenceT)
                            currentfile =  presenceT{ii};
                            
                            msg= sprintf('Inserting absences for %s',currentfile);
                            app.PressruntoprocessfilesLabel.Text = msg;
                            drawnow;
                            
                            species = getSpecies(currentfile);
                            switch species
                                case 'dolphins'
                                    sumType = 'hourly';
                                    dispMsg('Reading table:',currentfile);
                                    presTable = readtable([app.pathname,currentfile],'Sheet','HourlyPres','ReadVariableNames',true);
                                    
                                case 'Minke'
                                    sumType = 'daily';
                                    sheetName = 'DailyResults';
                                    dispMsg('Reading table:',currentfile);
                                    presTable = readtable([app.pathname,currentfile],'Sheet',sheetName,'ReadVariableNames',true);
                                case 'humpback'
                                    sumType = 'either';
                                otherwise
                                    
                            end
                            [startValue,endValue] = getDepBounds(depBoundsT,currentfile);
                            switch sumType
                                case 'hourly'
                                    sheetName = 'HourlyPres';
                                    dispMsg('Inserting abesences for:',currentfile);
                                    compPres = insertAbsences2(presTable,startValue,endValue,sumType);
                                    writetable(compPres,[app.pathname,currentfile],'Sheet',sheetName);
                                case 'either'
                                    [~,sheets] = xlsfinfo([app.pathname,currentfile]);
                                    sheetNameDaily = strcmp(string(sheets),{'DailyPres'});
                                    sheetNameHourly = strcmp(string(sheets),{'HourlyPres'});
                                    if any(sheetNameDaily > 0) && any(sheetNameHourly > 0)
                                        sheetName = [{'DailyPres'},{'HourlyPres'}];
                                    elseif any(sheetNameDaily > 0) && any(sheetNameHourly == 0)
                                        sheetName = {'DailyPres'};
                                    elseif any(sheetNameDaily == 0) && any(sheetNameHourly > 0)
                                        sheetName = {'HourlyPres'};
                                    else
                                        %neither
                                    end
                                    
                                    for k = 1:length(sheetName)
                                        if strcmp(sheetName(k),'DailyPres') == 1
                                            sumtype2 = 'daily';
                                        else
                                            sumtype2 = 'hourly';
                                        end
                                        dispMsg('Reading table:',currentfile);
                                        presTable = readtable([app.pathname,currentfile],'Sheet',char(sheetName(k)),'ReadVariableNames',true);
                                        dispMsg('Inserting abesences for:',currentfile);
                                        compPres = insertAbsences2(presTable,startValue,endValue,sumtype2);
                                        writetable(compPres,[app.pathname,currentfile],'Sheet',char(sheetName(k)));
                                    end
                                otherwise
                                    dispMsg('Inserting abesences for:',currentfile);
                                    compPres = insertAbsences2(presTable,startValue,endValue,sumType);
                                    writetable(compPres,[app.pathname,currentfile],'Sheet',sheetName);
                            end
                                
                        end
                    end
                
                    dispMsg('Started processing files:',app.filename_review);
                      app.filename_review = cellstr(app.filename_review);
                      for  k = 1:length(app.filename_review)
                            %read array of files
                            currentfile_review = app.filename_review{k};
                             
                            %change label to the current file that's being processed
                            msg= sprintf('Applying regression results to %s',currentfile_review);
                            app.PressruntoprocessfilesLabel.Text = msg;
                            drawnow;
                            
                            dispMsg('Applying regression results to:',currentfile_review);
                            
                            %set the range of numbers to look at
                            lowest_num = app.LowerValueEditField.Value;
                            highest_num = app.HigherValueEditField.Value;
                            
                            %call the postRegression function
                            postRegression(app.pathname_review,currentfile_review, lowest_num, highest_num)  
                      end
                otherwise
                    disp('error line 213 runButton pushed callback')
                    %the combination of files the user has selected isn't
                    %accounted for in the if statement at line 213
            end
            
            %clear all loaded files
            app.HourlyCheckBox.Value = 0;
            app.HourlyCheckBox.Enable = 'off';
            app.DailyCheckBox.Value = 0;
            app.DailyCheckBox.Enable = 'off';
            app.UITable.RowName = [];
            app.UITable.Data = [];
            app.TextArea.Value = {'No tables loaded to apply regression analysis results'};
            app.datafiles = {};
            app.filename_review = {};
            app.humpbackArray = {};
            app.minkeArray = {};
            app.dolphinArray = {};
            app.MnandOdontocetesArray = {};
            
            %make the run light green and change text to status
            app.StatusReadyLamp.Color = 'green';
            app.StatusReadyLampLabel.Text = 'Status: Ready';
            
            %return label on run button back to default value
            app.PressruntoprocessfilesLabel.Text = 'Press run to process a database';
            drawnow;
            app.CreateregressiontablesCheckBox.Enable = 'on';
            
            %display message in command window that processing has been
            %completed
            dispMsg('Processing completed','');
        end

        % Button pushed function: LoadDataButton
        function LoadDataButtonPushed(app, event)
            %change status lamp to red and say busy
            app.StatusReadyLamp.Color = 'red';
            app.StatusReadyLampLabel.Text = 'Status: Busy';
            drawnow;
            
            [app.datafiles,  app.pathname]= uigetfile({'*.sqlite3;*.txt;*.xlsx'},'Select Data To Process',"MultiSelect","on");
            
            %refocus app as primary window
            figure(app.UIFigure)
            
            %if user selects no files
            if isequal(app.datafiles, 0)
               dispMsg('No data loaded','');
            else
               dispMsg('Loaded data:',app.datafiles);
               
               %sort files
               file_array = cellstr(app.datafiles);
               app.database_array = contains(file_array,{'.sqlite3','.txt'});
               app.database_array = file_array(app.database_array);
               if ~isempty(app.database_array) == 1
                    [app.humpbackArray,app.minkeArray,app.dolphinArray,app.MnandOdontocetesArray,~] = organizeFilesSpecies(app.database_array);
               else
                   %do nothings
               end
                
               %disable humpback summarize options if there are no humpback
               %files loaded
               if isempty(app.MnandOdontocetesArray) == 1
                   app.HourlyCheckBox.Value = 0;
                   app.HourlyCheckBox.Enable = 'off';
                   app.DailyCheckBox.Value = 0;
                   app.DailyCheckBox.Enable = 'off';
               else 
                   app.HourlyCheckBox.Value = 0;
                   app.HourlyCheckBox.Enable = 'on';
                   app.DailyCheckBox.Value = 0;
                   app.DailyCheckBox.Enable = 'on';
               end
                
               %load files into deployment info table
                rowNames = getRowNames(file_array);
                app.rowTitles = rowNames;
                data = app.rowTitles;
                app.UITable.RowName = data;
                
                %fill table with data
                num = size(data,2);
                tableData = {};
                fillcell = char('M/d/yyyy HH:mm:ss');
                for ii = 1:num
                    tableData{ii,1} = fillcell;
                    tableData{ii,2} = fillcell;
                end
                app.UITable.Data = tableData;
            end
            
            %set status lamp to green and say status  
            app.StatusReadyLamp.Color = 'green';
            app.StatusReadyLampLabel.Text = 'Status: Ready';
            drawnow;
        end

        % Button pushed function: LoadTablesButton
        function LoadTablesButtonPushed(app, event)
            %make status lamp red and say busy
            app.StatusReadyLamp.Color = 'red';
            app.StatusReadyLampLabel.Text = 'Status: Busy';
            drawnow;
            
            %open browser to retrieve files
            [app.filename_review, app.pathname_review]= uigetfile('*.xlsx','Select tables','MultiSelect','on');         
            
            %refocus app as primary window
            figure(app.UIFigure)
 
            if isequal(app.filename_review, 0)
               dispMsg('No data selected to apply regression results','');
            else     
               dispMsg('Loaded files to apply regression results:',app.filename_review);
               %set text in text area to the filenames loaded
               app.TextArea.Value = cellstr(app.filename_review);
            end
            
            %change status lamp to green and say status
            app.StatusReadyLamp.Color = 'green';
            app.StatusReadyLampLabel.Text = 'Status: Ready';
            drawnow;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0 0 0];
            app.UIFigure.Position = [100 100 747 558];
            app.UIFigure.Name = 'UI Figure';

            % Create RunButton
            app.RunButton = uibutton(app.UIFigure, 'push');
            app.RunButton.ButtonPushedFcn = createCallbackFcn(app, @RunButtonPushed, true);
            app.RunButton.BackgroundColor = [0.851 0.1529 0.1529];
            app.RunButton.FontSize = 13;
            app.RunButton.FontColor = [0.9412 0.9412 0.9412];
            app.RunButton.Position = [14 14 99 24];
            app.RunButton.Text = 'Run';

            % Create PressruntoprocessfilesLabel
            app.PressruntoprocessfilesLabel = uilabel(app.UIFigure);
            app.PressruntoprocessfilesLabel.FontColor = [0.902 0.902 0.902];
            app.PressruntoprocessfilesLabel.Position = [117 15 486 22];
            app.PressruntoprocessfilesLabel.Text = 'Press run to process files';

            % Create StatusReadyLampLabel
            app.StatusReadyLampLabel = uilabel(app.UIFigure);
            app.StatusReadyLampLabel.HorizontalAlignment = 'right';
            app.StatusReadyLampLabel.FontColor = [0.902 0.902 0.902];
            app.StatusReadyLampLabel.Position = [613 15 81 22];
            app.StatusReadyLampLabel.Text = 'Status: Ready';

            % Create StatusReadyLamp
            app.StatusReadyLamp = uilamp(app.UIFigure);
            app.StatusReadyLamp.Position = [709 15 20 20];

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.ScaleMethod = 'fill';
            app.Image.Position = [3 444 745 115];
            app.Image.ImageSource = 'Marina10200png.png';

            % Create UITable
            app.UITable = uitable(app.UIFigure);
            app.UITable.ColumnName = {'Start Date (M/d/yyyy HH:mm:ss)'; 'End Date (M/d/yyyy HH:mm:ss)'};
            app.UITable.ColumnWidth = {'auto'};
            app.UITable.RowName = {''};
            app.UITable.ColumnEditable = true;
            app.UITable.Tooltip = {'Enter deployment info '};
            app.UITable.Position = [249 193 480 252];

            % Create AggregateDataDailyandHourlyLabel
            app.AggregateDataDailyandHourlyLabel = uilabel(app.UIFigure);
            app.AggregateDataDailyandHourlyLabel.FontName = 'Arial Black';
            app.AggregateDataDailyandHourlyLabel.FontSize = 40;
            app.AggregateDataDailyandHourlyLabel.FontColor = [0.9412 0.9412 0.9412];
            app.AggregateDataDailyandHourlyLabel.Position = [14 480 740 62];
            app.AggregateDataDailyandHourlyLabel.Text = 'Aggregate Data Daily and Hourly';

            % Create LoadDataButton
            app.LoadDataButton = uibutton(app.UIFigure, 'push');
            app.LoadDataButton.ButtonPushedFcn = createCallbackFcn(app, @LoadDataButtonPushed, true);
            app.LoadDataButton.BackgroundColor = [0.9412 0.9412 0.9412];
            app.LoadDataButton.Position = [14 450 100 23];
            app.LoadDataButton.Text = 'Load Data';

            % Create AggregateDataOptionsButtonGroup
            app.AggregateDataOptionsButtonGroup = uibuttongroup(app.UIFigure);
            app.AggregateDataOptionsButtonGroup.ForegroundColor = [0.9412 0.9412 0.9412];
            app.AggregateDataOptionsButtonGroup.Title = 'Aggregate Data Options';
            app.AggregateDataOptionsButtonGroup.BackgroundColor = [0 0 0];
            app.AggregateDataOptionsButtonGroup.FontSize = 13;
            app.AggregateDataOptionsButtonGroup.Position = [14 319 228 126];

            % Create SummarizeHumpbackDataPanel
            app.SummarizeHumpbackDataPanel = uipanel(app.AggregateDataOptionsButtonGroup);
            app.SummarizeHumpbackDataPanel.ForegroundColor = [0.9412 0.9412 0.9412];
            app.SummarizeHumpbackDataPanel.Title = 'Summarize Humpback Data';
            app.SummarizeHumpbackDataPanel.BackgroundColor = [0 0 0];
            app.SummarizeHumpbackDataPanel.FontSize = 13;
            app.SummarizeHumpbackDataPanel.Position = [11 16 206 78];

            % Create HourlyCheckBox
            app.HourlyCheckBox = uicheckbox(app.SummarizeHumpbackDataPanel);
            app.HourlyCheckBox.Enable = 'off';
            app.HourlyCheckBox.Text = 'Hourly';
            app.HourlyCheckBox.FontColor = [0.902 0.902 0.902];
            app.HourlyCheckBox.Position = [8 27 57 22];

            % Create DailyCheckBox
            app.DailyCheckBox = uicheckbox(app.SummarizeHumpbackDataPanel);
            app.DailyCheckBox.Enable = 'off';
            app.DailyCheckBox.Text = 'Daily';
            app.DailyCheckBox.FontColor = [0.902 0.902 0.902];
            app.DailyCheckBox.Position = [8 5 49 22];

            % Create RegressionAnalysisOptionsPanel
            app.RegressionAnalysisOptionsPanel = uipanel(app.UIFigure);
            app.RegressionAnalysisOptionsPanel.ForegroundColor = [0.9412 0.9412 0.9412];
            app.RegressionAnalysisOptionsPanel.Title = 'Regression Analysis Options';
            app.RegressionAnalysisOptionsPanel.BackgroundColor = [0 0 0];
            app.RegressionAnalysisOptionsPanel.FontSize = 13;
            app.RegressionAnalysisOptionsPanel.Position = [14 56 228 253];

            % Create PostRegressionAnalysisPanel
            app.PostRegressionAnalysisPanel = uipanel(app.RegressionAnalysisOptionsPanel);
            app.PostRegressionAnalysisPanel.ForegroundColor = [0.9412 0.9412 0.9412];
            app.PostRegressionAnalysisPanel.Title = 'Post-Regression Analysis';
            app.PostRegressionAnalysisPanel.BackgroundColor = [0 0 0];
            app.PostRegressionAnalysisPanel.FontSize = 13;
            app.PostRegressionAnalysisPanel.Position = [11 14 206 136];

            % Create HigherValueEditFieldLabel
            app.HigherValueEditFieldLabel = uilabel(app.PostRegressionAnalysisPanel);
            app.HigherValueEditFieldLabel.HorizontalAlignment = 'right';
            app.HigherValueEditFieldLabel.FontColor = [0.902 0.902 0.902];
            app.HigherValueEditFieldLabel.Position = [17 9 76 22];
            app.HigherValueEditFieldLabel.Text = 'Higher Value';

            % Create HigherValueEditField
            app.HigherValueEditField = uieditfield(app.PostRegressionAnalysisPanel, 'numeric');
            app.HigherValueEditField.ValueDisplayFormat = '%.0f';
            app.HigherValueEditField.FontSize = 13;
            app.HigherValueEditField.FontColor = [0.149 0.149 0.149];
            app.HigherValueEditField.BackgroundColor = [0.902 0.902 0.902];
            app.HigherValueEditField.Tooltip = {'anything above this value marked as positive detection'};
            app.HigherValueEditField.Position = [104 9 86 22];

            % Create LowerValueEditFieldLabel
            app.LowerValueEditFieldLabel = uilabel(app.PostRegressionAnalysisPanel);
            app.LowerValueEditFieldLabel.HorizontalAlignment = 'right';
            app.LowerValueEditFieldLabel.FontColor = [0.902 0.902 0.902];
            app.LowerValueEditFieldLabel.Position = [23 40 71 22];
            app.LowerValueEditFieldLabel.Text = 'Lower Value';

            % Create LowerValueEditField
            app.LowerValueEditField = uieditfield(app.PostRegressionAnalysisPanel, 'numeric');
            app.LowerValueEditField.ValueDisplayFormat = '%.0f';
            app.LowerValueEditField.FontColor = [0.149 0.149 0.149];
            app.LowerValueEditField.BackgroundColor = [0.902 0.902 0.902];
            app.LowerValueEditField.Tooltip = {'anything below this value marked as negative detection '};
            app.LowerValueEditField.Position = [104 40 86 22];

            % Create LoadTablesButton
            app.LoadTablesButton = uibutton(app.PostRegressionAnalysisPanel, 'push');
            app.LoadTablesButton.ButtonPushedFcn = createCallbackFcn(app, @LoadTablesButtonPushed, true);
            app.LoadTablesButton.BackgroundColor = [0.9412 0.9412 0.9412];
            app.LoadTablesButton.FontColor = [0.149 0.149 0.149];
            app.LoadTablesButton.Position = [8 79 100 23];
            app.LoadTablesButton.Text = 'Load Tables';

            % Create PreRegressionAnalysisPanel
            app.PreRegressionAnalysisPanel = uipanel(app.RegressionAnalysisOptionsPanel);
            app.PreRegressionAnalysisPanel.ForegroundColor = [0.9412 0.9412 0.9412];
            app.PreRegressionAnalysisPanel.Title = 'Pre-Regression Analysis';
            app.PreRegressionAnalysisPanel.BackgroundColor = [0 0 0];
            app.PreRegressionAnalysisPanel.FontSize = 13;
            app.PreRegressionAnalysisPanel.Position = [11 164 206 58];

            % Create CreateregressiontablesCheckBox
            app.CreateregressiontablesCheckBox = uicheckbox(app.PreRegressionAnalysisPanel);
            app.CreateregressiontablesCheckBox.Text = 'Create regression tables';
            app.CreateregressiontablesCheckBox.FontColor = [0.9412 0.9412 0.9412];
            app.CreateregressiontablesCheckBox.Position = [8 7 153 22];

            % Create TextArea
            app.TextArea = uitextarea(app.UIFigure);
            app.TextArea.Editable = 'off';
            app.TextArea.FontColor = [0.9412 0.9412 0.9412];
            app.TextArea.BackgroundColor = [0 0 0];
            app.TextArea.Position = [249 56 480 129];
            app.TextArea.Value = {'No tables loaded to apply regression analysis results'};

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Aggregate_Data_Daily_and_Hourly_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end