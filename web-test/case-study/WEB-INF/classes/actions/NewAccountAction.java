package actions;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import beans.app.User;
import beans.app.Users;

import action.ActionBase;
import action.ActionRouter;

public class NewAccountAction extends ActionBase 
                           implements beans.app.Constants { 
   public NewAccountAction() {
      isSensitive = true; // this is a sensitive action
   }
   public ActionRouter perform(HttpServlet servlet,
                               HttpServletRequest req, 
                               HttpServletResponse res)
                               throws ServletException {
      Users users = (Users)servlet.getServletContext().
                     getAttribute(USERS_KEY);

      if(users == null) {
         throw new ServletException("Users not found " +
                                    "in application scope");
      }
      HttpSession session = req.getSession();

      String  firstName = req.getParameter("firstName");
      String  lastName  = req.getParameter("lastName");
      String  address   = req.getParameter("address");
      String  city      = req.getParameter("city");
      String  state     = req.getParameter("state");
      String  country   = req.getParameter("country");

      String  creditCardType = req.getParameter("creditCardType");
      String  creditCardNumber = 
              req.getParameter("creditCardNumber");
      String  creditCardExpiration = 
              req.getParameter("creditCardExpiration");

      String  uname = req.getParameter("userName");
      String  pwd   = req.getParameter("password");

      String  pwdConfirm = req.getParameter("pwdConfirm");
      String  pwdHint    = req.getParameter("pwdHint");

      session.setAttribute(USERNAME_KEY, uname);
      session.setAttribute(PASSWORD_KEY, pwd);

      users.addUser(
           new User(firstName, lastName, address, city, state,
                    country, creditCardType, creditCardNumber,
                    creditCardExpiration, uname, pwd, pwdHint,
                    "customer")); // customer is a role

      req.setAttribute(USERNAME_KEY, uname);

      return new ActionRouter("account-created-page");
   }
}
