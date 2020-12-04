function wmd = readWMD_SQLiteTable_dolphin(pathname,filename)
%reads SQlite database with dolphinWMD table

%Allison Stokoe 11/18/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%read in SQLite table
dbid = mksqlite(0, 'open', [pathname,filename], 'ro');

dolphin= mksqlite(dbid, 'SELECT * FROM Dolphin_WMD ORDER BY UTC');
dolphin = struct2table(dolphin);
wmd= dolphin;

mksqlite(dbid, 'close')