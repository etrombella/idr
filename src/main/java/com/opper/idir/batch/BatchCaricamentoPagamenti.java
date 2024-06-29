package com.opper.idir.batch;

import java.io.PrintWriter;
import java.io.StringWriter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.opper.idir.run.OpperBase;
import com.opper.idir.run.Pagamenti;

public class BatchCaricamentoPagamenti extends OpperBase{
	
	private static Logger logger = LoggerFactory.getLogger(BatchCaricamentoPagamenti.class);

	public static void main(String ar[]) throws Exception {
		BatchCaricamentoPagamenti batchCaricamentoPagamenti = new BatchCaricamentoPagamenti();
		batchCaricamentoPagamenti.run(ar[0]);
	}
	
	public void run(String parameter) throws Exception {
		try {
			logger.info("START BATCH");
			logger.info("PATH: " + parameter);
			Pagamenti pagamenti = new Pagamenti(parameter);
			logger.info("START RUN POPULATE");
			pagamenti.run();
			logger.info("END RUN POPULATE");
			logger.info("END BATCH");
		} catch (Exception e) {
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
