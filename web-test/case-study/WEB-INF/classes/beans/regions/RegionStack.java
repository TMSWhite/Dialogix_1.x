package beans.regions;

import javax.servlet.jsp.PageContext;
import java.util.Stack;

public class RegionStack {
   private RegionStack() { } // no instantiations

   public static Stack getStack(PageContext pc) {
      Stack s = (Stack)pc.getAttribute("region-stack",
                                   PageContext.APPLICATION_SCOPE);
      if(s == null) {
         s = new Stack();
         pc.setAttribute("region-stack", s,
                         PageContext.APPLICATION_SCOPE);
      }
      return s;
   }
   public static Region peek(PageContext pc) {
      return (Region)getStack(pc).peek();
   }
   public static void push(PageContext pc, Region region){
		getStack(pc).push(region);
   }
   public static Region pop(PageContext pc) {
      return (Region)getStack(pc).pop();
   }
}
