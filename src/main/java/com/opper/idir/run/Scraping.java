package com.opper.idir.run;

import java.io.IOException;

import org.json.JSONObject;
import org.jsoup.Connection;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;

public class Scraping {

	//public void run() {
	public static void main(String[] args) throws IOException {
		// get login form
	    Connection.Response loginForm = Jsoup.connect("https://app.qricambi.com/")
	        .method(Connection.Method.GET).ignoreHttpErrors(true)
	        .execute();

	    String jsonBody = "{\"username\":\"a.monzeglio@idir.it\",\"password\":\"idirspa\",\"rememberMe\":\"true\"}";
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
	    
	    //Connection.Response execute = Jsoup.connect("https://app.qricambi.com/api/User/RequestToken")
	    String body = Jsoup.connect("https://app.qricambi.com/api/User/RequestToken")
	            .header("Content-Type", "application/json")
	            .header("Accept", "application/json")
	            .followRedirects(true)
	            .ignoreHttpErrors(true)
	            .ignoreContentType(true)
	            .userAgent("Mozilla/5.0 AppleWebKit/537.36 (KHTML," +
	                    " like Gecko) Chrome/45.0.2454.4 Safari/537.36")
	            .method(Connection.Method.POST)
	            .requestBody(jsonBody)
	            .maxBodySize(1_000_000 * 30) // 30 mb ~
	            .timeout(0) // infinite timeout
	            .execute().body();	    
	    //Document doc = execute.parse();

	    JSONObject jsonBodyOne = new JSONObject(body);
	    String token = jsonBodyOne.getString("token");
	    
	    String xmlBody = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA3OkKtalHx7JvNS8QRxFTejToPnVRDDtisea93FIiWJIA0l3uTUOD0swFCdHhTWCqaorhchB34HZ2nHnuWrYKI19KqStesHNPf/hUIR+H4uYRa9wU00wWP9ycOzkeHvnL3iYXhSRD4BlSU1WjEtSLuxn4KfMXn0UaUvo+1jb/19GgTGGy+8YCom4M7uUspToDLogyOmzJj6drMCdafqWCZAvLIjjBCuzYcetJx0xIVTXHWmmEdGOfkuw4T97dyjeqUsUS21Aex50KZJXAjxUQQbz2bJi0i9X4DZ02VrznoHpXFPhNXLF8neiBZf4PqhrKEyyMIbU0P2vZPRSv4uSxbwIDAQAB";
		
	    String authorization = "Bearer " + token;
	    Connection.Response execute1 = Jsoup.connect("https://app.qricambi.com/api/User/CheckIfOtherUserAlreadyLogged")
	            .header("Content-Type", "application/json")
	            .header("Accept", "application/json, text/plain, */*")
	            .header("Authorization", authorization)
	            .followRedirects(true)
	            .ignoreHttpErrors(true)
	            .ignoreContentType(true)
	            .userAgent("Mozilla/5.0 AppleWebKit/537.36 (KHTML," +
	                    " like Gecko) Chrome/45.0.2454.4 Safari/537.36")
	            .method(Connection.Method.POST)
	            .requestBody(xmlBody)
	            .maxBodySize(1_000_000 * 30) // 30 mb ~
	            .timeout(0) // infinite timeout
	            .execute();	    
	    
	    Connection.Response execute2 = Jsoup.connect("https://app.qricambi.com/api/User/GetPubKey")
	            .header("Content-Type", "application/text")
	            .header("Accept", "application/text")
	            .header("Authorization", authorization)
	            .followRedirects(true)
	            .ignoreHttpErrors(true)
	            .ignoreContentType(true)
	            .userAgent("Mozilla/5.0 AppleWebKit/537.36 (KHTML," +
	                    " like Gecko) Chrome/45.0.2454.4 Safari/537.36")
	            .method(Connection.Method.GET)
	            //.requestBody(jsonBody)
	            .cookies(loginForm.cookies())
	            .maxBodySize(1_000_000 * 30) // 30 mb ~
	            .timeout(0) // infinite timeout
	            .execute();	    
	    
	    //Connection.Response execute3 = Jsoup.connect("https://app.qricambi.com/api/SearchScheduler/List?page=1&filter=")
	    boolean next = true;
	    int page = 1;
	    while(next){
		    String bodyList = Jsoup.connect("https://app.qricambi.com/api/SearchScheduler/List?page="+page+"&filter=")
		            .header("Content-Type", "application/json")
		            .header("Accept", "application/json")
		            .header("Authorization", authorization)
		            .followRedirects(true)
		            .ignoreHttpErrors(true)
		            .ignoreContentType(true)
		            .userAgent("Mozilla/5.0 AppleWebKit/537.36 (KHTML," +
		                    " like Gecko) Chrome/45.0.2454.4 Safari/537.36")
		            .method(Connection.Method.GET)
		            //.requestBody(jsonBody)
		            .cookies(loginForm.cookies())
		            .maxBodySize(1_000_000 * 30) // 30 mb ~
		            .timeout(0) // infinite timeout
		            .execute().body();	       
		    
		    JSONObject jsonBodyTwo = new JSONObject(bodyList);
		    if(jsonBodyTwo.getJSONArray("Data").isEmpty())
		    	next = false;
		    else
		    	System.out.println(jsonBodyTwo.toString(4));
		    page++;
	    }
	    

	    // GET page
//	    Connection.Response document = Jsoup.connect("https://www.elit.com.ar/productos/computadoras.html")
//	        .method(Connection.Method.GET)
//	        .cookies(loginResponse.cookies())
//	        .timeout(100000)
//	        .execute();
	    //System.out.println(document.getAllElements());
	}
}
