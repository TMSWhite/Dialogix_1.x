import java.util.ResourceBundle;

import javax.servlet.ServletException;
import javax.servlet.ServletConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import action.Action;
import action.ActionFactory;
import action.ActionRouter;
import action.events.ActionEvent;

public class ActionServlet extends HttpServlet {
   private ActionFactory factory = new ActionFactory();

   public void init(ServletConfig config) throws ServletException{
      super.init(config);

      ResourceBundle bundle = null;

      try {
         bundle = ResourceBundle.getBundle(
                  config.getInitParameter("action-mappings"));
      }
      catch(java.util.MissingResourceException e) {
         throw new ServletException(e);
      }
      getServletContext().setAttribute("action-mappings", bundle);
   }
   public void service(HttpServletRequest req,
                       HttpServletResponse res)
                         throws ServletException {
      res.setContentType("text/html; charset=UTF-8");

      Action action = getAction(req);
      ActionEvent event = new ActionEvent(action,
                          ActionEvent.BEFORE_ACTION, req, res);

      try {
         action.fireEvent(event);
      }
      catch(javax.servlet.jsp.JspException ex) {
         throw new ServletException(ex);
      }
      ActionRouter router = performAction(action, req, res);
      event.setEventType(ActionEvent.AFTER_ACTION);

      try {
         action.fireEvent(event);
      }
      catch(javax.servlet.jsp.JspException ex) {
         throw new ServletException(ex);
      }

      // routers could fire events in a manner similar to actions
      routeAction(router, req, res);
   }
   protected Action getAction(HttpServletRequest req)
                                        throws ServletException {
      Action action = null;
      try {
         action = factory.getAction(getActionClass(req),
                                    getClass().getClassLoader());
      }
      catch(Exception ex) {
         throw new ServletException(ex);
      }
      return action;
   }
   protected ActionRouter performAction(Action action, 
                                        HttpServletRequest req,
                                        HttpServletResponse res) 
                                        throws ServletException {
      ActionRouter router = null;
      try {
         router = action.perform(this,req,res);
      }
      catch(Exception ex) {
         throw new ServletException(ex);
      }
      return router;
   }
   protected void routeAction(ActionRouter router,
                              HttpServletRequest req,
                                HttpServletResponse res)
                                throws ServletException {
      if(router == null)
         return;

      try {
         router.route(this, req, res);
      }
      catch(Exception ex) {
         throw new ServletException(ex);
      }
   }
   private String getClassname(HttpServletRequest req) {
      String path = req.getServletPath();
      int slash = path.lastIndexOf("/"), 
          period = path.lastIndexOf(".");

      if(period > 0 && period > slash)
       path = path.substring(slash+1, period);

      return path;
   }
   private String getActionClass(HttpServletRequest req) {
      ResourceBundle bundle = (ResourceBundle)getServletContext().
                              getAttribute("action-mappings");
      return (String)bundle.getObject(getActionKey(req));
   }
   private String getActionKey(HttpServletRequest req) {
      String path = req.getServletPath();
      int slash = path.lastIndexOf("/"), 
          period = path.lastIndexOf(".");

      if(period > 0 && period > slash)
       path = path.substring(slash+1, period);

      return path;
   }
}
