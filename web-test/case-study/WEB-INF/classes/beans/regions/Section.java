package beans.regions;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;

// A section is a named content. Sections contain content, that's
// either printed directly or included. That content can also be a
// region; if so, Region.render() is called from Section.Render().

public class Section extends Content {
   protected final String name;

   public Section(String name, String content, String direct) {
      super(content, direct);
      this.name = name;
   }
   public String getName() { 
      return name;    
   }
   public void render(PageContext pageContext) 
											 throws JspException {
      if(content != null) {
			Region region = (Region)pageContext.
											findAttribute(content);
			if(region != null) {
				RegionStack.push(pageContext, region);
				region.render(pageContext);
				RegionStack.pop(pageContext);
			}
         else {
				if(isDirect()) {
           		try {
              		pageContext.getOut().print(content.toString());
            	}
            	catch(java.io.IOException ex) {
              	 throw new JspException(ex.getMessage());
            	}
         	}
         	else {
           		try {
               	pageContext.include(content.toString());
            	}
            	catch(Exception ex) { 
              		throw new JspException(ex.getMessage());
            	}
         	}
			}
      }
   }
   public String toString() { 
      return "Section: " + name + ", content= " + 
                                     content.toString();
   }
}
