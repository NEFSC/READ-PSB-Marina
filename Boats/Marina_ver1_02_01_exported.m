classdef Marina_ver1_02_01_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                    matlab.ui.Figure
        PAGroupDocksMenu            matlab.ui.container.Menu
        SanctSoundMenu              matlab.ui.container.Menu
        BoatsMenu                   matlab.ui.container.Menu
        AggregateDataDailyandHourlyMenu  matlab.ui.container.Menu
        FormatDataforNCEIMenu       matlab.ui.container.Menu
        CreateFrequencyHeatmapMenu  matlab.ui.container.Menu
        VisualizationMenu           matlab.ui.container.Menu
        BoatsMenu_2                 matlab.ui.container.Menu
        GenerateSpectrogramMenu     matlab.ui.container.Menu
        version10201Label           matlab.ui.control.Label
        Image                       matlab.ui.control.Image
        MarinaLabel                 matlab.ui.control.Label
        MasterAcousticResearchGUINEFSCPAGroupLabel  matlab.ui.control.Label
    end

    
    properties (Access = private)
        aggregateBoat % aggregate data daily and hourly app 
        NCEIformatBoat% format data for NCEI app
        FreqHeatmapBoat %create frequency heatmap dolphin wmd
        SpectrogramBoat %generate a spectrgram from sound file
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Menu selected function: AggregateDataDailyandHourlyMenu
        function CallAggregateData(app, event)
            app.aggregateBoat = Aggregate_Data_Daily_and_Hourly;
        end

        % Menu selected function: FormatDataforNCEIMenu
        function FormatDataforNCEIMenuSelected(app, event)
            app.NCEIformatBoat = Format_data_for_NCEI;
        end

        % Menu selected function: CreateFrequencyHeatmapMenu
        function CreateFrequencyHeatmapMenuSelected(app, event)
            app.FreqHeatmapBoat = Create_Frequency_Heatmap;
        end

        % Menu selected function: GenerateSpectrogramMenu
        function GenerateSpectrogramMenuSelected(app, event)
            app.SpectrogramBoat = Generate_Spectrogram;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0 0 0];
            app.UIFigure.Position = [100 100 589 315];
            app.UIFigure.Name = 'UI Figure';

            % Create PAGroupDocksMenu
            app.PAGroupDocksMenu = uimenu(app.UIFigure);
            app.PAGroupDocksMenu.Text = 'PA Group Docks';

            % Create SanctSoundMenu
            app.SanctSoundMenu = uimenu(app.PAGroupDocksMenu);
            app.SanctSoundMenu.Text = 'SanctSound';

            % Create BoatsMenu
            app.BoatsMenu = uimenu(app.SanctSoundMenu);
            app.BoatsMenu.Text = 'Boats';

            % Create AggregateDataDailyandHourlyMenu
            app.AggregateDataDailyandHourlyMenu = uimenu(app.BoatsMenu);
            app.AggregateDataDailyandHourlyMenu.MenuSelectedFcn = createCallbackFcn(app, @CallAggregateData, true);
            app.AggregateDataDailyandHourlyMenu.Text = 'Aggregate Data Daily and Hourly';

            % Create FormatDataforNCEIMenu
            app.FormatDataforNCEIMenu = uimenu(app.BoatsMenu);
            app.FormatDataforNCEIMenu.MenuSelectedFcn = createCallbackFcn(app, @FormatDataforNCEIMenuSelected, true);
            app.FormatDataforNCEIMenu.Text = 'Format Data for NCEI';

            % Create CreateFrequencyHeatmapMenu
            app.CreateFrequencyHeatmapMenu = uimenu(app.BoatsMenu);
            app.CreateFrequencyHeatmapMenu.MenuSelectedFcn = createCallbackFcn(app, @CreateFrequencyHeatmapMenuSelected, true);
            app.CreateFrequencyHeatmapMenu.Text = 'Create Frequency Heatmap';

            % Create VisualizationMenu
            app.VisualizationMenu = uimenu(app.PAGroupDocksMenu);
            app.VisualizationMenu.Text = 'Visualization';

            % Create BoatsMenu_2
            app.BoatsMenu_2 = uimenu(app.VisualizationMenu);
            app.BoatsMenu_2.Text = 'Boats';

            % Create GenerateSpectrogramMenu
            app.GenerateSpectrogramMenu = uimenu(app.BoatsMenu_2);
            app.GenerateSpectrogramMenu.MenuSelectedFcn = createCallbackFcn(app, @GenerateSpectrogramMenuSelected, true);
            app.GenerateSpectrogramMenu.Text = 'Generate Spectrogram';

            % Create version10201Label
            app.version10201Label = uilabel(app.UIFigure);
            app.version10201Label.FontColor = [1 1 1];
            app.version10201Label.Position = [10 1 99 22];
            app.version10201Label.Text = 'version 1.02.01';

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.Position = [39 52 514 212];
            app.Image.ImageSource = 'Marina10200png.png';

            % Create MarinaLabel
            app.MarinaLabel = uilabel(app.UIFigure);
            app.MarinaLabel.FontName = 'Arial Black';
            app.MarinaLabel.FontSize = 72;
            app.MarinaLabel.FontColor = [1 1 1];
            app.MarinaLabel.Position = [158 121 276 111];
            app.MarinaLabel.Text = 'Marina';

            % Create MasterAcousticResearchGUINEFSCPAGroupLabel
            app.MasterAcousticResearchGUINEFSCPAGroupLabel = uilabel(app.UIFigure);
            app.MasterAcousticResearchGUINEFSCPAGroupLabel.FontColor = [1 1 1];
            app.MasterAcousticResearchGUINEFSCPAGroupLabel.Position = [162 121 272 22];
            app.MasterAcousticResearchGUINEFSCPAGroupLabel.Text = 'Master Acoustic Research GUI NEFSC PA Group';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Marina_ver1_02_01_exported

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