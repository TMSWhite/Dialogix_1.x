package beans.xml.dom;

import java.io.IOException;
import java.io.FileInputStream;
import java.io.StringReader;
import org.apache.xerces.parsers.DOMParser;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.w3c.dom.Document;

public class DOMParserBean { 
   private DOMParserBean() {} // disallow instantiation

   public static Document getDocument(FileInputStream fis)
                                throws SAXException, IOException {
      return getDocument(new InputSource(fis));
   }
	public static Document getDocument(StringReader sr)
                                throws SAXException, IOException {
      return getDocument(new InputSource(sr));
	}
	public static Document getDocument(InputSource is)
                                throws SAXException, IOException {
      DOMParser parser = new DOMParser();
      parser.parse(is);
      return parser.getDocument();
	}
}
