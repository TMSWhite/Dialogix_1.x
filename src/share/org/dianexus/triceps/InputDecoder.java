package org.dianexus.triceps;

import java.net.URLDecoder;

/** Decoder of InputEncoded Inputs
**/
class InputDecoder implements VersionIF {
	static String decode(String s) { 
		return URLDecoder.decode(s); 
	}
}
