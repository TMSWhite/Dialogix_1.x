package beans.app;

// These constants are mostly used by this application's actions 
// -- see /WEB-INF/classes/actions.

public interface Constants {
   // this prefix provides some degree of uniqueness for the
   // constants defined below.
   static final String prefix = "beans.app";

   static final String 
      // Keys for attributes
      LOCALE_KEY           = prefix + ".locale",
      SHOPPING_CART_KEY    = prefix + ".cart",
      USERS_KEY            = prefix + ".users",
      USERNAME_KEY         = prefix + ".username",
      PASSWORD_KEY         = prefix + ".password",
      CONFIRM_PASSWORD_KEY = prefix + ".cnfrmpwd",
      PASSWORD_HINT_KEY    = prefix + ".pwdhint",

      // Default values
      DEFAULT_I18N_BASE = "app";
}
