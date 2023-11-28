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

public class CallStoredProcedureMCD3 {

	private static Logger logger = LoggerFactory.getLogger(CallStoredProcedureMCD3.class);
	private static final SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss.SSS");
	
	public static void main(String[] args) throws SQLException {
		logger.info("START STORED MCD3 " + sdf.format(new Date()));
		call();
		logger.info("END STORED MCD3 " + sdf.format(new Date()));
	}

	private static Connection getConnection() throws SQLException {

		return DriverManager.getConnection(
				"jdbc:sqlserver://svrsqldwh.idirspa.local:1433;instanceName=MSSQLSERVER;databaseName=opper;encrypt=true;trustServerCertificate=true",
				"opper", "opper2023");
	}

	private static void call() throws SQLException {

		try (Connection conn = getConnection();) {
			try (PreparedStatement statement = conn.prepareCall("TRUNCATE TABLE opper.dbo.IDIR_MDC3");) {
				statement.execute();
			}
			try (CallableStatement statement = conn.prepareCall("{call PowerBI.dbo._PowerBI_MDC3_V_9(?,?)}");) {
				statement.setInt(1, 2023);
				statement.setInt(2, 11);
				try (ResultSet rs = statement.executeQuery();) {
					populateTable(conn, rs);
				}
			}
		}
	}

