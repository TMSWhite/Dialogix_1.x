package org.dianexus.triceps.modules.data;

import java.sql.Date;
import java.sql.Timestamp;

import junit.framework.TestCase;

public class MysqlRawDataDAOTest extends TestCase {
	
	int testIntValue = 123;
	String testStringValue = "abc";
	Timestamp ts = new Timestamp(100000000);
	long testLongValue = 98;
	RawDataDAO testDAO;
	DialogixDAOFactory mdao;
	int lastInsertID=0;

	public static void main(String[] args) {
	}

	protected void setUp() throws Exception {
		mdao =  DialogixDAOFactory.getDAOFactory(1);
		testDAO = mdao.getRawDataDAO();
	}

	protected void tearDown() throws Exception {
		if(mdao != null){
			mdao=null;
		}
		if(testDAO != null){
			testDAO = null;
		}
	}

	/*
	 * Test method for 'org.dianexus.triceps.modules.data.MysqlRawDataDAO.updateRawData()'
	 */
	public void testRawData() {
		//test getters and setters
		System.out.println(ts);
		testDAO.setAnswer(testStringValue);
		assertEquals(testDAO.getAnswer(),testStringValue);
		testDAO.setAnswerType(testIntValue);
		assertEquals(testDAO.getAnswerType(),testIntValue);
		testDAO.setComment(testStringValue);
		assertEquals(testDAO.getComment(),testStringValue);
		testDAO.setDisplayNum(testIntValue);
		assertEquals(testDAO.getDisplayNum(),testIntValue);
		testDAO.setGroupNum(testIntValue);
		assertEquals(testDAO.getGroupNum(),testIntValue);
		testDAO.setInstanceName(testStringValue);
		assertEquals(testDAO.getInstanceName(),testStringValue);
		testDAO.setInstrumentName(testStringValue);
		assertEquals(testDAO.getInstrumentName(),testStringValue);
		testDAO.setInstrumentSessionId(testIntValue);
		assertEquals(testDAO.getInstrumentSessionId(),testIntValue);
		testDAO.setItemVacillation(testIntValue);
		assertEquals(testDAO.getItemVacillation(),testIntValue);
		testDAO.setLangNum(testIntValue);
		assertEquals(testDAO.getLangNum(),testIntValue);
		testDAO.setNullFlavor(testIntValue);
		assertEquals(testDAO.getNullFlavor(),testIntValue);
		testDAO.setQuestionAsAsked(testStringValue);
		assertEquals(testDAO.getQuestionAsAsked(),testStringValue);
		testDAO.setRawDataId(testIntValue);
		assertEquals(testDAO.getRawDataId(),testIntValue);
		testDAO.setResponseDuration(testIntValue);
		assertEquals(testDAO.getResponseDuration(),testIntValue);
		testDAO.setResponseLatency(testIntValue);
		assertEquals(testDAO.getResponseLatency(),testIntValue);
		testDAO.setTimeStamp(ts); 
		assertEquals(testDAO.getTimeStamp(),ts);
		testDAO.setVarName(testStringValue);
		assertEquals(testDAO.getVarName(),testStringValue);
		testDAO.setVarNum(testIntValue);
		assertEquals(testDAO.getVarNum(),testIntValue);
		testDAO.setWhenAsMS(testLongValue);
		assertEquals(testDAO.getWhenAsMS(),testLongValue);
		
		//insert new row
		assertTrue(testDAO.setRawData());
		assertTrue(testDAO.getRawDataId()> 0);
		this.lastInsertID = testDAO.getRawDataId();
		// get the row back 
		assertTrue(testDAO.getRawData());
		assertEquals(testDAO.getAnswerType(),testIntValue);
		assertEquals(testDAO.getComment(),testStringValue);
		assertEquals(testDAO.getDisplayNum(),testIntValue);
		assertEquals(testDAO.getGroupNum(),testIntValue);
		assertEquals(testDAO.getInstanceName(),testStringValue);
		assertEquals(testDAO.getInstrumentName(),testStringValue);
		assertEquals(testDAO.getInstrumentSessionId(),testIntValue);
		assertEquals(testDAO.getItemVacillation(),testIntValue);
		assertEquals(testDAO.getLangNum(),testIntValue);
		assertEquals(testDAO.getNullFlavor(),testIntValue);
		assertEquals(testDAO.getQuestionAsAsked(),testStringValue);
		assertEquals(testDAO.getRawDataId(),this.lastInsertID);
		assertEquals(testDAO.getResponseDuration(),testIntValue);
		assertEquals(testDAO.getTimeStamp(),ts);
		System.out.println(testDAO.getTimeStamp());
		System.out.println(ts);
		assertEquals(testDAO.getVarName(),testStringValue);
		assertEquals(testDAO.getVarNum(),testIntValue);
		assertEquals(testDAO.getWhenAsMS(),testLongValue);
		// update the row with new values
		int testIntValue = 456;
		String testStringValue = "def";
		Timestamp ts = new Timestamp(100002000);
		long testLongValue = 980000000;
		testDAO.setAnswer(testStringValue);
		assertEquals(testDAO.getAnswer(),testStringValue);
		testDAO.setAnswerType(testIntValue);
		assertEquals(testDAO.getAnswerType(),testIntValue);
		testDAO.setComment(testStringValue);
		assertEquals(testDAO.getComment(),testStringValue);
		testDAO.setDisplayNum(testIntValue);
		assertEquals(testDAO.getDisplayNum(),testIntValue);
		testDAO.setGroupNum(testIntValue);
		assertEquals(testDAO.getGroupNum(),testIntValue);
		testDAO.setInstanceName(testStringValue);
		assertEquals(testDAO.getInstanceName(),testStringValue);
		testDAO.setInstrumentName(testStringValue);
		assertEquals(testDAO.getInstrumentName(),testStringValue);
		testDAO.setInstrumentSessionId(testIntValue);
		assertEquals(testDAO.getInstrumentSessionId(),testIntValue);
		testDAO.setItemVacillation(testIntValue);
		assertEquals(testDAO.getItemVacillation(),testIntValue);
		testDAO.setLangNum(testIntValue);
		assertEquals(testDAO.getLangNum(),testIntValue);
		testDAO.setNullFlavor(testIntValue);
		assertEquals(testDAO.getNullFlavor(),testIntValue);
		testDAO.setQuestionAsAsked(testStringValue);
		assertEquals(testDAO.getQuestionAsAsked(),testStringValue);
		testDAO.setRawDataId(this.lastInsertID);
		assertEquals(testDAO.getRawDataId(),this.lastInsertID);
		testDAO.setResponseDuration(testIntValue);
		assertEquals(testDAO.getResponseDuration(),testIntValue);
		testDAO.setResponseLatency(testIntValue);
		assertEquals(testDAO.getResponseLatency(),testIntValue);
		testDAO.setTimeStamp(ts); 
		assertEquals(testDAO.getTimeStamp(),ts);
		testDAO.setVarName(testStringValue);
		assertEquals(testDAO.getVarName(),testStringValue);
		testDAO.setVarNum(testIntValue);
		assertEquals(testDAO.getVarNum(),testIntValue);
		testDAO.setWhenAsMS(testLongValue);
		assertEquals(testDAO.getWhenAsMS(),testLongValue);
		assertTrue(testDAO.updateRawData());
		assertTrue(testDAO.getRawData());
		assertEquals(testDAO.getAnswer(),testStringValue);
		assertEquals(testDAO.getAnswerType(),testIntValue);
		assertEquals(testDAO.getComment(),testStringValue);
		assertEquals(testDAO.getDisplayNum(),testIntValue);
		assertEquals(testDAO.getGroupNum(),testIntValue);
		assertEquals(testDAO.getInstanceName(),testStringValue);
		assertEquals(testDAO.getInstrumentName(),testStringValue);
		assertEquals(testDAO.getInstrumentSessionId(),testIntValue);
		assertEquals(testDAO.getItemVacillation(),testIntValue);
		assertEquals(testDAO.getLangNum(),testIntValue);
		assertEquals(testDAO.getNullFlavor(),testIntValue);
		assertEquals(testDAO.getQuestionAsAsked(),testStringValue);
		assertEquals(testDAO.getRawDataId(),this.lastInsertID);
		assertEquals(testDAO.getResponseDuration(),testIntValue);
		assertEquals(testDAO.getResponseLatency(),testIntValue);
		assertTrue(testDAO.getTimeStamp().equals(ts));
		assertEquals(testDAO.getVarName(),testStringValue);
		assertEquals(testDAO.getVarNum(),testIntValue);
		//delete row
		assertTrue(testDAO.deleteRawData());
		assertFalse(testDAO.getRawData());

	}

	
}
