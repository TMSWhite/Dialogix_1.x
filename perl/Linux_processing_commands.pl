# Unix commands for copying Dialogix files

cp /usr/local/dialogix/webapps

find . -regex '.*completed\/[A-Za-z0-9_.-]*\.jar' -exec cp -pf {} /home/tmw/data/completed \;

find . -regex '.*working\/[A-Za-z0-9_.-]*\.dat.*' -exec cp -pf {} /home/tmw/data/working \;

find . -regex '.*schedules\/[A-Za-z0-9_.-]*\.jar' -exec cp -pf {} /home/tmw/data/instruments \;

# N.B.  If any filenames are shared across directories, they may be overwritten.  So, might be better to do this one source at a time


find . -regex '.*completed\/[A-Za-z0-9_.-]*\.jar' -print > /home/tmw/data/completed_list.txt

find . -regex '.*working\/[A-Za-z0-9_.-]*\.dat.*' -print > /home/tmw/data/working_list.txt

find . -regex '.*schedules\/[A-Za-z0-9_.-]*\.jar' -print > /home/tmw/data/instruments_list.txt
