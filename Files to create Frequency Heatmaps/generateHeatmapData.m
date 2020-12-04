function plotData = generateHeatmapData(siteFreqMat,daterangeAll,daterangeAllN, SanctuaryType)
%Allison Stokoe 11/18/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch SanctuaryType
    case 'FK'
        siteFreqMat(1:40,:)= NaN; %0-4 kHz not looked at
        siteFreqMat(180:240,:)= NaN; %18-24 kHz not looked at
        contour(1:length(daterangeAllN),1:100:24000,siteFreqMat)
        colormap(jet)
        set(gca,'XTick',[15,46,74,105],'XTickLabel',{datestr(daterangeAll(15),'mmm-yy'),...
            datestr(daterangeAll(46),'mmm-yy'),datestr(daterangeAll(74),'mmm-yy'),...
            datestr(daterangeAll(105),'mmm-yy')})
        set(gca,'YTick',[1,6000,12000,18000,23800],'YTickLabel',{'0','6','12','18','24'})
        c = colorbar;
        c.Label.String='Number of whistles/freq bin/day';
    case 'GR'
        siteFreqMat(1:40,:)= NaN; %0-4 kHz not looked at
        siteFreqMat(180:240,:)= NaN; %18-24 kHz not looked at
    case 'SB'
end



end

