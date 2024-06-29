package com.opper.idir.run;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class OpperBase {
	
	protected static Logger logger = LoggerFactory.getLogger(OpperBase.class);
	
	protected void sendEmail(Exception e) throws Exception {

		Properties props = new Properties();
		props.put("mail.smtp.host", "10.101.41.1");
		props.put("mail.smtp.port", "25");
		
		 //props.put("mail.smtp.auth", "true"); 
		 props.put("mail.smtp.starttls.enable", "true"); 
		 props.put("mail.smtp.ssl.trust", "*");		
		
		//props.put("mail.smtp.auth", "true");
	    //Authenticator auth = new SMTPAuthenticator();
	    Session session = Session.getInstance(props);//, auth);
	    session.setDebug(true);
		
		
	    //Session session = Session.getDefaultInstance(props, null);
		String from = "oppersender@idir.it";
		String subject = "Exception";
		Message msg = new MimeMessage(session);
		try {
			msg.setFrom(new InternetAddress(from));
			InternetAddress[] arrayEmail = new InternetAddress[4];
			arrayEmail[0] = new InternetAddress("etrombella@opper.it");
			arrayEmail[1] = new InternetAddress("trossi@opper.it");
			arrayEmail[2] = new InternetAddress("nsaporiti@opper.it");
			arrayEmail[3] = new InternetAddress("gpirovano@opper.it");
			msg.setRecipients(Message.RecipientType.TO, arrayEmail);
			msg.setSubject(subject);
			StringWriter sw = new StringWriter();
			PrintWriter pw = new PrintWriter(sw);
			e.printStackTrace(pw);
			String sStackTrace = sw.toString(); // stack trace as a string
			msg.setText(sStackTrace);
			Transport.send(msg);
		} catch (Exception ex) {
			StringWriter sw = new StringWriter();
			PrintWriter pw = new PrintWriter(sw);
			ex.printStackTrace(pw);
			String sStackTrace = sw.toString(); // stack trace as a string
			logger.error(sStackTrace);
			throw ex;
		}
	}

}
