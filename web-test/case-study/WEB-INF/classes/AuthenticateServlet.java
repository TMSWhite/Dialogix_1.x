import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public abstract class AuthenticateServlet extends HttpServlet 
                                 implements beans.app.Constants,
                                         tags.security.Constants {
   abstract Object getUser(String username, String pwd);

   public void service(HttpServletRequest req,
                       HttpServletResponse res)
                       throws IOException, ServletException {
      HttpSession session = req.getSession();
      String      uname   = req.getParameter("userName");
      String      pwd     = req.getParameter("password");
      Object      user    = getUser(uname, pwd);

      session.setAttribute(USERNAME_KEY, uname);
      session.setAttribute(PASSWORD_KEY, pwd);

      if(user == null) { // not authorized
         String loginPage = (String)session.
                            getAttribute(LOGIN_PAGE_KEY);
         String errorPage = (String)session.
                            getAttribute(ERROR_PAGE_KEY);
         String forwardTo = errorPage != null ? errorPage :
                                                loginPage;
         session.setAttribute(LOGIN_ERROR_KEY,
                  "Username: " + uname + " and " + 
                  "Password: " + pwd + " are not valid.");

         getServletContext().getRequestDispatcher(
                       res.encodeURL(forwardTo)).forward(req,res);
      }
      else { // authorized
         String protectedPage = (String)session.
                                 getAttribute(PROTECTED_PAGE_KEY);
         session.removeAttribute(LOGIN_PAGE_KEY);
         session.removeAttribute(ERROR_PAGE_KEY);
         session.removeAttribute(PROTECTED_PAGE_KEY);
         session.removeAttribute(LOGIN_ERROR_KEY);
         session.setAttribute(USER_KEY, user);

         getServletContext().getRequestDispatcher(
                   res.encodeURL(protectedPage)).forward(req,res);
      }
   }
}
