package beans.regions;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;

public abstract class Content implements java.io.Serializable {
   protected final String content, direct;

   // Render this content in a JSP page
   abstract void render(PageContext pc) throws JspException;

   public Content(String content, String direct) {
      this.content = content;
      this.direct  = direct;
   }
   public String getContent() {
      return content;
   }
   public String getDirect() {
      return direct;
   }
   public boolean isDirect() {
        return Boolean.valueOf(direct).booleanValue();
   }
   public String toString() { 
      return "Content: " + content;
   }
}
