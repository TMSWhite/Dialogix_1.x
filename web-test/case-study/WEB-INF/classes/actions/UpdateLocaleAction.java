package actions;

import java.util.Locale;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import action.ActionBase;
import action.ActionRouter;

public class UpdateLocaleAction extends ActionBase 
                             implements beans.app.Constants { 
   public ActionRouter perform(HttpServlet servlet,
                               HttpServletRequest req, 
                               HttpServletResponse res)
                               throws ServletException {
      Locale locale = new Locale(req.getParameter("country"),"");
      String forwardTo = req.getParameter("page");

      req.getSession(true).setAttribute(LOCALE_KEY, locale);
      res.setLocale(locale);

      return new ActionRouter(forwardTo, true, false);
   }
}
