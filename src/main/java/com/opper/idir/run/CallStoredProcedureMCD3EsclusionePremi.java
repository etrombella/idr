package com.opper.idir.run;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class CallStoredProcedureMCD3EsclusionePremi {

	private static Logger logger = LoggerFactory.getLogger(CallStoredProcedureMCD3EsclusionePremi.class);
	private static final SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss.SSS");
	
	public static void main(String[] args) throws SQLException {
		
		logger.info("START STORED MCD3 ESCLUSIONE PREMI " + sdf.format(new Date()));
		call();
		logger.info("END STORED MCD3 ESCLUSIONE PREMI" + sdf.format(new Date()));
	}

	private static Connection getConnection() throws SQLException {

		return DriverManager.getConnection(
				"jdbc:sqlserver://svrsqldwh.idirspa.local:1433;instanceName=MSSQLSERVER;databaseName=opper;encrypt=true;trustServerCertificate=true",
				"opper", "opper2023");
	}

	private static void call() throws SQLException {

		try (Connection conn = getConnection();) {
			try (PreparedStatement statement = conn.prepareCall("TRUNCATE TABLE opper.dbo.IDIR_MDC3_ESCLUSIONE_PREMI");) {
				statement.execute();
			}
			try (CallableStatement statement = conn.prepareCall("{call PowerBI.dbo._PowerBI_MDC3_V_9_Esclusione_Premi(?,?)}");) {
				statement.setInt(1, 2023);
				statement.setInt(2, 11);
				try (ResultSet rs = statement.executeQuery();) {
					populateTable(conn, rs);
				}
			}
		}
	}

	private static void populateTable(Connection conn, ResultSet rs) throws SQLException {

		String scriptSql = "INSERT INTO opper.dbo.IDIR_MDC3_ESCLUSIONE_PREMI"+
				"("+
				"ListeRigheID"+
				",CapoArea"+
				",Agente"+
				",AgenteCodice"+
				",Cliente"+
				",ClienteCodice"+
				",ClientiFornitoriID"+
				",CausaleMagazzino"+
				",Documento"+
				",DataDocumento"+
				",NumeroDocumento"+
				",Precodice"+
				",Codice"+
				",Quantita"+
				",Importo"+
				",TipoMovimento"+
				",TipoRiga"+
				",TipoEsclusione"+
				",Classe"+
				",SottoClasse"+
				")VALUES("+
				"?,"+
				"?,"+
				"?,"+
				"?,"+
				"?,"+
				"?,"+
				"?,"+
				"?,"+
				"?,"+
				"?,"+
				"?,"+
				"?,"+
				"?,"+
				"?,"+
				"?,"+
				"?,"+
				"?,"+
				"?,"+
				"?,"+
				"?"+
				")";
		int index = 1;
		try {
			try (PreparedStatement preparedStatement = conn.prepareStatement(scriptSql);) {
				while (rs.next()) {
					try {
						preparedStatement.setInt(1, rs.getInt(1));
						preparedStatement.setString(2, rs.getString(2));
						preparedStatement.setString(3, rs.getString(3));
						preparedStatement.setInt(4, rs.getInt(4));
						preparedStatement.setString(5, rs.getString(5));
						preparedStatement.setString(6, rs.getString(6));
						preparedStatement.setInt(7, rs.getInt(7));
						preparedStatement.setString(8, rs.getString(8));
						preparedStatement.setString(9, rs.getString(9));
						preparedStatement.setDate(10, rs.getDate(10));
						preparedStatement.setInt(11, rs.getInt(11));
						preparedStatement.setString(12, rs.getString(12));
						preparedStatement.setString(13, rs.getString(13));
						preparedStatement.setFloat(14, rs.getFloat(14));
						preparedStatement.setFloat(15, rs.getFloat(15));
						preparedStatement.setString(16, rs.getString(16));
						preparedStatement.setString(17, rs.getString(17));
						preparedStatement.setString(18, rs.getString(18));
						preparedStatement.setString(19, rs.getString(19));
						preparedStatement.setString(20, rs.getString(20));
						preparedStatement.addBatch();
						if (index % 10000 == 0) {
							preparedStatement.executeBatch();
							preparedStatement.clearBatch();
						}
					} catch (Exception e) {
						logger.info("INDEX-INNER: " + index);
						e.printStackTrace();
					}

					index++;
				}
				preparedStatement.executeBatch();
				preparedStatement.clearBatch();
			}
		} catch (Exception e) {
			logger.info("INDEX: " + index);
			e.printStackTrace();
		}
	}
}
