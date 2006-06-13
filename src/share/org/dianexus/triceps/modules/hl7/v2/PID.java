package org.dianexus.triceps.modules.hl7.v2;

public class PID {
	
	private char VT = 11;
	private char FS = 28;
	private char CR = 13;
	
	private String setId="";
	private String extPatientId="";
	private String intPatientId="";
	private String altPatientId="";
	private String patientName="";
	private String mothersMaidenName="";
	private String dateOfBirth="";
	private String sex="";
	private String patientAlias="";
	private String race="";
	private String patientAddress="";
	private String countryCode="";
	private String homePhone="";
	private String workPhone="";
	private String language="";
	private String maritalStatus="";
	private String religion="";
	private String patientAccountNum="";
	private String ssn="";
	private String driversLicNum="";
	private String mothersIdentifier="";
	private String ethnicGroup="";
	private String birthPlace="";
	private String multiBirthInd="";
	private String birthOrder="";
	private String citizenship="";
	private String vetMilStatus="";
	private String fieldSeparator="";
	
	public String getAltPatientId() {
		return altPatientId;
	}
	public void setAltPatientId(String altPatientId) {
		this.altPatientId = altPatientId;
	}
	public String getBirthOrder() {
		return birthOrder;
	}
	public void setBirthOrder(String birthOrder) {
		this.birthOrder = birthOrder;
	}
	public String getBirthPlace() {
		return birthPlace;
	}
	public void setBirthPlace(String birthPlace) {
		this.birthPlace = birthPlace;
	}
	public String getCitizenship() {
		return citizenship;
	}
	public void setCitizenship(String citizenship) {
		this.citizenship = citizenship;
	}
	public String getCountryCode() {
		return countryCode;
	}
	public void setCountryCode(String countryCode) {
		this.countryCode = countryCode;
	}
	public String getDateOfBirth() {
		return dateOfBirth;
	}
	public void setDateOfBirth(String dateOfBirth) {
		this.dateOfBirth = dateOfBirth;
	}
	public String getDriversLicNum() {
		return driversLicNum;
	}
	public void setDriversLicNum(String driversLicNum) {
		this.driversLicNum = driversLicNum;
	}
	public String getEthnicGroup() {
		return ethnicGroup;
	}
	public void setEthnicGroup(String ethnicGroup) {
		this.ethnicGroup = ethnicGroup;
	}
	public String getExtPatientId() {
		return extPatientId;
	}
	public void setExtPatientId(String extPatientId) {
		this.extPatientId = extPatientId;
	}
	public String getHomePhone() {
		return homePhone;
	}
	public void setHomePhone(String homePhone) {
		this.homePhone = homePhone;
	}
	public String getIntPatientId() {
		return intPatientId;
	}
	public void setIntPatientId(String intPatientId) {
		this.intPatientId = intPatientId;
	}
	public String getLanguage() {
		return language;
	}
	public void setLanguage(String language) {
		this.language = language;
	}
	public String getMaritalStatus() {
		return maritalStatus;
	}
	public void setMaritalStatus(String maritalStatus) {
		this.maritalStatus = maritalStatus;
	}
	public String getMothersIdentifier() {
		return mothersIdentifier;
	}
	public void setMothersIdentifier(String mothersIdentifier) {
		this.mothersIdentifier = mothersIdentifier;
	}
	public String getMothersMaidenName() {
		return mothersMaidenName;
	}
	public void setMothersMaidenName(String mothersMaidenName) {
		this.mothersMaidenName = mothersMaidenName;
	}
	public String getMultiBirthInd() {
		return multiBirthInd;
	}
	public void setMultiBirthInd(String multiBirthInd) {
		this.multiBirthInd = multiBirthInd;
	}
	public String getPatientAccountNum() {
		return patientAccountNum;
	}
	public void setPatientAccountNum(String patientAccountNum) {
		this.patientAccountNum = patientAccountNum;
	}
	public String getPatientAddress() {
		return patientAddress;
	}
	public void setPatientAddress(String patientAddress) {
		this.patientAddress = patientAddress;
	}
	public String getPatientAlias() {
		return patientAlias;
	}
	public void setPatientAlias(String patientAlias) {
		this.patientAlias = patientAlias;
	}
	public String getPatientName() {
		return patientName;
	}
	public void setPatientName(String patientName) {
		this.patientName = patientName;
	}
	public String getRace() {
		return race;
	}
	public void setRace(String race) {
		this.race = race;
	}
	public String getReligion() {
		return religion;
	}
	public void setReligion(String religion) {
		this.religion = religion;
	}
	public String getSetId() {
		return setId;
	}
	public void setSetId(String setId) {
		this.setId = setId;
	}
	public String getSex() {
		return sex;
	}
	public void setSex(String sex) {
		this.sex = sex;
	}
	public String getSsn() {
		return ssn;
	}
	public void setSsn(String ssn) {
		this.ssn = ssn;
	}
	public String getVetMilStatus() {
		return vetMilStatus;
	}
	public void setVetMilStatus(String vetMilStatus) {
		this.vetMilStatus = vetMilStatus;
	}
	public String getWorkPhone() {
		return workPhone;
	}
	public void setWorkPhone(String workPhone) {
		this.workPhone = workPhone;
	}
	public String getFieldSeparator() {
		return fieldSeparator;
	}
	public void setFieldSeparator(String fieldSeparator) {
		this.fieldSeparator = fieldSeparator;
	}
	
