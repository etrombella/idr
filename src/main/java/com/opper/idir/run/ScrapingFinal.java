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
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Set;
import java.util.StringTokenizer;
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

	private static Logger logger = LoggerFactory.getLogger(ScrapingFinal.class);

	private static final String PUNTO_VIRGOLA = ";";
	private static final String COMMA = ",";
	private static final String DOT = ".";
	private static final String SEPARATOR = "\\";
	private static final String DEFAULT_DOUBLE = "0.0";
	private static final char COMMA_CHAR = ',';

	private static final SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss.SSS");
	private static final SimpleDateFormat sdfOutput = new SimpleDateFormat("ddMMyyyy");

	private final static String PATH_DOWNLOAD = "T:\\OPPER\\jar\\download";
	// private final static String PATH_DOWNLOAD = "C:\\temp\\filecsv";

	public static void main(String[] args) throws IOException, SQLException {

		downloadFiles();
		populateTable();
		moveFileToEndDirectory();
	}

	private static void moveFileToEndDirectory() {

		String outputPath = PATH_DOWNLOAD.concat("\\").concat(sdfOutput.format(new Date()));
		
		File directoryOutput = new File(outputPath);
		directoryOutput.mkdirs();
		
		File[] files = new File(PATH_DOWNLOAD).listFiles();
		//If this pathname does not denote a directory, then listFiles() returns null. 

		for (File file : files) {
		    if (file.isFile()) 
		        file.renameTo(new File(outputPath.concat("\\").concat(file.getName())));
		}
		
	}

	private static java.sql.Connection getConnection() throws SQLException {

		return DriverManager.getConnection(
				"jdbc:sqlserver://svrsqldwh.idirspa.local:1433;instanceName=MSSQLSERVER;databaseName=opper;encrypt=true;trustServerCertificate=true",
				"opper", "opper2023");
	}

	private static String deleteCommna(String value) {

		long occurence = value.chars().filter(ch -> ch == COMMA_CHAR).count();
		if (occurence > 1) {
			StringBuilder strBuilder = new StringBuilder(value);
			int indexOccurence = 1;
			for (int index = 0; index < value.length(); index++) {
				if (value.charAt(index) == COMMA_CHAR) {
					if (indexOccurence < occurence)
						strBuilder = strBuilder.deleteCharAt(index);
					indexOccurence++;
				}
			}
			return strBuilder.toString();
		}
		return value;
	}

	private static void populateTable() throws IOException, SQLException {

		logger.info("START SCARPING " + sdf.format(new Date()));
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
								String[] values = line.split(PUNTO_VIRGOLA, -1);

								if (values.length != 20
										|| Arrays.asList(values).contains("Errore durante la ricerca")) {
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
										String number13 = DEFAULT_DOUBLE;
										if (values[12] != null && values[12].trim().length() != 0)
											number13 = deleteCommna(values[12]).replace(COMMA, DOT);
										preparedStatement.setDouble(13, Double.parseDouble(number13));
										String number14 = DEFAULT_DOUBLE;
										if (values[13] != null && values[13].trim().length() != 0)
											number14 = deleteCommna(values[13]).replace(COMMA, DOT);
										preparedStatement.setDouble(14, Double.parseDouble(number14));
										String number15 = DEFAULT_DOUBLE;
										if (values[14] != null && values[14].trim().length() != 0)
											number15 = deleteCommna(values[14]).replace(COMMA, DOT);
										preparedStatement.setDouble(15, Double.parseDouble(number15));
										preparedStatement.setString(16, values[15]);
										preparedStatement.setString(17, values[16]);
										preparedStatement.setString(18, values[17]);
										preparedStatement.setString(19, values[18]);
										preparedStatement.setString(20, values[19]);
										// preparedStatement.executeUpdate();
										preparedStatement.addBatch();
										if (index % 10000 == 0) {
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
		logger.info("END SCARPING " + sdf.format(new Date()));
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
		int indexOk = 0;
		int indexKo = 0;
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
						String[] array = node.getWholeText().replace("\"", "").replace(";;", ";X;").split("\n", -1);
						for (int ind = 0; ind < array.length; ind++) {
							if (array[ind].indexOf("risultato non trovato") != -1
									&& array[ind].indexOf("Errore durante la ricerca") != -1)
								continue;
							String line = array[ind].replace("\t", PUNTO_VIRGOLA);

							// System.out.println(line.split(PUNTO_VIRGOLA).length);
							String[] arrayStr = line.split(PUNTO_VIRGOLA, -1);
							int length = arrayStr.length;
							if (length == 20) {
								out.println(line);
								indexOk++;
							} else if (length == 19) {
								line = line + ";[]";
								// System.out.println("-->"+line.split(PUNTO_VIRGOLA, -1).length);
								// out.println(line);
								// logger.info("LINE " + line);
								indexOk++;
							} else if (length == 21) {
								line = line.substring(0, line.lastIndexOf(";"));
								// System.out.println("-->"+line.split(PUNTO_VIRGOLA, -1).length);
								// out.println(line);
								// logger.info("LINE " + line);
								indexOk++;
							} else if (length == 22) {
								List<String> listTemp22 = new ArrayList<>();
								listTemp22.add(arrayStr[0]);
								listTemp22.add(arrayStr[1]);
								listTemp22.add(arrayStr[2]);
								listTemp22.add(arrayStr[3]);
								listTemp22.add(arrayStr[4]);
								listTemp22.add(arrayStr[5]);
								listTemp22.add(arrayStr[6]);
								listTemp22.add(arrayStr[7]);
								listTemp22.add(arrayStr[8]);
								listTemp22.add(arrayStr[9]);
								listTemp22.add(arrayStr[10]);
								listTemp22.add(arrayStr[11]);
								listTemp22.add(arrayStr[14]);
								listTemp22.add(arrayStr[15]);
								listTemp22.add(arrayStr[16]);
								listTemp22.add(arrayStr[17]);
								listTemp22.add(arrayStr[18]);
								listTemp22.add(arrayStr[19]);
								listTemp22.add(arrayStr[20]);
								listTemp22.add(arrayStr[21]);
								line = String.join(PUNTO_VIRGOLA, listTemp22);
								// System.out.println("-->"+line.split(PUNTO_VIRGOLA, -1).length);
								// out.println(line);
								// logger.info("LINE " + line);
								indexOk++;
							} else if (length == 23) {
								List<String> listTemp23 = new ArrayList<>();
								listTemp23.add(arrayStr[0]);
								listTemp23.add(arrayStr[1]);
								listTemp23.add(arrayStr[2]);
								listTemp23.add(arrayStr[3]);
								listTemp23.add(arrayStr[4]);
								listTemp23.add(arrayStr[5]);
								listTemp23.add(arrayStr[6]);
								listTemp23.add(arrayStr[7]);
								listTemp23.add(arrayStr[8]);
								listTemp23.add(arrayStr[9]);
								listTemp23.add(arrayStr[10]);
								listTemp23.add(arrayStr[11]);
								listTemp23.add(arrayStr[15]);
								listTemp23.add(arrayStr[16]);
								listTemp23.add(arrayStr[17]);
								listTemp23.add(arrayStr[18]);
								listTemp23.add(arrayStr[19]);
								listTemp23.add(arrayStr[20]);
								listTemp23.add(arrayStr[21]);
								listTemp23.add(arrayStr[22]);
								line = String.join(PUNTO_VIRGOLA, listTemp23);
								// System.out.println("-->"+line.split(PUNTO_VIRGOLA, -1).length);
								// out.println(line);
								// logger.info("LINE " + line);
								indexOk++;
							} else if (length == 16) {
								List<String> listTemp16 = new ArrayList<>();
								listTemp16.add(arrayStr[0]);
								listTemp16.add(arrayStr[1]);
								listTemp16.add(arrayStr[2]);
								listTemp16.add(arrayStr[3]);
								listTemp16.add(arrayStr[4]);
								listTemp16.add(arrayStr[5]);
								listTemp16.add(arrayStr[6]);
								listTemp16.add(arrayStr[7]);
								listTemp16.add(arrayStr[8]);
								listTemp16.add(arrayStr[9]);
								listTemp16.add(arrayStr[10]);
								listTemp16.add(arrayStr[11]);
								listTemp16.add(arrayStr[13]);
								listTemp16.add(arrayStr[14]);
								listTemp16.add(arrayStr[15]);
								listTemp16.add("");
								listTemp16.add("");
								listTemp16.add("");
								listTemp16.add("");
								listTemp16.add("");
								line = String.join(PUNTO_VIRGOLA, listTemp16);
								// System.out.println("-->"+line.split(PUNTO_VIRGOLA, -1).length);
								// out.println(line);
								// logger.info("LINE " + line);
								indexOk++;
							} else if (length == 24) {
								List<String> listTemp24 = new ArrayList<>();
								listTemp24.add(arrayStr[0]);
								listTemp24.add(arrayStr[1]);
								listTemp24.add(arrayStr[2]);
								listTemp24.add(arrayStr[3]);
								listTemp24.add(arrayStr[4]);
								listTemp24.add(arrayStr[5]);
								listTemp24.add(arrayStr[6]);
								listTemp24.add(arrayStr[7]);
								listTemp24.add(arrayStr[8]);
								listTemp24.add(arrayStr[9]);
								listTemp24.add(arrayStr[10]);
								listTemp24.add(arrayStr[11]);
								listTemp24.add(arrayStr[16]);
								listTemp24.add(arrayStr[17]);
								listTemp24.add(arrayStr[18]);
								listTemp24.add(arrayStr[19]);
								listTemp24.add(arrayStr[20]);
								listTemp24.add(arrayStr[21]);
								listTemp24.add(arrayStr[22]);
								listTemp24.add(arrayStr[23]);
								line = String.join(PUNTO_VIRGOLA, listTemp24);
								// System.out.println("-->"+line.split(PUNTO_VIRGOLA, -1).length);
								// out.println(line);
								// logger.info("LINE " + line);
								indexOk++;
							} else if (length == 25) {
								List<String> listTemp25 = new ArrayList<>();
								listTemp25.add(arrayStr[0]);
								listTemp25.add(arrayStr[1]);
								listTemp25.add(arrayStr[2]);
								listTemp25.add(arrayStr[3]);
								listTemp25.add(arrayStr[4]);
								listTemp25.add(arrayStr[5]);
								listTemp25.add(arrayStr[6]);
								listTemp25.add(arrayStr[7]);
								listTemp25.add(arrayStr[8]);
								listTemp25.add(arrayStr[9]);
								listTemp25.add(arrayStr[10]);
								listTemp25.add(arrayStr[11]);
								listTemp25.add(arrayStr[17]);
								listTemp25.add(arrayStr[18]);
								listTemp25.add(arrayStr[19]);
								listTemp25.add(arrayStr[20]);
								listTemp25.add(arrayStr[21]);
								listTemp25.add(arrayStr[22]);
								listTemp25.add(arrayStr[23]);
								listTemp25.add(arrayStr[24]);
								line = String.join(PUNTO_VIRGOLA, listTemp25);
								// System.out.println("-->"+line.split(PUNTO_VIRGOLA, -1).length);
								// out.println(line);
								// logger.info("LINE " + line);
								indexOk++;
							} else if (length == 1) {
							} else {
								logger.info("LINE " + line + " LENGTH " + length);
								indexKo++;
							}
//							else if(length == 19) {
//								StringTokenizer st = new StringTokenizer(line,PUNTO_VIRGOLA);
//								System.out.println("COUNT TOKEN: -->"+st.countTokens());
//								line = line.substring(0,line.lastIndexOf(";")) + "[]"; 
//								System.out.println("-->"+line.split(PUNTO_VIRGOLA).length);
//								out.println(line);
//							}else if(length == 18) {
//									line += "[]"; 
//									System.out.println("-->"+line.split(PUNTO_VIRGOLA).length);
//									out.println(line);
//									logger.info("LINE " + line);
//							}else if(length == 17) {
//								line = line.substring(0,line.lastIndexOf(";")) + "[]"; 
//								System.out.println("-->"+line.split(PUNTO_VIRGOLA).length);
//								out.println(line);
//								logger.info("LINE " + line);
//							}else if(length == 21) {
//								line = line.substring(0,line.lastIndexOf(";")) ; 
//								System.out.println("-->"+line.split(PUNTO_VIRGOLA).length);
//								//out.println(line);
//								logger.info("LINE " + line);
//							}else if(length == 22) {
//								arrayStr = line.split(PUNTO_VIRGOLA);
//								List<String> listApp = new ArrayList<>();
//								List<String> list = Arrays.asList(arrayStr);
//								for(int i2=0;i2<list.size();i2++) {
//									if(i2 != 12 && i2 != 13 && i2 != 14)
//										listApp.add(list.get(i2));
//								}
//								line = "";
//								for(int i1=0;i1<listApp.size();i1++) {
//									line = line + listApp.get(i1) + PUNTO_VIRGOLA; 
//								}
//								//line = line +  PUNTO_VIRGOLA + "[]"; 
//								//line = line.substring(0,line.lastIndexOf(";")); 
//								System.out.println("-->"+line.split(PUNTO_VIRGOLA).length);
//								out.println(line);
//								logger.info("LINE " + line);
//							}else {
//								line = line.substring(0,line.lastIndexOf(";")); 
//								System.out.println("-->"+line.split(PUNTO_VIRGOLA).length);
//								out.println(line);
//								logger.info("LINE " + line);
//							}
						}
					}
					index++;
				}
			}
			page++;
		}
		logger.info("KO " + indexKo);
		logger.info("OK " + indexOk);
		logger.info("END DOWNLOAD " + sdf.format(new Date()));
	}
}