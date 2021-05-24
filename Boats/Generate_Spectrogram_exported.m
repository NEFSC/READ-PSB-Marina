classdef Generate_Spectrogram_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        GraphButton                     matlab.ui.control.Button
        StatusReadyLampLabel            matlab.ui.control.Label
        StatusReadyLamp                 matlab.ui.control.Lamp
        SpectrogramSettingsPanel        matlab.ui.container.Panel
        DefaultSettingsCheckBox         matlab.ui.control.CheckBox
        FFTLengthEditFieldLabel         matlab.ui.control.Label
        FFTLengthEditField              matlab.ui.control.NumericEditField
        FreqRangeEditFieldLabel         matlab.ui.control.Label
        FreqRangeEditField              matlab.ui.control.NumericEditField
        EditField                       matlab.ui.control.NumericEditField
        IncrementYaxisbyEditFieldLabel  matlab.ui.control.Label
        IncrementYaxisbyEditField       matlab.ui.control.NumericEditField
        PreviewButton                   matlab.ui.control.Button
        SavePresetButton                matlab.ui.control.Button
        ColormapDropDownLabel           matlab.ui.control.Label
        ColormapDropDown                matlab.ui.control.DropDown
        ShowYaxisinkHzCheckBox          matlab.ui.control.CheckBox
        SavedPresetsPanel               matlab.ui.container.Panel
        ListBox                         matlab.ui.control.ListBox
        Image                           matlab.ui.control.Image
        GetfilesButton                  matlab.ui.control.Button
        FilesSelectedListBox            matlab.ui.control.ListBox
        PlayAudioButton                 matlab.ui.control.Button
        StopAudioButton                 matlab.ui.control.Button
        ChoosefilestoprocessLabel       matlab.ui.control.Label
        ListentoaselectedfileLabel      matlab.ui.control.Label
        GenerateSpectrogramLabel        matlab.ui.control.Label
    end

    
    properties (Access = private)
        ListItems% array of filenames provided by user to feed into loop for graphing
        pathname% pathname of files selected by user
        filename %files provided by user
        preset_items % Description
    end
    
    methods (Access = private)
        
        
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            check4file = exist('MarinaSpectrogramPresets.xlsx','file');
            
            if check4file == 2
                app.preset_items = readtable('MarinaSpectrogramPresets.xlsx','ReadVariableNames',true,'ReadRowNames',true);
                app.ListBox.Items = app.preset_items.Row;
            else
                disp('no saved presets file located')
            end
        end

        % Button pushed function: GetfilesButton
        function GetfilesButtonPushed(app, event)
            [app.filename, app.pathname] = uigetfile('*.wav', 'MultiSelect',"on");  
            drawnow;
            figure(app.UIFigure) %refocus GUI window after uigetfile
            
            app.ListItems = cellstr(app.filename);
            app.FilesSelectedListBox.Items = app.ListItems;
        end

        % Button pushed function: GraphButton
        function GraphButtonPushed(app, event)
            %set status lamp to busy
            app.StatusReadyLamp.Color = 'red';
            app.StatusReadyLampLabel.Text = 'Status: Graphing';
            drawnow;

            savepath = uigetdir(path,'Please Select A Save Location'); %user selects a save folder
            drawnow;
            figure(app.UIFigure) %refocus GUI window after uigetdir
            file_array = cellstr(app.FilesSelectedListBox.Value); %convert into readable format for loop
            runtype = 'graph';
            settings_array = {app.FFTLengthEditField.Value,app.FreqRangeEditField.Value,app.EditField.Value,app.IncrementYaxisbyEditField.Value,app.ShowYaxisinkHzCheckBox.Value,app.ColormapDropDown.Value};
            
            %run files through plotting function 
            for ii = 1:length(file_array)
                currentfile = file_array{ii};
                
                gen_spect(currentfile,app.pathname,settings_array,runtype,savepath)      
            end
            
            %return status lamp to ready
            app.StatusReadyLamp.Color = 'green';
            app.StatusReadyLampLabel.Text = 'Status: Ready';
            drawnow;
        end

        % Button pushed function: PlayAudioButton
        function PlayAudioButtonPushed(app, event)
            currentfile = cellstr(app.FilesSelectedListBox.Value);
            clear sound;
            [y, fs] = audioread([app.pathname,currentfile{1}]);
            sound(y, fs, 16);
        end

        % Button pushed function: StopAudioButton
        function StopAudioButtonPushed(app, event)
            clear sound;
        end

        % Value changed function: DefaultSettingsCheckBox
        function DefaultSettingsCheckBoxValueChanged(app, event)
            value = app.DefaultSettingsCheckBox.Value;
            
            switch value
                case true
                    app.ListBox.Value = {};
                    app.FFTLengthEditField.Value = 8192;
                    app.FreqRangeEditField.Value = 0;
                    app.EditField.Value = 24000;
                    app.IncrementYaxisbyEditField.Value = 6000;
                    app.ShowYaxisinkHzCheckBox.Value = true; 
                    app.ColormapDropDown.Value = 'jet';
                    
                    app.FFTLengthEditField.Enable = false;
                    app.FreqRangeEditField.Enable = false;
                    app.EditField.Enable = false;
                    app.IncrementYaxisbyEditField.Enable = false;
                    app.ShowYaxisinkHzCheckBox.Enable = false; 
                    app.ColormapDropDown.Enable = false;
                    
                case false
                    app.FFTLengthEditField.Enable = true;
                    app.FreqRangeEditField.Enable = true;
                    app.EditField.Enable = true;
                    app.IncrementYaxisbyEditField.Enable = true;
                    app.ShowYaxisinkHzCheckBox.Enable = true; 
                    app.ColormapDropDown.Enable = true;
            end
        end

        % Button pushed function: PreviewButton
        function PreviewButtonPushed(app, event)
       %%set status lamp to busy
        app.StatusReadyLamp.Color = 'red';
        app.StatusReadyLampLabel.Text = 'Status: Graphing';
        drawnow;
        settings_array = {app.FFTLengthEditField.Value,app.FreqRangeEditField.Value,app.EditField.Value,app.IncrementYaxisbyEditField.Value,app.ShowYaxisinkHzCheckBox.Value,app.ColormapDropDown.Value};    
        
       %%Settings array info:
        %settings_array{1} = FFT length
        %settings_array{2} = Freq Lower Limit
        %settings_array{3} = Freq Upper Limit
        %settings_array{4} = YAxis Increment value
        %settings_array{5} = Is YAxis in Hz or kHz?
        %settings_array{6} = colormap name
        
        savepath = ''; %don't need to set a savepath, code will not save if just previewing
        runtype = 'preview';
        
        files = cellstr(app.FilesSelectedListBox.Value);
        gen_spect(files{1},app.pathname,settings_array,runtype,savepath)
        
        %%set status lamp to ready
        app.StatusReadyLamp.Color = 'green';
        app.StatusReadyLampLabel.Text = 'Status: Ready';
        drawnow;
        end

        % Button pushed function: SavePresetButton
        function SavePresetButtonPushed(app, event)
            check4file = exist('MarinaSpectrogramPresets.xlsx','file');
            if check4file == 2
               T = readtable('MarinaSpectrogramPresets.xlsx','ReadVariableNames',true,'ReadRowNames',true);
               preset_name = inputdlg({'Name this preset'}); 
               
               TNew = table(app.FFTLengthEditField.Value,app.FreqRangeEditField.Value,app.EditField.Value,app.IncrementYaxisbyEditField.Value,app.ShowYaxisinkHzCheckBox.Value,string(app.ColormapDropDown.Value),'VariableNames',{'FFT_Length','Freq_LowLim','Freq_HiLim','IncrementBy','kHzTrueFalse','Colormap'},'RowNames',cell(preset_name));
               MarinaSpectrogramPresets = [T;TNew];
               writetable(MarinaSpectrogramPresets,'MarinaSpectrogramPresets.xlsx','WriteVariableNames',true,'WriteRowNames',true);   
            else 
               preset_name = inputdlg({'Name this preset'});
               MarinaSpectrogramPresets = table(app.FFTLengthEditField.Value,app.FreqRangeEditField.Value,app.EditField.Value,app.IncrementYaxisbyEditField.Value,app.ShowYaxisinkHzCheckBox.Value,string(app.ColormapDropDown.Value),'VariableNames',{'FFT_Length','Freq_LowLim','Freq_HiLim','IncrementBy','kHzTrueFalse','Colormap'},'RowNames',cell(preset_name));
               writetable(MarinaSpectrogramPresets,'MarinaSpectrogramPresets.xlsx','WriteVariableNames',true,'WriteRowNames',true)                          
            end    
            
            app.preset_items = readtable('MarinaSpectrogramPresets.xlsx','ReadVariableNames',true,'ReadRowNames',true);
            app.ListBox.Items = app.preset_items.Row;
        end

        % Value changed function: ListBox
        function ListBoxValueChanged(app, event)
            value = app.ListBox.Value;
            thisrow = cellstr(value);
            
            app.FFTLengthEditField.Enable = true;
            app.FreqRangeEditField.Enable = true;
            app.EditField.Enable = true;
            app.IncrementYaxisbyEditField.Enable = true;
            app.ShowYaxisinkHzCheckBox.Enable = true; 
            app.ColormapDropDown.Enable = true;
            
            app.DefaultSettingsCheckBox.Value = false;
            app.FFTLengthEditField.Value = app.preset_items{thisrow,{'FFT_Length'}};
            app.FreqRangeEditField.Value = app.preset_items{thisrow,{'Freq_LowLim'}};
            app.EditField.Value = app.preset_items{thisrow,{'Freq_HiLim'}};
            app.IncrementYaxisbyEditField.Value = app.preset_items{thisrow,{'IncrementBy'}};
            app.ShowYaxisinkHzCheckBox.Value = app.preset_items{thisrow,{'kHzTrueFalse'}};
            app.ColormapDropDown.Value = app.preset_items{thisrow,{'Colormap'}};
            
        end

        % Value changed function: FFTLengthEditField
        function FFTLengthEditFieldValueChanged(app, event)
            app.ListBox.Value = {};
        end

        % Value changed function: FreqRangeEditField
        function FreqRangeEditFieldValueChanged(app, event)
            app.ListBox.Value = {};
        end

        % Value changed function: EditField
        function EditFieldValueChanged(app, event)
            app.ListBox.Value = {};            
        end

        % Value changed function: IncrementYaxisbyEditField
        function IncrementYaxisbyEditFieldValueChanged(app, event)
            app.ListBox.Value = {};
        end

        % Value changed function: ColormapDropDown
        function ColormapDropDownValueChanged(app, event)
            app.ListBox.Value = {};
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0 0 0];
            app.UIFigure.Position = [100 100 575 548];
            app.UIFigure.Name = 'UI Figure';

            % Create GraphButton
            app.GraphButton = uibutton(app.UIFigure, 'push');
            app.GraphButton.ButtonPushedFcn = createCallbackFcn(app, @GraphButtonPushed, true);
            app.GraphButton.BackgroundColor = [0.851 0.149 0.149];
            app.GraphButton.FontColor = [0.9412 0.9412 0.9412];
            app.GraphButton.Position = [21 13 100 22];
            app.GraphButton.Text = 'Graph';

            % Create StatusReadyLampLabel
            app.StatusReadyLampLabel = uilabel(app.UIFigure);
            app.StatusReadyLampLabel.HorizontalAlignment = 'right';
            app.StatusReadyLampLabel.FontColor = [0.9412 0.9412 0.9412];
            app.StatusReadyLampLabel.Position = [426 13 106 22];
            app.StatusReadyLampLabel.Text = 'Status: Ready';

            % Create StatusReadyLamp
            app.StatusReadyLamp = uilamp(app.UIFigure);
            app.StatusReadyLamp.Position = [547 13 20 20];

            % Create SpectrogramSettingsPanel
            app.SpectrogramSettingsPanel = uipanel(app.UIFigure);
            app.SpectrogramSettingsPanel.ForegroundColor = [0.9412 0.9412 0.9412];
            app.SpectrogramSettingsPanel.Title = 'Spectrogram Settings';
            app.SpectrogramSettingsPanel.BackgroundColor = [0 0 0];
            app.SpectrogramSettingsPanel.Position = [190 46 209 324];

            % Create DefaultSettingsCheckBox
            app.DefaultSettingsCheckBox = uicheckbox(app.SpectrogramSettingsPanel);
            app.DefaultSettingsCheckBox.ValueChangedFcn = createCallbackFcn(app, @DefaultSettingsCheckBoxValueChanged, true);
            app.DefaultSettingsCheckBox.Text = 'Default Settings';
            app.DefaultSettingsCheckBox.FontColor = [0.9412 0.9412 0.9412];
            app.DefaultSettingsCheckBox.Position = [8 274 107 22];
            app.DefaultSettingsCheckBox.Value = true;

            % Create FFTLengthEditFieldLabel
            app.FFTLengthEditFieldLabel = uilabel(app.SpectrogramSettingsPanel);
            app.FFTLengthEditFieldLabel.HorizontalAlignment = 'right';
            app.FFTLengthEditFieldLabel.FontColor = [0.9412 0.9412 0.9412];
            app.FFTLengthEditFieldLabel.Position = [48 215 67 22];
            app.FFTLengthEditFieldLabel.Text = 'FFT Length';

            % Create FFTLengthEditField
            app.FFTLengthEditField = uieditfield(app.SpectrogramSettingsPanel, 'numeric');
            app.FFTLengthEditField.ValueDisplayFormat = '%.0f';
            app.FFTLengthEditField.ValueChangedFcn = createCallbackFcn(app, @FFTLengthEditFieldValueChanged, true);
            app.FFTLengthEditField.Enable = 'off';
            app.FFTLengthEditField.Position = [123 215 80 22];
            app.FFTLengthEditField.Value = 8192;

            % Create FreqRangeEditFieldLabel
            app.FreqRangeEditFieldLabel = uilabel(app.SpectrogramSettingsPanel);
            app.FreqRangeEditFieldLabel.HorizontalAlignment = 'right';
            app.FreqRangeEditFieldLabel.FontColor = [0.9412 0.9412 0.9412];
            app.FreqRangeEditFieldLabel.Position = [43 183 72 22];
            app.FreqRangeEditFieldLabel.Text = 'Freq Range:';

            % Create FreqRangeEditField
            app.FreqRangeEditField = uieditfield(app.SpectrogramSettingsPanel, 'numeric');
            app.FreqRangeEditField.ValueDisplayFormat = '%.0f';
            app.FreqRangeEditField.ValueChangedFcn = createCallbackFcn(app, @FreqRangeEditFieldValueChanged, true);
            app.FreqRangeEditField.FontColor = [0.149 0.149 0.149];
            app.FreqRangeEditField.Enable = 'off';
            app.FreqRangeEditField.Tooltip = {'enter lower limit'};
            app.FreqRangeEditField.Position = [122 183 80 22];

            % Create EditField
            app.EditField = uieditfield(app.SpectrogramSettingsPanel, 'numeric');
            app.EditField.ValueDisplayFormat = '%.0f';
            app.EditField.ValueChangedFcn = createCallbackFcn(app, @EditFieldValueChanged, true);
            app.EditField.Enable = 'off';
            app.EditField.Tooltip = {'enter upper limit'};
            app.EditField.Position = [122 152 81 22];
            app.EditField.Value = 24000;

            % Create IncrementYaxisbyEditFieldLabel
            app.IncrementYaxisbyEditFieldLabel = uilabel(app.SpectrogramSettingsPanel);
            app.IncrementYaxisbyEditFieldLabel.HorizontalAlignment = 'right';
            app.IncrementYaxisbyEditFieldLabel.FontColor = [0.9412 0.9412 0.9412];
            app.IncrementYaxisbyEditFieldLabel.Position = [4 123 111 22];
            app.IncrementYaxisbyEditFieldLabel.Text = 'Increment Y-axis by';

            % Create IncrementYaxisbyEditField
            app.IncrementYaxisbyEditField = uieditfield(app.SpectrogramSettingsPanel, 'numeric');
            app.IncrementYaxisbyEditField.ValueDisplayFormat = '%.0f';
            app.IncrementYaxisbyEditField.ValueChangedFcn = createCallbackFcn(app, @IncrementYaxisbyEditFieldValueChanged, true);
            app.IncrementYaxisbyEditField.Enable = 'off';
            app.IncrementYaxisbyEditField.Tooltip = {'enter value in Hz'};
            app.IncrementYaxisbyEditField.Position = [122 123 81 22];
            app.IncrementYaxisbyEditField.Value = 6000;

            % Create PreviewButton
            app.PreviewButton = uibutton(app.SpectrogramSettingsPanel, 'push');
            app.PreviewButton.ButtonPushedFcn = createCallbackFcn(app, @PreviewButtonPushed, true);
            app.PreviewButton.Position = [104 43 100 22];
            app.PreviewButton.Text = 'Preview';

            % Create SavePresetButton
            app.SavePresetButton = uibutton(app.SpectrogramSettingsPanel, 'push');
            app.SavePresetButton.ButtonPushedFcn = createCallbackFcn(app, @SavePresetButtonPushed, true);
            app.SavePresetButton.Tooltip = {'Save values as a preset'};
            app.SavePresetButton.Position = [104 14 100 22];
            app.SavePresetButton.Text = 'Save Preset';

            % Create ColormapDropDownLabel
            app.ColormapDropDownLabel = uilabel(app.SpectrogramSettingsPanel);
            app.ColormapDropDownLabel.HorizontalAlignment = 'right';
            app.ColormapDropDownLabel.FontColor = [0.9412 0.9412 0.9412];
            app.ColormapDropDownLabel.Position = [53 92 58 22];
            app.ColormapDropDownLabel.Text = 'Colormap';

            % Create ColormapDropDown
            app.ColormapDropDown = uidropdown(app.SpectrogramSettingsPanel);
            app.ColormapDropDown.Items = {'jet', 'gray', 'bone', 'parula', ''};
            app.ColormapDropDown.ValueChangedFcn = createCallbackFcn(app, @ColormapDropDownValueChanged, true);
            app.ColormapDropDown.Enable = 'off';
            app.ColormapDropDown.Position = [122 92 82 22];
            app.ColormapDropDown.Value = 'jet';

            % Create ShowYaxisinkHzCheckBox
            app.ShowYaxisinkHzCheckBox = uicheckbox(app.SpectrogramSettingsPanel);
            app.ShowYaxisinkHzCheckBox.Enable = 'off';
            app.ShowYaxisinkHzCheckBox.Text = 'Show Y-axis in kHz';
            app.ShowYaxisinkHzCheckBox.FontColor = [0.9412 0.9412 0.9412];
            app.ShowYaxisinkHzCheckBox.Position = [8 253 124 22];
            app.ShowYaxisinkHzCheckBox.Value = true;

            % Create SavedPresetsPanel
            app.SavedPresetsPanel = uipanel(app.UIFigure);
            app.SavedPresetsPanel.ForegroundColor = [0.9412 0.9412 0.9412];
            app.SavedPresetsPanel.Title = 'Saved Presets:';
            app.SavedPresetsPanel.BackgroundColor = [0 0 0];
            app.SavedPresetsPanel.Position = [406 46 161 324];

            % Create ListBox
            app.ListBox = uilistbox(app.SavedPresetsPanel);
            app.ListBox.Items = {'no presets available'};
            app.ListBox.ValueChangedFcn = createCallbackFcn(app, @ListBoxValueChanged, true);
            app.ListBox.Position = [11 14 139 282];
            app.ListBox.Value = {};

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.ScaleMethod = 'fill';
            app.Image.Position = [1 417 574 132];
            app.Image.ImageSource = 'Marina10200png.png';

            % Create GetfilesButton
            app.GetfilesButton = uibutton(app.UIFigure, 'push');
            app.GetfilesButton.ButtonPushedFcn = createCallbackFcn(app, @GetfilesButtonPushed, true);
            app.GetfilesButton.Position = [21 419 100 22];
            app.GetfilesButton.Text = 'Get files';

            % Create FilesSelectedListBox
            app.FilesSelectedListBox = uilistbox(app.UIFigure);
            app.FilesSelectedListBox.Items = {'no files loaded'};
            app.FilesSelectedListBox.Multiselect = 'on';
            app.FilesSelectedListBox.Tooltip = {''};
            app.FilesSelectedListBox.Position = [21 46 150 342];
            app.FilesSelectedListBox.Value = {'no files loaded'};

            % Create PlayAudioButton
            app.PlayAudioButton = uibutton(app.UIFigure, 'push');
            app.PlayAudioButton.ButtonPushedFcn = createCallbackFcn(app, @PlayAudioButtonPushed, true);
            app.PlayAudioButton.Position = [194 396 100 22];
            app.PlayAudioButton.Text = 'Play Audio';

            % Create StopAudioButton
            app.StopAudioButton = uibutton(app.UIFigure, 'push');
            app.StopAudioButton.ButtonPushedFcn = createCallbackFcn(app, @StopAudioButtonPushed, true);
            app.StopAudioButton.BackgroundColor = [0.851 0.149 0.149];
            app.StopAudioButton.Position = [194 375 100 22];
            app.StopAudioButton.Text = 'Stop Audio';

            % Create ChoosefilestoprocessLabel
            app.ChoosefilestoprocessLabel = uilabel(app.UIFigure);
            app.ChoosefilestoprocessLabel.FontColor = [0.9412 0.9412 0.9412];
            app.ChoosefilestoprocessLabel.Position = [21 387 134 22];
            app.ChoosefilestoprocessLabel.Text = 'Choose files to process:';

            % Create ListentoaselectedfileLabel
            app.ListentoaselectedfileLabel = uilabel(app.UIFigure);
            app.ListentoaselectedfileLabel.FontColor = [0.9412 0.9412 0.9412];
            app.ListentoaselectedfileLabel.Position = [191 419 131 22];
            app.ListentoaselectedfileLabel.Text = 'Listen to a selected file:';

            % Create GenerateSpectrogramLabel
            app.GenerateSpectrogramLabel = uilabel(app.UIFigure);
            app.GenerateSpectrogramLabel.FontName = 'Arial Black';
            app.GenerateSpectrogramLabel.FontSize = 43;
            app.GenerateSpectrogramLabel.FontColor = [0.9412 0.9412 0.9412];
            app.GenerateSpectrogramLabel.Position = [18 458 554 66];
            app.GenerateSpectrogramLabel.Text = 'Generate Spectrogram';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Generate_Spectrogram_exported

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