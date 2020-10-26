function [siteFreqMat,daterangeAll,daterangeAllN]= freqMatBySite

[filename,pathname]= uigetfile('*.xlsx','Select the Presence table','Multiselect','on');

siteFreqMat= [];
daterangeAll= []; daterangeAllN= [];
c= iscell(filename);
if ~c
    inputfile= [pathname,filename];
    [freqMat1,daterange1,daterangeNum1]= computeFreqMatrix(inputfile);
    siteFreqMat= [siteFreqMat,freqMat1]; %assuming the files will be read in chronological order
    daterangeAll= [daterangeAll;daterange1];
    daterangeAllN= [daterangeAllN;daterangeNum1];
else
    nfiles= length(filename);
    for i= 1:nfiles
        msg= sprintf('Working on file %d of %d',i,nfiles);
        disp(msg);
        inputfile= [pathname,filename{i}];
        [freqMat1,daterange1,daterangeNum1]= computeFreqMatrix(inputfile);
        siteFreqMat= [siteFreqMat,freqMat1]; %assuming the files will be read in chronological order
        daterangeAll= [daterangeAll;daterange1];
        daterangeAllN= [daterangeAllN;daterangeNum1];
    end
end
