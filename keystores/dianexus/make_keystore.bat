@echo =====================================
@echo Batch file to create an SSL keystore
@echo =====================================


set JAVA_HOME=\jdk1.4

@echo =====================================
@echo Remove previous keystore [optional]
@echo Quit if you don't want to do this
@echo =====================================

pause
REM del dianexus.keystore


@echo =====================================
@echo Generate keystore and self-signed key
@echo =====================================

REM %JAVA_HOME%\bin\keytool -keystore dianexus.keystore -keypass aka##triceps -storepass aka##triceps -genkey -alias tomcat -keyalg RSA -dname "CN=www.dianexus.org, O=Dr. Michael J. Hauan, L=Fulton, ST=Missouri, C=US" -validity 745

@echo =====================================
@echo Create a certificate signing request
@echo =====================================

REM %JAVA_HOME%\bin\keytool -keystore dianexus.keystore -keypass aka##triceps -storepass aka##triceps -certreq -keyalg RSA  -alias tomcat -file dianexus_certreq.csr -v

REM %JAVA_HOME%\bin\keytool -keystore dianexus.keystore -keypass aka##triceps -storepass aka##triceps -list -v

@echo =====================================
@echo ... send it to Thawte or Verisign ...
@echo ... receive a signed cert from the CA
@echo [If from Thawte, ensure that it is a
@echo X509.v1 SSL Cert (not .v3), in 
@echo "standard" format]
@echo Save the reply as dianexus_certreq.cer
@echo Ensure that it has final CR (return).
@echo https://www.thawte.com/cgi/server/try.exe
@echo =====================================

pause


@echo =====================================
@echo Import Thawte's test root cert
@echo [Don't do this if you got a real
@echo signed certificate]
@echo =====================================

REM %JAVA_HOME%\bin\keytool -keystore dianexus.keystore -keypass aka##triceps -storepass aka##triceps -import -alias Thawte_certreq -file thawte_certreq.cer

@echo =====================================
@echo Import the signed certificate
@echo =====================================

%JAVA_HOME%\bin\keytool -keystore dianexus.keystore -keypass aka##triceps -storepass aka##triceps -import -alias tomcat -trustcacerts -file dianexus_certreq.cer

@echo =====================================
@echo List the contents of the keystore
@echo =====================================

%JAVA_HOME%\bin\keytool -keystore dianexus.keystore -keypass aka##triceps -storepass aka##triceps -list -v

