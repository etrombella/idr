package com.opper.idir.batch;

import java.io.PrintWriter;
import java.io.StringWriter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.opper.idir.run.OpperBase;
import com.opper.idir.run.PopulateTable;
import com.opper.idir.run.PopulateTableRealTime;


public class BatchCaricamentoRealTime extends OpperBase {

	private static Logger logger = LoggerFactory.getLogger(BatchCaricamentoRealTime.class);
	
	public static void main(String ar[]) throws Exception{
		BatchCaricamentoRealTime entryPoint = new BatchCaricamentoRealTime();
		entryPoint.run(ar[0]);
	}
	
	public void run(String parameter) throws Exception{
		try {
			logger.info("PATH: " + parameter);
			logger.info("START BATCH");
			PopulateTableRealTime populateTable = new PopulateTableRealTime(parameter);
			logger.info("START RUN REAL TIME");
			populateTable.executeSqlScript("populateRealTime.sql");
			logger.info("END RUN REAL TIME");
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