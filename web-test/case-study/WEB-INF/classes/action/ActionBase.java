package action;

import java.util.Enumeration;
import java.util.Vector;
import javax.servlet.jsp.JspException;
import action.Action;
import action.events.ActionEvent;
import action.events.ActionListener;

public abstract class ActionBase implements Action {
   protected boolean isSensitive = false, 
                     hasSensitiveForms = false;
   private Vector listeners = new Vector();

   public ActionBase() {
      addActionListener(new SensitiveActionListener());
   }
   public void addActionListener(ActionListener listener) {
      listeners.addElement(listener);   
   }
   public void removeActionListener(ActionListener listener) {
      listeners.remove(listener);   
   }
   public void fireEvent(ActionEvent event) throws JspException { 
      Enumeration it = listeners.elements();

      while(it.hasMoreElements()) {
         ActionListener listener = 
                        (ActionListener)it.nextElement();

         switch(event.getEventType()) {
            case ActionEvent.BEFORE_ACTION: 
                         listener.beforeAction(event);
                         break;
            case ActionEvent.AFTER_ACTION: 
                     listener.afterAction(event);
                     break;
         }
      }
   }
   public boolean isSensitive() { 
      return isSensitive;
   }
   public boolean hasSensitiveForms() { 
      return hasSensitiveForms;
   }
}
