package com.opper.idir.run;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Date;
import java.util.Properties;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.healthmarketscience.jackcess.Database;
import com.healthmarketscience.jackcess.DatabaseBuilder;
import com.healthmarketscience.jackcess.Table;

public class AccessDb {

	private static Logger logger = LoggerFactory.getLogger(AccessDb.class);

	private Properties properties;

	private String pathFile;
	
	private String pathDbAccess;
	
	private static final String IDIR_CMR = "INSERT INTO opper.dbo. IDIR_CMR(ID_CMR,Anno,Numero,ClienteFornitoreID,DestinazioneContatto,DestinazioneContattoID,LuogoPresa,DataPresa,IstruzioniMittente,PagamentoNoloID,Rimborso,ConvenzioniParticolari,CompilatoA,CompilatoIl,VettoreID,VettoreID_2,TargaMotrice,TargaRimorchio,DataFatturaTrasportatore,NumeroFatturaTrasportatore,CostoTraportatore,DocumentiRicevuti,DocumentiInBusta,MRN,FattureNsCopie,CmrAltriVettori,CmrControFirmati,Archiviato)VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	private static final String IDIR_CMR_TRUNCATE = "TRUNCATE TABLE opper.dbo. IDIR_CMR";

	private static final String IDIR_CMR_COLLI = "INSERT INTO opper.dbo.IDIR_CMR_Colli(ID,Collo)VALUES(?,?)";
	private static final String IDIR_CMR_COLLI_TRUNCATE = "TRUNCATE TABLE opper.dbo.IDIR_CMR_Colli";
	
	private static final String IDIR_CMR_CONTRASSEGNI = "INSERT INTO opper.dbo.IDIR_CMR_Contrassegni(ID_Contrassegni,ColloID,NumeroColli,ImballaggioID,TipoMerceID,StatisticaID,PesoLordoKg,VolumeM3,ID_Cmr) VALUES(?,?,?,?,?,?,?,?,?)";
	private static final String IDIR_CMR_CONTRASSEGNI_TRUNCATE = "TRUNCATE TABLE opper.dbo.IDIR_CMR_Contrassegni";
	
	private static final String IDIR_CMR_DOCUMENTI = "INSERT INTO opper.dbo.IDIR_CMR_Documenti(ID_Documento,EsercizioID,DocumentoID,ListeDocumentiID,ListeDocumentiNumero,VettoreID,PortoID,ID_Cmr)VALUES(?,?,?,?,?,?,?,?)";
	private static final String IDIR_CMR_DOCUMENTI_TRUNCATE = "TRUNCATE TABLE opper.dbo.IDIR_CMR_Documenti";
	
	private static final String IDIR_CMR_IMBALLAGGI = "INSERT INTO opper.dbo.IDIR_CMR_Imballaggi(ID,Imballaggio)VALUES(?,?)";
	private static final String IDIR_CMR_IMBALLAGGI_TRUNCATE = "TRUNCATE TABLE opper.dbo.IDIR_CMR_Imballaggi";
	
	private static final String IDIR_CMR_NUMERATORE = "INSERT INTO opper.dbo.IDIR_CMR_Numeratore(ID,Anno,Numero,Corrente,EsercizioID)VALUES(?,?,?,?,?)";
	private static final String IDIR_CMR_NUMERATORE_TRUNCATE = "TRUNCATE TABLE opper.dbo.IDIR_CMR_Numeratore";
	
	private static final String IDIR_CMR_PAGAMENTO_NOLI = "INSERT INTO opper.dbo.IDIR_CMR_Pagamento_Noli(ID,Pagamento_Noli)VALUES(?,?)";
	private static final String IDIR_CMR_PAGAMENTO_NOLI_TRUNCATE = "TRUNCATE TABLE opper.dbo.IDIR_CMR_Pagamento_Noli";
	
	private static final String IDIR_CMR_STATISTICA = "INSERT INTO opper.dbo.IDIR_CMR_Statistica(ID,Statistica)VALUES(?,?)";
	private static final String IDIR_CMR_STATISTICA_TRUNCATE = "TRUNCATE TABLE opper.dbo.IDIR_CMR_Statistica";
	
