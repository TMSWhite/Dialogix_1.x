import java.util.*;
import java.io.*;

public class XmlString extends Object {
	public static final XmlString NULL = new XmlString(null,null);

	private static final Hashtable ENTITIES = new Hashtable();
	private static final Hashtable BINARY_TAGS = new Hashtable();
	private static final Hashtable UNARY_TAGS = new Hashtable();
	private static final Hashtable DISALLOWED_TAGS = new Hashtable();
	private static final Hashtable SOLO_ATTRIBUTES = new Hashtable();
	private static final Hashtable TAGS_AFFECTED_BY_WHITESPACE = new Hashtable();

	private static final String binaryHTMLtags[] = {
		"a","abbr","acronym","address","applet",
		"b","bdo","big", "blink", "bgsound", "blockquote","body",
		"caption","center","cite","code","comment",
		"dd","del","dfn","dir","div","dl","dt",
		"em","embed",
		"fieldset","font","form","frame","frameset",
		"h1","h2","h3","h4","h5","h6","head","html",
		"i","iframe","ilayer","ins",
		"kbd", "keygen",
		"layer","label","legend","li","listing",
		"map","marquee","menu","meta","multicol",
		"nobr","noembed","noframes","noscript",
		"object","ol","optgroup","option",
		"p","param","pre",
		"q",
		"s","script","select","server","small","span","strike","strong","style","sub","sup",
		"table","tbody","td","textarea","th","title","tr","tt",
		"u","ul",
		"var",
		"xmp",
	};

	private static final String tagsAffectedByWhitespace[] = {
		"a","abbr","acronym","address",
		"b","bdo","big","blink","blockquote",
		"caption","center","cite","code","comment",
		"del","dfn","div",
		"em",
		"font",
		"h1","h2","h3","h4","h5","h6",
		"i","ins",
		"nobr",
		"option",
		"p","pre",
		"q",
		"s","small","span","strike","strong","sub","sup",
		"textarea",
		"u",
		"var"
	};

	private static final String unaryHTMLtags[] = {
		"area",
		"base","basefont","br","button",
		"col","colgroup",
		"hr",
		"img","input","isindex",
		"link",
		"meta",
		"plaintext",
		"spacer",
		"tfoot","thead",
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
	private static final String NEWLINE = "\n";


	static {
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
		for (int i=0;i<tagsAffectedByWhitespace.length;++i) {
			TAGS_AFFECTED_BY_WHITESPACE.put(tagsAffectedByWhitespace[i],"tagAffectedByWhitespace");
		}
	}

	private Writer dst = null;
	private Vector tagStack = new Vector();
	private Logger logger = new Logger();	// will always use an HTML eol
	private Lingua lingua = Lingua.NULL;
	private int lineNum = 1;
	private int column = 1;

    public XmlString(Lingua lang, String src) {
    	lingua = (lang == null) ? Lingua.NULL : lang;
    	if (src == null)
    		return;
    	try {
    		dst = new StringWriter();
    		encodeHTML(src);
    		dst.close();
    	}
    	catch (IOException e){ }
    }

    public XmlString(Lingua lang, String src, Writer out) {
    	lingua = (lang == null) ? Lingua.NULL : lang;
    	if (src == null || out == null)
    		return;
    	try {
    		dst = out;
    		encodeHTML(src);
    		dst.flush();	// don't close, since externally presented
    	}
    	catch (IOException e) { }
    }

    public	String toString() { return dst.toString(); }

    public void setLingua(Lingua lang) {
    	lingua = (lang == null) ? Lingua.NULL : lang;
    }

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
					error(lingua.get("ending_tags_may_not_have_attribute_value_pairs") + asElement(element));
					return false;
				}
				if (UNARY_TAGS.containsKey(endTag)) {
					error(lingua.get("unary_tags_may_not_have_closing_tags") + asElement(element));
					return false;
                }
                if (!BINARY_TAGS.containsKey(endTag)) {
					error(lingua.get("invalid_end_tag") + asElement(element));
					return false;
				}
                if (DISALLOWED_TAGS.containsKey(endTag)) {
                	error(lingua.get("disallowed_for_security_reasons") + asElement(element));
                	return false;
                }

