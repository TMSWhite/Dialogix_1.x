import java.util.*;

public class XmlString extends Object {
	private static final Hashtable ENTITIES;
	private static final Hashtable BINARY_TAGS;
	private static final Hashtable UNARY_TAGS;
	private static final Hashtable DISALLOWED_TAGS;
	private static final Hashtable SOLO_ATTRIBUTES;
	private static final String binaryHTMLtags[] = {
		"a","abbr","acronym","address",
		"b","bdo","big", "blockquote",
		"caption","center","cite","code","comment",
		"dd","del","dfn","dir","div","dl","dt",
		"em",
		"fieldset","font","form",
		"h1","h2","h3","h4","h5","h6",
		"i","ins", 
		"kbd",
		"label","legend","li","listing",
		"map","menu",
		"nobr",
		"ol","optgroup","option",
		"p","pre",
		"q",
		"s","select","small", "span","strike","strong","sub","sup",
		"table","tbody","td","textarea","tfoot","th","thead","tr","tt",
		"u","ul","var",
	};
	private static final String unaryHTMLtags[] = {
		"area", 
		"base","basefont","br","button",
		"col","colgroup",
		"hr", 
		"img","input",
		"link",
		"wbr",
	};
	private static final String disallowedHTMLtags[] = {
		"!--",
		"applet",
		"blink", "bgsound", "body",
		"embed",
		"frame","frameset",
		"head","html",
		"iframe","ilayer", "isindex",
		"keygen",
		"layer",
		"marquee", "meta","multicol",
		"noembed","noframes","noscript",
		"object",		        
		"param","plaintext",
		"script", "server","spacer", "style",
		"title",
		"xmp",		 
	};
	private static final String standardHTMLentities[] = {
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
	private static final String soloHTMLattributes[] = {
		"checked", "compact",
		"disabled",
		"ismap",
		"nohref", "noshade", "nowrap",
		"multiple",
		"readonly",
		"selected",
	};
	
	private static final String QUOT = "&quot;";
	private static final String LT = "&lt;";
	private static final String GT = "&gt;";
	private static final String AMP = "&amp;";
	private static final String NBSP = "&nbsp;";

	
	static {
		ENTITIES = new Hashtable();
		BINARY_TAGS = new Hashtable();
		UNARY_TAGS = new Hashtable();
		DISALLOWED_TAGS = new Hashtable();
		SOLO_ATTRIBUTES = new Hashtable();
		/* initialize static Hashtables */
		for (int i=0;i<standardHTMLentities.length;++i) {
			ENTITIES.put(standardHTMLentities[i], "HTMLentity");
		}
		for (int i=0;i<binaryHTMLtags.length;++i) {
			BINARY_TAGS.put(binaryHTMLtags[i], "binaryHTMLtag");
		}
		for (int i=0;i<unaryHTMLtags.length;++i) {
			UNARY_TAGS.put(unaryHTMLtags[i], "unaryHTMLtag");
		}
		for (int i=0;i<disallowedHTMLtags.length;++i) {
			DISALLOWED_TAGS.put(disallowedHTMLtags[i], "disallowedHTMLtag");
		}
		for (int i=0;i<soloHTMLattributes.length;++i) {
			SOLO_ATTRIBUTES.put(soloHTMLattributes[i],"soloHTMLattribute");
		}
	}
	
	private StringBuffer dst = new StringBuffer();	// in which output string is composed
	private String value = null;
	private Vector tagStack = new Vector();
	private Vector errors = new Vector();
	private int lineNum = 1;
	private int column = 1;
		
    public XmlString(String src) {
    	value = encodeHTML(src);
    }
    
    public	String toString() { return value; }
    
    private static final int TAG = 0;
    private static final int NMTOKEN = 1;
    private static final int EQUALS_SIGN = 2;
    private static final int START_OF_STRING = 3;
    private static final int END_OF_STRING = 4;
    private static final String[] parsingPosition = { "TAG", "NMTOKEN","EQUALS_SIGN","START_OF_STRING","END_OF_STRING" };
	private static final int UNARY_TAG = 0;
	private static final int BINARY_TAG = 1;
    
	private boolean isValidElement(String src) {
		String tag = null;
		String token = null;
		String quoteChar = null;
		boolean withinEscape = false;
		int tagType;
		int which = TAG;
		
		String element = src.substring(1,src.length()-1);	// remove open and close angle brackets
		
		++column;	// to account for the opening left angle bracket
		
		if (element == null)
			element = "";
		
		try {
			/* build a string stripped of the opening and closing angle brackets */
			StringTokenizer st = new StringTokenizer(element," \t\n\r\f=\'\"\\",true);
				
			/* get and check tag name */
			tag = st.nextToken().toLowerCase();
			
			if (tag.startsWith("/")) {
				/* then an end tag */
				String endTag = tag.substring(1,tag.length());
				
				if (st.hasMoreTokens()) {
					error("ending tags may not have attribute values pairs " + src);
					return false;
				}
				if (UNARY_TAGS.containsKey(endTag)) {
					error("unary tags may not have closing tags " + src);
					return false;
                }
                if (DISALLOWED_TAGS.containsKey(endTag)) {
                	error("disallowed for security reasons " + src);
                	return false;
                }
                if (!BINARY_TAGS.containsKey(endTag)) {
					error("invalid end tag " + src);
					return false;
				}
				
				if (!tagStack.contains(endTag)) {
					error("rejecting mismatched endTag " + src);
					return false;
				}
				
				insertMissingEndTags(endTag);
				return true;
			}
			
			if (BINARY_TAGS.containsKey(tag)) {
				tagType = BINARY_TAG;
			}
			else if (UNARY_TAGS.containsKey(tag)) {
				tagType = UNARY_TAG;
			}
			else if (DISALLOWED_TAGS.containsKey(tag)) {
				error("disallowed for security reasons " + src);
				return false;
			}
			else {
				return false;
			}
	
			which = NMTOKEN;
			for (column+=tag.length();st.hasMoreTokens();column+=token.length()) {
				/* Loop over name = "attribute" pairs */				
				token = st.nextToken();
				char c = token.charAt(0);
				
				if (c == '\n' || c == '\r') {
					prettyPrint("");
					continue;
				}
				if (Character.isWhitespace(c)) {
					continue;
				}
				
				switch(which) {
					case NMTOKEN: {
						char[] chars = token.toCharArray();
						for (int i=0;i<chars.length;++i) {
							if (!(Character.isLetterOrDigit(chars[i]) || chars[i] == '_')) {
								error("bad character " + chars[i] + " in NMTOKEN of " + src);								
								return false;
							}
						}
						if (SOLO_ATTRIBUTES.containsKey(token.toLowerCase())) {
							which = NMTOKEN;
						}
						else {
							which = EQUALS_SIGN;
						}
					}
						break;
					case EQUALS_SIGN:
						if (!"=".equals(token)) {
							error("expected equals sign in " + src);							
							return false;
						}
						which = START_OF_STRING;
						break;
					case START_OF_STRING: 
						quoteChar = token;
						if (!("\"".equals(quoteChar) || "\'".equals(quoteChar))) {
							error("expected the start of a string in " + src);							
							return false;
						}
						withinEscape = false;
						which = END_OF_STRING;
						break;
					case END_OF_STRING:
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
			if (which == NMTOKEN) {
				/* then a valid tag, so push it onto the tag stack */
				if (tagType == BINARY_TAG) {
					tagStack.addElement(tag);
				}
				
				prettyPrint(src);
				return true;
			}
			else {
				error("prematurely terminated element - expecting " + parsingPosition[which] + " " + src);		
				return false;	// unterminated attribute-value pairs
			}
		}
		catch (Throwable t) {
			error("prematurely terminated element - expecting " + parsingPosition[which] + " " + src);		
			return false;	
		}
	}
	
	private void prettyPrint(String s) {
		/* pretty-print the output */
		dst.append("\n");
		++lineNum;
		column = 1;
		for (int i=0;i<tagStack.size();++i) {
			dst.append("\t");
			++column;
		}
		dst.append(s);
		column += s.length();
	}
	
	private void insertMissingEndTags(String endTag) {
		for (int i=tagStack.size()-1;i>=0;--i) {
			String t = (String) tagStack.elementAt(i);
			
			if ("td".equals(t)) {
				for (int j=dst.length()-1;j>=0;--j) {
					if (Character.isWhitespace(dst.charAt(j)))
						continue;
					if (dst.charAt(j) == '>') {
						dst.append(NBSP);	// Netscape doesn't deal well with empty Table cells
					}
					break;
				}
			}
			
			prettyPrint("</" + t + ">");
			tagStack.removeElementAt(i);	// decrements its counter
			
			if (t.equals(endTag)) {
				break;
			}
			else {
				error("inserting missing endTag for <" + t + ">");
			}
		}
	}

	private String encodeHTML(String s) {
		if (s != null) {
			try {
				char[] src = s.toCharArray();

				for (int i=0;i<src.length;++i) {
					switch (src[i]) {
						case '\"': 
							dst.append(QUOT); 
							column += QUOT.length();
							break;
						case '<': {
							/* grab next complete element */
							int elementEnd;
							String element = null;
							
							elementEnd = s.indexOf('>',i);
							if (elementEnd != -1) {
								element = s.substring(i,elementEnd+1);
								/* Now, get the element name (assuming that might have attribute value pairs */
								int prevCol = column;	// since isValidElement() changes the column value internally
								if (isValidElement(element)) {
									i+= (element.length()-1);	// -1, since will be re-incremented in for loop	
								}
								else {
									dst.append(LT);
									column = prevCol + LT.length();
								}
							}
							else {
								error("no closing right angle bracket");
								dst.append(LT);
								column += LT.length();
							}
						}
							break;
						case '>': 
							dst.append(GT); 
							column += GT.length();
							break;
						case '&': {
							String entity = null;
							int entityEnd = s.indexOf(';',i);
							if (entityEnd != -1) {
								entity = s.substring(i,entityEnd+1);
								if (isEntity(entity)) {
									dst.append(entity);
									i += (entity.length()-1);
								}
								else {
									error("not a recognized Unicode entity:" + entity);
									dst.append(AMP);
									column += AMP.length();
								}
							}
							else {
								error("not an entity - ampersand without matching semicolon");
								dst.append(AMP);
								column += AMP.length();
							}
						}
							break;
						case '\n': case '\r':
							prettyPrint("");
							break;
						case '\t':
							break;	// ignore tabs - will be pretty-printed automatically
						default: 
							dst.append(src[i]); 
							++column;
							break;
					}
				}
			}
			catch (Throwable t) {
				error("Exception while HTMLizing string" + t.getMessage());
			}
		}
		insertMissingEndTags(null);
		
		String ans = dst.toString();
		
for (int i=0;i<errors.size();++i) {
	System.err.println((String) errors.elementAt(i));
}

		return ans;
	}
	
	private void error(String s) {
		errors.addElement("line " + lineNum + " column " + column + " - " + s);
	}
	
	public boolean hasErrors() { return (errors.size() > 0); }
	public Vector getErrors() { return errors; }
	
	public static synchronized boolean isEntity(String entity) {
		if (ENTITIES.containsKey(entity)) {
			return true;
		}
		else {
			/* check whether it is a valid UNICODE character */
			int unicodeHashMark = entity.indexOf('#');
			if (unicodeHashMark == 1 && entity.length() <= 3) {
				String unicodeTriple = entity.substring(unicodeHashMark,entity.length());
				for (int j=0;j<unicodeTriple.length();++j) {
					if (!Character.isDigit(unicodeTriple.charAt(j))) {
						return false;
					}
				}
				return true;
			}
			else {
				return false;
			}
		}	
	}
}