	private static final String IDIR_CMR_TIPO_MERCE = "INSERT INTO opper.dbo.IDIR_CMR_TipoMerce(ID,TipoMerce)VALUES(?,?)";
	private static final String IDIR_CMR_TIPO_MERCE_TRUNCATE = "TRUNCATE TABLE opper.dbo.IDIR_CMR_TipoMerce";
	
	

	public AccessDb(String pathFile) throws IOException {

		this.pathFile = pathFile;
		readPropertiesFile();
		this.pathDbAccess = properties.getProperty("pathDbAccess");
	}

	public void run() throws IOException, ParseException, SQLException {

		Database opper = DatabaseBuilder.open(new File(this.pathDbAccess));
	    Set<String> tableName = opper.getTableNames();
		Connection connectionDb = null;
		try {
			connectionDb = getConnection();
		    for(String key : tableName) {
		    	logger.info("TABLE: " + key);		
			    Table table = opper.getTable(key);
//			    if("IDIR_CMR".equals(key)) 
//			    	insertIDIR_CMR(table, connectionDb);
//			    if("IDIR_CMR_Colli".equals(key)) 
//			    	insertIDIR_CMR_Colli(table, connectionDb);
//			    if("IDIR_CMR_Contrassegni".equals(key)) 
//			    	insertIDIR_CMR_Contrassegni(table, connectionDb);
//			    if("IDIR_CMR_Documenti".equals(key)) 
//		    		insertIDIR_CMR_Documenti(table, connectionDb);
//			    if("IDIR_CMR_Imballaggi".equals(key)) 
//	    			insertIDIR_CMR_Imballaggi(table, connectionDb);
//			    if("IDIR_CMR_Numeratore".equals(key)) 
//					insertIDIR_CMR_Numeratore(table, connectionDb);
//			    if("IDIR_CMR_Pagamento_Noli".equals(key)) 
//					insertIDIR_CMR_Pagamento_Noli(table, connectionDb);
//			    if("IDIR_CMR_Statistica".equals(key)) 
//					insertIDIR_CMR_Statistica(table, connectionDb);
//			    if("IDIR_CMR_TipoMerce".equals(key)) 
//					insertIDIR_CMR_TipoMerce(table, connectionDb);
		    }
		} finally {
			try {
				if (connectionDb != null)
					connectionDb.close();
			} catch (Exception e) {
				StringWriter sw = new StringWriter();
				PrintWriter pw = new PrintWriter(sw);
				e.printStackTrace(pw);
				String sStackTrace = sw.toString(); // stack trace as a string
				logger.error(sStackTrace);
			}
		}		
	}

	private void insertIDIR_CMR_Colli(Table table, Connection connectionDb) throws SQLException {
		
			try (PreparedStatement preparedStatement = connectionDb.prepareStatement(IDIR_CMR_COLLI_TRUNCATE);) {
				preparedStatement.execute();
			}catch (Exception e) {
    			StringWriter sw = new StringWriter();
    			PrintWriter pw = new PrintWriter(sw);
    			e.printStackTrace(pw);
    			String sStackTrace = sw.toString(); // stack trace as a string
    			logger.error(sStackTrace);
			}	
			
			for(com.healthmarketscience.jackcess.Row row : table) {
		    	Integer idContrassegni					= (row.get("ID_Contrassegni") != null ) ? row.getInt("ID_Contrassegni") : null;						
		    	Integer collo							= (row.get("Collo") != null ) ? row.getInt("Collo") : null;

	    		try (PreparedStatement preparedStatement = connectionDb.prepareStatement(IDIR_CMR_COLLI);) {
	    				if(idContrassegni == null)
    						preparedStatement.setNull(1, java.sql.Types.INTEGER);
						else
							preparedStatement.setInt(1, idContrassegni);
	    				if(collo == null)
    						preparedStatement.setNull(2, java.sql.Types.INTEGER);
						else
							preparedStatement.setInt(2, collo);
		    			preparedStatement.execute();
	    		} catch (Exception e) {
		    			StringWriter sw = new StringWriter();
		    			PrintWriter pw = new PrintWriter(sw);
		    			e.printStackTrace(pw);
		    			String sStackTrace = sw.toString(); // stack trace as a string
		    			logger.error(sStackTrace);
	    		}
			}
	}
	
	
	
