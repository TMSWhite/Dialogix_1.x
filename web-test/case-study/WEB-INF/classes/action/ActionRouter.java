package action;

import java.util.ResourceBundle;
import javax.servlet.*;
import javax.servlet.http.*;

// Action routers are immutable

public class ActionRouter {
   private final String forwardTo;
   private final boolean isForward, isLocationAKey;

   public ActionRouter(String forwardTo) {
      this(forwardTo, true, true);
   }
   public ActionRouter(String forwardTo, boolean isForward) {
		this(forwardTo, isForward, true);
   }
   public ActionRouter(String forwardTo, boolean isForward, 
											        boolean isLocationAKey) {
      this.forwardTo = forwardTo;
      this.isForward = isForward;
      this.isLocationAKey = isLocationAKey;
	}

   // This method is called by the action servlet
   public synchronized void route(GenericServlet servlet,
                                  HttpServletRequest req,
                                  HttpServletResponse res) 
                    throws ServletException, java.io.IOException {
		String url = forwardTo;

		if(isLocationAKey) {
      	ResourceBundle bundle = (ResourceBundle)servlet.
                                 getServletContext().
                                 getAttribute("action-mappings");
      	url = (String)bundle.getObject(forwardTo);
		} 

      if(isForward) {
			ServletContext ctx = servlet.getServletContext();
			RequestDispatcher rd = ctx.getRequestDispatcher(
         									res.encodeURL(url));
			rd.forward(req, res);
      }
      else {
         res.sendRedirect(res.encodeRedirectURL(url));
      }
   }
}
