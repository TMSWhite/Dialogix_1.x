import java.lang.*;
import java.util.*;
import java.io.*;


public class AnswerChoice  {
	String value;
	String message;
	String anchor;
	String value_parsed=null;
	String message_parsed=null;
	
	public AnswerChoice(String value, String message, String anchor) {
		this.value = value;
		this.message = message;
		this.anchor = anchor;
		this.value_parsed = value;	// default initial is unparsed
		this.message_parsed = message;	// default initial is unparsed
	}
	
	public AnswerChoice(String value, String message) {
		this(value,message,"");
	}
	
	public void parse(Parser parser, Evidence ev) {
		value_parsed = parser.stringVal(ev,value);
		message_parsed = parser.parseJSP(ev,message);
	}
	
	public void setValue(String value) { this.value = value; }
	public String getValue() { return value_parsed; }
	
	public void setMessage(String message) { this.message = message; }
	public String getMessage() { return message_parsed; }	
	
	public void setAnchor(String anchor) { this.anchor = anchor; }
	public String getAnchor() { return anchor; }	
}
