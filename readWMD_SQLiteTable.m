function wmd= readWMD_SQLiteTable(pathname,filename)
%User provides path and filename of a Pamguard database from which the
%Whistle and Moan detector table can be extracted

%Output is a table of the whistle and moan detections

%Annamaria DeAngelis
%3/9/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%'C:\Users\annamaria.deangelis.NMFS\Documents\SanctSound\Dolphin_PG_Detector\ToBeCopied\SanctSound_FK01_01_dolphins - Copy.sqlite3

%read in SQLite table
dbid = mksqlite(0, 'open', [pathname,filename], 'ro');

wmd= mksqlite(dbid, 'SELECT * FROM Whistle_and_Moan_Detector ORDER BY UTC');
wmd= struct2table(wmd);

mksqlite(dbid, 'close')