package actions;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

import beans.app.User;
import beans.app.Users;

import action.ActionBase;
import action.ActionRouter;

public class ShowHintAction extends ActionBase 
                         implements beans.app.Constants { 
   public ActionRouter perform(HttpServlet servlet,
                               HttpServletRequest req, 
                               HttpServletResponse res)
                               throws ServletException {
      Users users = (Users)servlet.getServletContext().
                           getAttribute(USERS_KEY);
      HttpSession session = req.getSession();
      String username= (String)session.getAttribute(USERNAME_KEY);
      User user = users.getUser(username);

      if(user != null) {   
         req.setAttribute("hint", user.getPwdHint());
         req.setAttribute(USERNAME_KEY, username);
      }
      return new ActionRouter("show-hint-page");
   }
}
