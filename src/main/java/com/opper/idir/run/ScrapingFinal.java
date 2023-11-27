package com.opper.idir.run;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import org.json.JSONArray;
import org.json.JSONObject;
import org.jsoup.Connection;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.TextNode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ScrapingFinal {

	private static Logger logger = LoggerFactory.getLogger(EntryPoint.class);

	private static final String PUNTO_VIRGOLA = ";";
	private static final String COMMA = ",";
	private static final String DOT = ".";
	private static final String SEPARATOR = "\\";
	private static final String DEFAULT_DOUBLE = "0.0";

	private static final SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss.SSS");
	
	
	private final static String PATH_DOWNLOAD = "T:\\OPPER\\jar\\download";
	// private final static String PATH_DOWNLOAD = "C:\\temp\\filecsv\\";

	public static void main(String[] args) throws IOException, SQLException {

		// downloadFiles();
		populateTable();
	}

	private static java.sql.Connection getConnection() throws SQLException {

		return DriverManager.getConnection(
				"jdbc:sqlserver://svrsqldwh.idirspa.local:1433;instanceName=MSSQLSERVER;databaseName=opper;encrypt=true;trustServerCertificate=true",
				"opper", "opper2023");
	}

	private static void populateTable() throws IOException, SQLException {

		logger.info("START POPULATE " + sdf.format(new Date()));
		Set<String> listFiles = Stream.of(new File(PATH_DOWNLOAD).listFiles()).filter(file -> !file.isDirectory())
				.map(File::getName).collect(Collectors.toSet());
		try (java.sql.Connection conn = getConnection();) {
			for (String fileName : listFiles) {
				logger.info("FILE: " + fileName);
				try (BufferedReader br = new BufferedReader(
						new FileReader(PATH_DOWNLOAD.concat(SEPARATOR).concat(fileName)))) {
					String line;
					boolean first = true;
					int index = 1;
					String scriptSql = "INSERT INTO opper.dbo.IDIR_RICERCHE_SCHEDULATE(CODEMATCH,INPUTBRAND,INPUTQBRAND,OUTPUTBRANDQ,QUANTITYINPUT,FROMCODESEARCH,ECOMMERCE,USERNAME,CODE,ECOMMERCECODE,DESCRIPTION,BRAND,LISTPRICE,PRICE,WEBPRICE,AVAIL,DISPCOLOR,LINK,PROMO,QUANTITY_DISCOUNT) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
					try (PreparedStatement preparedStatement = conn.prepareStatement(scriptSql);) {
						while ((line = br.readLine()) != null) {
							if (first) {
								first = false;
							} else {
								String[] values = line.split(PUNTO_VIRGOLA);
								
								if (values.length != 20 || Arrays.asList(values).contains("Errore durante la ricerca")) {
									logger.info("FILE: " + fileName + " ### INDEX: " + index + " ### VALUES: "
											+ Arrays.toString(values));
								} else {
									try {
										preparedStatement.setString(1, values[0]);
										preparedStatement.setString(2, values[1]);
										preparedStatement.setString(3, values[2]);
										preparedStatement.setString(4, values[3]);
										preparedStatement.setString(5, values[4]);
										preparedStatement.setString(6, values[5]);
										preparedStatement.setString(7, values[6]);
										preparedStatement.setString(8, values[7]);
										preparedStatement.setString(9, values[8]);
										preparedStatement.setString(10, values[9]);
										preparedStatement.setString(11, values[10]);
										preparedStatement.setString(12, values[11]);
										preparedStatement.setDouble(13,
												Double.parseDouble(
														(values[12] != null && values[12].trim().length() != 0)
																? values[12].replace(COMMA, DOT)
																: DEFAULT_DOUBLE));
										preparedStatement.setDouble(14,
												Double.parseDouble(
														(values[13] != null && values[13].trim().length() != 0)
																? values[13].replace(COMMA, DOT)
																: DEFAULT_DOUBLE));
										preparedStatement.setDouble(15,
												Double.parseDouble(
														(values[14] != null && values[14].trim().length() != 0)
																? values[14].replace(COMMA, DOT)
																: DEFAULT_DOUBLE));
										preparedStatement.setString(16, values[15]);
										preparedStatement.setString(17, values[16]);
										preparedStatement.setString(18, values[17]);
										preparedStatement.setString(19, values[18]);
										preparedStatement.setString(20, values[19]);
										//preparedStatement.executeUpdate();
										preparedStatement.addBatch();
										if(index % 10000 == 0) {
											preparedStatement.executeBatch();
											preparedStatement.clearBatch();
										}
									} catch (Exception e) {
										logger.info("FILE: " + fileName + " ### INDEX: " + index + " ### VALUES: "
												+ Arrays.toString(values));
										e.printStackTrace();
									}
								}
							}
							index++;
						}
						preparedStatement.executeBatch();
						preparedStatement.clearBatch();
					}
				}
			}
		}
		logger.info("END POPULATE " + sdf.format(new Date()));
	}

	private static void downloadFiles() throws IOException {

		logger.info("START DOWNLOAD " + sdf.format(new Date()));
		Connection.Response loginForm = Jsoup.connect("https://app.qricambi.com/").method(Connection.Method.GET)
				.ignoreHttpErrors(true).execute();
		String jsonBodyAuthentication = "{\"username\":\"a.monzeglio@idir.it\",\"password\":\"idirspa\",\"rememberMe\":\"true\"}";
		String bodyToken = Jsoup.connect("https://app.qricambi.com/api/User/RequestToken")
				.header("Content-Type", "application/json").header("Accept", "application/json").followRedirects(true)
				.ignoreHttpErrors(true).ignoreContentType(true)
				.userAgent("Mozilla/5.0 AppleWebKit/537.36 (KHTML," + " like Gecko) Chrome/45.0.2454.4 Safari/537.36")
				.method(Connection.Method.POST).requestBody(jsonBodyAuthentication).maxBodySize(1_000_000 * 30) // 30 mb
				.timeout(0) // infinite timeout
				.execute().body();
		JSONObject jsonBodyOneToken = new JSONObject(bodyToken);
		String token = jsonBodyOneToken.getString("token");
		String authorization = "Bearer " + token;
		String publicKey = Jsoup.connect("https://app.qricambi.com/api/User/GetPubKey")
				.header("Content-Type", "application/text").header("Accept", "application/text")
				.header("Authorization", authorization).followRedirects(true).ignoreHttpErrors(true)
				.ignoreContentType(true)
				.userAgent("Mozilla/5.0 AppleWebKit/537.36 (KHTML," + " like Gecko) Chrome/45.0.2454.4 Safari/537.36")
				.method(Connection.Method.GET).cookies(loginForm.cookies()).maxBodySize(1_000_000 * 30) // 30 mb ~
				.timeout(0) // infinite timeout
				.execute().body();

		Connection.Response execute1 = Jsoup.connect("https://app.qricambi.com/api/User/CheckIfOtherUserAlreadyLogged")
				.header("Content-Type", "application/json").header("Accept", "application/json, text/plain, */*")
				.header("Authorization", authorization).followRedirects(true).ignoreHttpErrors(true)
				.ignoreContentType(true)
				.userAgent("Mozilla/5.0 AppleWebKit/537.36 (KHTML," + " like Gecko) Chrome/45.0.2454.4 Safari/537.36")
				.method(Connection.Method.POST).requestBody(publicKey).maxBodySize(1_000_000 * 30) // 30 mb ~
				.timeout(0) // infinite timeout
				.execute();
		boolean next = true;
		int page = 1;
		int index = 0;
		while (next) {
			String bodyList = Jsoup
					.connect("https://app.qricambi.com/api/SearchScheduler/List?page=" + page + "&filter=")
					.header("Content-Type", "application/json").header("Accept", "application/json")
					.header("Authorization", authorization).followRedirects(true).ignoreHttpErrors(true)
					.ignoreContentType(true)
					.userAgent(
							"Mozilla/5.0 AppleWebKit/537.36 (KHTML," + " like Gecko) Chrome/45.0.2454.4 Safari/537.36")
					.method(Connection.Method.GET).cookies(loginForm.cookies()).maxBodySize(1_000_000 * 30) // 30 mb ~
					.timeout(0) // infinite timeout
					.execute().body();
			JSONObject jsonBodyList = new JSONObject(bodyList);
			if (jsonBodyList.getJSONArray("Data").isEmpty())
				next = false;
			else {
				JSONObject jsonBodyInner = new JSONObject(jsonBodyList.toString(4));
				JSONArray listObject = (JSONArray) jsonBodyInner.get("Data");
				for (int i = 0; i < listObject.length(); i++) {
					JSONObject innerObject = listObject.getJSONObject(i);
					JSONObject inputs = (JSONObject) innerObject.get("Inputs");
					String url = "https://app.qricambi.com/api/SearchScheduler/DownloadExcel?task="
							.concat(String.valueOf(innerObject.get("Task")).concat(String.valueOf("&userid=")
									.concat(String.valueOf(inputs.get("UserId"))).concat("&newdownload=testnew")));
					logger.info("URL " + url);
					Connection.Response fileDownload = Jsoup.connect(url).header("Content-Type", "application/csv")
							.header("Accept", "application/json, text/plain, */*")
							.header("Authorization", authorization).followRedirects(true).ignoreHttpErrors(true)
							.ignoreContentType(true)
							.userAgent("Mozilla/5.0 AppleWebKit/537.36 (KHTML,"
									+ " like Gecko) Chrome/45.0.2454.4 Safari/537.36")
							.method(Connection.Method.GET).cookies(loginForm.cookies()).maxBodySize(1_000_000 * 30) // 30
																													// mb
							.timeout(0) // infinite timeout
							.maxBodySize(0).execute();
					Document document = fileDownload.parse();
					TextNode node = (TextNode) document.childNodes().get(0).childNodes().get(1).childNode(0);
					try (PrintWriter out = new PrintWriter(
							PATH_DOWNLOAD.concat("\\file_").concat("" + index).concat(".csv"))) {
						String[] array = node.getWholeText().replace("\"", "").split("\n");
						for (int ind = 0; ind < array.length; ind++) {
							if (array[ind].indexOf("risultato non trovato") != -1)
								continue;
							out.println(array[ind].replace("\t", PUNTO_VIRGOLA));
						}
					}
					index++;
				}
			}
			page++;
		}
		logger.info("END DOWNLOAD " + sdf.format(new Date()));
	}
}