	private void insertIDIR_CMR_Contrassegni(Table table, Connection connectionDb) throws SQLException {
		
			try (PreparedStatement preparedStatement = connectionDb.prepareStatement(IDIR_CMR_CONTRASSEGNI_TRUNCATE);) {
				preparedStatement.execute();
			}catch (Exception e) {
    			StringWriter sw = new StringWriter();
    			PrintWriter pw = new PrintWriter(sw);
    			e.printStackTrace(pw);
    			String sStackTrace = sw.toString(); // stack trace as a string
    			logger.error(sStackTrace);
			}	
			
			for(com.healthmarketscience.jackcess.Row row : table) {
		    	Integer id				= (row.get("ID") != null ) ? row.getInt("ID") : null;						
		    	Double colloID			= (row.get("ColloID") != null ) ? row.getDouble("ColloID"): null;
		    	Integer numeroColli		= (row.get("NumeroColli") != null ) ? row.getInt("NumeroColli") : null;						
		    	Integer imballaggioID	= (row.get("ImballaggioID") != null ) ? row.getInt("ImballaggioID") : null;						
		    	Integer tipoMerceID		= (row.get("TipoMerceID") != null ) ? row.getInt("TipoMerceID") : null;						
		    	Integer statisticaID	= (row.get("StatisticaID") != null ) ? row.getInt("StatisticaID") : null;						
		    	Double pesoLordoKg		= (row.get("PesoLordoKg") != null ) ? row.getDouble("PesoLordoKg"): null;
		    	Double volumeM3			= (row.get("VolumeM3") != null ) ? row.getDouble("VolumeM3"): null;
		    	Integer idCmr			= (row.get("ID_Cmr") != null ) ? row.getInt("ID_Cmr") : null;						
		    	
	    		try (PreparedStatement preparedStatement = connectionDb.prepareStatement(IDIR_CMR_CONTRASSEGNI);) {
	    				if(id == null)
	    					preparedStatement.setNull(1, java.sql.Types.INTEGER);
    					else
    						preparedStatement.setInt(1, id);
	    				if(colloID == null)
	    					preparedStatement.setNull(2, java.sql.Types.DOUBLE);
    					else
    						preparedStatement.setDouble(2, colloID);
		    			if(numeroColli == null)
	    					preparedStatement.setNull(3, java.sql.Types.INTEGER);
    					else
    						preparedStatement.setInt(3, numeroColli);
		    			if(imballaggioID == null)
	    					preparedStatement.setNull(4, java.sql.Types.INTEGER);
    					else
    						preparedStatement.setInt(4, imballaggioID);
		    			if(tipoMerceID == null)
	    					preparedStatement.setNull(5, java.sql.Types.INTEGER);
    					else
    						preparedStatement.setInt(5, tipoMerceID);
		    			if(statisticaID == null)
	    					preparedStatement.setNull(6, java.sql.Types.INTEGER);
    					else
    						preparedStatement.setInt(6,statisticaID);
		    			if(pesoLordoKg == null)
	    					preparedStatement.setNull(7, java.sql.Types.DOUBLE);
    					else
    						preparedStatement.setDouble(7, pesoLordoKg);
		    			if(volumeM3 == null)
	    					preparedStatement.setNull(8, java.sql.Types.DOUBLE);
    					else
    						preparedStatement.setDouble(8, volumeM3);
		    			if(idCmr == null)
	    					preparedStatement.setNull(9, java.sql.Types.INTEGER);
    					else
    						preparedStatement.setInt(9, idCmr);
		    			preparedStatement.execute();
	    		} catch (Exception e) {
		    			StringWriter sw = new StringWriter();
		    			PrintWriter pw = new PrintWriter(sw);
		    			e.printStackTrace(pw);
		    			String sStackTrace = sw.toString(); // stack trace as a string
		    			logger.error(sStackTrace);
	    		}
			}
	}
	
