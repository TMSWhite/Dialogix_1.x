package beans.app;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import java.util.Enumeration;
import java.util.Hashtable;

public class Users {
   private final static int FIRST_NAME=1, LAST_NAME=2, ADDRESS=3,
                            CITY=4, STATE=5, COUNTRY=6, 
                            CREDIT_TYPE=7, CREDIT_NUMBER=8,
                            CREDIT_EXPIRE=9, USER_NAME=10, 
                            PASSWORD=11, PASSWORD_HINT=12, 
                            ROLES=13;
   private final Hashtable users = new Hashtable();

   public Users(ResultSet rs) { 
      try {
         ResultSetMetaData rsmd = rs.getMetaData();

         if(rsmd.getColumnCount() > 0) {
            boolean moreRows = rs.next(); // point to first 
                                          // row initially
            while(moreRows) {
               addUser(new User(
                     ((String)rs.getObject(FIRST_NAME)).trim(),
                     ((String)rs.getObject(LAST_NAME)).trim(),
                     ((String)rs.getObject(ADDRESS)).trim(),
                     ((String)rs.getObject(CITY)).trim(),
                     ((String)rs.getObject(STATE)).trim(),
                     ((String)rs.getObject(COUNTRY)).trim(),
                     ((String)rs.getObject(CREDIT_TYPE)).trim(),
                     ((String)rs.getObject(CREDIT_NUMBER)).trim(),
                     ((String)rs.getObject(CREDIT_EXPIRE)).trim(),
                     ((String)rs.getObject(USER_NAME)).trim(),
                     ((String)rs.getObject(PASSWORD)).trim(),
                     ((String)rs.getObject(PASSWORD_HINT)).trim(),
                     ((String)rs.getObject(ROLES)).trim()));

               moreRows = rs.next(); // move to next row
            }
         }
      }
      catch(SQLException ex) {
         // can't throw an exception from a constructor
      }
   }
   public int getNumberOfUsers() {
      return users.size();
   }
   public User addUser(User user) {
      users.put(user.getUserName(), user);
      return user;
   }
   public User getUser(String username, String password) {
      User user = getUser(username);
		boolean found = false;
  
      if(user != null) {
         found = user.equals(username, password);
      }
      return found ? user : null;
   }
   public User getUser(String username) {
      return (User)users.get(username);
   }
   public Hashtable getUsers() {
      return users;
   }
   public String getPasswordHint(String username) {
      User user = getUser(username);
      return user != null ? user.getPwdHint() : null;
   }
}
