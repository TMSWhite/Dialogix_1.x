package beans.xml.sax;

import org.xml.sax.Attributes;

public class SAXElement {
   String namespace, localName, qualifiedName, value=null;
   Attributes attributes;

   public SAXElement(String namespace, String localName, 
                     String qualifiedName, Attributes attributes){
      this.namespace     = namespace;
      this.localName     = localName;
      this.qualifiedName = qualifiedName;
      this.attributes    = attributes;
   }
   public void setValue(String value) {
      this.value = value;
   }
   public String getNamespace()      { return namespace; }
   public String getLocalName()      { return localName; }
   public String getQualifiedName()  { return qualifiedName; }
   public String getValue()          { return value; }
   public Attributes getAttributes() { return attributes; }
}
