package beans.app.forms;

import beans.html.NameElement;
import beans.html.OptionsElement;
import beans.html.TextElement;
import beans.html.ValidatedElement;

public class CreateAccountForm implements ValidatedElement {
   private NameElement firstName = new NameElement("First Name");
   private NameElement lastName  = new NameElement("Last Name");
   private TextElement               address = new TextElement();
   private TextElement                  city = new TextElement();
   private TextElement                 state = new TextElement();
   private TextElement                 phone = new TextElement();
   private TextElement      creditCardNumber = new TextElement();
   private TextElement  creditCardExpiration = new TextElement();
   private TextElement              userName = new TextElement();
   private TextElement              password = new TextElement();
   private TextElement            pwdConfirm = new TextElement();
   private TextElement               pwdHint = new TextElement();

   private OptionsElement   creditCardType = new OptionsElement();
   private OptionsElement          country = new OptionsElement();

   private String error = "";

   public String getFirstName()   { return firstName.getValue();}
   public String getLastName()    { return lastName.getValue(); }
   public String getAddress()     { return address.getValue();  }
   public String getCity()        { return city.getValue();     }
   public String getState()       { return state.getValue();    }
   public String[] getCountry()   { return country.getValue();  }
   public String getPhone()       { return phone.getValue();    }
   public String[] getCreditCardType() { return creditCardType.
                                                getValue(); }
   public String getCreditCardNumber() { return creditCardNumber.
                                                getValue(); }
   public String getCreditCardExpiration() { 
      return creditCardExpiration.getValue(); 
   }
   public String getUserName()    { return userName.getValue(); }
   public String getPassword()    { return password.getValue(); }
   public String getPwdConfirm()  { return pwdConfirm.getValue();}
   public String getPwdHint()     { return pwdHint.getValue();}

   public String getCountrySelectionAttr(String s) {
      return country.selectionAttr(s);
   }
   public String getCreditCardTypeSelectionAttr(String s) {
      return creditCardType.selectionAttr(s);
   }

   public void setFirstName(String s) { firstName.setValue(s);   }
   public void setLastName(String s)  { lastName.setValue(s);    }
   public void setAddress(String s)   { address.setValue(s);     }
   public void setCity(String s)      { city.setValue(s);        }
   public void setState(String s)     { state.setValue(s);       }
   public void setCountry(String[] s) { country.setValue(s);     }
   public void setPhone(String s)     { phone.setValue(s);       }
   public void setCreditCardType(String[] s) { creditCardType.
                                               setValue(s); }
   public void setCreditCardNumber(String s) { creditCardNumber.
                                               setValue(s); }
   public void setCreditCardExpiration(String s) { 
      creditCardExpiration.setValue(s); 
   }

   public void setUserName(String s)   { userName.setValue(s);   }
   public void setPassword(String s)   { password.setValue(s);   }
   public void setPwdConfirm(String s) { pwdConfirm.setValue(s); }
   public void setPwdHint(String s)    { pwdHint.setValue(s);    }

   public boolean validate() {
      error = "";

      if(!firstName.validate()) {
         error += firstName.getValidationError();
      }
      if(!lastName.validate()) {
         if(error.length() > 0)
            error += "<br>";

         error += lastName.getValidationError();
      }
      return error == "";
   }
   public String getValidationError() {
      return error;   
   }
}
