package org.dianexus.triceps.modules.hl7.v2;

public class MSH {
	
	private char VT = 11;
	private char FS = 28;
	private char CR = 13;
	
	private String fieldSeparator = "";

	private String encodingCharacters = "";

	private String sendingApplication = "";

	private String sendingFacility = "";

	private String receivingApplication = "";

	private String receivingFacility = "";

	private String creationTimestamp = "";

	private String security = "";

	private String messageType = "";

	private String messageControlId = "";

	private String processingId = "";

	private String versionId = "";

	private String sequenceNumber = "";

	private String continuationPointer = "";

	private String acceptAckType = "";

	private String appAckType = "";

	private String countryCode = "";

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

	public String toString() {
		StringBuffer message = new StringBuffer();
		StringBuffer temp_message = new StringBuffer();
		
		message.append("MSH");
		
		if (!fieldSeparator.equals("")) {
			message.append(fieldSeparator);
		}
		if (!encodingCharacters.equals("")) {
			message.append(temp_message.toString()+encodingCharacters+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!sendingApplication.equals("")) {
			message.append(temp_message.toString()+sendingApplication+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!sendingFacility.equals("")) {
			message.append(temp_message.toString()+sendingFacility+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!receivingApplication.equals("")) {
			message.append(temp_message.toString()+receivingApplication+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!receivingFacility.equals("")) {
			message.append(temp_message.toString()+receivingFacility+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!creationTimestamp.equals("")) {
			message.append(temp_message.toString()+creationTimestamp+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!security.equals("")) {
			message.append(temp_message.toString()+security+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!messageType.equals("")) {
			message.append(temp_message.toString()+messageType+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!messageControlId.equals("")) {
			message.append(temp_message.toString()+messageControlId+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!processingId.equals("")) {
			message.append(temp_message.toString()+processingId+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!versionId.equals("")) {
			message.append(temp_message.toString()+versionId+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!sequenceNumber.equals("")) {
			message.append(temp_message.toString()+sequenceNumber+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!continuationPointer.equals("")) {
			message.append(temp_message.toString()+continuationPointer+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!acceptAckType.equals("")) {
			message.append(temp_message.toString()+acceptAckType+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!appAckType.equals("")) {
			message.append(temp_message.toString()+appAckType+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!countryCode.equals("")) {
			message.append(temp_message.toString()+countryCode+fieldSeparator);
			temp_message = new StringBuffer();

		}
		message.append(CR);
		return message.toString();

	}

}
