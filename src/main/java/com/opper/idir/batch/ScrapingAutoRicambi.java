package com.opper.idir.batch;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;

import com.opper.idir.run.OpperBase;

public class ScrapingAutoRicambi extends OpperBase {

	public static void main(String[] args) throws Exception {

		ScrapingAutoRicambi scrapingAutoRicambi = new ScrapingAutoRicambi();
		scrapingAutoRicambi.run();
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
		logger.info("START DOWNLOAD " + sdf.format(new Date()));

		Map<String, String> postData = new HashMap<>();
		postData.put("kba[]", "GL768GP");
		postData.put("route", "main");
		postData.put("eventObject", "block");
		Document publicKey = Jsoup.connect("https://www.auto-doc.it/ajax/selector/vehicle/search-number")
				// .header("Cookie", "kmtx_sync=2074717006689958280;
				// INGRESSCOOKIE=1709368176.785.20047.160407|f89e2d2acc6cd8c158ba7aaea6f7fb53;
				// clientCode=196677;
				// tb_visit_counter_atd_it=eyJpdiI6IjMyTHJaazc2YS9YV25WOE5oSTN3UEE9PSIsInZhbHVlIjoieEZzank0RDV4MTdlTEJmdzJ4SnUvQWVHeklQM0tNeFdzWDhBMGFOblQrTEd1Y0cwNmYrTlk1d2M2ZEtGWDYvOCIsIm1hYyI6IjhiMmYxMDgxZjYzZDJmMDI5M2JiYzEzMGRkMjlmMjY1MzU2MTc0MDYwNjljNWRlMGY1MjliODQ2NDk4MGMwZWUiLCJ0YWciOiIifQ%3D%3D;
				// __cf_bm=EE4G5pRHB3S09wPWz3wrfiZghlaiow92jfhX4LPjxdI-1709368176-1.0.1.1-65PU_juf_x3VaB6q.GqM4ejlgCTNMlAoL4yCwPg7hsuxy_3FpuRMu6ZZZSfPHf3P35YYUJBdUkA26VeAm7fxxGjq9CTcF_660Lje8YJ62r8;
				// kmtx_sync=2074717006689958280;
				// kmtx_sync_pi=06b2b6de-02d4-4c33-82aa-79d58e6718f0;
				// cf_clearance=2yCu2Uue4uoCnqVMVzT4BUW6CtgF0MCfknJdIMz9lHo-1709368180-1.0.1.1-qX0aT8OX.9Q6sjd9czi1xSk4F5xQq_sg9Q2IrJqCNos56wwDxTcJvgZquf_UTvWJhyy702SvfrhqDtz0IfhLcg;
				// XSRF-TOKEN=eyJpdiI6IkhNQTE1a3JUK1NVbVYxOTdzY3lpMXc9PSIsInZhbHVlIjoiSGRNV3ZhNVJGbDNsYzZ6Y0IzRkNoR1AxbHhEVndXdERxZHVmWjlrSlVHWWZxSnFXVy8wWkFtTDBBNjZIdlNneG1XRnhtQUJHVC83VHBNb0FnRzlybXIzeVBlWHliOG1jNHB1Z09BNkh1eTBFL2pLdEEzMlpRcmVWWEE0dktCWFQiLCJtYWMiOiI1YWZmOWExZDNjZGZiMTJmOTE1ZDE4YWFlMGNmM2RjMDZiZGVlNDJiNTAyZDExNjhkYWRiNjE1YWE1MDJiYTllIiwidGFnIjoiIn0%3D;
				// l=eyJpdiI6InN4RUIyZ1pGNjVQNCszYzdPVHYvREE9PSIsInZhbHVlIjoiSlljRWZaaElJb3pKYTRWaThjNFBvc1BxckVvYlB4VlV4TERDRTJYdkcrQWxFZmJFSXBoWGUza3Z5TjJuRDZlZDNML3E2d0xiaW9KWjdqblZUa1dpYm82Vk5KRUtISzJzRnE1VTFsQWxJcE5rcU56eU0vWk5meGxpdDN5YlVqTkMiLCJtYWMiOiJmYTM2MDMwNjg4Y2VlNmNiOGQ0NjllNDFkODk0NjkzNjI3Y2NmYjBiYzhlODIwNDExOWFiNjZmZmRjN2FlM2U1IiwidGFnIjoiIn0%3D")
				.header("Cookie",
						"_fbp=fb.1.1709371720982.877507230; kmtx_sync=2892424985283577070; INGRESSCOOKIE=1709371721.561.835.270201|f89e2d2acc6cd8c158ba7aaea6f7fb53; clientCode=943462; __cf_bm=4wO9BhGN2l6RkKPbyOrd65L3hC7dn6XZR1hijAINL.I-1709371720-1.0.1.1-gswRlr2AFjpaw9nZ72VckNHvejcNp7LnNg5fBIK30ub5MFHMQaFDLP_.KHnztGTJuLw8DxjHvYzLryz_pVgBve931ER2ZRfEKlD8.nbHegs; kmtx_sync=2892424985283577070; cf_clearance=1ngsuuBIeaU39m2cVga_fXpdMWyI7Ej7aRNPd75C8Z4-1709371776-1.0.1.1-91yCmSP5AZhgV1Ja1i3su5Es1wEO_GoFF0rpecN2yrXT2QulGNZvYtqwLxDK18.XcIMUQCwlkY4RCtB4MJQGsw; _gcl_au=1.1.1730614038.1709371778; _ga=GA1.1.297668939.1709371775; kk_leadtag=true; _cq_duid=1.1709371787.oXoO8eiemG08csPv; _cq_suid=1.1709371787.NTOBKX8XnyN99tTz; _tt_enable_cookie=1; _ttp=NQlWMX_C87GNJ6jWbHAqs-DAXZm; lantern=acefe3df-cbf1-449b-b3f7-f6bbb79a4ee1; deduplication_cookie=advAutoMarkup; deduplication_cookie=advAutoMarkup; _ttgclid=CjwKCAiAloavBhBOEiwAbtAJO58BuXHGf-WACEumthZbnkOOmlUAJvh6ifm0erMVy6KqKsALO4r5DBoCFHIQAvD_BwE; _ttgclid=CjwKCAiAloavBhBOEiwAbtAJO58BuXHGf-WACEumthZbnkOOmlUAJvh6ifm0erMVy6KqKsALO4r5DBoCFHIQAvD_BwE; _ttgclid=CjwKCAiAloavBhBOEiwAbtAJO58BuXHGf-WACEumthZbnkOOmlUAJvh6ifm0erMVy6KqKsALO4r5DBoCFHIQAvD_BwE; tt_deduplication_cookie=google; tt_deduplication_cookie=google; tt_deduplication_cookie=google; tb_visit_counter_atd_it=eyJpdiI6Ik51UmtNRzZVU0JYVWtvSVlwS09QaWc9PSIsInZhbHVlIjoiSE8vL1dkMnB4a1hXTEorOW1HOFlRcDJvNzNGSVVVdEdNOUltdHRnUTI2VXZ6RE9URnEwOERzcXY1SmNzbkY1UyIsIm1hYyI6ImU2YzRjMDFiNTEzYTg4YjVjMDg1NzQyM2Q2M2E0ZWE2NjczZGZiMGViMTk3MWE1YWUxZmM0MjE4MGJjOTA5YzciLCJ0YWciOiIifQ%3D%3D; _gcl_aw=GCL.1709371838.CjwKCAiAloavBhBOEiwAbtAJO58BuXHGf-WACEumthZbnkOOmlUAJvh6ifm0erMVy6KqKsALO4r5DBoCFHIQAvD_BwE; _ga_NWDLPLW2VG=GS1.1.1709371775.1.1.1709371838.60.0.0; _uetsid=64074680d87711ee984c279a32a4ec6b|100j1cr|2|fjq|0|1522; kmtx_sync_pi=1b61fd8a-bb48-4134-a6c0-2f93c7e1bfbc; cto_bundle=NxSUel9reFI5VUFJM2oybERidSUyQkFmV0l4JTJCMVZlTnI4M1VjekFsdDFjYlNLSzZJbWNURXpDTEdWZVFLZDBMRzc1bkNxaUUxMm9nZTlpaDZpSUhvM3FNYlhxRUlpR1RKSm45TjQ5UmRicVR0eDlNUlFpSGFiSHc0R3FLRFgwWUZyNUZvSWt2RFlZNHExcHI0QkozTTVPVlRnYnZRJTNEJTNE; XSRF-TOKEN=eyJpdiI6IkN2YlE2SXlCd1hnSnRldmNDeng5NVE9PSIsInZhbHVlIjoiNTB5WG5maFpCM05DUUxjMVZON3RVcWJ1dWFqZ0NaWGdWNk5kV3R3WXkrNmxwMzhmZU9oYnBOWVdDUHJlTTVpU1BwbFB4VnROcnF5aGx1Ny96RWZra0N4aEwyTUM0UXJobHQyUGYzdjJSTTRoblRqT3N5TzY0Sm96N3pKc1dvYlgiLCJtYWMiOiIxZTgxYzQxOGZiZGYwMDkyM2U3MDQ5MjZjZTgxMDNkMjA3MWM0ODllMzRmYWM2MTg1YTI2YTMxZTEzYWM1Y2YwIiwidGFnIjoiIn0%3D; l=eyJpdiI6Iis4cGZvbVRodTRaYnZpMGVBczJKRVE9PSIsInZhbHVlIjoiRUF2MzQwTm9KZnRHWWFqWnE4RVd0UTdrWG4zT2k3Mi9jSXJ0anRac1BKa2NyL1ZYQ0hoejFzTkZMNjhnOWNUTUlhcit1K0Z6ck9XUFlZMXI4cUhyNzFPdUpEQmlYUWRJbFdmbE15YndsWXVrL2NtOElDY2VRZlhWZmFzTElPN1UiLCJtYWMiOiI2M2UwZDllM2NhMDU3ZmU3M2NhMjZlZjhiNGNmOGQwYzA5ODg4YTg4MGJhNDA4M2M4MjE3ZTJkYzM1MTEwOGE0IiwidGFnIjoiIn0%3D; _uetvid=64077950d87711eead9c87a850f4a752|edkkdm|1709371838952|5|1|bat.bing.com/p/insights/c/t")

				.header("X-Csrf-Token", "LRy0EC26Vf43VOfGxuU6voaoIfZ2aocgnPwZ2RMq")
				.header("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8")
				.header("Accept", "application/json, text/javascript, */*; q=0.01")
				// .header("Authorization", authorization)
				.followRedirects(true).ignoreHttpErrors(true).ignoreContentType(true)
				.userAgent("Mozilla/5.0 AppleWebKit/537.36 (KHTML," + " like Gecko) Chrome/45.0.2454.4 Safari/537.36")
				// .method(Connection.Method.POST)
				// .cookies(loginForm.cookies()).maxBodySize(1_000_000 * 30) // 30 mb ~
				.timeout(0) // infinite timeout
				.data(postData).post();
		// .execute().body();

		System.out.println("publicKey ---> " + publicKey);

		// Connection.Response loginForm =
		// Jsoup.connect("https://app.qricambi.com/").method(Connection.Method.GET)
		// .ignoreHttpErrors(true).execute();
		// String jsonBodyAuthentication =
		// "{\"username\":\"a.monzeglio@idir.it\",\"password\":\"idirspa\",\"rememberMe\":\"true\"}";
		// String bodyToken =
		// Jsoup.connect("https://app.qricambi.com/api/User/RequestToken")
		// .header("Content-Type", "application/json").header("Accept",
		// "application/json").followRedirects(true)
		// .ignoreHttpErrors(true).ignoreContentType(true)
		// .userAgent("Mozilla/5.0 AppleWebKit/537.36 (KHTML," + " like Gecko)
		// Chrome/45.0.2454.4 Safari/537.36")
		// .method(Connection.Method.POST).requestBody(jsonBodyAuthentication).maxBodySize(1_000_000
		// * 30) // 30 mb
		// .timeout(0) // infinite timeout
		// .execute().body();
		// JSONObject jsonBodyOneToken = new JSONObject(bodyToken);
		// String token = jsonBodyOneToken.getString("token");
		// String authorization = "Bearer " + token;
		// String publicKey =
		// Jsoup.connect("https://app.qricambi.com/api/User/GetPubKey")
		// .header("Content-Type", "application/text").header("Accept",
		// "application/text")
		// .header("Authorization",
		// authorization).followRedirects(true).ignoreHttpErrors(true)
		// .ignoreContentType(true)
		// .userAgent("Mozilla/5.0 AppleWebKit/537.36 (KHTML," + " like Gecko)
		// Chrome/45.0.2454.4 Safari/537.36")
		// .method(Connection.Method.GET).cookies(loginForm.cookies()).maxBodySize(1_000_000
		// * 30) // 30 mb ~
		// .timeout(0) // infinite timeout
		// .execute().body();
		//
		// Connection.Response execute1 =
		// Jsoup.connect("https://app.qricambi.com/api/User/CheckIfOtherUserAlreadyLogged")
		// .header("Content-Type", "application/json").header("Accept",
		// "application/json, text/plain, */*")
		// .header("Authorization",
		// authorization).followRedirects(true).ignoreHttpErrors(true)
		// .ignoreContentType(true)
		// .userAgent("Mozilla/5.0 AppleWebKit/537.36 (KHTML," + " like Gecko)
		// Chrome/45.0.2454.4 Safari/537.36")
		// .method(Connection.Method.POST).requestBody(publicKey).maxBodySize(1_000_000
		// * 30) // 30 mb ~
		// .timeout(0) // infinite timeout
		// .execute();
		// boolean next = true;
		// int page = 1;
		// int index = 0;
		// int indexOk = 0;
		// int indexKo = 0;
		// while (next) {
		// String bodyList = Jsoup
		// .connect("https://app.qricambi.com/api/SearchScheduler/List?page=" + page +
		// "&filter=")
		// .header("Content-Type", "application/json").header("Accept",
		// "application/json")
		// .header("Authorization",
		// authorization).followRedirects(true).ignoreHttpErrors(true)
		// .ignoreContentType(true)
		// .userAgent(
		// "Mozilla/5.0 AppleWebKit/537.36 (KHTML," + " like Gecko) Chrome/45.0.2454.4
		// Safari/537.36")
		// .method(Connection.Method.GET).cookies(loginForm.cookies()).maxBodySize(1_000_000
		// * 30) // 30 mb ~
		// .timeout(0) // infinite timeout
		// .execute().body();
		// JSONObject jsonBodyList = new JSONObject(bodyList);
		// if (jsonBodyList.getJSONArray("Data").isEmpty())
		// next = false;
		// else {
		// JSONObject jsonBodyInner = new JSONObject(jsonBodyList.toString(4));
		// JSONArray listObject = (JSONArray) jsonBodyInner.get("Data");
		// for (int i = 0; i < listObject.length(); i++) {
		// JSONObject innerObject = listObject.getJSONObject(i);
		// JSONObject inputs = (JSONObject) innerObject.get("Inputs");
		// String url =
		// "https://app.qricambi.com/api/SearchScheduler/DownloadExcel?task="
		// .concat(String.valueOf(innerObject.get("Task")).concat(String.valueOf("&userid=")
		// .concat(String.valueOf(inputs.get("UserId"))).concat("&newdownload=testnew")));
		// logger.info("URL " + url);
		// Connection.Response fileDownload = Jsoup.connect(url).header("Content-Type",
		// "application/csv")
		// .header("Accept", "application/json, text/plain, */*")
		// .header("Authorization",
		// authorization).followRedirects(true).ignoreHttpErrors(true)
		// .ignoreContentType(true)
		// .userAgent("Mozilla/5.0 AppleWebKit/537.36 (KHTML,"
		// + " like Gecko) Chrome/45.0.2454.4 Safari/537.36")
		// .method(Connection.Method.GET).cookies(loginForm.cookies()).maxBodySize(1_000_000
		// * 30) // 30
		// // mb
		// .timeout(0) // infinite timeout
		// .maxBodySize(0).execute();
		// Document document = fileDownload.parse();
		// TextNode node = (TextNode)
		// document.childNodes().get(0).childNodes().get(1).childNode(0);
		// try (PrintWriter out = new PrintWriter(
		// PATH_DOWNLOAD.concat("\\file_").concat("" + index).concat(".csv"))) {
		// String[] array = node.getWholeText().replace("\"", "").replace(";;",
		// ";X;").split("\n", -1);
		// for (int ind = 0; ind < array.length; ind++) {
		// if (array[ind].indexOf("risultato non trovato") != -1
		// && array[ind].indexOf("Errore durante la ricerca") != -1)
		// continue;
		// String line = array[ind].replace("\t", PUNTO_VIRGOLA);
		//
		// // System.out.println(line.split(PUNTO_VIRGOLA).length);
		// String[] arrayStr = line.split(PUNTO_VIRGOLA, -1);
		// int length = arrayStr.length;
		// if (length == 20) {
		// out.println(line);
		// indexOk++;
		// } else if (length == 19) {
		// line = line + ";[]";
		// // System.out.println("-->"+line.split(PUNTO_VIRGOLA, -1).length);
		// // out.println(line);
		// // logger.info("LINE " + line);
		// indexOk++;
		// } else if (length == 21) {
		// line = line.substring(0, line.lastIndexOf(";"));
		// // System.out.println("-->"+line.split(PUNTO_VIRGOLA, -1).length);
		// // out.println(line);
		// // logger.info("LINE " + line);
		// indexOk++;
		// } else if (length == 22) {
		// List<String> listTemp22 = new ArrayList<>();
		// listTemp22.add(arrayStr[0]);
		// listTemp22.add(arrayStr[1]);
		// listTemp22.add(arrayStr[2]);
		// listTemp22.add(arrayStr[3]);
		// listTemp22.add(arrayStr[4]);
		// listTemp22.add(arrayStr[5]);
		// listTemp22.add(arrayStr[6]);
		// listTemp22.add(arrayStr[7]);
		// listTemp22.add(arrayStr[8]);
		// listTemp22.add(arrayStr[9]);
		// listTemp22.add(arrayStr[10]);
		// listTemp22.add(arrayStr[11]);
		// listTemp22.add(arrayStr[14]);
		// listTemp22.add(arrayStr[15]);
		// listTemp22.add(arrayStr[16]);
		// listTemp22.add(arrayStr[17]);
		// listTemp22.add(arrayStr[18]);
		// listTemp22.add(arrayStr[19]);
		// listTemp22.add(arrayStr[20]);
		// listTemp22.add(arrayStr[21]);
		// line = String.join(PUNTO_VIRGOLA, listTemp22);
		// // System.out.println("-->"+line.split(PUNTO_VIRGOLA, -1).length);
		// // out.println(line);
		// // logger.info("LINE " + line);
		// indexOk++;
		// } else if (length == 23) {
		// List<String> listTemp23 = new ArrayList<>();
		// listTemp23.add(arrayStr[0]);
		// listTemp23.add(arrayStr[1]);
		// listTemp23.add(arrayStr[2]);
		// listTemp23.add(arrayStr[3]);
		// listTemp23.add(arrayStr[4]);
		// listTemp23.add(arrayStr[5]);
		// listTemp23.add(arrayStr[6]);
		// listTemp23.add(arrayStr[7]);
		// listTemp23.add(arrayStr[8]);
		// listTemp23.add(arrayStr[9]);
		// listTemp23.add(arrayStr[10]);
		// listTemp23.add(arrayStr[11]);
		// listTemp23.add(arrayStr[15]);
		// listTemp23.add(arrayStr[16]);
		// listTemp23.add(arrayStr[17]);
		// listTemp23.add(arrayStr[18]);
		// listTemp23.add(arrayStr[19]);
		// listTemp23.add(arrayStr[20]);
		// listTemp23.add(arrayStr[21]);
		// listTemp23.add(arrayStr[22]);
		// line = String.join(PUNTO_VIRGOLA, listTemp23);
		// // System.out.println("-->"+line.split(PUNTO_VIRGOLA, -1).length);
		// // out.println(line);
		// // logger.info("LINE " + line);
		// indexOk++;
		// } else if (length == 16) {
		// List<String> listTemp16 = new ArrayList<>();
		// listTemp16.add(arrayStr[0]);
		// listTemp16.add(arrayStr[1]);
		// listTemp16.add(arrayStr[2]);
		// listTemp16.add(arrayStr[3]);
		// listTemp16.add(arrayStr[4]);
		// listTemp16.add(arrayStr[5]);
		// listTemp16.add(arrayStr[6]);
		// listTemp16.add(arrayStr[7]);
		// listTemp16.add(arrayStr[8]);
		// listTemp16.add(arrayStr[9]);
		// listTemp16.add(arrayStr[10]);
		// listTemp16.add(arrayStr[11]);
		// listTemp16.add(arrayStr[13]);
		// listTemp16.add(arrayStr[14]);
		// listTemp16.add(arrayStr[15]);
		// listTemp16.add("");
		// listTemp16.add("");
		// listTemp16.add("");
		// listTemp16.add("");
		// listTemp16.add("");
		// line = String.join(PUNTO_VIRGOLA, listTemp16);
		// // System.out.println("-->"+line.split(PUNTO_VIRGOLA, -1).length);
		// // out.println(line);
		// // logger.info("LINE " + line);
		// indexOk++;
		// } else if (length == 24) {
		// List<String> listTemp24 = new ArrayList<>();
		// listTemp24.add(arrayStr[0]);
		// listTemp24.add(arrayStr[1]);
		// listTemp24.add(arrayStr[2]);
		// listTemp24.add(arrayStr[3]);
		// listTemp24.add(arrayStr[4]);
		// listTemp24.add(arrayStr[5]);
		// listTemp24.add(arrayStr[6]);
		// listTemp24.add(arrayStr[7]);
		// listTemp24.add(arrayStr[8]);
		// listTemp24.add(arrayStr[9]);
		// listTemp24.add(arrayStr[10]);
		// listTemp24.add(arrayStr[11]);
		// listTemp24.add(arrayStr[16]);
		// listTemp24.add(arrayStr[17]);
		// listTemp24.add(arrayStr[18]);
		// listTemp24.add(arrayStr[19]);
		// listTemp24.add(arrayStr[20]);
		// listTemp24.add(arrayStr[21]);
		// listTemp24.add(arrayStr[22]);
		// listTemp24.add(arrayStr[23]);
		// line = String.join(PUNTO_VIRGOLA, listTemp24);
		// // System.out.println("-->"+line.split(PUNTO_VIRGOLA, -1).length);
		// // out.println(line);
		// // logger.info("LINE " + line);
		// indexOk++;
		// } else if (length == 25) {
		// List<String> listTemp25 = new ArrayList<>();
		// listTemp25.add(arrayStr[0]);
		// listTemp25.add(arrayStr[1]);
		// listTemp25.add(arrayStr[2]);
		// listTemp25.add(arrayStr[3]);
		// listTemp25.add(arrayStr[4]);
		// listTemp25.add(arrayStr[5]);
		// listTemp25.add(arrayStr[6]);
		// listTemp25.add(arrayStr[7]);
		// listTemp25.add(arrayStr[8]);
		// listTemp25.add(arrayStr[9]);
		// listTemp25.add(arrayStr[10]);
		// listTemp25.add(arrayStr[11]);
		// listTemp25.add(arrayStr[17]);
		// listTemp25.add(arrayStr[18]);
		// listTemp25.add(arrayStr[19]);
		// listTemp25.add(arrayStr[20]);
		// listTemp25.add(arrayStr[21]);
		// listTemp25.add(arrayStr[22]);
		// listTemp25.add(arrayStr[23]);
		// listTemp25.add(arrayStr[24]);
		// line = String.join(PUNTO_VIRGOLA, listTemp25);
		// // System.out.println("-->"+line.split(PUNTO_VIRGOLA, -1).length);
		// // out.println(line);
		// // logger.info("LINE " + line);
		// indexOk++;
		// } else if (length == 1) {
		// } else {
		// logger.info("LINE " + line + " LENGTH " + length);
		// indexKo++;
		// }
		//// else if(length == 19) {
		//// StringTokenizer st = new StringTokenizer(line,PUNTO_VIRGOLA);
		//// System.out.println("COUNT TOKEN: -->"+st.countTokens());
		//// line = line.substring(0,line.lastIndexOf(";")) + "[]";
		//// System.out.println("-->"+line.split(PUNTO_VIRGOLA).length);
		//// out.println(line);
		//// }else if(length == 18) {
		//// line += "[]";
		//// System.out.println("-->"+line.split(PUNTO_VIRGOLA).length);
		//// out.println(line);
		//// logger.info("LINE " + line);
		//// }else if(length == 17) {
		//// line = line.substring(0,line.lastIndexOf(";")) + "[]";
		//// System.out.println("-->"+line.split(PUNTO_VIRGOLA).length);
		//// out.println(line);
		//// logger.info("LINE " + line);
		//// }else if(length == 21) {
		//// line = line.substring(0,line.lastIndexOf(";")) ;
		//// System.out.println("-->"+line.split(PUNTO_VIRGOLA).length);
		//// //out.println(line);
		//// logger.info("LINE " + line);
		//// }else if(length == 22) {
		//// arrayStr = line.split(PUNTO_VIRGOLA);
		//// List<String> listApp = new ArrayList<>();
		//// List<String> list = Arrays.asList(arrayStr);
		//// for(int i2=0;i2<list.size();i2++) {
		//// if(i2 != 12 && i2 != 13 && i2 != 14)
		//// listApp.add(list.get(i2));
		//// }
		//// line = "";
		//// for(int i1=0;i1<listApp.size();i1++) {
		//// line = line + listApp.get(i1) + PUNTO_VIRGOLA;
		//// }
		//// //line = line + PUNTO_VIRGOLA + "[]";
		//// //line = line.substring(0,line.lastIndexOf(";"));
		//// System.out.println("-->"+line.split(PUNTO_VIRGOLA).length);
		//// out.println(line);
		//// logger.info("LINE " + line);
		//// }else {
		//// line = line.substring(0,line.lastIndexOf(";"));
		//// System.out.println("-->"+line.split(PUNTO_VIRGOLA).length);
		//// out.println(line);
		//// logger.info("LINE " + line);
		//// }
		// }
		// }
		// index++;
		// }
		// }
		// page++;
		// }
		// logger.info("KO " + indexKo);
		// logger.info("OK " + indexOk);
		logger.info("END DOWNLOAD " + sdf.format(new Date()));
	}
}