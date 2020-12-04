function plotData = generateHeatmapData(siteFreqMat,daterangeAll,daterangeAllN)
%Allison Stokoe 11/18/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

contour(1:length(daterangeAllN),1:100:24000,siteFreqMat)
colormap(jet)
c = colorbar;
c.Label.String='Number of whistles/freq bin/day';
        
end

