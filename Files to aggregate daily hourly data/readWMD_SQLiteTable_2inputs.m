function wmd= readWMD_SQLiteTable_2inputs(pathname,filename,species)
%User provides path and filename of a Pamguard database from which the
%humpback and dolphin Whistle and Moan detector table can be extracted

%table names in the SQL database have to be named Humpback_WMD and
%Dolphin_WMD

%Output is 1 table of the whistle and moan detections for the detector the
%user selects

%Annamaria DeAngelis
%10/23/20
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%'C:\Users\annamaria.deangelis.NMFS\Documents\SanctSound\Dolphin_PG_Detector\ToBeCopied\SanctSound_FK01_01_dolphins - Copy.sqlite3

%read in SQLite table
dbid = mksqlite(0, 'open', [pathname,filename], 'ro');

humpback= mksqlite(dbid, 'SELECT * FROM Humpback_WMD ORDER BY UTC'); 
dolphin= mksqlite(dbid, 'SELECT * FROM Dolphin_WMD ORDER BY UTC');
humpback= struct2table(humpback);
dolphin= struct2table(dolphin);
if strcmp(species,'humpback')
    wmd= humpback;
else
    wmd= dolphin;
end

mksqlite(dbid, 'close')