import java.util.*;

public class XmlString extends Object {
	private static Hashtable HTMLentities = new Hashtable();
	private static Hashtable HTMLtags = new Hashtable();
	private static String allowableHTMLtags[] = {
		"b","/b","i","/i","u","/u","br","hr",	
	};
	private static String allowableHTMLentities[] = {
		"&quot;","&amp;","&lt;","&gt;","&nbsp;","&iexcl;","&cent;","&pound;","&curren;",
		"&yen;","&brvbar;","&sect;","&uml;","&copy;","&ordf;","&laquo;","&not;","&shy;","&reg;",
		"&macr;","&deg;","&plusmn;","&sup2;","&sup3;","&acute;","&micro;","&para;","&middot;","&cedil;",
		"&sup1;","&ordm;","&raquo;","&frac14;","&frac12;","&frac34;","&iquest;","&Agrave;","&Aacute;","&Acirc;",
		"&Atilde;","&Auml;","&Aring;","&AElig;","&Ccedil;","&Egrave;","&Eacute;","&Ecirc;","&Euml;","&Igrave;",
		"&Iacute;","&Icirc;","&Iuml;","&ETH;","&Ntilde;","&Ograve;","&Oacute;","&Ocirc;","&Otilde;","&Ouml;",
		"&times;","&Oslash;","&Ugrave;","&Uacute;","&Ucirc;","&Uuml;","&Yacute;","&THORN;","&szlig;","&agrave;",
		"&aacute;","&acirc;","&atilde;","&auml;","&aring;","&aelig;","&ccedil;","&egrave;","&eacute;","&ecirc;",
		"&euml;","&igrave;","&iacute;","&icirc;","&iuml;","&eth;","&ntilde;","&ograve;","&oacute;","&ocirc;",
		"&otilde;","&ouml;","&divide;","&oslash;","&ugrave;","&uacute;","&ucirc;","&uuml;","&yacute;","&thorn;",
		"&yuml;",
	};
	
	static {
		/* initialize static Hashtables */
		for (int i=0;i<allowableHTMLentities.length;++i) {
			HTMLentities.put(allowableHTMLentities[i], "HTMLentity");
		}
		for (int i=0;i<allowableHTMLtags.length;++i) {
			HTMLtags.put(allowableHTMLtags[i], "HTMLtag");
		}		
	}
	
	private String value = null;
		
    public XmlString(String src) {
    	this(src,false);
    }
	
    public XmlString(String src, boolean disallowEmpty) {
    	value = encodeHTML(src,disallowEmpty);
    }
    
    public	String toString() { return value; }
    
	private boolean isValidElement(String element) {
		String token;
		
		try {
			/* build a string stripped of the opening and closing angle brackets */
			StringTokenizer st = new StringTokenizer(element.substring(1,element.length()-1)," \t\n\r\f=\'\"",true);
				
			token = st.nextToken().toLowerCase();
			if (!HTMLtags.containsKey(token))
				return false;
				
			while (st.hasMoreTokens()) {
				token = st.nextToken();
				
				if (" ".equals(token) || "\t".equals(token) || "\n".equals(token) || "\r".equals(token) || "\f".equals(token))
					continue;	// ignore whitespace
				
				/* should now loop over name = "attribute" pairs */
			}
			return true;
		}
		catch (Throwable t) {
			return false;	// invalid element syntax
		}
	}

	private String encodeHTML(String s, boolean disallowEmpty) {
		StringBuffer dst = new StringBuffer();

		if (s != null) {
			try {
				char[] src = s.toCharArray();

				for (int i=0;i<src.length;++i) {
					switch (src[i]) {
						case '\'': dst.append("&#39;"); break;
						case '\"': dst.append("&#34;"); break;
						case '<': {
							/* grab next complete element */
							int elementEnd;
							String element = null;
							
							elementEnd = s.indexOf('>',i);
							if (elementEnd != -1) {
								element = s.substring(i,elementEnd+1);
								/* Now, get the element name (assuming that might have attribute value pairs */
								if (isValidElement(element)) {
									dst.append(element);
									i+= (element.length()-1);
								}
								else {
									/* Not a recognized HTML element, so HTMLize this character, and move one */
									dst.append("&#60;");
								}
							}
							else {
								/* No matching '>', so HTMLize this character, and move one */
								dst.append("&#60;");
							}
						}
							break;
						case '>': dst.append("&#62;"); break;
						case '&': {
							String entity = null;
							int entityEnd;
							entityEnd = s.indexOf(';',i);
							if (entityEnd != -1) {
								entity = s.substring(i,entityEnd+1);
								if (HTMLentities.containsKey(entity)) {
									dst.append(entity);
									i += (entity.length()-1);
								}
								else {
									/* check whether it is a valid UNICODE character */
									boolean isUnicode = true;
									String unicodeTriple = null;
									
									entityEnd = entity.indexOf('#',i);
									if (entityEnd == 1 && entity.length() <= 3) {
										unicodeTriple = entity.substring(entityEnd,entity.length());
										for (int j=0;j<unicodeTriple.length();++j) {
											if (!Character.isDigit(unicodeTriple.charAt(j))) {
												isUnicode = false;
												break;
											}
										}
										if (isUnicode) {
											dst.append(entity);
											i += (entity.length()-1);
										}
										else {
											/* Not a recognized HTML entity, so HTMLize this character, and move one */
											dst.append("&#38;");			
										}
									}
									else {
										/* Not a recognized HTML entity, so HTMLize this character, and move one */
										dst.append("&#38;");
									}
								}
							}
							else {
								/* No matching ';', so HTMLize this character, and move one */
								dst.append("&#38;");
							}
						}
							break;
						default: dst.append(src[i]); break;
					}
				}
			}
			catch (Throwable t) {
				System.err.println("Exception while HTMLizing string" + t.getMessage());
			}
		}
		String ans = dst.toString();
		if (disallowEmpty && ans.length() == 0) {
			return "&nbsp;";
		}
		else {
			return ans;
		}
	}
}
