package beans.i18n;

import java.util.*;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

public class LocaleDetector {
   public Vector detectLocales(HttpServletRequest req,
                               ServletResponse res) {
      Vector locales = getLocalesFromRequest(req);

      if(locales == null) {
         locales = getLocalesByHand(
                                 req.getHeader("Accept-Language"),
                                 req.getHeader("Accept-Charset"),
                                 res.getCharacterEncoding());
      }
      return locales;
   }
   private Vector getLocalesFromRequest(HttpServletRequest req) {
      Enumeration locales = null;
      Vector vector = null;

      try {
         locales = req.getLocales();
      }
      catch(Throwable ex) {
         // If the servlet container implements the Servlet 2.1
         // spec or earlier, we'll wind up here because 
         // ServletRequest.getLocales() first appeared in 
         // Servlet 2.2. 
      }
      if(locales != null) {
         vector = new Vector();

         while(locales.hasMoreElements()) {
            vector.addElement(locales.nextElement());
         }
      }
      return vector;
   }
   private Vector getLocalesByHand(String acceptLanguages,
                                   String acceptCharsets,
                                   String responseEncoding) {
      Vector locales = new Vector();
      StringTokenizer tokenizer = 
                      new StringTokenizer(acceptLanguages, ",");

      while(tokenizer.hasMoreTokens()) {
         String tok = tokenizer.nextToken(), language, country;
         int qval = tok.indexOf(';'), dash;

         if(qval >= 0) {
            tok = tok.substring(0, qval);   
         }

         dash = tok.indexOf('-');

         if(dash >= 0) {
            language = tok.substring(0, dash);
            country = tok.substring(dash+1);
         }
         else {
            language = tok;
            country = "";
         }
         if(charsetIsAcceptable(acceptCharsets, responseEncoding))
            locales.addElement(new Locale(language, country));
      }
      return locales;
   }
   private boolean charsetIsAcceptable(String acceptCharsets,
                                       String responseCharset) {
      boolean accept = acceptCharsets == null;

      if(!accept) {
         accept = acceptCharsets.indexOf('*') >= 0;
      }
      if(!accept) {
         accept = acceptCharsets.indexOf(responseCharset) >= 0;
      }
      return accept;
   }
}
