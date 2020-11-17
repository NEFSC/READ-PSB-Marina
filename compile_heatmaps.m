%% FKNMS
%FK01_01
[FK01FreqMat,FK01daterangeAll,FK01daterangeAllN]= freqMatBySite;
FK01FreqMat(1:40,:)= NaN; %0-4 kHz not looked at
FK01FreqMat(180:240,:)= NaN; %18-24 kHz not looked at

%FK02_01
[FK02FreqMat,FK02daterangeAll,FK02daterangeAllN]= freqMatBySite;
FK02FreqMat(1:40,:)= NaN; %0-4 kHz not looked at
FK02FreqMat(180:240,:)= NaN; %18-24 kHz not looked at

%FK03_01
[FK03FreqMat,FK03daterangeAll,FK03daterangeAllN]= freqMatBySite;
FK03FreqMat(1:40,:)= NaN; %0-4 kHz not looked at
FK03FreqMat(180:240,:)= NaN; %18-24 kHz not looked at

%FK04_01-02
[FK04FreqMat,FK04daterangeAll,FK04daterangeAllN]= freqMatBySite;
FK04FreqMat(1:40,:)= NaN; %0-4 kHz not looked at
FK04FreqMat(180:240,:)= NaN; %18-24 kHz not looked at

%Figure generation FK
FKfig= figure;
subplot(4,1,1)
contour(1:length(FK01daterangeAllN),1:100:24000,FK01FreqMat)
colormap(jet)
set(gca,'XTick',[15,46,74,105],'XTickLabel',{datestr(FK01daterangeAll(15),'mmm-yy'),...
    datestr(FK01daterangeAll(46),'mmm-yy'),datestr(FK01daterangeAll(74),'mmm-yy'),...
    datestr(FK01daterangeAll(105),'mmm-yy')})
set(gca,'YTick',[1,6000,12000,18000,23800],'YTickLabel',{'0','6','12','18','24'})
colorbar

subplot(4,1,2)
contour(1:length(FK02daterangeAllN),1:100:24000,FK02FreqMat)
colormap(jet)
set(gca,'XTick',[15,46,74,105],'XTickLabel',{datestr(FK02daterangeAll(15),'mmm-yy'),...
    datestr(FK02daterangeAll(46),'mmm-yy'),datestr(FK02daterangeAll(74),'mmm-yy'),...
    datestr(FK02daterangeAll(105),'mmm-yy')})
set(gca,'YTick',[1,6000,12000,18000,23800],'YTickLabel',{'0','6','12','18','24'})
c= colorbar;
c.Label.String='Number of whistles/freq bin/day';

subplot(4,1,3)
contour(1:length(FK03daterangeAllN),1:100:24000,FK03FreqMat)
colormap(jet)
set(gca,'XTick',[15,46,74,105],'XTickLabel',{datestr(FK03daterangeAll(15),'mmm-yy'),...
    datestr(FK03daterangeAll(46),'mmm-yy'),datestr(FK03daterangeAll(74),'mmm-yy'),...
    datestr(FK03daterangeAll(105),'mmm-yy')})
set(gca,'YTick',[1,6000,12000,18000,23800],'YTickLabel',{'0','6','12','18','24'})
colorbar

subplot(4,1,4)
contour(1:length(FK04daterangeAllN),1:100:24000,FK04FreqMat)
colormap(jet)
set(gca,'XTick',[25,53,84,112,142,173],'XTickLabel',...
    {datestr(FK04daterangeAll(25),'mmm-yy'),datestr(FK04daterangeAll(53),'mmm-yy'),...
    datestr(FK04daterangeAll(84),'mmm-yy'),...
    datestr(FK04daterangeAll(112),'mmm-yy'),...
    datestr(FK04daterangeAll(142),'mmm-yy'),datestr(FK04daterangeAll(173),'mmm-yy')})
set(gca,'YTick',[1,6000,12000,18000,23800],'YTickLabel',{'0','6','12','18','24'})
colorbar

han= axes(FKfig,'visible','off');
han.Title.Visible='on';

han.YLabel.Visible='on';
ylabel(han,'Frequency (kHz)');

title(han,'FKNMS');
%% GRNMS
%GR01_01-02
[GR01FreqMat,GR01daterangeAll,GR01daterangeAllN]= freqMatBySite;
GR01FreqMat(1:40,:)= NaN; %0-4 kHz not looked at
GR01FreqMat(180:240,:)= NaN; %18-24 kHz not looked at

%GR02_02
[GR02FreqMat,GR02daterangeAll,GR02daterangeAllN]= freqMatBySite;
GR02FreqMat(1:40,:)= NaN; %0-4 kHz not looked at
GR02FreqMat(180:240,:)= NaN; %18-24 kHz not looked at

%GR03_02
[GR03FreqMat,GR03daterangeAll,GR03daterangeAllN]= freqMatBySite;
GR03FreqMat(1:40,:)= NaN; %0-4 kHz not looked at
GR03FreqMat(180:240,:)= NaN; %18-24 kHz not looked at

