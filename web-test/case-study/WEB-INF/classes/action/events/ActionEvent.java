package action.events;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import action.Action;

public class ActionEvent extends java.util.EventObject {
   public static final int BEFORE_ACTION=0, AFTER_ACTION=1;

   private int eventType;
   private HttpServletRequest request;
   private HttpServletResponse response;

   public ActionEvent(Action action, int eventType, 
                      HttpServletRequest request,
                      HttpServletResponse response) { 
      super(action);  // sets action as the source of the event 
      this.eventType = eventType;
      this.request = request;
      this.response = response;
   }
   public int                 getEventType() { return eventType; }
   public HttpServletRequest  getRequest()   { return request;   }
   public HttpServletResponse getResponse()  { return response;  }

   public void setEventType(int eventType) { 
      this.eventType = eventType;
   }
}
