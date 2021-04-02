function gen_spect(currentfile,filepath,settings_array,runtype,savepath)
%modified version of Tim Rowell's code 'Spect_Generic'. Part of Marina
%Generate Spectrogram Boat
%
%Created by Allison Stokoe 3/31/2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cal = -171.8; % Calibration/sensitivity

%%Settings array info:
NFFT = settings_array{1}; %FFT length
FreqLowLim = settings_array{2}; % Freq Lower Limit
FreqUpLim = settings_array{3}; % Freq Upper Limit
YIncrement = settings_array{4}; % YAxis Increment value
Hz_kHz = settings_array{5}; % Is YAxis in Hz or kHz?
color = settings_array{6}; %determines colormap 

   %%read .wav file
    [y, fs] = audioread([filepath,currentfile],'native');
    y = y(:,1); %set to mono
       
    duration = length(y)/fs;
    data = double(y)/2^15;
    data = data - mean(data); %get rid of DC offset
    data_cal_uPa = data./(10^(cal/20)); %uPa
    data_cal_Pa = data_cal_uPa./(10^6); %Pa
    time = linspace(0,duration,length(data));
    
   %%plot and settings
   switch runtype
       case 'graph'
           f = figure('visible','off'); %suppress figure window
       case 'preview'
           f = figure('visible','on'); %show figure window
   end
   
    win = kaiser(NFFT,7.85);
    [S,F,T,P] = spectrogram(data_cal_uPa,win,floor(NFFT*.99),NFFT,fs);
    imagesc(T,F,10*log10(P));
    axis xy
    caxis([65 95])
    
    %%colormap settings
    switch color
        case 'gray'
            colormap(flipud(gray))
        case 'bone'
            colormap(flipud(bone))
        otherwise
            colormap(color)
    end
    
   %%find xlim and set x and y lims
    timelim = floor(duration);
    xlim([0 timelim])
    ylim([FreqLowLim FreqUpLim])
    
    %%create array for YTick values
    TickNumAmount = (FreqUpLim - FreqLowLim)/YIncrement; %finds the number of ticks to graph
    YTick_Array = [FreqLowLim];

    for ii = 1:TickNumAmount
        nextValue = FreqLowLim + YIncrement*ii;  
        YTick_Array = [YTick_Array, nextValue];
    end
    
    %%create array for Ytick labels
    switch Hz_kHz 
        case true %graph is in kHz
           YLabels_Array = YTick_Array/1000;
           text = 'Frequency (kHz)'; %sets yaxis title
           
        case false %graph is in Hz
           YLabels_Array = YTick_Array; 
           text = 'Frequency (Hz)'; %sets yaxis title
        otherwise
            %do nothing
    end
    
   %%options for YTick and XTick 
    set(gca,'FontSize',14,'YTick',YTick_Array,'YTickLabels',YLabels_Array,'TickDir','out','Box','off');
    %set(gca,'FontSize',14,'XTick',[0 1 2 3 4 5],'XTickLabel',{'0','1','2','3','4','5'},'TickDir','out','Box','off');
    
   %%Set labels and add title
    %text = 'add title text here';
    %title(text);
    ylabel(text,'FontSize',14)
    xlabel('Time (s)','FontSize',14)
    
  %%save figure as png depending on runtype
    switch runtype
        case 'graph'        
            savename = split(currentfile,".");
            saveas(f, fullfile(savepath,savename{1}), 'png');
        case 'preview'
            %do nothing
    end
end

