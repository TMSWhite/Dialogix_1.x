package beans.regions;

import java.util.Enumeration;
import java.util.Hashtable;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.JspException;

// A region contains a set of sections.

public class Region extends Content {
   private Hashtable sections = new Hashtable();

   public Region(String content) { 
		this(content, null);
   }
   public Region(String content, Hashtable hashtable) { 
      super(content, "false"); // content is a template

		if(hashtable != null)
			sections = (Hashtable)hashtable.clone();
	}
   public void put(Section section) {
      sections.put(section.getName(), section);
   }
   public Section get(String name) {
      return (Section)sections.get(name);
   }
   public Hashtable getSections() {
      return sections;
   }
   public void render(PageContext pageContext) 
										    throws JspException {
      try {
         pageContext.include(content);
      }
      catch(Exception ex) { // IOException or ServletException
         throw new JspException(ex.getMessage());
      }
   }
   public String toString() {
      String s = "Region: " + content.toString() + "<br/>";
      int indent = 4;
      Enumeration e = sections.elements();

      while(e.hasMoreElements()) {
         Section section = (Section)e.nextElement();
         for(int i=0; i < indent; ++i) {
            s += "&nbsp;";
         }
         s += section.toString() + "<br/>";
      }
      return s;   
   }
}