	private static void populateTable(Connection conn, ResultSet rs) throws SQLException {

		String scriptSql = "INSERT INTO opper.dbo.IDIR_MDC3("+
				"ANNO,MESE,AREA,AREA_SUB,STATO,REGIONE,SEGMENTAZIONE,PROGETTO,SETTORE,CAPOAREA,CAPOAREAIDCONTATTO,AGENTE,KPIAGENTEINCIDENZAPREMIOAC,CLIENTE,CLICOD,CLIENTECODICEALFANUMERICO,PAGAMENTO"+
				",PAGAMENTOTIPO,PAGAMENTOMEDIO,TIPOLOGIA,PARTITAIVA,CLIENTEANNOCORRMESECORRFATTURATO,CLIENTEANNOCORRMESECORRCOSTO,CLIENTEANNOCORRMESECORRMARGINE,CLIENTEMESECORRFATTURATO,CLIENTEMESECORRCOSTO"+
				",CLIENTEMESECORRMARGINE,CLIENTEANNOPRECMESECORRFATTURATO,CLIENTEANNOPRECMESECORRCOSTO,CLIENTEANNOPRECMESECORRMARGINE,CLIENTEMESECORRAPFATTURATO,CLIENTEMESECORRAPCOSTO,CLIENTEMESECORRAPMARGINE,CLIENTEANNOCORRPROGRESSIVOFATTURATO"+
				",CLIENTEANNOCORRPROGRESSIVOCOSTO,CLIENTEANNOCORRPROGRESSIVOMARGINE,CLIENTEANNOCORRENTEPROGRESSIVOMARGINE,CLIENTEANNOCORRPROIEZIONEFATTURATO,CLIENTEANNOCORRPROIEZIONECOSTO,CLIENTEANNOCORRPROIEZIONEMARGINE,CLIENTEANNOCORRENTEPROIEZIONEMARGINE,CLIENTEANNOPRECPROGRESSIVOFATTURATO"+
				",CLIENTEANNOPRECPROGRESSIVOCOSTO,CLIENTEANNOPRECPROGRESSIVOMARGINE,CLIENTEANNOPRECPROGRESSIVOMARGINE_PERC,CLIENTEANNOPRECTOTALEFATTURATO,CLIENTEANNOPRECTOTALECOSTO,CLIENTEANNOPRECTOTALEMARGINE,CLIENTEANNOPRECTOTALEMARGINE_PERC,CLIENTEANNOPREC_1PROGRESSIVOFATTURATO"+
				",CLIENTEANNOPREC_1PROGRESSIVOCOSTO,CLIENTEANNOPREC_1PROGRESSIVOMARGINE,CLIENTEANNOPREC_1PROGRESSIVOMARGINE_PERC,CLIENTEANNOPREC_1TOTALEFATTURATO,CLIENTEANNOPREC_1TOTALECOSTO,CLIENTEANNOPREC_1TOTALEMARGINE,CLIENTEANNOPREC_1TOTALEMARGINE_PERC,CLIENTEANNOCORRPROIEZIONEFATTURATOCLIENTIBUDGETRAGGIUNTO"+
				",CLIENTEANNOCORRPROGRESSIVOASTERISCATI,CLIENTEANNOCORRPROIEZIONEASTERISCATI,CLIENTEANNOCORRPROGRESSIVOSOTTOCLASSI,CLIENTEANNOCORRPROIEZIONESOTTOCLASSI,CLIENTEANNOCORRPROGRESSIVOPRECODICI,CLIENTEANNOCORRPROIEZIONEPRECODICI,CLIENTEANNOCORRPROGRESSIVOSOTTOCLASSIPRECODICI,CLIENTEANNOCORRPROIEZIONESOTTOCLASSIPRECODICI"+
				",CLIENTEANNOPRECPROGRESSIVOASTERISCATI,CLIENTEANNOPRECTOTALEASTERISCATI,CLIENTEANNOPREC_1PROGRESSIVOASTERISCATI,CLIENTEANNOPREC_1TOTALEASTERISCATI,CLIENTEBUDGETCONTRATTOANNO,CLIENTEBUDGETMINIMOANNO,CLIENTEBUDGETMINIMOANNOPROG,CLIENTESCAGLIONEINIZIALE,CLIENTESCAGLIONEFINALE,CLIENTEPERCENTUALEBONUS,CLIASTESC,BUDGETBASEINIZIALE,BUDGETBASEFINALE"+
				",BUDGETBASEBONUS,CLIASTESCLBUDGBASE,CLIENTEFATTURATOPREMIATO,CLIENTEPREMIO,CLIENTEPROVVIGIONEAGENTEANAGANNOCORR,CLIENTEPROVVIGIONEAGENTEANAGANNOCORRMESECORR,CLIENTEPROVVIGIONEAGENTEANAGANNOCORRPROIEZIONE,CLIENTEPROVVIGIONEAGENTEDOCANNOCORR,CLIENTEPROVVIGIONEAGENTEDOCANNOCORRPROIEZIONE,CLIENTEPROVVIGIONEAGENTEANAGANNOPREC"+
				",CLIENTEPROVVIGIONEAGENTEANAGANNOPRECPROIEZIONE,CLIENTEPROVVIGIONEAGENTEANAGANNOPRECTOTALE,CLIENTEPROVVIGIONEAGENTEANAG2ANNOPRECTOTALE,CLIENTEPROVVIGIONEAGENTEDOCANNOPREC,CLIENTEPROVVIGIONEAGENTEDOCANNOPRECPROIEZIONE,CAPOAREAFATTURATOANNOCORRMESECORR"+
				",CAPOAREAFATTURATOANNOCORRPROG,CAPOAREAPROVVIGIONIANNOCORRPROG,CLIENTEPROVVIGIONECAPOAREAANNOCORRMESECORR,CLIENTEPROVVIGIONECAPOAREAANNOCORR,CLIENTEPROVVIGIONECAPOAREAANNOCORR_PERC,CLIENTEPROVVIGIONECAPOAREAANNOCORRPROIEZIONE,CAPOAREAFATTURATOANNOPRECPROG"+
				",CAPOAREAPROVVIGIONIANNOPRECPROG,CLIENTEPROVVIGIONECAPOAREAANNOPREC,CLIENTEPROVVIGIONECAPOAREAANNOPREC_PERC,CLIENTEPROVVIGIONECAPOAREAANNOPRECPROIEZIONE,CLIENTEPROVVIGIONECAPOAREAANNOPRECTOTALE,CLIENTEPROVVIGIONECAPOAREA2ANNOPRECTOTALE,CLIENTEBRANDFATTURATO,CLIENTEBRANDPREMIO,GRUPPOSCAGLIONEINIZIALE,GRUPPOSCAGLIONEFINALE,GRUPPOPERCENTUALEBONUS,GRUPPOCLIENTEFATTURATOPREMIATO,GRUPPOCLIENTEPREMIO,SEGMENTAZIONESCAGLIONEINIZIALE,SEGMENTAZIONESCAGLIONEFINALE"+
				",SEGMASTESCL,SEGMENTAZIONEFATTURATOPREMIATO,SEGMENTAZIONEPREMIO,SEGMENTAZIONECLIENTEFATTURATOPREMIATO,SEGMENTAZIONECLIENTEPREMIO,SC_PREC_CLIENTEFATTURATOPREMIATO,SC_PREC_CLIENTEFATTURATOPREMIO,CLIENTECOSTOTRASPORTOACMC"+
				",CLIENTECOSTOTRASPORTOACPROG,CLIENTERECUPEROTRASPORTOACMC,CLIENTERECUPEROTRASPORTOACPROG,CLIENTEGIORNICONSEGNAACMC,CLIENTEGIORNICONSEGNAACPROG,CLIENTECOSTOTRASPORTOACPROIEZ,CLIENTERECUPEROTRASPORTOACPROIEZ,CLIENTECOSTOTRASPORTOAPPROG"+
				",CLIENTERECUPEROTRASPORTOAPPROG,CLIENTEGIORNICONSEGNAAPPROG,CLIENTECOSTOTRASPORTOAPPROIEZ,CLIENTERECUPEROTRASPORTOAPPROIEZ,CLIENTECOSTOTRASPORTOAPTOTALE,CLIENTERECUPEROTRASPORTOAPTOTALE,CLIENTECOSTOTRASPORTO2APTOTALE,CLIENTERECUPEROTRASPORTO2APTOTALE"+
				",CLIENTEINSOLUTINUMEROACPROG,CLIENTEINSOLUTIVALOREACPROG,CLIENTEINSOLUTI_FATTACPROG,CLIENTEINSOLUTINUMEROAPPROG,CLIENTEINSOLUTIVALOREAPPROG,CLIENTEINSOLUTI_FATTAPPROG,CLIENTEINSOLUTINUMEROAPTOT,CLIENTEINSOLUTIVALOREAPTOT"+
				",CLIENTEINSOLUTI_FATTAPTOT,CLIENTEDSOAC,CLIENTEDSOAP,CLIENTEDSO2AP,CLIENTEDSOACMP,CLIENTEDSOAPMP,AGENTEDSOAC,AGENTEDSOAP,AGENTEDSO2AP,AGENTEDSOACMP,AGENTEDSOAPMP,AZIENDADSOAC,AZIENDADSOAP,AZIENDADSOACMP,AZIENDADSOAPMP,CERVEDFATTURATOAC,CERVEDACQUISTATOAC,TAGLIAAC,CERVEDFATTURATOAP,CERVEDACQUISTATOAP,TAGLIAAP,PREMIOANNOCORRMESECORR,PREMIOANNOCORRMESECORR_PERC,PREMIOANNOCORRPROG,PREMIOANNOCORRPROG_PER,PREMIOANNOCORRPROIEZIONE,PREMIOANNOCORRPROIEZIONE_PERC,PREMIOANNOPREC,PREMIOANNOPREC_PERC,PREMIO2ANNOPREC,PREMIO2ANNOPREC_PERC,PREMIOANNOPRECPROG,PREMIOANNOPRECPROG_PERC,MARKETSHAREAC,MARKETSHAREAP,MDCACPROG,MDCAPPROG,PUNTIDSO,PUNTISHARE,PUNTIFATTURATO,MAXGIORNI,MAXGIORNIMP,NUMARTACPROG,NUMARTAPPROG,PUNTIMDC,SCORE,CLUB)VALUES("+
				"?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		int index = 1;
		try {
			try (PreparedStatement preparedStatement = conn.prepareStatement(scriptSql);) {
				while (rs.next()) {
					try {
						preparedStatement.setString(1, rs.getString(1));
						preparedStatement.setString(2, rs.getString(2));
						preparedStatement.setString(3, rs.getString(3));
						preparedStatement.setString(4, rs.getString(4));
						preparedStatement.setString(5, rs.getString(5));
						preparedStatement.setString(6, rs.getString(6));
						preparedStatement.setString(7, rs.getString(7));
						preparedStatement.setString(8, rs.getString(8));
						preparedStatement.setString(9, rs.getString(9));
						preparedStatement.setString(10, rs.getString(10));
						preparedStatement.setString(11, rs.getString(11));
						preparedStatement.setString(12, rs.getString(12));
						preparedStatement.setString(13, rs.getString(13));
						preparedStatement.setString(14, rs.getString(14));
						preparedStatement.setString(15, rs.getString(15));
						preparedStatement.setString(16, rs.getString(16));
						preparedStatement.setString(17, rs.getString(17));
						preparedStatement.setString(18, rs.getString(18));
						preparedStatement.setString(19, rs.getString(19));
						preparedStatement.setString(20, rs.getString(20));
						preparedStatement.setString(21, rs.getString(21));
						preparedStatement.setString(22, rs.getString(22));
						preparedStatement.setString(23, rs.getString(23));
						preparedStatement.setString(24, rs.getString(24));
						preparedStatement.setString(25, rs.getString(25));
						preparedStatement.setString(26, rs.getString(26));
						preparedStatement.setString(27, rs.getString(27));
						preparedStatement.setString(28, rs.getString(28));
						preparedStatement.setString(29, rs.getString(29));
						preparedStatement.setString(30, rs.getString(30));
						preparedStatement.setString(31, rs.getString(31));
						preparedStatement.setString(32, rs.getString(32));
						preparedStatement.setString(33, rs.getString(33));
						preparedStatement.setString(34, rs.getString(34));
						preparedStatement.setString(35, rs.getString(35));
						preparedStatement.setString(36, rs.getString(36));
						preparedStatement.setString(37, rs.getString(37));
						preparedStatement.setString(38, rs.getString(38));
						preparedStatement.setString(39, rs.getString(39));
						preparedStatement.setString(40, rs.getString(40));
						preparedStatement.setString(41, rs.getString(41));
						preparedStatement.setString(42, rs.getString(42));
						preparedStatement.setString(43, rs.getString(43));
						preparedStatement.setString(44, rs.getString(44));
						preparedStatement.setString(45, rs.getString(45));
						preparedStatement.setString(46, rs.getString(46));
						preparedStatement.setString(47, rs.getString(47));
						preparedStatement.setString(48, rs.getString(48));
						preparedStatement.setString(49, rs.getString(49));
						preparedStatement.setString(50, rs.getString(50));
						preparedStatement.setString(51, rs.getString(51));
						preparedStatement.setString(52, rs.getString(52));
						preparedStatement.setString(53, rs.getString(53));
						preparedStatement.setString(54, rs.getString(54));
						preparedStatement.setString(55, rs.getString(55));
						preparedStatement.setString(56, rs.getString(56));
						preparedStatement.setString(57, rs.getString(57));
						preparedStatement.setString(58, rs.getString(58));
						preparedStatement.setString(59, rs.getString(59));
						preparedStatement.setString(60, rs.getString(60));
						preparedStatement.setString(61, rs.getString(61));
						preparedStatement.setString(62, rs.getString(62));
						preparedStatement.setString(63, rs.getString(63));
						preparedStatement.setString(64, rs.getString(64));
						preparedStatement.setString(65, rs.getString(65));
						preparedStatement.setString(66, rs.getString(66));
						preparedStatement.setString(67, rs.getString(67));
						preparedStatement.setString(68, rs.getString(68));
						preparedStatement.setString(69, rs.getString(69));
						preparedStatement.setString(70, rs.getString(70));
						preparedStatement.setString(71, rs.getString(71));
						preparedStatement.setString(72, rs.getString(72));
						preparedStatement.setString(73, rs.getString(73));
						preparedStatement.setString(74, rs.getString(74));
						preparedStatement.setString(75, rs.getString(75));
						preparedStatement.setString(76, rs.getString(76));
						preparedStatement.setString(77, rs.getString(77));
						preparedStatement.setString(78, rs.getString(78));
						preparedStatement.setString(79, rs.getString(79));
						preparedStatement.setString(80, rs.getString(80));
						preparedStatement.setString(81, rs.getString(81));
						preparedStatement.setString(82, rs.getString(82));
						preparedStatement.setString(83, rs.getString(83));
						preparedStatement.setString(84, rs.getString(84));
						preparedStatement.setString(85, rs.getString(85));
						preparedStatement.setString(86, rs.getString(86));
						preparedStatement.setString(87, rs.getString(87));
						preparedStatement.setString(88, rs.getString(88));
						preparedStatement.setString(89, rs.getString(89));
						preparedStatement.setString(90, rs.getString(90));
						preparedStatement.setString(91, rs.getString(91));
						preparedStatement.setString(92, rs.getString(92));
						preparedStatement.setString(93, rs.getString(93));
						preparedStatement.setString(94, rs.getString(94));
						preparedStatement.setString(95, rs.getString(95));
						preparedStatement.setString(96, rs.getString(96));
						preparedStatement.setString(97, rs.getString(97));
						preparedStatement.setString(98, rs.getString(98));
						preparedStatement.setString(99, rs.getString(99));
						preparedStatement.setString(100, rs.getString(100));
						preparedStatement.setString(101, rs.getString(101));
						preparedStatement.setString(102, rs.getString(102));
						preparedStatement.setString(103, rs.getString(103));
						preparedStatement.setString(104, rs.getString(104));
						preparedStatement.setString(105, rs.getString(105));
						preparedStatement.setString(106, rs.getString(106));
						preparedStatement.setString(107, rs.getString(107));
						preparedStatement.setString(108, rs.getString(108));
						preparedStatement.setString(109, rs.getString(109));
						preparedStatement.setString(110, rs.getString(110));
						preparedStatement.setString(111, rs.getString(111));
						preparedStatement.setString(112, rs.getString(112));
						preparedStatement.setString(113, rs.getString(113));
						preparedStatement.setString(114, rs.getString(114));
						preparedStatement.setString(115, rs.getString(115));
						preparedStatement.setString(116, rs.getString(116));
						preparedStatement.setString(117, rs.getString(117));
						preparedStatement.setString(118, rs.getString(118));
						preparedStatement.setString(119, rs.getString(119));
						preparedStatement.setString(120, rs.getString(120));
						preparedStatement.setString(121, rs.getString(121));
						preparedStatement.setString(122, rs.getString(122));
						preparedStatement.setString(123, rs.getString(123));
						preparedStatement.setString(124, rs.getString(124));
						preparedStatement.setString(125, rs.getString(125));
						preparedStatement.setString(126, rs.getString(126));
						preparedStatement.setString(127, rs.getString(127));
						preparedStatement.setString(128, rs.getString(128));
						preparedStatement.setString(129, rs.getString(129));
						preparedStatement.setString(130, rs.getString(130));
						preparedStatement.setString(131, rs.getString(131));
						preparedStatement.setString(132, rs.getString(132));
						preparedStatement.setString(133, rs.getString(133));
						preparedStatement.setString(134, rs.getString(134));
						preparedStatement.setString(135, rs.getString(135));
						preparedStatement.setString(136, rs.getString(136));
						preparedStatement.setString(137, rs.getString(137));
						preparedStatement.setString(138, rs.getString(138));
						preparedStatement.setString(139, rs.getString(139));
						preparedStatement.setString(140, rs.getString(140));
						preparedStatement.setString(141, rs.getString(141));
						preparedStatement.setString(142, rs.getString(142));
						preparedStatement.setString(143, rs.getString(143));
						preparedStatement.setString(144, rs.getString(144));
						preparedStatement.setString(145, rs.getString(145));
						preparedStatement.setString(146, rs.getString(146));
						preparedStatement.setString(147, rs.getString(147));
						preparedStatement.setString(148, rs.getString(148));
						preparedStatement.setString(149, rs.getString(149));
						preparedStatement.setString(150, rs.getString(150));
						preparedStatement.setString(151, rs.getString(151));
						preparedStatement.setString(152, rs.getString(152));
						preparedStatement.setString(153, rs.getString(153));
						preparedStatement.setString(154, rs.getString(154));
						preparedStatement.setString(155, rs.getString(155));
						preparedStatement.setString(156, rs.getString(156));
						preparedStatement.setString(157, rs.getString(157));
						preparedStatement.setString(158, rs.getString(158));
						preparedStatement.setString(159, rs.getString(159));
						preparedStatement.setString(160, rs.getString(160));
						preparedStatement.setString(161, rs.getString(161));
						preparedStatement.setString(162, rs.getString(162));
						preparedStatement.setString(163, rs.getString(163));
						preparedStatement.setString(164, rs.getString(164));
						preparedStatement.setString(165, rs.getString(165));
						preparedStatement.setString(166, rs.getString(166));
						preparedStatement.setString(167, rs.getString(167));
						preparedStatement.setString(168, rs.getString(168));
						preparedStatement.setString(169, rs.getString(169));
						preparedStatement.setString(170, rs.getString(170));
						preparedStatement.setString(171, rs.getString(171));
						preparedStatement.setString(172, rs.getString(172));
						preparedStatement.setString(173, rs.getString(173));
						preparedStatement.setString(174, rs.getString(174));
						preparedStatement.setString(175, rs.getString(175));
						preparedStatement.setString(176, rs.getString(176));
						preparedStatement.setString(177, rs.getString(177));
						preparedStatement.setString(178, rs.getString(178));
						preparedStatement.setString(179, rs.getString(179));
						preparedStatement.setString(180, rs.getString(180));
						preparedStatement.setString(181, rs.getString(181));
						preparedStatement.setString(182, rs.getString(182));
						preparedStatement.setString(183, rs.getString(183));
						preparedStatement.setString(184, rs.getString(184));
						preparedStatement.setString(185, rs.getString(185));
						preparedStatement.setString(186, rs.getString(186));
						preparedStatement.setString(187, rs.getString(187));
						preparedStatement.setString(188, rs.getString(188));
						preparedStatement.setString(189, rs.getString(189));
						preparedStatement.setString(190, rs.getString(190));
						preparedStatement.setString(191, rs.getString(191));
						preparedStatement.setString(192, rs.getString(192));
						preparedStatement.setString(193, rs.getString(193));
						preparedStatement.setString(194, rs.getString(194));
						preparedStatement.setString(195, rs.getString(195));
						preparedStatement.setString(196, rs.getString(196));
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
