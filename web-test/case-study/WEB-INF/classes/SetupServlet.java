import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;
import java.sql.SQLException;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;

import beans.app.User;
import beans.app.Users;
import beans.jdbc.DbConnectionPool;

public class SetupServlet extends HttpServlet 
                       implements beans.app.Constants,
                                  tags.jdbc.Constants {
   private DbConnectionPool pool;

   public void init(ServletConfig config) throws ServletException{
      super.init(config);

      ServletContext ctx = config.getServletContext();
      createDbConnectionPool(config, ctx);

      try {
         ctx.setAttribute(USERS_KEY, loadUsers(ctx));
      }
      catch(SQLException ex) {
         throw new ServletException(ex);
      }
   }
   public void destroy() {
      ServletContext ctx = getServletConfig().getServletContext();
      ctx.removeAttribute(DBPOOL_KEY);
      ctx.removeAttribute(USERS_KEY);

      pool.shutdown();
      pool = null;
      super.destroy();
   }
   private void createDbConnectionPool(ServletConfig config,
                                       ServletContext ctx) {
      pool = new DbConnectionPool(
                  config.getInitParameter("jdbcDriver"),
                  config.getInitParameter("jdbcURL"),
                  config.getInitParameter("jdbcUser"),
                  config.getInitParameter("jdbcPwd"));
      ctx.setAttribute(DBPOOL_KEY, pool);
   }
   private Users loadUsers(ServletContext ctx) 
                                          throws SQLException {
      Connection conn = null;

      if(pool != null) {
         try {
            // wait for a maximum of 10 seconds for a connection
            // if pool is full
               conn = (Connection)pool.getConnection(10000);
         }
         catch(Exception ex) { 
            throw new SQLException(ex.getMessage());
         }
         Statement stmt = conn.createStatement();
         ResultSet rs = stmt.executeQuery("SELECT * FROM USERS");
         Users users = new Users(rs);

         pool.recycleConnection(conn);
         return users;
      }
      return null;
   }
}
