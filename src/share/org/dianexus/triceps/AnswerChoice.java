import java.lang.*;
import java.util.*;
import java.io.*;


public class AnswerChoice  {
	String value;
	String message;
	String anchor;
	
	public AnswerChoice(String value, String message, String anchor) {
		this.value = value;
		this.message = message;
		this.anchor = anchor;
	}
	
	public AnswerChoice(String value, String message) {
		this.value = value;
		this.message = message;
		this.anchor = "";
	}	
	
	public void setValue(String value) { this.value = value; }
	public String getValue() { return value; }
	
	public void setMessage(String message) { this.message = message; }
	public String getMessage() { return message; }	
	
	public void setAnchor(String anchor) { this.anchor = anchor; }
	public String getAnchor() { return anchor; }	
}
