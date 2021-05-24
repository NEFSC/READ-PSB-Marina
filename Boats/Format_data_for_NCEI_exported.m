classdef Format_data_for_NCEI_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                   matlab.ui.Figure
        CurrentlyProcessingLabel   matlab.ui.control.Label
        Image                      matlab.ui.control.Image
        FormatDataForNCEILabel     matlab.ui.control.Label
        BrowseButton               matlab.ui.control.Button
        CurrentlySelectedTextArea  matlab.ui.control.TextArea
        DetectorTypeButtonGroup    matlab.ui.container.ButtonGroup
        DolphinButton              matlab.ui.control.RadioButton
        MinkeButton                matlab.ui.control.RadioButton
        CodButton                  matlab.ui.control.RadioButton
        VesselButton               matlab.ui.control.RadioButton
        GrouperButton              matlab.ui.control.RadioButton
        PingerButton               matlab.ui.control.RadioButton
        LFDCSButton                matlab.ui.control.RadioButton
        RunButton                  matlab.ui.control.Button
        StatusReadyLampLabel       matlab.ui.control.Label
        StatusReadyLamp            matlab.ui.control.Lamp
    end

    
    properties (Access = private)
        filename
        pathname
        file_array 
        suprafolder %suprafolder for file saving
    end
    
    methods (Access = private)
        
        function minke_detector(app, ~, ~)
        
            for i = 1:length(app.file_array)
                currentfile = app.file_array{i};
                
                msg = sprintf('Processing %s',currentfile);
                app.CurrentlyProcessingLabel.Text = msg;
                drawnow
                
                %some variable names may be different between users. Coerce all variable
                %names in table to be the same
                dataInput = readtable([app.pathname, currentfile],'Sheet', 'DailyResults');
                dataInput.Properties.VariableNames= {'Date','SelNo','Present'};
                
                %go through the data and remove any blank rows
                %dataInput = rmmissing(dataInput,'DataVariables','Present');                
                
                %coerce all 2/3 to 0s
                unsure= find(dataInput.Present==2);
                dataInput.Present(unsure)= 0;
                    %if any number besides 0-1, sprintf them for the user to go back and
                    %fix. Don't continue the conversion
                    notAccepted= find(dataInput.Present>2);
                    if ~isempty(notAccepted)
                       disp('You have entered presence values that are not accepted (0-2).')
                       errMsg2= fprintf('Please go back to the Excel file and check rows %d \n',...
                           notAccepted+1);
                    else
                        Minke_dates = dataInput.Date;
                        Convert_dates = datetime(Minke_dates, 'InputFormat', 'MM/dd/yyyy');
                        Convert_dates = datestr(Convert_dates,'yyyy-mm-dd');
                        ISOStartTime= string(Convert_dates);
                        Presence = dataInput.Present;
                        dataOut= table(ISOStartTime,Presence);
                        dataOut = noBlanks(dataOut);
                        
                        Species = getSpecies(currentfile);
                        [Sanctuary,Site,Deployment] = extractInfoFromFilename2(currentfile);
                        if isempty(Species)
                          fprintf('%s not processed. Check species name is in species databank in getSpecies function\n',currentfile);
                        else
                           new_filename = ['SanctSound_', char(Site),'_',char(Deployment), '_', char(Species), '.csv'];
                           site_deployment = [char(Site),'_',char(Deployment)];
                           exportFiles(app.suprafolder, dataOut, new_filename, Sanctuary, site_deployment);   
                        end   
                    end           
            end
        end
        
        function vessel_detector(app, ~, ~)
             for i = 1:length(app.file_array)
                currentfile = app.file_array{i};
                
                msg = sprintf('Processing %s',currentfile);
                app.CurrentlyProcessingLabel.Text = msg;
                drawnow
                
                Vessel_table = readtable([app.pathname, currentfile]);
                Find_Ship = Vessel_table(strcmp(Vessel_table.Labels, 'ship'), :);
                dataOut = removevars(Find_Ship,{'StartTime', 'EndTime'});
                
                [Sanctuary,Site,Deployment] = extractInfoFromFilename2(currentfile);
                Species = getSpecies(currentfile);
                if isempty(Species)
                  fprintf('%s not processed. Check species name is in species databank in getSpecies function\n',currentfile);
                else
                   new_filename = ['SanctSound_', char(Site),'_',char(Deployment), '_', char(Species), '.csv'];
                   site_deployment = [char(Site),'_',char(Deployment)];
                   exportFiles(app.suprafolder, dataOut, new_filename, Sanctuary, site_deployment);   
                end
                        
             end
        end
        
        
        function dataOut= dolphinDetector4NCEI(app, ~, ~)
             for i = 1:length(app.file_array)
                currentfile = app.file_array{i};
                
                msg = sprintf('Processing %s',currentfile);
                app.CurrentlyProcessingLabel.Text = msg;
                drawnow
                
                dataInput = readtable([app.pathname, currentfile],'Sheet', 'HourlyPres');

                %some variable names may be different between users. Coerce all variable
                %names in table to be the same
                dataInput.Properties.VariableNames= {'Day','Hour','nDet','MedLowFreq',...
                    'MedHighFreq','Presence','Band1','Band2','Comments'};
                
                %go through the data and remove any blank rows
                %dataInput = rmmissing(dataInput,'DataVariables','Presence');
                
                %coerce all 2/3 to 0s
                unsure= find(dataInput.Presence==2);
                clicks= find(dataInput.Presence==3);
                dataInput.Presence(unsure)= 0;
                dataInput.Presence(clicks)= 0;
                    %if any number besides 0-3, sprintf them for the user to go back and
                    %fix. Don't continue the conversion
                    notAccepted= find(dataInput.Presence>3);
                    if ~isempty(notAccepted)
                       disp('You have entered presence values that are not accepted (0-3).')
                       errMsg2= fprintf('Please go back to the Excel file and check rows %d \n',...
                           notAccepted);
                    else
                        %if all ok, go ahead and apply the ISO format
                            %combine Day and Hour column
                            nRows= length(dataInput.Hour);
                            temp= cell(nRows,1);
                            for i= 1:nRows
                                %if hours 0-9 need to convert them to 2 digits
                                if dataInput.Hour(i)<10 
                                temp{i}= datestr(datetime([num2str(dataInput.Hour(i)),':00:00'],...
                                    'InputFormat','H:mm:ss'));
                                else
                                    temp{i}= datestr(datetime([num2str(dataInput.Hour(i)),':00:00'],...
                                    'InputFormat','HH:mm:ss'));
                                end
                            end
                           
                            dataInput.Time= temp;
                            dataInput.Day.Format = 'MM/dd/yyyy HH:mm:ss';
                            dataInput.Time= datetime(dataInput.Time, 'Format', 'MM/dd/yyyy HH:mm:ss');
                            findMidnight= isnat(dataInput.Time);
                            dataInput.Time(findMidnight)= datetime('00:00:00','Format', 'MM/dd/yyyy HH:mm:ss');
                            dataInput.Datetime = dataInput.Day + timeofday(dataInput.Time);
                            
                            %need Matlab serial dates to go into ISO conversion function
                            serialDatetime = datenum(dataInput.Datetime);
                            ISOStartTime = dbSerialDateToISO8601(serialDatetime);
                            Presence = dataInput.Presence;
                            dataOut = table(ISOStartTime,Presence);
                            dataOut = noBlanks(dataOut);
                            
                            [Sanctuary,Site,Deployment] = extractInfoFromFilename2(currentfile);
                            Species = getSpecies(currentfile);
                            
                        if isempty(Species)
                           fprintf('%s not processed. Check species name is in species databank in getSpecies function\n',currentfile);
                        else
                           new_filename = ['SanctSound_', char(Site),'_',char(Deployment), '_', char(Species), '.csv'];
                           site_deployment = [char(Site),'_',char(Deployment)];
                           exportFiles(app.suprafolder, dataOut, new_filename, Sanctuary, site_deployment);   
                        end                        
                    end
             end
        end
        
        
        function processCod(app, pathname, file_array)
            for ii = 1:length(file_array)
                currentfile = file_array{ii};
                
                msg = sprintf('Processing %s',currentfile);
                app.CurrentlyProcessingLabel.Text = msg;
                drawnow
                
                [dataOut, needsZeros] = codDetector4NCEI(pathname,currentfile);
                
                
                switch needsZeros
                    case 1
                        fprintf('%s has no cod, please create the NCEI file manually\n',currentfile);
                    
                        %foruser= disp(sprintf('%s has no cod, please create the NCEI file manually',currentfile);
                        %disp(foruser);
                    case 0
                        [Sanctuary,Site,Deployment] = extractInfoFromFilename2(currentfile);
                        Species = getSpecies(currentfile);

                        if isempty(Species)
                          fprintf('%s not processed. Check species name is in species databank in getSpecies function\n',currentfile);
                        else
                           new_filename = ['SanctSound_', char(Site),'_',char(Deployment), '_', char(Species), '.csv'];
                           site_deployment = [char(Site),'_',char(Deployment)];
                           exportFiles(app.suprafolder, dataOut, new_filename, Sanctuary, site_deployment);   
                        end
                        
                    otherwise
                        %neither 1 or 0
                end
            end  
        end
        
        function trncData= removeLFDCSHeader(app, data, currentfile)
            
            detectorType = finddetectorType(app, currentfile);
            switch detectorType
                case {'sei', 'blue'}
                    %sei and blue are the same (start at row 18)
                    trncData= data(17:end,:);
                case 'fin'
                    %fin is at 16
                    trncData= data(15:end,:);
                case 'RW'
                    %narw is at 20
                    trncData= data(19:end,:);
                case 'humpback'
                    %hump is at 24
                    trncData= data(23:end,:);
                otherwise
                    disp('Invalid detector type selected');
            end
            
            %get the column headers from the table
            colnames= table2cell(trncData(1,:));
            
            %check to see if the column names are in Matlab format
            Mformat= cellfun(@isvarname,colnames);
            
                %if not, change them to be
                %probably because there's spaces- remove them
                   newNames= strrep(colnames(Mformat==0),' ','_');
                   colnames(Mformat==0)= newNames;
                %remove ?
                findquest= contains(colnames,'?');
                colnames(findquest)= strrep(colnames(findquest),'?','');
                %remove /
                findslash= contains(colnames,'/');
                colnames(findslash)= strrep(colnames(findslash),'/','_');
                
            %once done, remove the column names from the table and we're done
            trncData(1,:)= [];
            ncols= length(colnames);
            if ncols==20
                trncData(:,20)= [];
                colnames(20)= [];
            end
            trncData.Properties.VariableNames= colnames;
        end
        
        function dataOut= LFDCS4NCEI(app, ~, ~)
            for i = 1:length(app.file_array)
                currentfile = app.file_array{i};
                
                msg = sprintf('Processing %s',currentfile);
                app.CurrentlyProcessingLabel.Text = msg;
                drawnow
                
                data = readtable([app.pathname, currentfile], "ReadVariableNames",true);
                trncData = removeLFDCSHeader(app, data, currentfile);
                
                nrows= length(trncData.Manual_Review);
                
                %Use columns start date and Manual_Review
                [Sanctuary,Site,Deployment] = extractInfoFromFilename2(currentfile);
                Species = getSpecies(currentfile);
                %Coerce all 2s to 0s
                trncData.Manual_Review= str2double(trncData.Manual_Review);
                maybes= find(trncData.Manual_Review== 2);
                trncData.Manual_Review(maybes)= 0;
                if strcmp(Species,'fin')
                    %Has an if statement for finwhale to do the extra step Find the days
                    %without presence (blanks) and autofill as 0
                    startdate= trncData.start_date(1);
                    enddate= trncData.end_date(end);
                    trncData(isnan(trncData.Manual_Review),:)= [];
                    trncData(:,2:6)= [];
                    trncData(:,3:5)= [];
                    trncData= trncData(:,1:2);
                    if isempty(trncData)
                        startnum= datenum(startdate);
                        endnum= datenum(enddate);
                        daterange= startnum:1:endnum;
                        trncData= [];
                        start_date= cellstr(datestr(daterange,'mm/dd/yy'));
                        trncData= table(start_date);
                        Presence= zeros(length(daterange),1);
                    else
                        trncData= insertAbsencesFin(trncData,startdate,enddate);
                        Presence= trncData.Manual_Review;
                    end
                else %not fin
                    Presence= trncData.Manual_Review;
                end
                
                %Convert start date to ISO
                %yyyy-mm-dd 
                ISOStartTime= datetime(trncData.start_date,'InputFormat','M/d/yy','Format',...
                    'yyyy-MM-dd');
                
                dataOut= table(ISOStartTime,Presence);
                dataOut = noBlanks(dataOut);
                %dataOut.Properties.VariableNames{1}= 'ISO Date'; %can't have a space in
                %the column name...now what?
                %the input filename for species is not what NCEI wants-
                %needs to be fully written out
                switch Species
                    case 'RW'
                        Species= 'northatlanticrightwhale';
                    case 'fin'
                        Species= 'finwhale';
                    case 'sei'
                        Species= 'seiwhale';
                    case 'blue'
                        Species= 'bluewhale';
                    otherwise %humpback
                        Species= 'humpbackwhale';
                end
                new_filename = ['SanctSound_', char(Site),'_',char(Deployment), '_', char(Species),'_1d', '.csv'];
                site_deployment = [char(Site),'_',char(Deployment)];
                exportFiles(app.suprafolder, dataOut, new_filename, Sanctuary, site_deployment);
            end 
        end
        
        function detectorType = finddetectorType(app, currentfile)
            Species = getSpecies(currentfile);
           
            switch Species
                case 'sei'
                    detectorType = 'sei';
            
                case 'RW'
                    detectorType = 'RW';
            
                case 'fin'
                    detectorType = 'fin';
            
                case 'blue'
                    detectorType = 'blue';
                        
                case'humpback'
                    detectorType = 'humpback';
                otherwise
                    %do nothing
            end
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: BrowseButton
        function BrowseButtonPushed(app, event)
            app.StatusReadyLamp.Color = 'red';
            app.StatusReadyLampLabel.Text = 'Status: Busy';
            drawnow

            if app.DolphinButton.Value == true
               [app.filename, app.pathname] = uigetfile('*.xlsx', 'MultiSelect',"on");
               
                if isequal(app.filename, 0)
                   app.CurrentlySelectedTextArea.Value = 'Please select files...';
                else
                   app.file_array = cellstr(app.filename); 
                   app.CurrentlySelectedTextArea.Value = app.file_array;
                end
            end
            if app.MinkeButton.Value == true
               [app.filename, app.pathname] = uigetfile('*.xlsx', 'MultiSelect',"on");
                if isequal(app.filename, 0)
                   app.CurrentlySelectedTextArea.Value = 'Please select files...';
                else
                   app.file_array = cellstr(app.filename); 
                   app.CurrentlySelectedTextArea.Value = app.file_array;
                end
            end
            if app.CodButton.Value == true
               [app.filename, app.pathname] = uigetfile('*.txt', 'MultiSelect',"on");
                if isequal(app.filename, 0)
                   app.CurrentlySelectedTextArea.Value = 'Please select files...';
                else
                   app.file_array = cellstr(app.filename); 
                   app.CurrentlySelectedTextArea.Value = app.file_array;
                end
            end
            if app.VesselButton.Value == true
               [app.filename, app.pathname] = uigetfile('*.csv', 'MultiSelect',"on");
                if isequal(app.filename, 0)
                   app.CurrentlySelectedTextArea.Value = 'Please select files...';
                else
                   app.file_array = cellstr(app.filename); 
                   app.CurrentlySelectedTextArea.Value = app.file_array;
                end
            end
            if app.GrouperButton.Value == true
               [app.filename, app.pathname] = uigetfile('*.xlsx', 'MultiSelect',"on");
                if isequal(app.filename, 0)
                   app.CurrentlySelectedTextArea.Value = 'Please select files...';
                else
                   app.file_array = cellstr(app.filename); 
                   app.CurrentlySelectedTextArea.Value = app.file_array;
                end
            end
            if app.PingerButton.Value == true
               [app.filename, app.pathname] = uigetfile('*.xlsx', 'MultiSelect',"on");
                if isequal(app.filename, 0)
                   app.CurrentlySelectedTextArea.Value = 'Please select files...';
                else
                   app.file_array = cellstr(app.filename); 
                   app.CurrentlySelectedTextArea.Value = app.file_array;
                end
            end
            if app.LFDCSButton.Value == true
               [app.filename, app.pathname] = uigetfile('*.csv', 'MultiSelect',"on");
                if isequal(app.filename, 0)
                   app.CurrentlySelectedTextArea.Value = 'Please select files...';
                else
                   app.file_array = cellstr(app.filename); 
                   app.CurrentlySelectedTextArea.Value = app.file_array;
                end
            end
            figure(app.UIFigure)
            app.StatusReadyLamp.Color = 'green';
            app.StatusReadyLampLabel.Text = 'Status: Ready';
            drawnow
        end

        % Button pushed function: RunButton
        function RunButtonPushed(app, event)
            app.StatusReadyLamp.Color = 'red';
            app.StatusReadyLampLabel.Text = 'Status: Busy';
            drawnow
            
            app.suprafolder = uigetdir('This PC','Select Save Location' );
            figure(app.UIFigure)
            
            app.CurrentlyProcessingLabel.Visible = 'On';
            if app.MinkeButton.Value == true
                minke_detector(app, app.pathname, app.file_array);
            end
            
            if app.VesselButton.Value == true
               vessel_detector(app, app.pathname, app.file_array);
            end
            
            if app.DolphinButton.Value == true
               dolphinDetector4NCEI(app, app.pathname, app.file_array);
            end
            
            if app.CodButton.Value == true
               processCod(app, app.pathname, app.file_array);
            end
            
            if app.GrouperButton.Value == true 
            end
            
            if app.PingerButton.Value == true
            end
            
            if app.LFDCSButton.Value == true
               LFDCS4NCEI(app, app.pathname, app.file_array); 
            end
            
            
            msg = 'Processing finished';
            app.CurrentlyProcessingLabel.Text = msg;
            app.StatusReadyLamp.Color = 'green';
            app.StatusReadyLampLabel.Text = 'Status: Ready';
            drawnow
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0 0 0];
            app.UIFigure.Position = [100 100 523 367];
            app.UIFigure.Name = 'UI Figure';

            % Create CurrentlyProcessingLabel
            app.CurrentlyProcessingLabel = uilabel(app.UIFigure);
            app.CurrentlyProcessingLabel.FontColor = [0.9412 0.9412 0.9412];
            app.CurrentlyProcessingLabel.Visible = 'off';
            app.CurrentlyProcessingLabel.Position = [17 12 286 22];
            app.CurrentlyProcessingLabel.Text = 'Currently Processing:';

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.ScaleMethod = 'fill';
            app.Image.Position = [1 255 519 113];
            app.Image.ImageSource = 'Marina10200png.png';

            % Create FormatDataForNCEILabel
            app.FormatDataForNCEILabel = uilabel(app.UIFigure);
            app.FormatDataForNCEILabel.FontName = 'Arial Black';
            app.FormatDataForNCEILabel.FontSize = 40;
            app.FormatDataForNCEILabel.FontWeight = 'bold';
            app.FormatDataForNCEILabel.FontColor = [0.9412 0.9412 0.9412];
            app.FormatDataForNCEILabel.Position = [17 268 490 100];
            app.FormatDataForNCEILabel.Text = 'Format Data For NCEI';

            % Create BrowseButton
            app.BrowseButton = uibutton(app.UIFigure, 'push');
            app.BrowseButton.ButtonPushedFcn = createCallbackFcn(app, @BrowseButtonPushed, true);
            app.BrowseButton.BackgroundColor = [1 1 1];
            app.BrowseButton.FontColor = [0.149 0.149 0.149];
            app.BrowseButton.Position = [17 255 104 24];
            app.BrowseButton.Text = 'Browse...';

            % Create CurrentlySelectedTextArea
            app.CurrentlySelectedTextArea = uitextarea(app.UIFigure);
            app.CurrentlySelectedTextArea.Editable = 'off';
            app.CurrentlySelectedTextArea.FontColor = [0.9412 0.9412 0.9412];
            app.CurrentlySelectedTextArea.BackgroundColor = [0 0 0];
            app.CurrentlySelectedTextArea.Position = [129 68 378 176];
            app.CurrentlySelectedTextArea.Value = {'Please select files...'};

            % Create DetectorTypeButtonGroup
            app.DetectorTypeButtonGroup = uibuttongroup(app.UIFigure);
            app.DetectorTypeButtonGroup.ForegroundColor = [1 1 1];
            app.DetectorTypeButtonGroup.Title = 'Detector Type';
            app.DetectorTypeButtonGroup.BackgroundColor = [0 0 0];
            app.DetectorTypeButtonGroup.FontSize = 14;
            app.DetectorTypeButtonGroup.Position = [17 68 104 178];

            % Create DolphinButton
            app.DolphinButton = uiradiobutton(app.DetectorTypeButtonGroup);
            app.DolphinButton.Text = 'Dolphin';
            app.DolphinButton.FontColor = [1 1 1];
            app.DolphinButton.Position = [11 130 63 22];
            app.DolphinButton.Value = true;

            % Create MinkeButton
            app.MinkeButton = uiradiobutton(app.DetectorTypeButtonGroup);
            app.MinkeButton.Text = 'Minke';
            app.MinkeButton.FontColor = [1 1 1];
            app.MinkeButton.Position = [11 108 65 22];

            % Create CodButton
            app.CodButton = uiradiobutton(app.DetectorTypeButtonGroup);
            app.CodButton.Text = 'Cod';
            app.CodButton.FontColor = [1 1 1];
            app.CodButton.Position = [11 86 65 22];

            % Create VesselButton
            app.VesselButton = uiradiobutton(app.DetectorTypeButtonGroup);
            app.VesselButton.Text = 'Vessel';
            app.VesselButton.FontColor = [1 1 1];
            app.VesselButton.Position = [11 65 65 22];

            % Create GrouperButton
            app.GrouperButton = uiradiobutton(app.DetectorTypeButtonGroup);
            app.GrouperButton.Text = 'Grouper';
            app.GrouperButton.FontColor = [1 1 1];
            app.GrouperButton.Position = [11 44 66 22];

            % Create PingerButton
            app.PingerButton = uiradiobutton(app.DetectorTypeButtonGroup);
            app.PingerButton.Text = 'Pinger';
            app.PingerButton.FontColor = [1 1 1];
            app.PingerButton.Position = [11 23 57 22];

            % Create LFDCSButton
            app.LFDCSButton = uiradiobutton(app.DetectorTypeButtonGroup);
            app.LFDCSButton.Text = 'LFDCS';
            app.LFDCSButton.FontColor = [1 1 1];
            app.LFDCSButton.Position = [11 2 61 22];

            % Create RunButton
            app.RunButton = uibutton(app.UIFigure, 'push');
            app.RunButton.ButtonPushedFcn = createCallbackFcn(app, @RunButtonPushed, true);
            app.RunButton.BackgroundColor = [0.851 0.149 0.149];
            app.RunButton.FontSize = 13;
            app.RunButton.FontColor = [0.9412 0.9412 0.9412];
            app.RunButton.Position = [17 32 104 24];
            app.RunButton.Text = 'Run';

            % Create StatusReadyLampLabel
            app.StatusReadyLampLabel = uilabel(app.UIFigure);
            app.StatusReadyLampLabel.HorizontalAlignment = 'right';
            app.StatusReadyLampLabel.FontColor = [1 1 1];
            app.StatusReadyLampLabel.Position = [367 12 111 22];
            app.StatusReadyLampLabel.Text = 'Status: Ready';

            % Create StatusReadyLamp
            app.StatusReadyLamp = uilamp(app.UIFigure);
            app.StatusReadyLamp.Position = [487 14 20 20];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Format_data_for_NCEI_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

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