package com.opper.idir.run;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.io.Reader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class PopulateTable {

	private static Logger logger = LoggerFactory.getLogger(PopulateTable.class);

	private Properties properties;

	private String pathFile;

	public PopulateTable(String pathFile) throws IOException {

		this.pathFile = pathFile;
		readPropertiesFile();
	}

	public void executeSqlScript(String fileName) throws Exception {

		try (Connection conn = getConnection();) {
			File file = getScriptSqlFile(fileName);
			try (Reader reader = new BufferedReader(new FileReader(file))) {
				try (FileWriter logFile = new FileWriter("T:\\OPPER\\jar\\logs\\appOpperScriptRunner_"+file.getName()+".log");
						PrintWriter output = new PrintWriter(logFile);) {
					logger.info("Running script from file: " + file.getCanonicalPath());
					OpperScriptRunner sr = new OpperScriptRunner(conn);
					sr.setErrorLogWriter(output);
					sr.setLogWriter(output);					
					sr.setAutoCommit(true);
					sr.setStopOnError(true);
					sr.setSendFullScript(false);
					sr.runScript(reader);
					logger.info("Done.");
				}
			} catch (Exception ex) {
				throw ex;
			}
		} catch (Exception ex) {
			throw ex;
		}
	}

	private Connection getConnection() throws SQLException {

		return DriverManager.getConnection(properties.getProperty("datasource.jdbc-url"),
				properties.getProperty("datasource.username"), properties.getProperty("datasource.password"));
	}

	private void readPropertiesFile() throws IOException {

		try (InputStream input = new FileInputStream(pathFile.concat("config.properties"))) {
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

	private File getScriptSqlFile(String fileName) {

		return new File(pathFile.concat(fileName));
	}
}