package beans.xml.xpath;

import java.io.InputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import javax.servlet.jsp.JspException;

import org.apache.xerces.parsers.DOMParser;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import org.apache.xalan.xpath.XPathSupport;
import org.apache.xalan.xpath.XPath;
import org.apache.xalan.xpath.XPathProcessorImpl;
import org.apache.xalan.xpath.xml.XMLParserLiaisonDefault;
import org.apache.xalan.xpath.xml.PrefixResolverDefault;
import org.apache.xalan.xpath.XObject;

public class XPathBean {
   private XPathBean() { } // defeat instantiation

   public static NodeList process(Node node, String expr) 
                                             throws SAXException {
      XPathSupport s = new XMLParserLiaisonDefault();
      PrefixResolverDefault pr = new PrefixResolverDefault(node);
      XPathProcessorImpl processor = new XPathProcessorImpl(s);
      XPath xpath = new XPath();

      processor.initXPath(xpath, expr, pr);
      XObject xo = xpath.execute(s, node, pr);
      return xo.nodeset();
   }
	public static Node processToFirstNode(Node node, String expr)
                                             throws SAXException {
		NodeList list = process(node, expr);
		return list.getLength() > 0 ? list.item(0) : null;
   }
}
