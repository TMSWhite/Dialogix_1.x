package action;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import action.events.ActionEvent;
import action.events.ActionListener;

// Application-specific actions implement this interface

public interface Action { 
   ActionRouter perform(HttpServlet servlet,
                        HttpServletRequest req, 
                        HttpServletResponse res)
                        throws javax.servlet.ServletException;

   void addActionListener(ActionListener listener);
   void fireEvent(ActionEvent event) 
                  throws javax.servlet.jsp.JspException;
   
   boolean hasSensitiveForms();
   boolean isSensitive();
}