				if (!tagStack.contains(endTag)) {
					error(lingua.get("rejecting_mismatched_endTag") + asElement(element));
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
			else {
				return false;
			}

			if (DISALLOWED_TAGS.containsKey(tag)) {
				error(lingua.get("disallowed_for_security_reasons") + asElement(element));
				return false;
			}

			which = NMTOKEN;
			for (column+=tag.length();st.hasMoreTokens();column+=token.length()) {
				/* Loop over name = "attribute" pairs */
				token = st.nextToken();
				char c = token.charAt(0);

				if (c == '\n' || c == '\r') {
					prettyPrint("",true);
					continue;
				}
				if (Character.isWhitespace(c)) {
					continue;
				}

				switch(which) {
					case NMTOKEN: {
						if (!isNMTOKEN(token))
							return false;

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
							error(lingua.get("expected_equals_sign") + asElement(element));
							return false;
						}
						which = START_OF_STRING;
						break;
					case START_OF_STRING:
						quoteChar = token;
						if (!("\"".equals(quoteChar) || "\'".equals(quoteChar))) {
							error(lingua.get("expected_start_of_a_string") + asElement(element));
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

				if (TAGS_AFFECTED_BY_WHITESPACE.containsKey(tag)) {
					prettyPrint(src,false);
				}
				else {
					prettyPrint(src,true);
				}
				return true;
			}
			else {
				error(lingua.get("prematurely_terminated_element") + parsingPosition[which] + " " + asElement(element));
				return false;	// unterminated attribute-value pairs
			}
		}
		catch (Throwable t) {
			error(lingua.get("prematurely_terminated_element") + parsingPosition[which] + " " + asElement(element));
			return false;
		}
	}

	private void prettyPrint(String s, boolean addReturn) {
		try {
			/* pretty-print the output */
			if (addReturn) {
				dst.write(NEWLINE);
				++lineNum;
				column = 1;
				for (int i=0;i<tagStack.size();++i) {
					dst.write("   ");	// three spaces - like a tab, but more reliable
					column += 3;
				}
			}
			dst.write(s);
			column += s.length();
		}
		catch (IOException e) { }
	}

	private void insertMissingEndTags(String endTag) {
		for (int i=tagStack.size()-1;i>=0;--i) {
			String t = (String) tagStack.elementAt(i);
			String tagToPrint = "</" + t + ">";

			if ("td".equals(t)) {
				tagToPrint = NBSP + tagToPrint;	// just in case, since Netscape doesn't deal well with empty Table cells
			}

			if (TAGS_AFFECTED_BY_WHITESPACE.containsKey(t)) {
				if ("option".equals(t)) {
					try {
						dst.write(tagToPrint);
					}
					catch (IOException e) { }
					prettyPrint("",true);
				}
				else {
					prettyPrint(tagToPrint,false);
				}
			}
			else {
				prettyPrint(tagToPrint,true);
			}
			tagStack.removeElementAt(i);	// decrements its counter

			if (t.equals(endTag)) {
				break;
			}
			else {
				error(lingua.get("inserting_missing_endTag_for") + asElement(t));
			}
		}
	}

	private void encodeHTML(String s) {
		if (s != null) {
			try {
				char[] src = s.toCharArray();

				for (int i=0;i<src.length;++i) {
					switch (src[i]) {
						case '\"':
							dst.write(QUOT);
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
									dst.write(LT);
									column = prevCol + LT.length();
								}
							}
							else {
								error(lingua.get("no_closing_right_angle_bracket"));
								dst.write(LT);
								column += LT.length();
							}
						}
							break;
						case '>':
							dst.write(GT);
							column += GT.length();
							break;
						case '&': {
							String entity = null;
							int entityEnd = s.indexOf(';',i);
							if (entityEnd != -1) {
								entity = s.substring(i,entityEnd+1);
								if (isEntity(entity)) {
									dst.write(entity);
									i += (entity.length()-1);
								}
								else {
									dst.write(AMP);
									column += AMP.length();
								}
							}
							else {
								dst.write(AMP);
								column += AMP.length();
							}
						}
							break;
						case '\n': case '\r':
							prettyPrint("",true);
							break;
						default:
							dst.write(src[i]);
							++column;
							break;
					}
				}
			}
			catch (IOException e) { }
		}
		insertMissingEndTags(null);
	}

	private void error(String s) {
		logger.println(s,lineNum,column);
	}

	public boolean hasErrors() { return (logger.size() > 0); }
	public String getErrors() { return logger.toString(); }

	public boolean isNMTOKEN(String token) {
		char[] chars = token.toCharArray();
		for (int i=0;i<chars.length;++i) {
			if (!(Character.isLetterOrDigit(chars[i]) || chars[i] == '_')) {
				error(lingua.get("name_contains_invalid_character") + chars[i]);
				return false;
			}
		}
		return true;
	}

	public boolean isEntity(String entity) {
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

	private String asElement(String s) {
		return (LT + s + GT);
	}
	private String asEntity(String s) {
		return (AMP + s + ";");
	}
}

