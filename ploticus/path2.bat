REM batch file for processing Heather's QRT scores

set PLOTICUS_PREFABS=c:\ftp\plbin200win32\prefabs

pl.exe -ps -o path2a.ps -prefab lines data=meq1.txt x=2 y=3 y2=6 y3=9 y4=12 name="Told inconsitent; changed answers; became consistent" name2="Consistent" name3="Told inconsistent, but claimed OK" name4="Consistent, but backtracked" xlbl="Display Step (Deployment)" ylbl="Instrument Step (Definition)" yrange="1 27" xrange="1 50" title="Trajectory through AutoMEQ" pointsym=none pointsym2=none pointsym3=none pointsym4=none

pl.exe -ps -o path2c.ps meq-time.plo
