package beans.email;

import java.util.Properties;
import java.util.Date;
import javax.mail.*;
import javax.mail.internet.*;

public class SendEmailBean {
   public SendEmailBean() {}

   public void send(String host, String to, String from,
                     String subject, String msgText) 
                    throws AddressException, MessagingException {
      Properties props = new Properties();
      props.put("mail.smtp.host", host);
      props.put("mail.debug", Boolean.TRUE);

      Session session = Session.getDefaultInstance(props, null);
      session.setDebug(true);
   
      InternetAddress[] addresses={new InternetAddress(to)};
      Message msg = new MimeMessage(session);

      msg.setFrom(new InternetAddress(from));
      msg.setRecipients(Message.RecipientType.TO,addresses);
      msg.setSubject(subject);
      msg.setSentDate(new Date());
      msg.setText(msgText);
          
      Transport.send(msg);
   }
}
