package beans.html;

public class NameElement extends TextElement {
   String error, fieldName;

   public NameElement(String fieldName) {
      this.fieldName = fieldName;
   }
   public boolean validate() {
      boolean valid = true;
      String value = getValue();

      error = "";

      if(value.length() == 0) {
         valid = false;
         error = fieldName + " must be filled in";
      }
      else {
         for(int i=0; i < value.length(); ++i) {
            char c = value.charAt(i);

            if(c == ' ' || (c > '0' && c < '9')) {
               valid = false;   
               if(c == ' ') 
                  error = fieldName + " cannot contain spaces";
               else           
                  error = fieldName + " cannot contain digits";
            }
         }
      }
      return valid;
   }
   public String getValidationError() {
      return error;   
   }
}
