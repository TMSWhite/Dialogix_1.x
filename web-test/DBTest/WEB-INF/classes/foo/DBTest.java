package foo;

import javax.naming.*;
import javax.sql.*;
import java.sql.*;

public class DBTest {

  String foo = "Not Connected";
  int bar = -1;
    
  public void init() {
    try{
      Context ctx = new InitialContext();
      if(ctx == null ) 
          throw new Exception("Boom - No Context");

      DataSource ds = 
            (DataSource)ctx.lookup(
               "java:comp/env/jdbc/TestDB");

      if (ds != null) {
        Connection conn = ds.getConnection();
              
        if(conn != null)  {
            foo = "Got Connection "+conn.toString();
            Statement stmt = conn.createStatement();
            ResultSet rst = 
                stmt.executeQuery(
                  "select id, foo, bar from testdata");
            if(rst.next()) {
               foo=rst.getString(2);
               bar=rst.getInt(3);
            }
            conn.close();
        }
      }
    }catch(Exception e) {
      e.printStackTrace();
    }
 }

 public String getFoo() { return foo; }
 public int getBar() { return bar;}
}

