This application is easy to run:

1. Modify WEB-INF/util/CreateDB.java to suit your database. See
the databases chapter of the book for details.

2. Change directory to WEB-INF/util and do this: 'java CreateDB'.

3. Now start Tomcat 3.2.1 or 3.2.2.

4. Access the application: http://localhost:8080/$INSTALL_DIR
where $INSTALL_DIR is top-level directory for the application.
That will cause Tomcat to access the index.jsp file, which is
specified as a welcome file.


Note:

Not all of the English text has Chinese or German translations. 
In those cases, English is used. You can easily replace the
English by modifying WEB-INF/classes/app_zh.properties or WEB-INF/classes/app_zh.properties. See the i18n chapter of the book for
more details.
