package beans.app;

// Users are immutable to eliminate multithreading concerns.

public class User implements java.io.Serializable { 
   private final String firstName, lastName, address, city, state;
   private final String country, creditCardType, creditCardNumber;
   private final String creditCardExpiration;
   private final String userName, password, pwdHint, roles;

   public User(String firstName, String lastName, String address, 
               String city, String state, String country, 
               String creditCardType, String creditCardNumber,
               String creditCardExpiration, String userName, 
               String password, String pwdHint, String roles) {
      this.firstName            = firstName; 
      this.lastName             = lastName;
      this.address              = address;   
      this.city                 = city;
      this.state                = state;     
      this.country              = country;
      this.creditCardType       = creditCardType;
      this.creditCardNumber     = creditCardNumber;
      this.creditCardExpiration = creditCardExpiration;
      this.userName             = userName;  
      this.password             = password;  
      this.pwdHint              = pwdHint;   
      this.roles                = roles;
   }
   public String getFirstName() { return firstName; }
   public String getLastName()  { return lastName;  }
   public String getAddress()   { return address;   }
   public String getCity()      { return city;      }
   public String getState()     { return state;     }
   public String getCountry()   { return country;   }

   public String getCreditCardType()   { return creditCardType; }
   public String getCreditCardNumber() { return creditCardNumber;}
   public String getCreditCardExpiration() { 
      return creditCardExpiration; 
   }

   public String getUserName() { return userName; }
   public String getPassword() { return password; }
   public String getPwdHint()  { return pwdHint;  }
   public String getRoles()    { return roles;    }

   public boolean equals(String uname, String pwd) {
      return getUserName().equals(uname) &&
             getPassword().equals(pwd);
   }
}
