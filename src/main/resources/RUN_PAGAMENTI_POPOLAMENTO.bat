@ECHO OFF
set CLASSPATH=.
set CLASSPATH=%CLASSPATH%;T:\\OPPER\\jar\\idr-0.0.1-SNAPSHOT_PAGAMENTI.jar

"T:\OPPER\jdk-21\bin\java" -Xms128m -Xmx384m -Xnoclassgc com.opper.idir.batch.BatchCaricamentoPagamenti "T:\\OPPER\\jar\\"