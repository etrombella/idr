package com.opper.idir.batch;

import java.io.PrintWriter;
import java.io.StringWriter;

import com.opper.idir.run.OpperBase;
import com.opper.idir.run.RicercheSchedulate;

public class BatchCaricamentoRicercheSchedulate extends OpperBase {
	
	public static void main(String ar[]) throws Exception {
		BatchCaricamentoRicercheSchedulate batchCaricamentoRicercheSchedulate = new BatchCaricamentoRicercheSchedulate();
		batchCaricamentoRicercheSchedulate.run(ar[0]);
	}
	
	public void run(String parameter) throws Exception {
		try {
			logger.info("PATH: " + parameter);
			logger.info("START BATCH");
			RicercheSchedulate ricercheSchedulate = new RicercheSchedulate(parameter);
			logger.info("START RUN RICERCHE SCHEDULATE");
			ricercheSchedulate.run();
			logger.info("END RUN RICERCHE SCHEDULATE");
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