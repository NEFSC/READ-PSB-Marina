classdef Create_Frequency_Heatmap_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                     matlab.ui.Figure
        UIAxes                       matlab.ui.control.UIAxes
        Image                        matlab.ui.control.Image
        LoadDataButton               matlab.ui.control.Button
        CreateFrequencyHeatmapLabel  matlab.ui.control.Label
        SelectDataPanel              matlab.ui.container.Panel
        SelectSiteListBoxLabel       matlab.ui.control.Label
        SelectSiteListBox            matlab.ui.control.ListBox
        PlotButton                   matlab.ui.control.Button
        OpenButton                   matlab.ui.control.Button
        StatusLampLabel              matlab.ui.control.Label
        StatusLamp                   matlab.ui.control.Lamp
    end

    
    properties (Access = private)
        filename % array of files loaded into GUI
        pathname % pathname of files loaded into GUI
        file_array % cell string of filenames
        SortedFilesArray
        siteFreqMat %frequency matrix for site
        daterangeAll %date range
        daterangeAllN %
    end
    


    
    methods (Access = private)
            function [siteFreqMat,daterangeAll,daterangeAllN] = freqMatBySite2(app, files)
                siteFreqMat= [];
                daterangeAll= []; 
                daterangeAllN= [];
                    for ii = 1:length(files)
                        currentfile = files{ii};
        
                        %check to see if there is a RawData sheet
                        [~,allsheets] = xlsfinfo([app.pathname,currentfile]);
                        checksheets = contains(allsheets, "RawData");
                        
                        %if RawData sheet doesn't exist, load a database and create
                        %a table from it
                        if checksheets == 0
                            instructions = strjoin({'Select database for',currentfile}); 
                            [database, database_path] = uigetfile('*.sqlite3', instructions);
                            
                            %create rawData table
                            rawData = readWMD_SQLiteTable_dolphin(database_path, database);
                        else
                            %check to see how many RawData sheets exist and create
                            %array from their names
                            sheetIndex = find(checksheets==1);
                            sheetArray = allsheets(sheetIndex);
                            
                            %check if just one exists, if so then readtable
                            %if not then combine rawdata sheets 
                            if size(sheetArray) == 1
                                app.StatusLampLabel.Text = 'reading rawdata';
                                drawnow;
                                rawData = readtable([app.pathname,currentfile], "Sheet", "RawData");
                            else
                                app.StatusLampLabel.Text = 'Combining rawdata';
                                drawnow;
                                rawData = combineRawDataSheets(app.pathname, currentfile, sheetArray);                     
                            end
                        end
                        app.StatusLampLabel.Text = 'Computing freq. matrix';
                        drawnow;
                        [freqMat,daterange,daterangeN] = computeFreqMatrix(app.pathname, currentfile, rawData);
                    end
                    siteFreqMat= [siteFreqMat,freqMat]; %assuming the files will be read in chronological order
                    daterangeAll= [daterangeAll;daterange];
                    daterangeAllN= [daterangeAllN;daterangeN];
            end
        
        
        function ItemsArray = sortbySite(app, listoffiles)

            ItemsArray = {};
            for ii = 1:length(listoffiles)
                currentfile = listoffiles{ii};
                
                Site_name = strsplit(currentfile,'_');
                Site_name = Site_name{2};
                
                compare = contains(Site_name,ItemsArray); 
                if compare == 0
                    ItemsArray = [ItemsArray, Site_name];     
                end
            end
        end
    end
    
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: LoadDataButton
        function LoadDataButtonPushed(app, event)

            [app.filename, app.pathname] = uigetfile('*.xlsx','Select Presence Table', 'MultiSelect',"on");
            app.SelectSiteListBox.Enable = true;
            
            
            app.file_array = cellstr(app.filename);
            
            ItemsArray = sortbySite(app, app.file_array);
            
            app.SelectSiteListBox.Items = ItemsArray;
                
  
        end

        % Button pushed function: PlotButton
        function PlotButton_2Pushed(app, event)
        app.StatusLamp.Color = 'red';
        drawnow;        
        
        app.StatusLampLabel.Text = 'Extracting info from files';
        drawnow;
        compare = contains(app.file_array, app.SelectSiteListBox.Value);
        location = find(compare == 1);
        files = app.file_array(location);
        
           [app.siteFreqMat,app.daterangeAll,app.daterangeAllN] = freqMatBySite2(app, files);            
     
           app.StatusLampLabel.Text = 'graphing';
           drawnow;
           contour(app.UIAxes,1:length(app.daterangeAllN),(1:100:24000)/1000,app.siteFreqMat);
           ii = length(app.daterangeAllN)/6;
           ii = floor(ii);
           n2 = 2*ii;
           n3 = 3*ii;
           n4 = 4*ii;
           n5 = 5*ii;
           n6 = 6*ii;
           
           app.UIAxes.XTick = [ii,n2,n3,n4,n5,n6];
           app.UIAxes.XTickLabel = {datestr(app.daterangeAll(ii),'mm-dd-yy'), datestr(app.daterangeAll(n2),'mm-dd-yy'),datestr(app.daterangeAll(n3),'mm-dd-yy'), datestr(app.daterangeAll(n4),'mm-dd-yy'), datestr(app.daterangeAll(n5),'mm-dd-yy'), datestr(app.daterangeAll(n6),'mm-dd-yy')};

        
        app.StatusLampLabel.Text = 'status';
        app.StatusLamp.Color = 'green';
        drawnow;
        end

        % Button pushed function: OpenButton
        function OpenButtonPushed(app, event)
        fig = figure;    
        contour(1:length(app.daterangeAllN),(1:100:24000)/1000,app.siteFreqMat);
        colormap(jet)
        ii = length(app.daterangeAllN)/6;
        ii = floor(ii);
        n2 = 2*ii;
        n3 = 3*ii;
        n4 = 4*ii;
        n5 = 5*ii;
        n6 = 6*ii;
        
        set(gca,'XTick',[ii,n2,n3,n4,n5,n6],'XTickLabel',{datestr(app.daterangeAll(ii),'mm-dd-yy'), datestr(app.daterangeAll(n2),'mm-dd-yy'),datestr(app.daterangeAll(n3),'mm-dd-yy'), datestr(app.daterangeAll(n4),'mm-dd-yy'), datestr(app.daterangeAll(n5),'mm-dd-yy'), datestr(app.daterangeAll(n6),'mm-dd-yy')})
        han= axes(fig,'visible','off');
        han.Title.Visible='on';
        
        han.YLabel.Visible='on';
        ylabel(han,'Frequency (kHz)');
        

        

        title(han,app.SelectSiteListBox.Value);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0 0 0];
            app.UIFigure.Position = [100 100 789 409];
            app.UIFigure.Name = 'UI Figure';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Preview')
            xlabel(app.UIAxes, 'Date')
            ylabel(app.UIAxes, 'Frequency (kHz)')
            app.UIAxes.Position = [224 47 549 267];

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.ScaleMethod = 'fill';
            app.Image.Position = [16 313 757 97];
            app.Image.ImageSource = 'Marina10200png.png';

            % Create LoadDataButton
            app.LoadDataButton = uibutton(app.UIFigure, 'push');
            app.LoadDataButton.ButtonPushedFcn = createCallbackFcn(app, @LoadDataButtonPushed, true);
            app.LoadDataButton.Position = [16 321 100 22];
            app.LoadDataButton.Text = 'Load Data';

            % Create CreateFrequencyHeatmapLabel
            app.CreateFrequencyHeatmapLabel = uilabel(app.UIFigure);
            app.CreateFrequencyHeatmapLabel.FontName = 'Arial Black';
            app.CreateFrequencyHeatmapLabel.FontSize = 47;
            app.CreateFrequencyHeatmapLabel.FontWeight = 'bold';
            app.CreateFrequencyHeatmapLabel.FontColor = [0.9412 0.9412 0.9412];
            app.CreateFrequencyHeatmapLabel.Position = [15 337 724 73];
            app.CreateFrequencyHeatmapLabel.Text = 'Create Frequency Heatmap';

            % Create SelectDataPanel
            app.SelectDataPanel = uipanel(app.UIFigure);
            app.SelectDataPanel.ForegroundColor = [0.9412 0.9412 0.9412];
            app.SelectDataPanel.Title = 'Select Data';
            app.SelectDataPanel.BackgroundColor = [0 0 0];
            app.SelectDataPanel.Position = [16 47 200 267];

            % Create SelectSiteListBoxLabel
            app.SelectSiteListBoxLabel = uilabel(app.SelectDataPanel);
            app.SelectSiteListBoxLabel.HorizontalAlignment = 'right';
            app.SelectSiteListBoxLabel.FontColor = [0.9412 0.9412 0.9412];
            app.SelectSiteListBoxLabel.Position = [5 217 63 22];
            app.SelectSiteListBoxLabel.Text = 'Select Site';

            % Create SelectSiteListBox
            app.SelectSiteListBox = uilistbox(app.SelectDataPanel);
            app.SelectSiteListBox.Enable = 'off';
            app.SelectSiteListBox.Position = [83 83 100 158];

            % Create PlotButton
            app.PlotButton = uibutton(app.SelectDataPanel, 'push');
            app.PlotButton.ButtonPushedFcn = createCallbackFcn(app, @PlotButton_2Pushed, true);
            app.PlotButton.BackgroundColor = [0.9412 0.9412 0.9412];
            app.PlotButton.Position = [83 34 100 22];
            app.PlotButton.Text = 'Plot';

            % Create OpenButton
            app.OpenButton = uibutton(app.SelectDataPanel, 'push');
            app.OpenButton.ButtonPushedFcn = createCallbackFcn(app, @OpenButtonPushed, true);
            app.OpenButton.BackgroundColor = [0.851 0.149 0.149];
            app.OpenButton.FontColor = [0.9412 0.9412 0.9412];
            app.OpenButton.Position = [83 13 100 22];
            app.OpenButton.Text = 'Open';

            % Create StatusLampLabel
            app.StatusLampLabel = uilabel(app.UIFigure);
            app.StatusLampLabel.HorizontalAlignment = 'right';
            app.StatusLampLabel.FontColor = [0.9412 0.9412 0.9412];
            app.StatusLampLabel.Position = [499 14 247 22];
            app.StatusLampLabel.Text = 'Status';

            % Create StatusLamp
            app.StatusLamp = uilamp(app.UIFigure);
            app.StatusLamp.Position = [753 15 20 20];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Create_Frequency_Heatmap_exported

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