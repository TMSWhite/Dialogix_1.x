package org.dianexus.triceps;

import java.text.DecimalFormat;
import java.lang.IllegalArgumentException;

/** Encoder to massage XML Attribute Strings to prevent premature termination of Attribute Nodees
**/
class XMLAttrEncoder implements VersionIF {
	private static DecimalFormat ATT_ENTITY_FORMAT = null;
	
	static {
		try {
			ATT_ENTITY_FORMAT = new DecimalFormat("'&#'000';'");
		}
		catch (IllegalArgumentException e) { }
	}

	/** Encode XML Attribute values.  Replace any character that might prematurely terminate an XML attribute with an XML entity
	* FIXME - needs to be modified to supporte Unicode
	**/
	static String encode(String s) {
		StringBuffer sb = new StringBuffer();
		char[] chars = s.toCharArray();
		char c;
		
		for (int i=0;i<chars.length;++i) {
			c = chars[i];
			if (Character.isISOControl(c) || c == '\'' || c == '<' || c == '>' || c == '"' || c == '&') {
				sb.append(attEntityFormat(c));
			}
			else {
				sb.append(c);
			}
		}
		return sb.toString();
	}
	
	/** Format XML Entities using &#000; syntax.  FIXME  This does not extend gracefully to Unicode
	**/
	private static String attEntityFormat(char c) {
		try {
			return ATT_ENTITY_FORMAT.format((long) (c & 0x00ff));	// must strip high byte for HTML
		}
		catch (Throwable t) {
if (DEBUG) Logger.writeln("##Node.attEntityFormat()" + t.getMessage());
			return "";
		}
	}	
}
