import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class CreateDB {
   private Connection conn;
   private Statement stmt;

   public static void main(String args[]) { 
      new CreateDB();
   }
   public CreateDB() { 
      try {
         loadJDBCDriver();
         conn = getConnection("/usr/local/dialogix/webapps/case-study/WEB-INF/cloudscape/sunpress");
         stmt = conn.createStatement();

         createTables(stmt);
         populateTables(stmt);

         stmt.close();
         conn.close();
         DriverManager.getConnection(
                                "jdbc:cloudscape:;shutdown=true");
      }
      catch(SQLException ex) {
         ex.printStackTrace();
      }
   }
   private void createTables(Statement stmt) {
      try {
         stmt.execute("CREATE TABLE Users (" +
             "FIRST_NAME VARCHAR(15), " +
             "LAST_NAME VARCHAR(25), " +
             "ADDRESS VARCHAR(35), " +
             "CITY VARCHAR(15), " +
             "STATE VARCHAR(15), " +
             "COUNTRY VARCHAR(25), " +
             "CREDIT_CARD_TYPE VARCHAR(10), " +
             "CREDIT_CARD_NUMBER VARCHAR(20), " +
             "CREDIT_CARD_EXPIRATION VARCHAR(10), " +
             "USER_ID VARCHAR(15), " +
             "PASSWORD VARCHAR(15), " +
             "PASSWORD_HINT VARCHAR(15), " +
             "ROLES VARCHAR(99))");

         stmt.execute("CREATE TABLE Inventory (" +
            "SKU         INTEGER, " +
            "NAME        VARCHAR(30), " +
            "PRICE       FLOAT)");
      }
      catch(SQLException ex) {
         ex.printStackTrace();
      }
   }
   private void populateTables(Statement stmt) {
      try {
         stmt.execute("INSERT INTO Users VALUES " +
         "('James', 'Wilson', '24978 Roquert Lane', 'Ithica'," +
         " 'New York', 'USA', 'Visa', '124-3393-62975', '01/05',"+
         " 'jwilson', 's2pdpl8', 'license', 'customer')");

         stmt.execute("INSERT INTO Inventory VALUES " +
                           "('1001', 'apple', '0.29')," +
                           "('1002', 'banana', '0.69')," +
                           "('1003', 'cantaloupe', '0.19')," +
                           "('1004', 'grapefruit', '0.49')," +
                           "('1005', 'grapes', '0.79')," +
                           "('1006', 'kiwi', '0.99')," +
                           "('1007', 'peach', '0.39')," +
                           "('1008', 'pear', '0.69')," +
                           "('1009', 'pineapple', '0.29')," +
                           "('1010', 'strawberry', '0.89')," +
                           "('1011', 'watermelon', '0.29')");
      }
      catch(SQLException ex) {
         ex.printStackTrace();
      }
   }
   private void loadJDBCDriver() {
      try {
         Class.forName("COM.cloudscape.core.JDBCDriver");
      }
      catch(ClassNotFoundException e) {
         e.printStackTrace();
      }
   }
   private Connection getConnection(String dbName) {
      Connection con = null;
      try {
         con = DriverManager.getConnection(
            "jdbc:cloudscape:" + dbName + ";create=true");
      }
      catch(SQLException sqe) {
         System.err.println("Couldn't access " + dbName);
      }
      return con;
   }      
}
