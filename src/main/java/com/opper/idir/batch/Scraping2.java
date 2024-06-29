package com.opper.idir.batch;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.json.JSONArray;
import org.json.JSONObject;
import org.jsoup.Connection;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.TextNode;

import com.opper.idir.run.OpperBase;

public class Scraping2 extends OpperBase {

	public static void main(String[] args) throws Exception {

		Scraping2 scraping2 = new Scraping2();
		scraping2.run();
	}

	public void run() throws Exception {

		try {
			downloadFiles();
		} catch (Exception e) {
			sendEmail(e);
			throw e;
		}
	}

	private void downloadFiles() throws IOException {
		SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss.SSS");
		System.out.println("START DOWNLOAD " + sdf.format(new Date()));
		// get login form
		Connection.Response loginForm = Jsoup.connect("https://app.qricambi.com/").method(Connection.Method.GET)
				.ignoreHttpErrors(true).execute();

		String jsonBodyAuthentication = "{\"username\":\"a.monzeglio@idir.it\",\"password\":\"idirspa\",\"rememberMe\":\"true\"}";
		// POST login data
//	    Document loginResponse = Jsoup.connect("https://app.qricambi.com/api/User/RequestToken")
//	    		
//	    		
//	        .data("username", "a.monzeglio@idir.it")
//	        .data("password", "idirspa")
//	        .data("rememberMe", "true")
//	        .cookies(loginForm.cookies())
//	        .timeout(100000)
//	        .post();

		// Connection.Response execute =
		// Jsoup.connect("https://app.qricambi.com/api/User/RequestToken")
		String bodyToken = Jsoup.connect("https://app.qricambi.com/api/User/RequestToken")
				.header("Content-Type", "application/json").header("Accept", "application/json").followRedirects(true)
				.ignoreHttpErrors(true).ignoreContentType(true)
				.userAgent("Mozilla/5.0 AppleWebKit/537.36 (KHTML," + " like Gecko) Chrome/45.0.2454.4 Safari/537.36")
				.method(Connection.Method.POST).requestBody(jsonBodyAuthentication).maxBodySize(1_000_000 * 30) // 30 mb
																												// ~
				.timeout(0) // infinite timeout
				.execute().body();
		// Document doc = execute.parse();

		JSONObject jsonBodyOneToken = new JSONObject(bodyToken);
		String token = jsonBodyOneToken.getString("token");
		String authorization = "Bearer " + token;

		// Connection.Response execute2 =
		// Jsoup.connect("https://app.qricambi.com/api/User/GetPubKey")
		String publicKey = Jsoup.connect("https://app.qricambi.com/api/User/GetPubKey")
				.header("Content-Type", "application/text").header("Accept", "application/text")
				.header("Authorization", authorization).followRedirects(true).ignoreHttpErrors(true)
				.ignoreContentType(true)
				.userAgent("Mozilla/5.0 AppleWebKit/537.36 (KHTML," + " like Gecko) Chrome/45.0.2454.4 Safari/537.36")
				.method(Connection.Method.GET)
				// .requestBody(jsonBody)
				.cookies(loginForm.cookies()).maxBodySize(1_000_000 * 30) // 30 mb ~
				.timeout(0) // infinite timeout
				.execute().body();

		// String xmlBodyPublicKey =
		// "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA3OkKtalHx7JvNS8QRxFTejToPnVRDDtisea93FIiWJIA0l3uTUOD0swFCdHhTWCqaorhchB34HZ2nHnuWrYKI19KqStesHNPf/hUIR+H4uYRa9wU00wWP9ycOzkeHvnL3iYXhSRD4BlSU1WjEtSLuxn4KfMXn0UaUvo+1jb/19GgTGGy+8YCom4M7uUspToDLogyOmzJj6drMCdafqWCZAvLIjjBCuzYcetJx0xIVTXHWmmEdGOfkuw4T97dyjeqUsUS21Aex50KZJXAjxUQQbz2bJi0i9X4DZ02VrznoHpXFPhNXLF8neiBZf4PqhrKEyyMIbU0P2vZPRSv4uSxbwIDAQAB";

		// Connection.Response execute1 =
		Jsoup.connect("https://app.qricambi.com/api/User/CheckIfOtherUserAlreadyLogged")
				.header("Content-Type", "application/json").header("Accept", "application/json, text/plain, */*")
				.header("Authorization", authorization).followRedirects(true).ignoreHttpErrors(true)
				.ignoreContentType(true)
				.userAgent("Mozilla/5.0 AppleWebKit/537.36 (KHTML," + " like Gecko) Chrome/45.0.2454.4 Safari/537.36")
				.method(Connection.Method.POST).requestBody(publicKey).maxBodySize(1_000_000 * 30) // 30 mb ~
				.timeout(0) // infinite timeout
				.execute();

		// Connection.Response execute3 =
		// Jsoup.connect("https://app.qricambi.com/api/SearchScheduler/List?page=1&filter=")
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
					.method(Connection.Method.GET)
					// .requestBody(jsonBody)
					.cookies(loginForm.cookies()).maxBodySize(1_000_000 * 30) // 30 mb ~
					.timeout(0) // infinite timeout
					.execute().body();

			JSONObject jsonBodyList = new JSONObject(bodyList);
			if (jsonBodyList.getJSONArray("Data").isEmpty())
				next = false;
			else {
				// System.out.println(jsonBodyList.toString(4));
//		    	"Task"
//		    	"UserId"
				JSONObject jsonBodyInner = new JSONObject(jsonBodyList.toString(4));
				JSONArray listObject = (JSONArray) jsonBodyInner.get("Data");
				for (int i = 0; i < listObject.length(); i++) {
					JSONObject innerObject = listObject.getJSONObject(i);
					// System.out.println("Task--> " + innerObject.get("Task"));
					JSONObject inputs = (JSONObject) innerObject.get("Inputs");
					// System.out.println("UserId--> " + inputs.get("UserId"));

					String url = "https://app.qricambi.com/api/SearchScheduler/DownloadExcel?task="
							.concat(String.valueOf(innerObject.get("Task")).concat(String.valueOf("&userid=")
									.concat(String.valueOf(inputs.get("UserId"))).concat("&newdownload=testnew")));
					System.out.println("URL " + url);

					// Connection.Response fileDownload = Jsoup.connect(url)

					// sFile downloadFile = new
					// File("C:\\temp\\filecsv\\file_2222".concat(".xlsx"));
//
//					Connection con = Jsoup.connect("https://app.qricambi.com/api/SearchScheduler/DownloadExcel?task=projects%2Fqricambi%2Flocations%2Feurope-west3%2Fqueues%2Fscheduled-searches%2Ftasks%2F38610179009514844651&userid=801&newdownload=testnew")
//					    .timeout(300000)
//					    .header("Cache-Control", "max-age=0")
//					    .method(Connection.Method.GET).cookies(loginForm.cookies())
//					    .ignoreContentType(true);
//					Connection.Response res = con.execute();
//					BufferedInputStream body = res.bodyStream();
//					Files.copy(body, downloadFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
//
//					System.out.println("Saved URL to " + downloadFile.getAbsolutePath());

					Connection.Response fileDownload = Jsoup.connect(url)
							// "https://app.qricambi.com/api/SearchScheduler/DownloadExcel?task=projects%2Fqricambi%2Flocations%2Feurope-west3%2Fqueues%2Fscheduled-searches%2Ftasks%2F38610179009514844651&userid=801&newdownload=testnew")
							// "https://app.qricambi.com/api/SearchScheduler/DownloadExcel?task=projects/qricambi/locations/europe-west3/queues/scheduled-searches/tasks/38610179009514844651&userid=801&newdownload=testnew")

							.header("Content-Type", "application/csv")
							.header("Accept", "application/json, text/plain, */*")
							.header("Authorization", authorization).followRedirects(true).ignoreHttpErrors(true)
							.ignoreContentType(true)
							.userAgent("Mozilla/5.0 AppleWebKit/537.36 (KHTML,"
									+ " like Gecko) Chrome/45.0.2454.4 Safari/537.36")
							.method(Connection.Method.GET).cookies(loginForm.cookies()).maxBodySize(1_000_000 * 30) // 30
																													// mb
																													// ~
							.timeout(0) // infinite timeout
							.maxBodySize(0).execute();
//					BufferedInputStream body = fileDownload.bodyStream();
//					Files.copy(body, downloadFile.toPath(), StandardCopyOption.REPLACE_EXISTING);

//					File file = new File("C:\\temp\\filecsv\\file_1111".concat(".xlsx"));
//					BufferedInputStream inputStream = fileDownload.bodyStream();
//			        FileOutputStream fos = new FileOutputStream(file);
//			        byte[] buffer = new byte[1024];
//			        int len;
//			        while ((len = inputStream.read(buffer)) != -1) {
//			            fos.write(buffer, 0, len);
//			        }
//			        inputStream.close();
//			        fos.close();

					Document document = fileDownload.parse();
					TextNode node = (TextNode) document.childNodes().get(0).childNodes().get(1).childNode(0);
					// System.out.println("INIZIO --> " + node.getWholeText() + " <-- FINE");
					// String content =
					// document.childNodes().get(0).childNodes().get(1).childNode(0).toString();
					try (PrintWriter out = new PrintWriter(
							"C:\\temp\\filecsv\\file_".concat("" + index).concat(".csv"))) {
						String[] array = node.getWholeText().replace("\"", "").split("\n");
						for (int ind = 0; ind < array.length; ind++) {
							// String[] split = array[ind].split("\\t");
							if (array[ind].indexOf("risultato non trovato") != -1)
								continue;
							out.println(array[ind].replace("\t", ";"));
						}
					}
					index++;
					// System.out.println("END CALL URL");

				}

			}
			page++;
		}
		System.out.println("END DOWNLOAD " + sdf.format(new Date()));

		// GET page
//	    Connection.Response document = Jsoup.connect("https://www.elit.com.ar/productos/computadoras.html")
//	        .method(Connection.Method.GET)
//	        .cookies(loginResponse.cookies())
//	        .timeout(100000)
//	        .execute();
		// System.out.println(document.getAllElements());

	}
}
