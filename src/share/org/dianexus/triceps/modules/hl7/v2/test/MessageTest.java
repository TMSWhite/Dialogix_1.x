package org.dianexus.triceps.modules.hl7.v2.test;

import junit.framework.TestCase;
import org.dianexus.triceps.modules.hl7.v2.*;

public class MessageTest extends TestCase {
	public String testString="test";
	public int testInt =1234;
	
	public void testBean(){
		// test message getters and setters
		Message message = new Message();
		message.setStatus(testString);
		assertEquals(message.getStatus(),testString);
		
		//test MSH getters and setters
		MSH msh = new MSH();
		
		msh.setAcceptAckType(testString);
		assertEquals(msh.getAcceptAckType(),testString);
		msh.setAppAckType(testString);
		assertEquals(msh.getAppAckType(),testString);
		msh.setContinuationPointer(testString);
		assertEquals(msh.getContinuationPointer(),testString);
		msh.setCountryCode(testString);
		assertEquals(msh.getCountryCode(),testString);
		msh.setCreationTimestamp(testString);
		assertEquals(msh.getCreationTimestamp(),testString);
		msh.setEncodingCharacters(testString);
		assertEquals(msh.getEncodingCharacters(),testString);
		msh.setFieldSeparator("|");
		assertEquals(msh.getFieldSeparator(),"|");
		msh.setMessageControlId(testString);
		assertEquals(msh.getMessageControlId(),testString);
		msh.setMessageType(testString);
		assertEquals(msh.getMessageType(),testString);
		msh.setProcessingId(testString);
		assertEquals(msh.getProcessingId(),testString);
		msh.setReceivingApplication(testString);
		assertEquals(msh.getReceivingApplication(),testString);
		msh.setReceivingFacility(testString);
		assertEquals(msh.getReceivingFacility(),testString);
		msh.setSecurity(testString);
		assertEquals(msh.getSecurity(),testString);
		msh.setSendingApplication(testString);
		assertEquals(msh.getSendingApplication(),testString);
		msh.setSendingFacility(testString);
		assertEquals(msh.getSendingFacility(),testString);
		msh.setSequenceNumber(testString);
		assertEquals(msh.getSequenceNumber(),testString);
		msh.setVersionId(testString);
		assertEquals(msh.getVersionId(),testString);
		
		//test PID getters and setters
		PID pid = new PID();
		pid.setAltPatientId(testString);
		assertEquals(pid.getAltPatientId(),testString);
		pid.setBirthOrder(testString);
		assertEquals(pid.getBirthOrder(),testString);
		pid.setBirthPlace(testString);
		assertEquals(pid.getBirthPlace(),testString);
		pid.setCitizenship(testString);
		assertEquals(pid.getCitizenship(),testString);
		pid.setCountryCode(testString);
		assertEquals(pid.getCountryCode(),testString);
		pid.setDateOfBirth(testString);
		assertEquals(pid.getDateOfBirth(),testString);
		pid.setDriversLicNum(testString);
		assertEquals(pid.getDriversLicNum(),testString);
		pid.setEthnicGroup(testString);
		assertEquals(pid.getEthnicGroup(),testString);
		pid.setExtPatientId(testString);
		assertEquals(pid.getExtPatientId(),testString);
		pid.setFieldSeparator("|");
		assertEquals(pid.getFieldSeparator(),"|");
		pid.setHomePhone(testString);
		assertEquals(pid.getHomePhone(),testString);
		pid.setIntPatientId(testString);
		assertEquals(pid.getIntPatientId(),testString);
		pid.setLanguage(testString);
		assertEquals(pid.getLanguage(),testString);
		pid.setMaritalStatus(testString);
		assertEquals(pid.getMaritalStatus(),testString);
		pid.setMothersIdentifier(testString);
		assertEquals(pid.getMothersIdentifier(),testString);
		pid.setMothersMaidenName(testString);
		assertEquals(pid.getMothersMaidenName(),testString);
		pid.setMultiBirthInd(testString);
		assertEquals(pid.getMultiBirthInd(),testString);
		pid.setPatientAccountNum(testString);
		assertEquals(pid.getPatientAccountNum(),testString);
		pid.setPatientAddress(testString);
		assertEquals(pid.getPatientAddress(),testString);
		pid.setPatientAlias(testString);
		assertEquals(pid.getPatientAlias(),testString);
		pid.setPatientName(testString);
		assertEquals(pid.getPatientName(),testString);
		pid.setRace(testString);
		assertEquals(pid.getRace(),testString);
		pid.setReligion(testString);
		assertEquals(pid.getReligion(),testString);
		pid.setSetId(testString);
		assertEquals(pid.getSetId(),testString);
		pid.setSex(testString);
		assertEquals(pid.getSex(),testString);
		pid.setSsn(testString);
		assertEquals(pid.getSsn(),testString);
		pid.setVetMilStatus(testString);
		assertEquals(pid.getVetMilStatus(),testString);
		pid.setWorkPhone(testString);
		assertEquals(pid.getWorkPhone(),testString);
		
		//test OBR4 setters and getters
		OBR4 obr = new OBR4();
		obr.setAlternateCodingSystem(testString);
		assertEquals(obr.getAlternateCodingSystem(),testString);
		obr.setAlternateMessage(testString);
		assertEquals(obr.getAlternateMessage(),testString);
		obr.setAlternateValue(testString);
		assertEquals(obr.getAlternateValue(),testString);
		obr.setCodingSystem(testString);
		assertEquals(obr.getCodingSystem(),testString);
		obr.setElementId(testInt);
		assertEquals(obr.getElementId(),testInt);
		obr.setMessage(testString);
		assertEquals(obr.getMessage(),testString);
		obr.setMessageId(testInt);
		assertEquals(obr.getMessageId(),testInt);
		obr.setValue(testString);
		assertEquals(obr.getValue(),testString);
		
		//test OBX3 getters and setters
		OBX3 obx3 = new OBX3();
		obx3.setAlternateCodingSystem(testString);
		assertEquals(obx3.getAlternateCodingSystem(),testString);
		obx3.setAlternateMessage(testString);
		assertEquals(obx3.getAlternateMessage(),testString);
		obx3.setAlternateValue(testString);
		assertEquals(obx3.getAlternateValue(),testString);
		obx3.setCodingSystem(testString);
		assertEquals(obx3.getCodingSystem(),testString);
		obx3.setElementId(testInt);
		assertEquals(obx3.getElementId(),testInt);
		obx3.setMessage(testString);
		assertEquals(obx3.getMessage(),testString);
		obx3.setMessageId(testInt);
		assertEquals(obx3.getMessageId(),testInt);
		obx3.setValue(testString);
		assertEquals(obx3.getValue(),testString);
		
		//test OBX5 getters and setters
		
		OBX5 obx5 = new OBX5();
		obx5.setAlternateCodingSystem(testString);
		assertEquals(obx5.getAlternateCodingSystem(),testString);
		obx5.setAlternateMessage(testString);
		assertEquals(obx5.getAlternateMessage(),testString);
		obx5.setAlternateValue(testString);
		assertEquals(obx5.getAlternateValue(),testString);
		obx5.setCodingSystem(testString);
		assertEquals(obx5.getCodingSystem(),testString);
		obx5.setElementId(testInt);
		assertEquals(obx5.getElementId(),testInt);
		obx5.setMessage(testString);
		assertEquals(obx5.getMessage(),testString);
		obx5.setMessageId(testInt);
		assertEquals(obx5.getMessageId(),testInt);
		obx5.setValue(testString);
		assertEquals(obx5.getValue(),testString);
		
		// test message building
		message.addElement(msh);
		message.addElement(pid);
		message.addElement(obr);
		message.addElement(obx3);
		message.addElement(obx5);
		System.out.println(message.toString());
		
	}

}
