package com.opper.idir.batch;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import com.opper.idir.run.OpperBase;

public class CallStoredProcedureMCD3EsclusionePremi  extends OpperBase{

	private static final SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss.SSS");

	public static void main(String[] args) throws Exception {

		logger.info("START STORED MCD3 ESCLUSIONE PREMI " + sdf.format(new Date()));
		CallStoredProcedureMCD3EsclusionePremi callStoredProcedureMCD3EsclusionePremi = new CallStoredProcedureMCD3EsclusionePremi();
		callStoredProcedureMCD3EsclusionePremi.call();
		logger.info("END STORED MCD3 ESCLUSIONE PREMI" + sdf.format(new Date()));
	}

	private Connection getConnection() throws SQLException {

		return DriverManager.getConnection(
				"jdbc:sqlserver://svrsqldwh.idirspa.local:1433;instanceName=MSSQLSERVER;databaseName=opper;encrypt=true;trustServerCertificate=true",
				"opper", "opper2023");
	}

	private void call() throws Exception {

		try (Connection conn = getConnection();) {
//			try (PreparedStatement statement = conn.prepareCall("TRUNCATE TABLE opper.dbo.IDIR_MDC3_ESCLUSIONE_PREMI");) {
//				statement.execute();
//			}
//			try (CallableStatement statement = conn.prepareCall("{call PowerBI.dbo._PowerBI_MDC3_V_9_Esclusione_Premi(?,?)}");) {
//				Calendar calendar = new GregorianCalendar();
//				statement.setInt(1, calendar.get(Calendar.YEAR));
//				statement.setInt(2, calendar.get(Calendar.MONTH +1));
//				try (ResultSet rs = statement.executeQuery();) {
			populateTable(conn);
//				}
//			}
		}catch(Exception e) {
			sendEmail(e);
			throw e;
		}
	}

	private void populateTable(Connection conn) throws SQLException {

		String scriptSql = "INSERT INTO opper.dbo.IDIR_MDC3_ESCLUSIONE_PREMI"
				+ "(ListeRigheID,CapoArea,Agente,AgenteCodice,Cliente,ClienteCodice,ClientiFornitoriID"
				+ ",CausaleMagazzino,Documento,DataDocumento,NumeroDocumento,Precodice,Codice"
				+ ",Quantita,Importo,TipoMovimento,TipoRiga,TipoEsclusione,Classe,SottoClasse) "
				+ "exec PowerBI.dbo._PowerBI_MDC3_V_9_Esclusione_Premi @AnnoElaborazione=?, @MeseElaborazione=?";
		try (PreparedStatement preparedStatement = conn.prepareStatement(scriptSql);) {
			Calendar calendar = new GregorianCalendar();
			preparedStatement.setInt(1, calendar.get(Calendar.YEAR));
			preparedStatement.setInt(2, calendar.get(Calendar.MONTH) + 1);
			preparedStatement.execute();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
