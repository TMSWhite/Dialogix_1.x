#!/bin/sh
# script to assess current AutoMEQ status

pushd .
cd /usr/local/dialogix/logs

echo Report of CET activity
echo `date`
echo '---- Unique Values ---'
echo `grep AutoMEQ-SA-irb.*\(0\) Dialogix.log.err* | cut -d ' ' -f 9 | sort | uniq | wc -l` Unique IP addresses started the AutoMEQ-SA-irb.
echo `grep AutoMEQ-SA-irb.*\(11\) Dialogix.log.err* | cut -d ' ' -f 9 | sort | uniq | wc -l` ... entered Demographics.
echo `grep AutoMEQ-SA-irb.*\(36\) Dialogix.log.err* | cut -d ' ' -f 9 | sort | uniq | wc -l` ... got to question 3 on the MEQ.
echo `grep AutoMEQ-SA-irb.*\(52\) Dialogix.log.err* | cut -d ' ' -f 9 | sort | uniq | wc -l` ... viewed the results of the MEQ.

echo '--- Non-Unique Values ---'
echo `grep AutoMEQ-SA-irb.*\(0\) Dialogix.log.err* | cut -d ' ' -f 9 | sort |  wc -l` sessions started the AutoMEQ-SA-irb.
echo `grep AutoMEQ-SA-irb.*\(11\) Dialogix.log.err* | cut -d ' ' -f 9 | sort | wc -l` ... entered Demographics.
echo `grep AutoMEQ-SA-irb.*\(36\) Dialogix.log.err* | cut -d ' ' -f 9 | sort | wc -l` ... got to question 3 on the MEQ.
echo `grep AutoMEQ-SA-irb.*\(52\) Dialogix.log.err* | cut -d ' ' -f 9 | sort | wc -l` ... viewed the results of the MEQ.

echo Here are the current data file counts -- they may include older files:
echo There are `ls /usr/local/dialogix/webapps/CET/WEB-INF/working/*.dat | wc -l` files in the working directory
echo There are `ls /usr/local/dialogix/webapps/CET/WEB-INF/completed/*.jar | wc -l` files in the completed directory

popd
