/* ******************************************************** 
** Copyright (c) 2000-2001, Thomas Maxwell White, all rights reserved. 
** $Header$
******************************************************** */ 

package org.dianexus.triceps;

/*import java.lang.*;*/
/*import java.util.*;*/
/*import java.io.*;*/
import java.util.Vector;


/*public*/ class AnswerChoice implements VersionIF  {
	private static final String INTRA_OPTION_LINE_BREAK = "<br>";

	String value;
	String message;
	String anchor;
	String value_parsed=null;
	String message_parsed=null;

	/*public*/ AnswerChoice(String value, String message, String anchor) {
		this.value = value;
		this.message = message;
		this.anchor = anchor;
		this.value_parsed = value;	// default initial is unparsed
		this.message_parsed = message;	// default initial is unparsed
	}

	/*public*/ AnswerChoice(String value, String message) {
		this(value,message,"");
	}

	/*public*/ void parse(Triceps triceps) {
		Parser parser = triceps.getParser();
		value_parsed = parser.stringVal(triceps,value);
		message_parsed = parser.parseJSP(triceps,message);
	}

	/*public*/ void setValue(String value) { this.value = value; }
	/*public*/ String getValue() { return value_parsed; }

	/*public*/ void setMessage(String message) { this.message = message; }
	/*public*/ String getMessage() { return message_parsed; }

	/*public*/ void setAnchor(String anchor) { this.anchor = anchor; }
	/*public*/ String getAnchor() { return anchor; }
	
	/*public*/ String toXML(boolean selected, int maxLen, String key) {
		StringBuffer sb = new StringBuffer();
if (XML) {
			
		Vector v = subdivideMessage(getMessage(),maxLen);
		String val = XMLAttrEncoder.encode(getValue());
		
		for (int i=0;i<v.size();++i) {
			sb.append("		<ac val=\"");
			sb.append(val);
			sb.append("\" key=\"");
			sb.append((i==0) ? key : " ");	// the accelerator key - only accelerate the first of a multi-line option
			sb.append("\" on=\"");
			sb.append((selected && i==0) ? "1" : "0");	// only mark the first instance as selected
			sb.append("\">");
			sb.append((new XmlString(null,(String) v.elementAt(i))).toString());	// can have embedded markup
			sb.append("</ac>\n");
		}
}		
		return sb.toString();
	}
	
	/*public*/ static String toXML(String emptyVal, boolean selected) {
		StringBuffer sb = new StringBuffer();
if (XML) {		
		sb.append("		<ac val=\"\" key=\"\" on=\"");
		sb.append((selected) ? "1" : "0");	// only mark the first instance as selected
		sb.append("\">");
		sb.append(XMLAttrEncoder.encode(emptyVal));
		sb.append("</ac>\n");
}		
		return sb.toString();
	}
	
	/*public*/ static Vector subdivideMessage(String src, int maxLen) {
		/** splits a string at a natural boundaries so that no line is longer than maxLen */
		Vector choices = new Vector();
		int start=0;
		int stop=0;
		int toadd=0;
		int lineBreak=0;
		char breakChar;
		char[] breakChars = {' ', '-', '.', ':', ']', '[', '(', ')'};
		int breakCharIdx = 0;
		String option = null;
		String messageStr = src;
		
		if (maxLen == -1) {
			choices.addElement(messageStr);
			return choices;
		}

		/* also detects <br> for intra-option line-breaks */
		while (start < messageStr.length()) {
			toadd = 0;
			
			lineBreak = messageStr.indexOf(INTRA_OPTION_LINE_BREAK,start);
			if (lineBreak == -1) {
				option = messageStr.substring(start,messageStr.length());
			}
			else {
				option = messageStr.substring(start,lineBreak);
			}
			
			if (option.length() <= maxLen) {
				stop = option.length();
				choices.addElement(option.substring(0,stop));
				if (lineBreak != -1) {
					toadd = INTRA_OPTION_LINE_BREAK.length();
				}
			}
			else {
				for (breakCharIdx=0;breakCharIdx<breakChars.length;++breakCharIdx) {
					stop = option.lastIndexOf(breakChars[breakCharIdx],maxLen);
					if (stop != -1) {
						toadd = 1;
						break;
					}
				}
				if (breakCharIdx == 0 || stop == -1) {
					choices.addElement(option.substring(0,stop));	// exclude the space
				}
				else {
					choices.addElement(option.substring(0,stop+1));	// include the punctuation
				}
			}
			start += (stop + toadd);
		}
		return choices;
	}
}
