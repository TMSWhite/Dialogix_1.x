import javax.servlet.ServletContext;

import beans.app.Users;
import beans.app.User;

public class AppAuthenticateServlet extends AuthenticateServlet 
                                 implements beans.app.Constants,
                                            tags.jdbc.Constants {
   public Object getUser(String username, String password) {
      ServletContext ctx = getServletContext();
      Users users = (Users)ctx.getAttribute(USERS_KEY);
      return users.getUser(username, password);
   }
}
