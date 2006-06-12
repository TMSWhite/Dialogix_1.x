package org.dianexus.triceps.modules.hl7.v2;

public class OBX5 {
	private int messageId;
	private int elementId;
	private String value="";
	private String message="";
	private String codingSystem="";
	private String alternateValue="";
	private String alternateMessage="";
	private String alternateCodingSystem="";
	
	public String getAlternateCodingSystem() {
		return alternateCodingSystem;
	}
	public void setAlternateCodingSystem(String alternateCodingSystem) {
		this.alternateCodingSystem = alternateCodingSystem;
	}
	public String getAlternateMessage() {
		return alternateMessage;
	}
	public void setAlternateMessage(String alternateMessage) {
		this.alternateMessage = alternateMessage;
	}
	public String getAlternateValue() {
		return alternateValue;
	}
	public void setAlternateValue(String alternateValue) {
		this.alternateValue = alternateValue;
	}
	public String getCodingSystem() {
		return codingSystem;
	}
	public void setCodingSystem(String codingSystem) {
		this.codingSystem = codingSystem;
	}
	public int getElementId() {
		return elementId;
	}
	public void setElementId(int elementId) {
		this.elementId = elementId;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public int getMessageId() {
		return messageId;
	}
	public void setMessageId(int messageId) {
		this.messageId = messageId;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	public String toString(){
		StringBuffer sb = new StringBuffer();
		sb.append("OBX|5|CE|");
		sb.append(this.getValue()+"^");
		sb.append(this.getMessage()+"^");
		sb.append(this.getCodingSystem());
		if(this.alternateValue.equals("")){
			sb.append("|");
		}
		else{
			sb.append("^"+this.alternateValue+"^");
			sb.append(this.alternateMessage+"^");
			sb.append(this.alternateCodingSystem+"|");
		}
		return sb.toString();
	}
}
