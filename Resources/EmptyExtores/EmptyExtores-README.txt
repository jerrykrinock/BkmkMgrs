These files are used

(1) When exporting to a browser, to create a native bookmarks file from scratch, if the browser has not created a bookmarks file yet (because user has not created any bookmarks).

(2) When exporting to a Choose File (Advanced) new native browser file.


The ExtoreFirefox file is a places.sqlite file which has been zipped (because it is otherwise 10 MB).  All of the others are *not* zipped.

To create the ExtoreFirefox file:

• Quit Firefox.
• Remove places.sqlite file.
• Launch Firefox.
• Delete all new "Mozilla" bookmarks.
• Quit Firefox.
• Open the new places.sqlite file.
• Delete all rows in moz_favicons.
• Delete all rows in moz_historyvisits
• In moz_places, delete all rows whose `id` points to deleted bookmarks, which are those whose URL is mozilla.org/whatever.  The rows whose URL is place:whatever will stay.
• Quit sqlite editor.
• If -shm or -wal files are created, or if you want a smaller places.sqlite file (which may be unnecessary since it's going to be zipped anyhow) open with SQLite Profressional or equivalent and

VACUUM;
PRAGMA wal_checkpoint;

There may be a trick to this and it may need to be done repeatedly, and maybe you need to use the sqlite3 command-line tool.  I think that maybe VACUUM *creates* the -shm and -wal files, and PRAGMA wal_checkpoint should remove them but does not always.  See comment by Jerry Krinock in here:
https://stackoverflow.com/questions/19574286/how-to-merge-contents-of-sqlite-3-7-wal-file-into-main-database-file

