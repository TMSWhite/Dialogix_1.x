package org.dianexus.triceps;

import java.net.URLEncoder;

/** Encoder to ensure that an Input can be expressed without whitespace or dangerous control characters
**/
class InputEncoder implements VersionIF {
	static String encode(String s) { 
		return URLEncoder.encode(s); 
	}
}
