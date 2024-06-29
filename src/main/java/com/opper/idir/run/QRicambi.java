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
import java.util.Properties;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class QRicambi {

	private static Logger logger = LoggerFactory.getLogger(QRicambi.class);

	private Properties properties;

	private String pathFile;

	private String inputDirectory;

	private String outputDirectory;

	public QRicambi(String pathFile) throws IOException {

		this.pathFile = pathFile;
		readPropertiesFile();
		inputDirectory = properties.getProperty("qricambi.directory.input");
		outputDirectory = properties.getProperty("qricambi.directory.output");
	}

	public void run() throws IOException, ParseException, SQLException {

		File folder = new File(inputDirectory);
		File[] listOfFiles = folder.listFiles();

		for (File file : listOfFiles) {
			if (file.isFile()) {
				logger.info("FILE INPUT: ".concat(file.getName()));
				readExcel(file);
				file.renameTo(new File(outputDirectory.concat("\\").concat(file.getName())));
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

	private void readExcel(File fileInput) throws IOException, ParseException, SQLException {

		FileInputStream file = null;
		Workbook workbook = null;
		Connection connectionDb = null;
		try {
			connectionDb = getConnection();
			file = new FileInputStream(fileInput);
			logger.info("PRIMA LEGGERE EXCEL");
			workbook = new XSSFWorkbook(file);
			logger.info("LETTO FILE EXCEL");
			for (int index = 0; index < workbook.getNumberOfSheets(); index++) {
				logger.info("DENTRO SHEET");
				Sheet sheet = workbook.getSheetAt(index);
				boolean first = true;
				for (Row row : sheet) {					
					String descrizione = row.getCell(0).getStringCellValue();
					logger.info("DESCRIZIONE: " + descrizione);
					if (!first) {
						try {
//							if (row == null || row.getCell(0).getCellType() == null || row.getCell(2).getCellType() == null
//									|| row.getCell(3).getCellType() == null || row.getCell(4).getCellType() == null
//									|| row.getCell(5).getCellType() == null|| row.getCell(6).getCellType() == null
//									|| row.getCell(7).getCellType() == null|| row.getCell(8).getCellType() == null)
//								break;
							String brand = (row.getCell(0) != null ) ? row.getCell(0).getStringCellValue() : "";
							String precodice = (row.getCell(1) != null ) ? row.getCell(1).getStringCellValue() : "";

							insertQRicambiTable(brand, precodice, connectionDb);
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

	private void insertQRicambiTable(String brand, String precodice, Connection conn) {
		String script = "INSERT INTO opper.dbo.IDIR_QRICAMBI_BRAND(BRAND, PRECODICE)"
				+ " VALUES(?,?)";

		try (PreparedStatement preparedStatement = conn.prepareStatement(script);) {
			preparedStatement.setString(1, brand);
			preparedStatement.setString(2, precodice);
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