	public String toString(){
		StringBuffer message = new StringBuffer();
		StringBuffer temp_message = new StringBuffer();
		
		message.append("PID"+fieldSeparator);
		
		
		if (!setId.equals("")) {
			message.append(temp_message.toString()+setId+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!extPatientId.equals("")) {
			message.append(temp_message.toString()+extPatientId+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!intPatientId.equals("")) {
			message.append(temp_message.toString()+intPatientId+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!altPatientId.equals("")) {
			message.append(temp_message.toString()+altPatientId+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!patientName.equals("")) {
			message.append(temp_message.toString()+patientName+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!mothersMaidenName.equals("")) {
			message.append(temp_message.toString()+mothersMaidenName+fieldSeparator); 
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!dateOfBirth.equals("")) {
			message.append(temp_message.toString()+dateOfBirth+fieldSeparator);  
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!sex.equals("")) {
			message.append(temp_message.toString()+sex+fieldSeparator); 
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!patientAlias.equals("")) {
			message.append(temp_message.toString()+patientAlias+fieldSeparator); 
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!race.equals("")) {
			message.append(temp_message.toString()+race+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!patientAddress.equals("")) {
			message.append(temp_message.toString()+patientAddress+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!countryCode.equals("")) {
			message.append(temp_message.toString()+countryCode+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!homePhone.equals("")) {
			message.append(temp_message.toString()+homePhone+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!workPhone.equals("")) {
			message.append(temp_message.toString()+workPhone+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!language.equals("")) {
			message.append(temp_message.toString()+language+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!maritalStatus.equals("")) {
			message.append(temp_message.toString()+maritalStatus+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!religion.equals("")) {
			message.append(temp_message.toString()+religion+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!patientAccountNum.equals("")) {
			message.append(temp_message.toString()+patientAccountNum+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!ssn.equals("")) {
			message.append(temp_message.toString()+ssn+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!driversLicNum.equals("")) {
			message.append(temp_message.toString()+driversLicNum+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!mothersIdentifier.equals("")) {
			message.append(temp_message.toString()+mothersIdentifier+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!ethnicGroup.equals("")) {
			message.append(temp_message.toString()+ethnicGroup+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!birthPlace.equals("")) {
			message.append(temp_message.toString()+birthPlace+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!multiBirthInd.equals("")) {
			message.append(temp_message.toString()+multiBirthInd+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!birthOrder.equals("")) {
			message.append(temp_message.toString()+birthOrder+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!citizenship.equals("")) {
			message.append(temp_message.toString()+citizenship+fieldSeparator);
			temp_message = new StringBuffer();

		}else{
			temp_message.append(fieldSeparator);
		}
		if (!vetMilStatus.equals("")) {
			message.append(temp_message.toString()+vetMilStatus+fieldSeparator);
			temp_message = new StringBuffer();

		}
		message.append(CR);

		return message.toString();
		
	}
	
	

}
