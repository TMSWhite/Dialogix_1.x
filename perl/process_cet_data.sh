#!/bin/sh

# Process CET data

# Remove old files (carefully)
cd /home/tmw/data/CET_20061116/analysis
rm -f *.tsv

cd /home/tmw/data/cvs/Dialogix/perl

# Prepare all schedules
perl unjar.pl cet_unix_20061116.prep.conf unix  > cet_unix_20061116.prep.log 2> cet_unix_20061116.prep.err&

# Then process the data
perl unjar.pl cet_unix_20061116.conf unix > cet_unix_20061116.log 2> cet_unix_20061116.err&