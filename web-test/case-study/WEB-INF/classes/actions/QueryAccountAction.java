package actions;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import action.ActionBase;
import action.ActionRouter;

public class QueryAccountAction extends ActionBase { 
   public QueryAccountAction() {
      // this action forwards to a JSP page with sensitive forms
      hasSensitiveForms = true;
   }
   public ActionRouter perform(HttpServlet servlet,
                               HttpServletRequest req, 
                               HttpServletResponse res)
                               throws ServletException { 
      return new ActionRouter("query-account-page");
   }
}