%Figure generation GR
GRfig= figure;
subplot(3,1,1)
contour(1:length(GR01daterangeAllN),1:100:24000,GR01FreqMat)
colormap(jet)
set(gca,'XTick',[19,49,77,107,134,165,195,226,256],'XTickLabel',...
    {datestr(GR01daterangeAll(19),'mmm-yy'),...
    datestr(GR01daterangeAll(49),'mmm-yy'),datestr(GR01daterangeAll(77),'mmm-yy'),...
    datestr(GR01daterangeAll(107),'mmm-yy'),datestr(GR01daterangeAll(134),'mmm-yy'),...
    datestr(GR01daterangeAll(165),'mmm-yy'),datestr(GR01daterangeAll(195),'mmm-yy'),...
    datestr(GR01daterangeAll(226),'mmm-yy'),datestr(GR01daterangeAll(256),'mmm-yy')})
set(gca,'YTick',[1,6000,12000,18000,23800],'YTickLabel',{'0','6','12','18','24'})
colorbar

subplot(3,1,2)
contour(1:length(GR02daterangeAllN),1:100:24000,GR02FreqMat)
colormap(jet)
set(gca,'XTick',[20,50,81,112],'XTickLabel',{datestr(GR02daterangeAll(20),'mmm-yy'),...
    datestr(GR02daterangeAll(50),'mmm-yy'),datestr(GR02daterangeAll(81),'mmm-yy'),...
    datestr(GR02daterangeAll(112),'mmm-yy')})
set(gca,'YTick',[1,6000,12000,18000,23800],'YTickLabel',{'0','6','12','18','24'})
c= colorbar;
c.Label.String='Number of whistles/freq bin/day';

subplot(3,1,3)
contour(1:length(GR03daterangeAllN),1:100:24000,GR03FreqMat)
colormap(jet)
set(gca,'XTick',[31,61,92,123],'XTickLabel',{datestr(GR03daterangeAll(31),'mmm-yy'),...
    datestr(GR03daterangeAll(61),'mmm-yy'),datestr(GR03daterangeAll(92),'mmm-yy'),...
    datestr(GR03daterangeAll(123),'mmm-yy')})
set(gca,'YTick',[1,6000,12000,18000,23800],'YTickLabel',{'0','6','12','18','24'})
colorbar


han= axes(GRfig,'visible','off');
han.Title.Visible='on';

han.YLabel.Visible='on';
ylabel(han,'Frequency (kHz)');

title(han,'GRNMS');

%% SBNMS
%SB01_01-03
[SB01FreqMat,SB01daterangeAll,SB01daterangeAllN]= freqMatBySite; %dep 3 doesn't have RawData

%SB02_01-03- this could be done automatically
[SB02FreqMat,SB02daterangeAll,SB02daterangeAllN]= freqMatBySite;

%SB03_01-03- had to do all of this by hand
[SB03FreqMat,SB03daterangeAll,SB03daterangeAllN]= freqMatBySite; %dep 1-3 doesn't have RawData

%Figure generation SB
SBfig= figure;
subplot(3,1,1)
contour(1:length(SB01daterangeAllN),1:100:24000,SB01FreqMat)
colormap(jet)
set(gca,'XTick',[20,51,83,111,142,173],'XTickLabel',...
    {datestr(SB01daterangeAll(20),'mmm-yy'),...
    datestr(SB01daterangeAll(51),'mmm-yy'),datestr(SB01daterangeAll(83),'mmm-yy'),...
    datestr(SB01daterangeAll(111),'mmm-yy'),datestr(SB01daterangeAll(142),'mmm-yy'),...
    datestr(SB01daterangeAll(173),'mmm-yy')})
set(gca,'YTick',[1,6000,12000,18000,23800],'YTickLabel',{'0','6','12','18','24'})
colorbar

subplot(3,1,2)
contour(1:length(SB02daterangeAllN),1:100:24000,SB02FreqMat)
colormap(jet)
set(gca,'XTick',[20,51,83,111,142,173],'XTickLabel',{datestr(SB02daterangeAll(20),'mmm-yy'),...
    datestr(SB02daterangeAll(51),'mmm-yy'),datestr(SB02daterangeAll(83),'mmm-yy'),...
    datestr(SB02daterangeAll(111),'mmm-yy'),datestr(SB02daterangeAll(142),'mmm-yy'),...
    datestr(SB02daterangeAll(173),'mmm-yy')})
set(gca,'YTick',[1,6000,12000,18000,23800],'YTickLabel',{'0','6','12','18','24'})
c= colorbar;
c.Label.String='Number of whistles/freq bin/day';

subplot(3,1,3)
contour(1:length(SB03daterangeAllN),1:100:24000,SB03FreqMat)
colormap(jet)
set(gca,'XTick',[20,51,83,111,142,173],'XTickLabel',{datestr(SB03daterangeAll(20),'mmm-yy'),...
    datestr(SB03daterangeAll(51),'mmm-yy'),datestr(SB03daterangeAll(83),'mmm-yy'),...
    datestr(SB03daterangeAll(111),'mmm-yy'),datestr(SB03daterangeAll(142),'mmm-yy'),...
    datestr(SB03daterangeAll(173),'mmm-yy')})
set(gca,'YTick',[1,6000,12000,18000,23800],'YTickLabel',{'0','6','12','18','24'})
colorbar


han= axes(SBfig,'visible','off');
han.Title.Visible='on';

han.YLabel.Visible='on';
ylabel(han,'Frequency (kHz)');

title(han,'SBNMS');
