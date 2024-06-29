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

public class RicercheSchedulate {

	private static Logger logger = LoggerFactory.getLogger(RicercheSchedulate.class);

	private Properties properties;

	private String pathFile;

	private String inputDirectory;

	private String outputDirectory;

	public RicercheSchedulate(String pathFile) throws IOException {

		this.pathFile = pathFile;
		readPropertiesFile();
		inputDirectory = properties.getProperty("ricercheschedulate.directory.input");
		outputDirectory = properties.getProperty("ricercheschedulate.directory.output");
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
							String codematch = (row.getCell(0) != null ) ? row.getCell(0).getStringCellValue() : "";
							String inputbrand = (row.getCell(1) != null ) ? row.getCell(1).getStringCellValue() : "";
							String inputqbrand = (row.getCell(2) != null ) ? row.getCell(2).getStringCellValue() : "";
							String outputbrandq = (row.getCell(3) != null ) ? row.getCell(3).getStringCellValue() : "";
							String quantityinput = (row.getCell(4) != null ) ? row.getCell(4).getStringCellValue() : "";
							String fromcodesearch = (row.getCell(5) != null ) ? row.getCell(5).getStringCellValue() : "";
							String ecommerce = (row.getCell(6) != null ) ? row.getCell(6).getStringCellValue() : "";
							String username = (row.getCell(7) != null ) ? row.getCell(7).getStringCellValue() : "";
							String code = (row.getCell(8) != null ) ? row.getCell(8).getStringCellValue() : "";
							String ecommercecode = (row.getCell(9) != null ) ? row.getCell(9).getStringCellValue() : "";
							String description = (row.getCell(10) != null ) ? row.getCell(10).getStringCellValue() : "";
							String brand = (row.getCell(11) != null ) ? row.getCell(11).getStringCellValue() : "";
							Double listprice = (row.getCell(12) != null && !row.getCell(12).getStringCellValue().isEmpty()) ? Double.parseDouble(row.getCell(12).getStringCellValue().replace(",",".")) : 0;
							Double price = (row.getCell(13) != null && !row.getCell(13).getStringCellValue().isEmpty()) ? Double.parseDouble(row.getCell(13).getStringCellValue().replace(",",".")) : 0;
							Double webprice = (row.getCell(14) != null && !row.getCell(14).getStringCellValue().isEmpty()) ? Double.parseDouble(row.getCell(14).getStringCellValue().replace(",",".")) : 0;
							String avail = (row.getCell(15) != null ) ? row.getCell(15).getStringCellValue() : "";
							String dispcolor = (row.getCell(16) != null ) ? row.getCell(16).getStringCellValue() : "";
							String link = (row.getCell(17) != null ) ? row.getCell(17).getStringCellValue() : "";
							String promo = (row.getCell(18) != null ) ? row.getCell(18).getStringCellValue() : "";
							String quantity_discount = (row.getCell(19) != null ) ? row.getCell(19).getStringCellValue() : "";

							insertRicercheSchedulateTable(codematch,inputbrand,inputqbrand,outputbrandq,quantityinput,fromcodesearch,ecommerce,username,code,ecommercecode,description,brand,listprice,price,webprice,avail,dispcolor,link,promo,quantity_discount, connectionDb);
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

	private void insertRicercheSchedulateTable(String codematch, String inputbrand, String inputqbrand,
			String outputbrandq, String quantityinput, String fromcodesearch, String ecommerce, String username,
			String code, String ecommercecode, String description, String brand, Double listprice, Double price,
			Double webprice, String avail, String dispcolor, String link, String promo, String quantity_discount,
			Connection conn) {
		String script = "INSERT INTO opper.dbo.IDIR_RICERCHE_SCHEDULATE1(CODEMATCH,INPUTBRAND,INPUTQBRAND,OUTPUTBRANDQ,QUANTITYINPUT,FROMCODESEARCH,ECOMMERCE,USERNAME,CODE,ECOMMERCECODE,DESCRIPTION,BRAND,LISTPRICE,PRICE,WEBPRICE,AVAIL,DISPCOLOR,LINK,PROMO,QUANTITY_DISCOUNT)"
				+ " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

		try (PreparedStatement preparedStatement = conn.prepareStatement(script);) {
			preparedStatement.setString(1, codematch);
			preparedStatement.setString(2, inputbrand);
			preparedStatement.setString(3, inputqbrand);
			preparedStatement.setString(4, outputbrandq);
			preparedStatement.setString(5, quantityinput);
			preparedStatement.setString(6, fromcodesearch);
			preparedStatement.setString(7, ecommerce);
			preparedStatement.setString(8, username);
			preparedStatement.setString(9, code);
			preparedStatement.setString(10, ecommercecode);
			preparedStatement.setString(11, description);
			preparedStatement.setString(12, brand);
			preparedStatement.setDouble(13, listprice);
			preparedStatement.setDouble(14, price);
			preparedStatement.setDouble(15, webprice);
			preparedStatement.setString(16, avail);
			preparedStatement.setString(17, dispcolor);
			preparedStatement.setString(18, link);
			preparedStatement.setString(19, promo);
			preparedStatement.setString(20, quantity_discount);
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