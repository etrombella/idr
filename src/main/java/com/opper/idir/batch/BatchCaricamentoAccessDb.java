package com.opper.idir.batch;

import java.io.PrintWriter;
import java.io.StringWriter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.opper.idir.run.AccessDb;
import com.opper.idir.run.OpperBase;

public class BatchCaricamentoAccessDb extends OpperBase{
	
	private static Logger logger = LoggerFactory.getLogger(BatchCaricamentoAccessDb.class);

	public static void main(String ar[]) throws Exception {
		BatchCaricamentoAccessDb batchCaricamentoPagamenti = new BatchCaricamentoAccessDb();
		batchCaricamentoPagamenti.run(ar[0]);
	}
	
	public void run(String parameter) throws Exception {
		try {
			logger.info("START BATCH");
			logger.info("PATH: " + parameter);
			AccessDb accessDb = new AccessDb(parameter);
			logger.info("START RUN POPULATE ACCESS DB");
			accessDb.rimuoviSpaziNomeFile();
			accessDb.run();
			accessDb.rinominaFileElaborati();
			logger.info("END RUN POPULATE ACCESS DB");
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
