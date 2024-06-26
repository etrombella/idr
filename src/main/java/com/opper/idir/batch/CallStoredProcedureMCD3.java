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

public class CallStoredProcedureMCD3 extends OpperBase{

	private static final SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss.SSS");

	public static void main(String[] args) throws Exception {
		logger.info("START STORED MCD3 " + sdf.format(new Date()));
		CallStoredProcedureMCD3 callStoredProcedureMCD3 = new CallStoredProcedureMCD3();
		callStoredProcedureMCD3.call();
		logger.info("END STORED MCD3 " + sdf.format(new Date()));
	}

	private Connection getConnection() throws SQLException {

		return DriverManager.getConnection(
				"jdbc:sqlserver://svrsqldwh.idirspa.local:1433;instanceName=MSSQLSERVER;databaseName=opper;encrypt=true;trustServerCertificate=true",
				"opper", "opper2023");
	}

	private void call() throws Exception {

		try (Connection conn = getConnection();) {
//			try (PreparedStatement statement = conn.prepareCall("TRUNCATE TABLE opper.dbo.IDIR_MDC3");) {
//				statement.execute();
//			}
//			try (CallableStatement statement = conn.prepareCall("{call PowerBI.dbo._PowerBI_MDC3_V_9_BIS(?,?)}");) {
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

	private static void populateTable(Connection conn) throws SQLException {

		String script = "INSERT INTO opper.dbo.IDIR_MDC3("
				+ "ANNO,MESE,AREA,AREA_SUB,STATO,REGIONE,SEGMENTAZIONE,PROGETTO,SETTORE,CAPOAREA,CAPOAREAIDCONTATTO,AGENTE,KPIAGENTEINCIDENZAPREMIOAC,CLIENTE,CLICOD,CLIENTECODICEALFANUMERICO,PAGAMENTO"
				+ ",PAGAMENTOTIPO,PAGAMENTOMEDIO,TIPOLOGIA,PARTITAIVA,CLIENTEANNOCORRMESECORRFATTURATO,CLIENTEANNOCORRMESECORRCOSTO,CLIENTEANNOCORRMESECORRMARGINE,CLIENTEMESECORRFATTURATO,CLIENTEMESECORRCOSTO"
				+ ",CLIENTEMESECORRMARGINE,CLIENTEANNOPRECMESECORRFATTURATO,CLIENTEANNOPRECMESECORRCOSTO,CLIENTEANNOPRECMESECORRMARGINE,CLIENTEMESECORRAPFATTURATO,CLIENTEMESECORRAPCOSTO,CLIENTEMESECORRAPMARGINE,CLIENTEANNOCORRPROGRESSIVOFATTURATO"
				+ ",CLIENTEANNOCORRPROGRESSIVOCOSTO,CLIENTEANNOCORRPROGRESSIVOMARGINE,CLIENTEANNOCORRENTEPROGRESSIVOMARGINE_PERC,CLIENTEANNOCORRPROIEZIONEFATTURATO,CLIENTEANNOCORRPROIEZIONECOSTO,CLIENTEANNOCORRPROIEZIONEMARGINE,CLIENTEANNOCORRENTEPROIEZIONEMARGINE_PERC,CLIENTEANNOPRECPROGRESSIVOFATTURATO"
				+ ",CLIENTEANNOPRECPROGRESSIVOCOSTO,CLIENTEANNOPRECPROGRESSIVOMARGINE,CLIENTEANNOPRECPROGRESSIVOMARGINE_PERC,CLIENTEANNOPRECTOTALEFATTURATO,CLIENTEANNOPRECTOTALECOSTO,CLIENTEANNOPRECTOTALEMARGINE,CLIENTEANNOPRECTOTALEMARGINE_PERC,CLIENTEANNOPREC_1PROGRESSIVOFATTURATO"
				+ ",CLIENTEANNOPREC_1PROGRESSIVOCOSTO,CLIENTEANNOPREC_1PROGRESSIVOMARGINE,CLIENTEANNOPREC_1PROGRESSIVOMARGINE_PERC,CLIENTEANNOPREC_1TOTALEFATTURATO,CLIENTEANNOPREC_1TOTALECOSTO,CLIENTEANNOPREC_1TOTALEMARGINE,CLIENTEANNOPREC_1TOTALEMARGINE_PERC,CLIENTEANNOCORRPROIEZIONEFATTURATOCLIENTIBUDGETRAGGIUNTO"
				+ ",CLIENTEANNOCORRPROGRESSIVOASTERISCATI,CLIENTEANNOCORRPROIEZIONEASTERISCATI,CLIENTEANNOCORRPROGRESSIVOSOTTOCLASSI,CLIENTEANNOCORRPROIEZIONESOTTOCLASSI,CLIENTEANNOCORRPROGRESSIVOPRECODICI,CLIENTEANNOCORRPROIEZIONEPRECODICI,CLIENTEANNOCORRPROGRESSIVOSOTTOCLASSIPRECODICI,CLIENTEANNOCORRPROIEZIONESOTTOCLASSIPRECODICI"
				+ ",CLIENTEANNOPRECPROGRESSIVOASTERISCATI,CLIENTEANNOPRECTOTALEASTERISCATI,CLIENTEANNOPREC_1PROGRESSIVOASTERISCATI,CLIENTEANNOPREC_1TOTALEASTERISCATI,CLIENTEBUDGETCONTRATTOANNO,CLIENTEBUDGETMINIMOANNO,CLIENTEBUDGETMINIMOANNOPROG,CLIENTESCAGLIONEINIZIALE,CLIENTESCAGLIONEFINALE,CLIENTEPERCENTUALEBONUS,CLIASTESC,BUDGETBASEINIZIALE,BUDGETBASEFINALE"
				+ ",BUDGETBASEBONUS_PERC,CLIASTESCLBUDGBASE,CLIENTEFATTURATOPREMIATO,CLIENTEPREMIO,CLIENTEPROVVIGIONEAGENTEANAGANNOCORR,CLIENTEPROVVIGIONEAGENTEANAGANNOCORRMESECORR,CLIENTEPROVVIGIONEAGENTEANAGANNOCORRPROIEZIONE,CLIENTEPROVVIGIONEAGENTEDOCANNOCORR,CLIENTEPROVVIGIONEAGENTEDOCANNOCORRPROIEZIONE,CLIENTEPROVVIGIONEAGENTEANAGANNOPREC"
				+ ",CLIENTEPROVVIGIONEAGENTEANAGANNOPRECPROIEZIONE,CLIENTEPROVVIGIONEAGENTEANAGANNOPRECTOTALE,CLIENTEPROVVIGIONEAGENTEANAG2ANNOPRECTOTALE,CLIENTEPROVVIGIONEAGENTEDOCANNOPREC,CLIENTEPROVVIGIONEAGENTEDOCANNOPRECPROIEZIONE,CAPOAREAFATTURATOANNOCORRMESECORR"
				+ ",CAPOAREAFATTURATOANNOCORRPROG,CAPOAREAPROVVIGIONIANNOCORRPROG,CLIENTEPROVVIGIONECAPOAREAANNOCORRMESECORR,CLIENTEPROVVIGIONECAPOAREAANNOCORR,CLIENTEPROVVIGIONECAPOAREAANNOCORR_PERC,CLIENTEPROVVIGIONECAPOAREAANNOCORRPROIEZIONE,CAPOAREAFATTURATOANNOPRECPROG"
				+ ",CAPOAREAPROVVIGIONIANNOPRECPROG,CLIENTEPROVVIGIONECAPOAREAANNOPREC,CLIENTEPROVVIGIONECAPOAREAANNOPREC_PERC,CLIENTEPROVVIGIONECAPOAREAANNOPRECPROIEZIONE,CLIENTEPROVVIGIONECAPOAREAANNOPRECTOTALE,CLIENTEPROVVIGIONECAPOAREA2ANNOPRECTOTALE,CLIENTEBRANDFATTURATO,CLIENTEBRANDPREMIO,GRUPPO,GRUPPOSCAGLIONEINIZIALE,GRUPPOSCAGLIONEFINALE,GRUPPOPERCENTUALEBONUS,GRUPPOCLIENTEFATTURATOPREMIATO,GRUPPOCLIENTEPREMIO,SEGMENTAZIONESCAGLIONEINIZIALE,SEGMENTAZIONESCAGLIONEFINALE"
				+ ",SEGMASTESCL,SEGMENTAZIONEFATTURATOPREMIATO,SEGMENTAZIONEPREMIO,SEGMENTAZIONECLIENTEFATTURATOPREMIATO,SEGMENTAZIONECLIENTEPREMIO,SC_PREC_CLIENTEFATTURATOPREMIATO,SC_PREC_CLIENTEFATTURATOPREMIO,CLIENTECOSTOTRASPORTOACMC"
				+ ",CLIENTECOSTOTRASPORTOACPROG,CLIENTERECUPEROTRASPORTOACMC,CLIENTERECUPEROTRASPORTOACPROG,CLIENTEGIORNICONSEGNAACMC,CLIENTEGIORNICONSEGNAACPROG,CLIENTECOSTOTRASPORTOACPROIEZ,CLIENTERECUPEROTRASPORTOACPROIEZ,CLIENTECOSTOTRASPORTOAPPROG"
				+ ",CLIENTERECUPEROTRASPORTOAPPROG,CLIENTEGIORNICONSEGNAAPPROG,CLIENTECOSTOTRASPORTOAPPROIEZ,CLIENTERECUPEROTRASPORTOAPPROIEZ,CLIENTECOSTOTRASPORTOAPTOTALE,CLIENTERECUPEROTRASPORTOAPTOTALE,CLIENTECOSTOTRASPORTO2APTOTALE,CLIENTERECUPEROTRASPORTO2APTOTALE"
				+ ",CLIENTEINSOLUTINUMEROACPROG,CLIENTEINSOLUTIVALOREACPROG,CLIENTEINSOLUTI_FATTACPROG,CLIENTEINSOLUTINUMEROAPPROG,CLIENTEINSOLUTIVALOREAPPROG,CLIENTEINSOLUTI_FATTAPPROG,CLIENTEINSOLUTINUMEROAPTOT,CLIENTEINSOLUTIVALOREAPTOT"
				+ ",CLIENTEINSOLUTI_FATTAPTOT,CLIENTEDSOAC,CLIENTEDSOAP,CLIENTEDSO2AP,CLIENTEDSOACMP,CLIENTEDSOAPMP,AGENTEDSOAC,AGENTEDSOAP,AGENTEDSO2AP,AGENTEDSOACMP,AGENTEDSOAPMP,AZIENDADSOAC,AZIENDADSOAP,AZIENDADSOACMP,AZIENDADSOAPMP,CERVEDFATTURATOAC,CERVEDACQUISTATOAC,TAGLIAAC,CERVEDFATTURATOAP,CERVEDACQUISTATOAP,TAGLIAAP,PREMIOANNOCORRMESECORR,PREMIOANNOCORRMESECORR_PERC,PREMIOANNOCORRPROG,PREMIOANNOCORRPROG_PER,PREMIOANNOCORRPROIEZIONE,PREMIOANNOCORRPROIEZIONE_PERC,PREMIOANNOPREC,PREMIOANNOPREC_PERC,PREMIO2ANNOPREC,PREMIO2ANNOPREC_PERC,PREMIOANNOPRECPROG,PREMIOANNOPRECPROG_PERC,MARKETSHAREAC,MARKETSHAREAP,MDCACPROG,MDCAPPROG,PUNTIDSO,PUNTISHARE,PUNTIFATTURATO,MAXGIORNI,MAXGIORNIMP,NUMARTACPROG,NUMARTAPPROG,PUNTIMDC,SCORE,CLUB)"
				+ " exec PowerBI.dbo._PowerBI_MDC3_V_9 @AnnoElaborazione=?, @MeseElaborazione=?";

		try (PreparedStatement preparedStatement = conn.prepareStatement(script);) {
			Calendar calendar = new GregorianCalendar();
			preparedStatement.setInt(1, calendar.get(Calendar.YEAR));
			preparedStatement.setInt(2, calendar.get(Calendar.MONTH) + 1);
			preparedStatement.execute();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