	private void insertIDIR_CMR_Documenti(Table table, Connection connectionDb) throws SQLException {
		
			try (PreparedStatement preparedStatement = connectionDb.prepareStatement(IDIR_CMR_DOCUMENTI_TRUNCATE);) {
				preparedStatement.execute();
			}catch (Exception e) {
    			StringWriter sw = new StringWriter();
    			PrintWriter pw = new PrintWriter(sw);
    			e.printStackTrace(pw);
    			String sStackTrace = sw.toString(); // stack trace as a string
    			logger.error(sStackTrace);
			}	
			
			for(com.healthmarketscience.jackcess.Row row : table) {
		    	Integer idDocumento				= (row.get("ID_Documento") != null ) ? row.getInt("ID_Documento") : null;						
		    	Integer esercizioID				= (row.get("EsercizioID") != null ) ? row.getInt("EsercizioID") : null;
		    	Integer documentoID				= (row.get("DocumentoID") != null ) ? row.getInt("DocumentoID") : null;
		    	Double listeDocumentiID			= (row.get("ListeDocumentiID") != null ) ? row.getDouble("ListeDocumentiID") : null;
		    	Double listeDocumentiNumero		= (row.get("ListeDocumentiNumero") != null ) ? row.getDouble("ListeDocumentiNumero") : null;
		    	Integer vettoreID				= (row.get("VettoreID") != null ) ? row.getInt("VettoreID") : null;
		    	Integer portoID					= (row.get("PortoID") != null ) ? row.getInt("PortoID") : null;
		    	Integer idCmr					= (row.get("ID_Cmr") != null ) ? row.getInt("ID_Cmr") : null;

	    		try (PreparedStatement preparedStatement = connectionDb.prepareStatement(IDIR_CMR_DOCUMENTI);) {
	    				if(idDocumento == null)
    						preparedStatement.setNull(1, java.sql.Types.INTEGER);
						else
							preparedStatement.setInt(1, idDocumento);
	    				if(esercizioID == null)
    						preparedStatement.setNull(2, java.sql.Types.INTEGER);
						else
							preparedStatement.setInt(2, esercizioID);
	    				if(documentoID == null)
    						preparedStatement.setNull(3, java.sql.Types.INTEGER);
						else
							preparedStatement.setInt(3, documentoID);
	    				if(listeDocumentiID == null)
    						preparedStatement.setNull(4, java.sql.Types.DOUBLE);
						else
							preparedStatement.setDouble(4, listeDocumentiID);
	    				if(listeDocumentiNumero == null)
    						preparedStatement.setNull(5, java.sql.Types.DOUBLE);
						else
							preparedStatement.setDouble(5, listeDocumentiNumero);
	    				if(vettoreID == null)
    						preparedStatement.setNull(6, java.sql.Types.INTEGER);
						else
							preparedStatement.setInt(6, vettoreID);
	    				if(portoID == null)
    						preparedStatement.setNull(7, java.sql.Types.INTEGER);
						else
							preparedStatement.setInt(7, portoID);
	    				if(idCmr == null)
    						preparedStatement.setNull(8, java.sql.Types.INTEGER);
						else
							preparedStatement.setInt(8, idCmr);
	    				
		    			preparedStatement.execute();
	    		} catch (Exception e) {
		    			StringWriter sw = new StringWriter();
		    			PrintWriter pw = new PrintWriter(sw);
		    			e.printStackTrace(pw);
		    			String sStackTrace = sw.toString(); // stack trace as a string
		    			logger.error(sStackTrace);
	    		}
			}
	}
	
	private void insertIDIR_CMR_Imballaggi(Table table, Connection connectionDb) throws SQLException {

			try (PreparedStatement preparedStatement = connectionDb.prepareStatement(IDIR_CMR_IMBALLAGGI_TRUNCATE);) {
				preparedStatement.execute();
			}catch (Exception e) {
    			StringWriter sw = new StringWriter();
    			PrintWriter pw = new PrintWriter(sw);
    			e.printStackTrace(pw);
    			String sStackTrace = sw.toString(); // stack trace as a string
    			logger.error(sStackTrace);
			}	
			
			for(com.healthmarketscience.jackcess.Row row : table) {
		    	Integer id						= (row.get("ID") != null ) ? row.getInt("ID") : null;						
		    	String imballaggio				= (row.get("Imballaggio") != null ) ? row.getString("Imballaggio") : null;

	    		try (PreparedStatement preparedStatement = connectionDb.prepareStatement(IDIR_CMR_IMBALLAGGI);) {
	    				if(id == null)
    						preparedStatement.setNull(1, java.sql.Types.INTEGER);
						else
							preparedStatement.setInt(1, id);
						preparedStatement.setString(2, imballaggio);
		    			preparedStatement.execute();
	    		} catch (Exception e) {
		    			StringWriter sw = new StringWriter();
		    			PrintWriter pw = new PrintWriter(sw);
		    			e.printStackTrace(pw);
		    			String sStackTrace = sw.toString(); // stack trace as a string
		    			logger.error(sStackTrace);
	    		}
			}
	}
	
