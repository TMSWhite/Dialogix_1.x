package org.dianexus.triceps.modules.hl7.v2;

public class MSH {
	private String fieldSeparator="";
	private String encodingCharacters="";
	private String sendingApplication="";
	private String sendingFacility="";
	private String receivingApplication="";
	private String receivingFacility="";
	private String creationTimestamp="";
	private String security="";
	private String messageType="";
	private String messageControlId="";
	private String processingId="";
	private String versionId = "";
	private String sequenceNumber="";
	private String continuationPointer="";
	private String acceptAckType="";
	private String appAckType="";
	private String countryCode="";
	
	public String getAcceptAckType() {
		return acceptAckType;
	}
	public void setAcceptAckType(String acceptAckType) {
		this.acceptAckType = acceptAckType;
	}
	public String getAppAckType() {
		return appAckType;
	}
	public void setAppAckType(String appAckType) {
		this.appAckType = appAckType;
	}
	public String getContinuationPointer() {
		return continuationPointer;
	}
	public void setContinuationPointer(String continuationPointer) {
		this.continuationPointer = continuationPointer;
	}
	public String getCountryCode() {
		return countryCode;
	}
	public void setCountryCode(String countryCode) {
		this.countryCode = countryCode;
	}
	public String getCreationTimestamp() {
		return creationTimestamp;
	}
	public void setCreationTimestamp(String creationTimestamp) {
		this.creationTimestamp = creationTimestamp;
	}
	public String getEncodingCharacters() {
		return encodingCharacters;
	}
	public void setEncodingCharacters(String encodingCharacters) {
		this.encodingCharacters = encodingCharacters;
	}
	public String getFieldSeparator() {
		return fieldSeparator;
	}
	public void setFieldSeparator(String fieldSeparator) {
		this.fieldSeparator = fieldSeparator;
	}
	public String getMessageControlId() {
		return messageControlId;
	}
	public void setMessageControlId(String messageControlId) {
		this.messageControlId = messageControlId;
	}
	public String getMessageType() {
		return messageType;
	}
	public void setMessageType(String messageType) {
		this.messageType = messageType;
	}
	public String getProcessingId() {
		return processingId;
	}
	public void setProcessingId(String processingId) {
		this.processingId = processingId;
	}
	public String getReceivingApplication() {
		return receivingApplication;
	}
	public void setReceivingApplication(String receivingApplication) {
		this.receivingApplication = receivingApplication;
	}
	public String getReceivingFacility() {
		return receivingFacility;
	}
	public void setReceivingFacility(String receivingFacility) {
		this.receivingFacility = receivingFacility;
	}
	public String getSecurity() {
		return security;
	}
	public void setSecurity(String security) {
		this.security = security;
	}
	public String getSendingApplication() {
		return sendingApplication;
	}
	public void setSendingApplication(String sendingApplication) {
		this.sendingApplication = sendingApplication;
	}
	public String getSendingFacility() {
		return sendingFacility;
	}
	public void setSendingFacility(String sendingFacility) {
		this.sendingFacility = sendingFacility;
	}
	public String getSequenceNumber() {
		return sequenceNumber;
	}
	public void setSequenceNumber(String sequenceNumber) {
		this.sequenceNumber = sequenceNumber;
	}
	public String getVersionId() {
		return versionId;
	}
	public void setVersionId(String versionId) {
		this.versionId = versionId;
	}
	
	public String toString(){
		return "";
		
	}
	

}
