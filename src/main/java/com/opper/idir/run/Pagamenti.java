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
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.Properties;

import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Pagamenti {

	private static Logger logger = LoggerFactory.getLogger(Pagamenti.class);

	private Properties properties;

	private String pathFile;

	private String inputDirectory;

	private String outputDirectory;

	public Pagamenti(String pathFile) throws IOException {

		this.pathFile = pathFile;
		readPropertiesFile();
		inputDirectory = properties.getProperty("pagamenti.directory.input");
		outputDirectory = properties.getProperty("pagamenti.directory.output");
	}

	public void run() throws IOException, ParseException, SQLException {

		File folder = new File(inputDirectory);
		File[] listOfFiles = folder.listFiles();

		for (File file : listOfFiles) {
			if (file.isFile()) {
				logger.info("FILE INPUT: ".concat(file.getName()));
				readExcel(file);
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
		} catch (IOException ex) {
			throw ex;
		}
	}

	private Connection getConnection() throws SQLException {

		return DriverManager.getConnection(properties.getProperty("datasource.jdbc-url"),
				properties.getProperty("datasource.username"), properties.getProperty("datasource.password"));
	}

	private void readExcel(File fileInput) throws IOException, ParseException, SQLException {

		FileInputStream file = null;
		Workbook workbook = null;
		Connection connectionDb = null;
		try {
			connectionDb = getConnection();
			file = new FileInputStream(fileInput);
			workbook = new XSSFWorkbook(file);
			for (int index = 0; index < workbook.getNumberOfSheets(); index++) {
				Sheet sheet = workbook.getSheetAt(index);
				String sheetName = sheet.getSheetName();
				SimpleDateFormat simpleDateFormat = new SimpleDateFormat("dd-MM-yyyy");
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(simpleDateFormat.parse(sheetName));
				boolean first = true;
				for (Row row : sheet) {
					String descrizione = row.getCell(0).getStringCellValue();
					if (!first && descrizione != null && descrizione.trim().length() > 0
							&& descrizione.indexOf("TOTALE") == -1) {
						try {
//							if (row == null || row.getCell(0).getCellType() == null || row.getCell(2).getCellType() == null
//									|| row.getCell(3).getCellType() == null || row.getCell(4).getCellType() == null
//									|| row.getCell(5).getCellType() == null|| row.getCell(6).getCellType() == null
//									|| row.getCell(7).getCellType() == null|| row.getCell(8).getCellType() == null)
//								break;
							Double riportoScadutiMesiPrecedenti = (row.getCell(2)== null || row.getCell(2).getCellType() == null) ? Double.valueOf(0) : row.getCell(2).getCellType().equals(CellType.STRING)
									? getDoubleFromString(row.getCell(2).getStringCellValue())
									: Double.valueOf(row.getCell(2).getNumericCellValue());
							Double scadereDicembre = (row.getCell(3)== null || row.getCell(3).getCellType() == null) ? Double.valueOf(0) :row.getCell(3).getCellType().equals(CellType.STRING)
									? getDoubleFromString(row.getCell(3).getStringCellValue())
									: Double.valueOf(row.getCell(3).getNumericCellValue());
							Double totaleDaPagare = (row.getCell(4)== null || row.getCell(4).getCellType() == null) ? Double.valueOf(0) :row.getCell(4).getCellType().equals(CellType.STRING)
									? getDoubleFromString(row.getCell(4).getStringCellValue())
									: Double.valueOf(row.getCell(4).getNumericCellValue());
							Double spostareAGennaio = (row.getCell(5)== null || row.getCell(5).getCellType() == null) ? Double.valueOf(0) :row.getCell(5).getCellType().equals(CellType.STRING)
									? getDoubleFromString(row.getCell(5).getStringCellValue())
									: Double.valueOf(row.getCell(5).getNumericCellValue());
							Double pagareDicembre = (row.getCell(6)== null || row.getCell(6).getCellType() == null) ? Double.valueOf(0) :row.getCell(6).getCellType().equals(CellType.STRING)
									? getDoubleFromString(row.getCell(6).getStringCellValue())
									: Double.valueOf(row.getCell(6).getNumericCellValue());
							Double pagato = (row.getCell(7)== null || row.getCell(7).getCellType() == null) ? Double.valueOf(0) :row.getCell(7).getCellType().equals(CellType.STRING)
									? getDoubleFromString(row.getCell(7).getStringCellValue())
									: Double.valueOf(row.getCell(7).getNumericCellValue());
							Double residuoDaPagareAutorizzatoDicembre = (row.getCell(8)== null || row.getCell(8).getCellType() == null) ? Double.valueOf(0) :row.getCell(8).getCellType()
									.equals(CellType.STRING) ? getDoubleFromString(row.getCell(8).getStringCellValue())
											: Double.valueOf(row.getCell(8).getNumericCellValue());

							insertPagamentiTable(descrizione, riportoScadutiMesiPrecedenti, scadereDicembre,
									totaleDaPagare, spostareAGennaio, pagareDicembre, pagato,
									residuoDaPagareAutorizzatoDicembre, calendar.get(Calendar.YEAR),
									calendar.get(Calendar.MONTH) + 1, connectionDb);
						} finally {
							//System.out.println(descrizione);
						}
					}
					first = false;
				}
			}
		} finally {
			try {
				if (workbook != null)
					workbook.close();
			} catch (Exception e) {
				StringWriter sw = new StringWriter();
				PrintWriter pw = new PrintWriter(sw);
				e.printStackTrace(pw);
				String sStackTrace = sw.toString(); // stack trace as a string
				logger.error(sStackTrace);
			}
			try {
				if (file != null)
					file.close();
			} catch (Exception e) {
				StringWriter sw = new StringWriter();
				PrintWriter pw = new PrintWriter(sw);
				e.printStackTrace(pw);
				String sStackTrace = sw.toString(); // stack trace as a string
				logger.error(sStackTrace);
			}
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

	private void insertPagamentiTable(String descrizione, Double riportoScadutiMesiPrecedenti, Double scadereDicembre,
			Double totaleDaPagare, Double spostareAGennaio, Double pagareDicembre, Double pagato,
			Double residuoDaPagareAutorizzatoDicembre, int anno, int mese, Connection conn) {
		String script = "INSERT INTO opper.dbo.IDIR_PAGAMENTI(MESE,ANNO,DESCRIZIONE,RIPORTO_SCADUTI_MESI_PRECEDENTI,SCADERE_DICEMBRE,TOTALE_DA_PAGARE,SPOSTARE_A_GENNAIO,PAGARE_DICEMBRE,PAGATO,RESIDUO_DA_PAGARE_MESE_RIFERIMENTO)"
				+ " VALUES(?,?,?,?,?,?,?,?,?,?)";

		try (PreparedStatement preparedStatement = conn.prepareStatement(script);) {
			Calendar calendar = new GregorianCalendar();
			preparedStatement.setInt(1, mese);
			preparedStatement.setInt(2, anno);
			preparedStatement.setString(3, descrizione);
			preparedStatement.setDouble(4, riportoScadutiMesiPrecedenti);
			preparedStatement.setDouble(5, scadereDicembre);
			preparedStatement.setDouble(6, totaleDaPagare);
			preparedStatement.setDouble(7, spostareAGennaio);
			preparedStatement.setDouble(8, pagareDicembre);
			preparedStatement.setDouble(9, pagato);
			preparedStatement.setDouble(10, residuoDaPagareAutorizzatoDicembre);
			preparedStatement.execute();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private Double getDoubleFromString(String valueStr) {
		//System.out.println("valueStr --> " + valueStr);
		if (valueStr == null || valueStr.trim().length() == 0 || valueStr.indexOf("-") != -1)
			return Double.valueOf(0.00);
		else
			return Double.valueOf(valueStr.replaceAll(".", "").replaceAll(",", "."));
	}
}