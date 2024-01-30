@ECHO OFF
set CLASSPATH=.
set CLASSPATH=%CLASSPATH%;T:\\OPPER\\jar\\idr-0.0.1-SNAPSHOT_STORED.jar

"T:\OPPER\jdk-19\bin\java" -Xms128m -Xmx384m -Xnoclassgc com.opper.idir.run.CallStoredProcedureMCD3EsclusionePremi