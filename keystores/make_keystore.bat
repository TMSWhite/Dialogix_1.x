@echo =====================================
@echo Batch file to create an SSL keystore
@echo =====================================


set JAVA_HOME=\jdk1.3

@echo =====================================
@echo Remove previous keystore [optional]
@echo Quit if you don't want to do this
@echo =====================================

pause
del dianexus.keystore


@echo =====================================
@echo Generate keystore and self-signed key
@echo =====================================

%JAVA_HOME%\bin\keytool -keystore dianexus.keystore -keypass aka##triceps -storepass aka##triceps -genkey -alias tomcat -keyalg RSA -dname "CN=127.0.0.1, OU=Department of Medical Informatics, O=Columbia University, L=New York, ST=New York, C=US"

@echo =====================================
@echo Create a certificate signing request
@echo =====================================

%JAVA_HOME%\bin\keytool -keystore dianexus.keystore -keypass aka##triceps -storepass aka##triceps -certreq -alias tomcat -file dianexus_test.csr -v


@echo =====================================
@echo ... send it to Thawte or Verisign ...
@echo ... receive a signed cert from the CA
@echo [If from Thawte, ensure that it is a
@echo X509.v1 SSL Cert (not .v3), in 
@echo "standard" format]
@echo Save the reply as dianexus_test.cer
@echo Ensure that it has final CR (return).
@echo <https://www.thawte.com/cgi/server/try.exe>
@echo =====================================

pause


@echo =====================================
@echo Import Thawte's test root cert
@echo [Don't do this if you got a real
@echo signed certificate]
@echo =====================================

%JAVA_HOME%\bin\keytool -keystore dianexus.keystore -keypass aka##triceps -storepass aka##triceps -import -alias Thawte_Test -file thawte_test.cer

@echo =====================================
@echo Import the signed certificate
@echo =====================================

%JAVA_HOME%\bin\keytool -keystore dianexus.keystore -keypass aka##triceps -storepass aka##triceps -import -alias tomcat -trustcacerts -file dianexus_test.cer

@echo =====================================
@echo List the contents of the keystore
@echo =====================================

%JAVA_HOME%\bin\keytool -keystore dianexus.keystore -keypass aka##triceps -storepass aka##triceps -list -v

