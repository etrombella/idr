@ECHO OFF
set CLASSPATH=.
set CLASSPATH=%CLASSPATH%;C:/OPPER/jar/idr-0.0.1-SNAPSHOT.jar

"C:\Program Files\Java\jdk-16.0.2\bin\java" -Xms128m -Xmx384m -Xnoclassgc com.opper.idir.batch.BatchCaricamentoPagamenti "C:/OPPER/jar/"