	private void insertIDIR_CMR_Numeratore(Table table, Connection connectionDb) throws SQLException {
		
			try (PreparedStatement preparedStatement = connectionDb.prepareStatement(IDIR_CMR_NUMERATORE_TRUNCATE);) {
				preparedStatement.execute();
			}catch (Exception e) {
    			StringWriter sw = new StringWriter();
    			PrintWriter pw = new PrintWriter(sw);
    			e.printStackTrace(pw);
    			String sStackTrace = sw.toString(); // stack trace as a string
    			logger.error(sStackTrace);
			}	
			
			for(com.healthmarketscience.jackcess.Row row : table) {
		    	Integer id					= (row.get("ID") != null ) ? row.getInt("ID") : null;						
		    	Integer anno				= (row.get("Anno") != null ) ? row.getInt("Anno") : null;
		    	Float numero				= (row.get("Numero") != null ) ? row.getFloat("Numero") : null;
		    	String corrente				= (row.get("Corrente") != null ) ? (row.getBoolean("Corrente")) ? "1" : "0" : null;
		    	Integer esercizioID			= (row.get("EsercizioID") != null ) ? row.getInt("EsercizioID") : null;

	    		try (PreparedStatement preparedStatement = connectionDb.prepareStatement(IDIR_CMR_NUMERATORE);) {
	    				if(id == null)
    						preparedStatement.setNull(1, java.sql.Types.INTEGER);
						else
							preparedStatement.setInt(1, id);
	    				if(anno == null)
    						preparedStatement.setNull(2, java.sql.Types.INTEGER);
						else
							preparedStatement.setInt(2, anno);
	    				if(numero == null)
    						preparedStatement.setNull(3, java.sql.Types.NUMERIC);
						else
							preparedStatement.setFloat(3, numero);
						preparedStatement.setString(4, corrente);
	    				if(esercizioID == null)
    						preparedStatement.setNull(5, java.sql.Types.INTEGER);
						else
							preparedStatement.setInt(5, esercizioID);
		    			preparedStatement.execute();
	    		} catch (Exception e) {
		    			StringWriter sw = new StringWriter();
		    			PrintWriter pw = new PrintWriter(sw);
		    			e.printStackTrace(pw);
		    			String sStackTrace = sw.toString(); // stack trace as a string
		    			logger.error(sStackTrace);
	    		}
			}
	}
	
	private void insertIDIR_CMR_Pagamento_Noli(Table table, Connection connectionDb) throws SQLException {
		
			try (PreparedStatement preparedStatement = connectionDb.prepareStatement(IDIR_CMR_PAGAMENTO_NOLI_TRUNCATE);) {
				preparedStatement.execute();
			}catch (Exception e) {
    			StringWriter sw = new StringWriter();
    			PrintWriter pw = new PrintWriter(sw);
    			e.printStackTrace(pw);
    			String sStackTrace = sw.toString(); // stack trace as a string
    			logger.error(sStackTrace);
			}	
			
			for(com.healthmarketscience.jackcess.Row row : table) {
		    	Integer id					= (row.get("ID") != null ) ? row.getInt("ID") : null;						
		    	String pagamentoNoli		= (row.get("Pagamento_Noli") != null ) ? row.getString("Pagamento_Noli") : null;

	    		try (PreparedStatement preparedStatement = connectionDb.prepareStatement(IDIR_CMR_PAGAMENTO_NOLI);) {
	    				if(id == null)
    						preparedStatement.setNull(1, java.sql.Types.INTEGER);
						else
							preparedStatement.setInt(1, id);
						preparedStatement.setString(2, pagamentoNoli);
		    			preparedStatement.execute();
	    		} catch (Exception e) {
		    			StringWriter sw = new StringWriter();
		    			PrintWriter pw = new PrintWriter(sw);
		    			e.printStackTrace(pw);
		    			String sStackTrace = sw.toString(); // stack trace as a string
		    			logger.error(sStackTrace);
	    		}
			}
	}
	
