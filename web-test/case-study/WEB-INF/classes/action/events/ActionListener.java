package action.events;

import javax.servlet.jsp.JspException;

public interface ActionListener extends java.util.EventListener {
   public void beforeAction(ActionEvent event) 
                            throws JspException;
   public void afterAction(ActionEvent event) 
                           throws JspException;
}
