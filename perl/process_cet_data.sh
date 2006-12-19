#!/bin/sh

# Process CET data
find /usr/local/dialogix/webapps/CET/WEB-INF/completed -regex ".*\.jar" -exec cp -p {} /home/tmw/data/CET_20061116/completed \; &
find /usr/local/dialogix/webapps/CET/WEB-INF/working -regex ".*\.da.*" -exec cp -p {} /home/tmw/data/CET_20061116/working \; &

# Find newer files (This may be inappropriate - what if an old extract had data form a working file, and it is now completed?  Will it double count?)
find /usr/local/dialogix/webapps/CET/WEB-INF/completed -newer /home/tmw/data/CET_20061116/last_cet_extract -regex ".*\.jar" -exec cp -p {} /home/tmw/data/CET_20061116/completed \; &
find /usr/local/dialogix/webapps/CET/WEB-INF/working -newer /home/tmw/data/CET_20061116/last_cet_extract -regex ".*\.da.*" -exec cp -p {} /home/tmw/data/CET_20061116/working \; &

ls -l /home/tmw/data/CET_20061116/last_cet_extract
touch -B 7200 /home/tmw/data/CET_20061116/last_cet_extract
ls -l /home/tmw/data/CET_20061116/last_cet_extract

# Remove old files (carefully)
cd /home/tmw/data/CET_20061116/analysis
rm -f *.tsv

cd /home/tmw/data/cvs/Dialogix/perl

# Prepare all schedules
perl unjar.pl cet_unix_20061116.prep.conf unix  >> cet_unix_20061219.prep.log 2> cet_unix_20061219.prep.err&

# Then process the data
perl unjar.pl cet_unix_20061116.conf unix >> cet_unix_20061219.log 2> cet_unix_20061219.err&