	private void insertIDIR_CMR_Statistica(Table table, Connection connectionDb) throws SQLException {
		
			try (PreparedStatement preparedStatement = connectionDb.prepareStatement(IDIR_CMR_STATISTICA_TRUNCATE);) {
				preparedStatement.execute();
			}catch (Exception e) {
    			StringWriter sw = new StringWriter();
    			PrintWriter pw = new PrintWriter(sw);
    			e.printStackTrace(pw);
    			String sStackTrace = sw.toString(); // stack trace as a string
    			logger.error(sStackTrace);
			}	
			
			for(com.healthmarketscience.jackcess.Row row : table) {
		    	Integer id					= (row.get("ID") != null ) ? row.getInt("ID") : null;						
		    	String statistica		= (row.get("Statistica") != null ) ? row.getString("Statistica") : null;

	    		try (PreparedStatement preparedStatement = connectionDb.prepareStatement(IDIR_CMR_STATISTICA);) {
	    				if(id == null)
    						preparedStatement.setNull(1, java.sql.Types.INTEGER);
						else
							preparedStatement.setInt(1, id);
						preparedStatement.setString(2, statistica);
		    			preparedStatement.execute();
	    		} catch (Exception e) {
		    			StringWriter sw = new StringWriter();
		    			PrintWriter pw = new PrintWriter(sw);
		    			e.printStackTrace(pw);
		    			String sStackTrace = sw.toString(); // stack trace as a string
		    			logger.error(sStackTrace);
	    		}
			}
	}
	
	private void insertIDIR_CMR_TipoMerce(Table table, Connection connectionDb) throws SQLException {
		
			try (PreparedStatement preparedStatement = connectionDb.prepareStatement(IDIR_CMR_TIPO_MERCE_TRUNCATE);) {
				preparedStatement.execute();
			}catch (Exception e) {
    			StringWriter sw = new StringWriter();
    			PrintWriter pw = new PrintWriter(sw);
    			e.printStackTrace(pw);
    			String sStackTrace = sw.toString(); // stack trace as a string
    			logger.error(sStackTrace);
			}	
			
			for(com.healthmarketscience.jackcess.Row row : table) {
		    	Integer id					= (row.get("ID") != null ) ? row.getInt("ID") : null;						
		    	String tipoMerce		= (row.get("TipoMerce") != null ) ? row.getString("TipoMerce") : null;

	    		try (PreparedStatement preparedStatement = connectionDb.prepareStatement(IDIR_CMR_TIPO_MERCE);) {
	    				if(id == null)
    						preparedStatement.setNull(1, java.sql.Types.INTEGER);
						else
							preparedStatement.setInt(1, id);
						preparedStatement.setString(2, tipoMerce);
		    			preparedStatement.execute();
	    		} catch (Exception e) {
		    			StringWriter sw = new StringWriter();
		    			PrintWriter pw = new PrintWriter(sw);
		    			e.printStackTrace(pw);
		    			String sStackTrace = sw.toString(); // stack trace as a string
		    			logger.error(sStackTrace);
	    		}
			}
	}
	
