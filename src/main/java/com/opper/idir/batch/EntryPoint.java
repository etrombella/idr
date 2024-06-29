package com.opper.idir.batch;

import java.io.PrintWriter;
import java.io.StringWriter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.opper.idir.run.OpperBase;
import com.opper.idir.run.PopulateTable;


public class EntryPoint extends OpperBase {

	private static Logger logger = LoggerFactory.getLogger(EntryPoint.class);
	
	public static void main(String ar[]) throws Exception{
		EntryPoint entryPoint = new EntryPoint();
		entryPoint.run(ar[0]);
	}
	
	public void run(String parameter) throws Exception{
		try {
			logger.info("PATH: " + parameter);
			logger.info("START BATCH");
			PopulateTable populateTable = new PopulateTable(parameter);
			logger.info("START RUN POPULATE");
			populateTable.executeSqlScript("populate.sql");
			logger.info("END RUN POPULATE");
			logger.info("START RUN POPULATE");
			populateTable.executeSqlScript("populate_logistica.sql");
			logger.info("END RUN POPULATE");
			logger.info("END BATCH");
		}catch(Exception e) {
			sendEmail(e);
			logger.error("ERRORE BATCH: " + e.getMessage() + " ////////// " + e.getLocalizedMessage());
			StringWriter sw = new StringWriter();
			PrintWriter pw = new PrintWriter(sw);
			e.printStackTrace(pw);
			String sStackTrace = sw.toString(); // stack trace as a string
			logger.error(sStackTrace);
		}
	}
}