package beans.i18n;

import java.util.*;

public class BundleCache {
   private Hashtable bundles = new Hashtable();

   public Object getObject(String base, Locale locale, String key)
                                 throws MissingResourceException {
      return getBundle(base, locale).getObject(key);
   }
   public String getString(String base, Locale locale, String key)
                                 throws MissingResourceException {
      return getBundle(base, locale).getString(key);
   }
   public String[] getStringArray(String base, Locale locale, 
                     String key) throws MissingResourceException {
      return getBundle(base, locale).getStringArray(key);
   }
   public ResourceBundle getBundle(String base, Locale locale) 
                                 throws MissingResourceException {
      String key = base + "_" + locale.toString();
      ResourceBundle bundle = (ResourceBundle)bundles.get(key);

      if(bundle == null) {
         bundle = ResourceBundle.getBundle(base, locale); 
         bundles.put(bundle, key);
      }
      return bundle;
   }
   public void addBundle(ResourceBundle bundle, String base) {
      Locale locale = bundle.getLocale();
      bundles.put(bundle, base + "_" + locale.toString());
   }
}
