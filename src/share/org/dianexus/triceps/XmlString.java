import java.util.*;

public class XmlString extends Object {
	private static Hashtable HTMLentities = new Hashtable();
	private static Hashtable HTMLtags = new Hashtable();
	private static String allowableHTMLtags[] = {
		"a","/a","abbr","/abbr","acronym","/acronym","address","/address",	/*"applet","/applet",*/ "area", 
		"b","/b","base","basefont","bdo","/bdo", /*"bgsound",*/ "big","/big", /*"blink","/blink",*/ "blockquote","/blockquote", /*"body","/body",*/ "br","button",
		"caption","/caption","center","/center","cite","/cite","code","/code","col","colgroup","comment","/comment",
		"dd","/dd","del","/del","dfn","/dfn","dir","/dir","div","/div","dl","/dl","dt","/dt",
		"em","/em", /*"embed","/embed",*/ "fieldset","/fieldset","font","/font","form","/form", /*"frame","/frame","frameset","/frameset"*/
		"h1","/h1","h2","/h2","h3","/h3","h4","/h4","h5","/h5","h6","/h6", /*"head","/head",*/ "hr", /*"html","/html",*/
		"i","/i", /*"iframe","/iframe","ilayer","/ilayer",*/ "img","input","ins","/ins", /*"isindex",*/
		"kbd","/kbd", /*"keygen","/keygen",*/
		"label","/label", /*"layer","/layer",*/ "legend","/legend","li","/li","link","listing","/listing",
		"map","/map", /*"marquee","/marquee",*/ "menu","/menu", /*"meta","/meta","multicol","/multicol",*/
		"nobr","/nobr", /*"noembed","/noembed","noframes","/noframes","noscript","/noscript",*/
		/*"object","/object",*/ "ol","/ol","optgroup","/optgroup","option","/option",
		"p","/p", /*"param","/param"*/ "plaintext","pre","/pre",
		"q","/q",
		"s","/s", /*"script","/script"*/ "select","/select", /*"server","/server",*/ "small","/small", /*"spacer",*/ "span","/span","strike","/strike","strong","/strong", /*"style","style",*/ "sub","/sub","sup","/sup",
		"table","/table","tbody","/tbody","td","/td","textarea","/textarea","tfoot","/tfoot","th","/th","thead","/thead", /*"title","/title",*/ "tr","/tr","tt","/tt",
		"ul","/ul","var","/var","wbr", /*"xmp","/xmp"*/		
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
    
    private static final int NMTOKEN = 0;
    private static final int EQUALS = 1;
    private static final int START_STRING = 2;
    private static final int END_STRING = 3;
    private static final String[] parsingPosition = { "NMTOKEN","EQUALS","STARTING_STRING","END_STRING" };
    
	private boolean isValidElement(String element) {
		String token = null;
		String quoteChar = null;
		boolean withinEscape = false;
		
		try {
			/* build a string stripped of the opening and closing angle brackets */
			StringTokenizer st = new StringTokenizer(element.substring(1,element.length()-1)," \t\n\r\f=\'\"\\",true);
				
			/* get and check tag name */
			token = st.nextToken().toLowerCase();
			if (!HTMLtags.containsKey(token))
				return false;
	
			int which = NMTOKEN;				
			while (st.hasMoreTokens()) {
				/* Loop over name = "attribute" pairs */				
				token = st.nextToken();
				if (Character.isWhitespace(token.charAt(0)))
					continue;
//				if (" ".equals(token) || "\t".equals(token) || "\n".equals(token) || "\r".equals(token) || "\f".equals(token))
						
				switch(which) {
					case NMTOKEN: {
						char[] chars = token.toCharArray();
						for (int i=0;i<chars.length;++i) {
							if (!(Character.isLetterOrDigit(chars[i]) || chars[i] == '_')) {
//System.err.println("bad character in NMTOKEN: " + chars[i]);								
								return false;
							}
						}
						which = EQUALS;
					}
						break;
					case EQUALS:
						if (!"=".equals(token)) {
//System.err.println("expected equals sign, got: " + token);							
							return false;
						}
						which = START_STRING;
						break;
					case START_STRING: 
						quoteChar = token;
						if (!("\"".equals(quoteChar) || "\'".equals(quoteChar))) {
//System.err.println("expected the start of a string, got: " + token);							
							return false;
						}
						withinEscape = false;
						which = END_STRING;
						break;
					case END_STRING:
						if ("\\".equals(token)) {
							withinEscape = !(withinEscape);
							continue;
						}
						if (quoteChar.equals(token) && !withinEscape) {
							/* normal end of that string */
							which = NMTOKEN;
						}
						break;
				}
			}
			if (which == NMTOKEN)
				return true;
			else {
//System.err.println("prematurely terminated attribute-value pair - ended expecting: " + parsingPosition[which]	);		
				return false;	// unterminated attribute-value pairs
			}
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
