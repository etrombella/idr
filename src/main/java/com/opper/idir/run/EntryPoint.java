package com.opper.idir.run;

import java.io.PrintWriter;
import java.io.StringWriter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class EntryPoint {

	private static Logger logger = LoggerFactory.getLogger(EntryPoint.class);
	
	public static void main(String ar[]){
		try {
			logger.info("PATH: " + ar[0]);
			logger.info("START BATCH");
			PopulateTable populateTable = new PopulateTable(ar[0]);
			logger.info("START RUN POPULATE");
			populateTable.executeSqlScript("populate.sql");
			logger.info("END RUN POPULATE");
			logger.info("START RUN POPULATE");
			populateTable.executeSqlScript("populate_logistica.sql");
			logger.info("END RUN POPULATE");
			logger.info("END BATCH");
		}catch(Exception e) {
			logger.error("ERRORE BATCH: " + e.getMessage() + " ////////// " + e.getLocalizedMessage());
			StringWriter sw = new StringWriter();
			PrintWriter pw = new PrintWriter(sw);
			e.printStackTrace(pw);
			String sStackTrace = sw.toString(); // stack trace as a string
			logger.error(sStackTrace);
		}
	}
}