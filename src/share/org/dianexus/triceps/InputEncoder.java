package org.dianexus.triceps;

/** Encoder to ensure that an Input can be expressed without tabs and newlines - simply strip them out and replace with single space
**/
class InputEncoder implements VersionIF {
	static String encode(String s) {
		StringBuffer sb = new StringBuffer();
		char[] chars = s.toCharArray();
		char c;
		
		for (int i=0;i<chars.length;++i) {
			c = chars[i];
			if (Character.isWhitespace(c)) {
				sb.append(' ');
			}
			else {
				sb.append(c);
			}
		}
		return sb.toString();
	}
}
