package beans.xml.xslt;

import java.io.InputStream;
import java.io.Reader;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.xalan.xslt.XSLTInputSource;
import org.apache.xalan.xslt.XSLTProcessor;
import org.apache.xalan.xslt.XSLTProcessorFactory;
import org.apache.xalan.xslt.XSLTResultTarget;

public class XSLTProcessorBean implements java.io.Serializable {
   public void process(Reader xmlrdr, InputStream xslstrm,
                       HttpServletRequest req,
                       HttpServletResponse res) 
                    throws java.io.IOException, ServletException {
      process(new XSLTInputSource(xmlrdr),   
              new XSLTInputSource(xslstrm), req, res);
   }
   public void process(XSLTInputSource xmlsrc, 
                       XSLTInputSource xslsrc,
                       HttpServletRequest req,
                       HttpServletResponse res) 
                    throws java.io.IOException, ServletException {
      try {
         XSLTProcessorFactory.getProcessor().process(
                           xmlsrc, xslsrc,
                           new XSLTResultTarget(res.getWriter()));
      }
      catch(Exception ex) {
         throw new ServletException(ex);
      }
   }
}
