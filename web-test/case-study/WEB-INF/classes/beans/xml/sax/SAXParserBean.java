package beans.xml.sax;

import java.io.FileReader;
import org.xml.sax.Attributes;
import java.io.IOException;
import java.util.Vector;
import org.xml.sax.Attributes;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.DefaultHandler;
import org.apache.xerces.parsers.SAXParser;

public class SAXParserBean extends DefaultHandler { 
   private Vector vector = new Vector();
   private SAXElement currentElement = null;
   private String elementText;

   public Vector parse(String filename) throws SAXException, 
                                               IOException {
      XMLReader xmlReader = new SAXParser();
      FileReader fileReader = new FileReader(filename);

      xmlReader.setContentHandler(this);
      xmlReader.parse(new InputSource(fileReader));
      return vector;
   }
   public void startElement(String uri, String localName,
                            String qName, Attributes attrs) {
      currentElement = new SAXElement(uri,localName,qName,attrs);
      vector.addElement(currentElement);
      elementText = new String();
   }
   public void characters(char[] chars, int start, int length) {
      if(currentElement != null && elementText != null) {
         String value = new String(chars, start, length);
         elementText += value;
      }
   }
   public void endElement(String uri, String localName,
                          String qName) {
      if(currentElement != null && elementText != null)
         currentElement.setValue(elementText.trim());

      currentElement = null;
   }
}
