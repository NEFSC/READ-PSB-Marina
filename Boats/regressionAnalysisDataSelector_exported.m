classdef regressionAnalysisDataSelector_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure               matlab.ui.Figure
        EnterButton            matlab.ui.control.Button
        Image_2                matlab.ui.control.Image
        RegressionAnalysisDataSelectorLabel  matlab.ui.control.Label
        SelectDayNumbersPanel  matlab.ui.container.Panel
        DaysBox                matlab.ui.control.ListBox
        SelectHoursPanel       matlab.ui.container.Panel
        HoursBox               matlab.ui.control.ListBox
        SelectDataPanel        matlab.ui.container.Panel
        FileListBox            matlab.ui.control.ListBox
        SelectallCheckBox      matlab.ui.control.CheckBox
    end

    
    properties (Access = private)
        aggregateDataBoat % main app
        sanctArrayMaster %array of filenames rearranged and organized by sanctuary
    end
    
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, aggregate_data_Boat, file_array)
        %Store main app object
        app.aggregateDataBoat = aggregate_data_Boat;
        app.FileListBox.Items = cellstr(file_array);
        end

        % Value changed function: FileListBox
        function FileListBoxValueChanged(app, event)
               app.HoursBox.Enable = 'on';
               app.DaysBox.Enable = 'on';
        end

        % Button pushed function: EnterButton
        function EnterButtonPushed(app, event)
            hinterest= app.HoursBox.Value; 
            dinterest= app.DaysBox.Value;
            files = app.FileListBox.Value;
            
            getDatafromApp(app.aggregateDataBoat,dinterest,hinterest,files);
            
            %close app
            delete(app)            
        end

        % Value changed function: SelectallCheckBox
        function SelectallCheckBoxValueChanged(app, event)
            value = app.SelectallCheckBox.Value;
            app.HoursBox.Enable = 'on';
            app.DaysBox.Enable = 'on';            
            if value == 1
                app.FileListBox.Value = app.FileListBox.Items;
            else
                app.FileListBox.Value = {};
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0 0 0];
            app.UIFigure.Position = [100 100 563 537];
            app.UIFigure.Name = 'UI Figure';

            % Create EnterButton
            app.EnterButton = uibutton(app.UIFigure, 'push');
            app.EnterButton.ButtonPushedFcn = createCallbackFcn(app, @EnterButtonPushed, true);
            app.EnterButton.BackgroundColor = [0.902 0.902 0.902];
            app.EnterButton.FontColor = [0.149 0.149 0.149];
            app.EnterButton.Position = [436 18 106 24];
            app.EnterButton.Text = 'Enter';

            % Create Image_2
            app.Image_2 = uiimage(app.UIFigure);
            app.Image_2.ScaleMethod = 'fill';
            app.Image_2.Position = [2 452 563 86];
            app.Image_2.ImageSource = 'Marina10200png.png';

            % Create RegressionAnalysisDataSelectorLabel
            app.RegressionAnalysisDataSelectorLabel = uilabel(app.UIFigure);
            app.RegressionAnalysisDataSelectorLabel.FontName = 'Arial Black';
            app.RegressionAnalysisDataSelectorLabel.FontSize = 28;
            app.RegressionAnalysisDataSelectorLabel.FontColor = [0.9412 0.9412 0.9412];
            app.RegressionAnalysisDataSelectorLabel.Position = [15 452 537 86];
            app.RegressionAnalysisDataSelectorLabel.Text = 'Regression Analysis Data Selector';

            % Create SelectDayNumbersPanel
            app.SelectDayNumbersPanel = uipanel(app.UIFigure);
            app.SelectDayNumbersPanel.ForegroundColor = [0.9412 0.9412 0.9412];
            app.SelectDayNumbersPanel.Title = 'Select Day Numbers';
            app.SelectDayNumbersPanel.BackgroundColor = [0 0 0];
            app.SelectDayNumbersPanel.Position = [290 53 128 400];

            % Create DaysBox
            app.DaysBox = uilistbox(app.SelectDayNumbersPanel);
            app.DaysBox.Items = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28'};
            app.DaysBox.Multiselect = 'on';
            app.DaysBox.Enable = 'off';
            app.DaysBox.Position = [11 10 106 362];
            app.DaysBox.Value = {'1'};

            % Create SelectHoursPanel
            app.SelectHoursPanel = uipanel(app.UIFigure);
            app.SelectHoursPanel.ForegroundColor = [0.9412 0.9412 0.9412];
            app.SelectHoursPanel.Title = 'Select Hours';
            app.SelectHoursPanel.BackgroundColor = [0 0 0];
            app.SelectHoursPanel.Position = [425 53 128 400];

            % Create HoursBox
            app.HoursBox = uilistbox(app.SelectHoursPanel);
            app.HoursBox.Items = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23'};
            app.HoursBox.Multiselect = 'on';
            app.HoursBox.Enable = 'off';
            app.HoursBox.Position = [11 10 106 362];
            app.HoursBox.Value = {'0'};

            % Create SelectDataPanel
            app.SelectDataPanel = uipanel(app.UIFigure);
            app.SelectDataPanel.ForegroundColor = [0.9412 0.9412 0.9412];
            app.SelectDataPanel.Title = 'Select Data';
            app.SelectDataPanel.BackgroundColor = [0 0 0];
            app.SelectDataPanel.Position = [16 53 266 400];

            % Create FileListBox
            app.FileListBox = uilistbox(app.SelectDataPanel);
            app.FileListBox.Items = {};
            app.FileListBox.Multiselect = 'on';
            app.FileListBox.ValueChangedFcn = createCallbackFcn(app, @FileListBoxValueChanged, true);
            app.FileListBox.FontColor = [0.149 0.149 0.149];
            app.FileListBox.Position = [10 10 247 337];
            app.FileListBox.Value = {};

            % Create SelectallCheckBox
            app.SelectallCheckBox = uicheckbox(app.SelectDataPanel);
            app.SelectallCheckBox.ValueChangedFcn = createCallbackFcn(app, @SelectallCheckBoxValueChanged, true);
            app.SelectallCheckBox.Text = 'Select all';
            app.SelectallCheckBox.FontColor = [0.9412 0.9412 0.9412];
            app.SelectallCheckBox.Position = [10 350 71 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = regressionAnalysisDataSelector_exported(varargin)

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @(app)startupFcn(app, varargin{:}))

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