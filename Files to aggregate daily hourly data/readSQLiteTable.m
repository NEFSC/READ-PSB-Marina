function wmd = readSQLiteTable(pathname_summary, currentfile)
%Read an SQLite database from pamguard whiste and moan detector. For
%Dolphin/Minke GUI
 dbid = mksqlite(0, 'open',[pathname_summary, currentfile], 'ro');
 wmd = mksqlite(dbid, 'SELECT * FROM Whistle_and_Moan_Detector ORDER BY UTC');
 wmd = struct2table(wmd);
 mksqlite(dbid, 'close')
end