	private void insertIDIR_CMR(Table table, Connection connectionDb) throws SQLException {
		try (PreparedStatement preparedStatement = connectionDb.prepareStatement(IDIR_CMR_TRUNCATE);) {
				preparedStatement.execute();
			}catch (Exception e) {
    			StringWriter sw = new StringWriter();
    			PrintWriter pw = new PrintWriter(sw);
    			e.printStackTrace(pw);
    			String sStackTrace = sw.toString(); // stack trace as a string
    			logger.error(sStackTrace);
			}	
			
			for(com.healthmarketscience.jackcess.Row row : table) {
		    	Integer idCMR								= (row.get("ID_CMR") != null ) ? row.getInt("ID_CMR") : null;						
		    	Integer anno								= (row.get("Anno") != null ) ? row.getInt("Anno") : null;
		    	Double numeroA								= (row.get("Numero") != null ) ? row.getDouble("Numero") : 0;
		    	Double clienteFornitoreID					= (row.get("ClienteFornitoreID") != null ) ? row.getDouble("ClienteFornitoreID") : null;
		    	String destinazioneContatto					= (row.get("DestinazioneContatto") != null ) ? row.getString("DestinazioneContatto") : null;
		    	Double destinazioneContattoID				= (row.get("DestinazioneContattoID") != null ) ? row.getDouble("DestinazioneContattoID"): null;
		    	String luogoPresa							= (row.get("LuogoPresa") != null ) ? row.getString("LuogoPresa") : null;
		    	Date dataPresa								= (row.get("DataPresa") != null ) ? row.getDate("DataPresa") : null;
		    	String istruzioniMittente					= (row.get("IstruzioniMittente") != null ) ? row.getString("IstruzioniMittente") : null;
		    	Integer pagamentoNoloID						= (row.get("PagamentoNoloID") != null ) ? row.getInt("PagamentoNoloID") : null;
		    	String rimborso								= (row.get("Rimborso") != null ) ? row.getString("Rimborso") : null;
		    	String convenzioniParticolari				= (row.get("ConvenzioniParticolari") != null ) ? row.getString("ConvenzioniParticolari") : null;
		    	String compilatoA							= (row.get("CompilatoA") != null ) ? row.getString("CompilatoA") : null;
		    	Date compilatoIl							= (row.get("CompilatoIl") != null ) ? row.getDate("CompilatoIl") : null;
		    	Integer vettoreID							= (row.get("VettoreID") != null ) ? row.getInt("VettoreID") : null;
		    	Integer vettoreID_2							= (row.get("VettoreID_2") != null ) ? row.getInt("VettoreID_2") : null;
		    	String targaMotrice							= (row.get("TargaMotrice") != null ) ? row.getString("TargaMotrice") : null;
		    	String targaRimorchio						= (row.get("TargaRimorchio") != null ) ? row.getString("TargaRimorchio") : null;
		    	Date dataFatturaTrasportatore				= (row.get("DataFatturaTrasportatore") != null ) ? row.getDate("DataFatturaTrasportatore") : null;
		    	String numeroFatturaTrasportatore			= (row.get("NumeroFatturaTrasportatore") != null ) ? row.getString("NumeroFatturaTrasportatore") : null;
		    	Double costoTraportatore					= (row.get("CostoTraportatore") != null ) ? row.getDouble("CostoTraportatore") : null;
		    	String documentiRicevuti					= (row.get("DocumentiRicevuti") != null && row.getBoolean("DocumentiRicevuti")) ? "1" : "0";
		    	String documentiInBusta						= (row.get("DocumentiInBusta") != null ) ? row.getString("DocumentiInBusta") : null;
		    	String mrn									= (row.get("MRN") != null && row.getBoolean("MRN")) ? "1" : "0";
		    	String fattureNsCopie						= (row.get("FattureNsCopie") != null && row.getBoolean("FattureNsCopie")) ? "1" : "0";
		    	String cmrAltriVettori						= (row.get("CmrAltriVettori") != null && row.getBoolean("CmrAltriVettori")) ? "1" : "0";
		    	String cmrControFirmati						= (row.get("CmrControFirmati") != null && row.getBoolean("CmrControFirmati")) ? "1" : "0";
		    	String archiviato							= (row.get("Archiviato") != null && row.getBoolean("Archiviato")) ? "1" : "0";

	    		try (PreparedStatement preparedStatement = connectionDb.prepareStatement(IDIR_CMR);) {
	    				if(idCMR == null)
	    					preparedStatement.setNull(1, java.sql.Types.INTEGER);
	    				else
	    					preparedStatement.setInt(1, idCMR);
		    			if(anno == null)
		    				preparedStatement.setNull(2, java.sql.Types.INTEGER);
		    			else
		    				preparedStatement.setInt(2, anno);
		    			if(numeroA == null)
		    				preparedStatement.setNull(3, java.sql.Types.DOUBLE);
		    			else
		    				preparedStatement.setDouble(3, numeroA);
		    			if(clienteFornitoreID == null)
		    				preparedStatement.setNull(4, java.sql.Types.DOUBLE);
		    			else
		    				preparedStatement.setDouble(4, clienteFornitoreID);
		    			preparedStatement.setString(5, destinazioneContatto);
		    			if(destinazioneContattoID == null)
		    				preparedStatement.setNull(6, java.sql.Types.DOUBLE);
		    			else
		    				preparedStatement.setDouble(6, destinazioneContattoID);
		    			preparedStatement.setString(7, luogoPresa);
		    			if(dataPresa == null)
		    				preparedStatement.setNull(8, java.sql.Types.DATE);
		    			else
		    				preparedStatement.setDate(8, new java.sql.Date(dataPresa.getTime()));
		    			preparedStatement.setString(9, istruzioniMittente);
		    			if(pagamentoNoloID == null)
		    				preparedStatement.setNull(10, java.sql.Types.INTEGER);
		    			else
		    				preparedStatement.setInt(10, pagamentoNoloID);
		    			preparedStatement.setString(11, rimborso);
		    			preparedStatement.setString(12, convenzioniParticolari);
		    			preparedStatement.setString(13, compilatoA);
		    			if(compilatoIl == null)
		    				preparedStatement.setNull(14, java.sql.Types.DATE);
		    			else
		    				preparedStatement.setDate(14,  new java.sql.Date(compilatoIl.getTime()));
		    			if(vettoreID == null)
		    				preparedStatement.setNull(15, java.sql.Types.INTEGER);
		    			else
		    				preparedStatement.setInt(15, vettoreID);
		    			if(vettoreID_2 == null)
		    				preparedStatement.setNull(16, java.sql.Types.INTEGER);
		    			else
		    				preparedStatement.setInt(16, vettoreID_2);
		    			preparedStatement.setString(17, targaMotrice);
		    			preparedStatement.setString(18, targaRimorchio);
		    			if(dataFatturaTrasportatore == null)
		    				preparedStatement.setNull(19, java.sql.Types.DATE);
		    			else
		    				preparedStatement.setDate(19, new java.sql.Date(dataFatturaTrasportatore.getTime()));
		    			preparedStatement.setString(20, numeroFatturaTrasportatore);
	    				if(costoTraportatore == null)
	    					preparedStatement.setNull(21, java.sql.Types.DOUBLE);
	    				else
	    					preparedStatement.setDouble(21, costoTraportatore);
		    			preparedStatement.setString(22, documentiRicevuti);
		    			preparedStatement.setString(23, documentiInBusta);
		    			preparedStatement.setString(24, mrn);
		    			preparedStatement.setString(25, fattureNsCopie);
		    			preparedStatement.setString(26, cmrAltriVettori);
		    			preparedStatement.setString(27, cmrControFirmati);
		    			preparedStatement.setString(28, archiviato);
		    			preparedStatement.execute();
	    		} catch (Exception e) {
		    			StringWriter sw = new StringWriter();
		    			PrintWriter pw = new PrintWriter(sw);
		    			e.printStackTrace(pw);
		    			String sStackTrace = sw.toString(); // stack trace as a string
		    			logger.error(sStackTrace);
	    		}
			}
	}

	private void readPropertiesFile() throws IOException {

		try (InputStream input = new FileInputStream(pathFile.concat("\\").concat("config.properties"))) {
			properties = new Properties();
			// load a properties file
			properties.load(input);
			// get the property value and print it out
			logger.info(properties.getProperty("datasource.username"));
			logger.info(properties.getProperty("datasource.password"));
			logger.info(properties.getProperty("datasource.jdbc-url"));
			logger.info(properties.getProperty("pathDbAccess"));			
		} catch (IOException ex) {
			StringWriter sw = new StringWriter();
			PrintWriter pw = new PrintWriter(sw);
			ex.printStackTrace(pw);
			String sStackTrace = sw.toString(); // stack trace as a string
			logger.error(sStackTrace);
			throw ex;
		}
	}

	private Connection getConnection() throws SQLException {

		return DriverManager.getConnection(properties.getProperty("datasource.jdbc-url"),
				properties.getProperty("datasource.username"), properties.getProperty("datasource.password"));
	}
}