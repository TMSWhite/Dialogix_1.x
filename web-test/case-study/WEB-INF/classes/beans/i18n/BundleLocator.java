package beans.i18n;

import java.util.*;
import javax.servlet.jsp.JspWriter;

public class BundleLocator {
   public ResourceBundle locateBundle(String base,
                                      Vector locales) {
      Enumeration en = locales.elements();
      Locale defaultLocale = Locale.getDefault();
      ResourceBundle defaultBundle = null;
   
      try {
         defaultBundle = ResourceBundle.getBundle(base, 
                                                  defaultLocale);
      }
      catch(MissingResourceException ex) {
         // No default bundle found
      }
		
      while(en.hasMoreElements()) {
         Locale locale = (Locale)en.nextElement();
         ResourceBundle bundle = null;

         try {
            bundle = ResourceBundle.getBundle(base, locale);
         }
         catch(MissingResourceException ex2) {
            // ignore missing bundles ...   
         }
         if(bundle != defaultBundle)
            return bundle;

         if(defaultBundle != null && bundle == defaultBundle) {
            String lang = locale.getLanguage();
            String defLang = defaultLocale.getLanguage();

            if(lang.equals(defLang))
               return bundle;
         }
      }
      return null;
   }
}
