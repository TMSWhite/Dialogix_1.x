@echo - Program to prepare Dialogix data for analysis (copies files into data directories)

mkdir \Dialogix\@@LICENSE.STUDY_ALIAS@@\data\completed
mkdir \Dialogix\@@LICENSE.STUDY_ALIAS@@\data\analysis
mkdir \Dialogix\@@LICENSE.STUDY_ALIAS@@\data\unjar
mkdir \Dialogix\@@LICENSE.STUDY_ALIAS@@\data\working
mkdir \Dialogix\@@LICENSE.STUDY_ALIAS@@\data\instruments

copy \usr\local\dialogix\webapps\@@LICENSE.STUDY_ALIAS@@\WEB-INF\schedules\*.jar \Dialogix\@@LICENSE.STUDY_ALIAS@@\data\instruments
copy \usr\local\dialogix\webapps\@@LICENSE.STUDY_ALIAS@@\WEB-INF\completed\*.jar \Dialogix\@@LICENSE.STUDY_ALIAS@@\data\completed
copy \usr\local\dialogix\webapps\@@LICENSE.STUDY_ALIAS@@\WEB-INF\working\*.* \Dialogix\@@LICENSE.STUDY_ALIAS@@\data\working

cd \Dialogix\@@LICENSE.STUDY_ALIAS@@\perl
perl \Dialogix\@@LICENSE.STUDY_ALIAS@@\perl\unjar.pl _study.conf dos

perl \Dialogix\@@LICENSE.STUDY_ALIAS@@\perl\validate_inst.pl _study.conf

