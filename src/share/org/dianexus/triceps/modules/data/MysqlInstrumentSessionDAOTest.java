package org.dianexus.triceps.modules.data;

import java.sql.Timestamp;

import junit.framework.TestCase;

public class MysqlInstrumentSessionDAOTest extends TestCase {
	int testIntValue = 123;
	String testStringValue = "abc";
	Timestamp ts = new Timestamp(100000000);
	long testLongValue = 98;
	InstrumentSessionDAO testDAO;
	DialogixDAOFactory mdao;
	int lastInsertId=0;

	public static void main(String[] args) {
	}

	protected void setUp() throws Exception {
		mdao =  DialogixDAOFactory.getDAOFactory(1);
		testDAO = mdao.getInstrumentSessionDAO();
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
	 * Test method for 'org.dianexus.triceps.modules.data.MysqlInstrumentSessionDAO.setInstrumentSession()'
	 */
	public void testInstrumentSession() {
		//test getters and setters
		testDAO.setInstrumentSessionId(testIntValue);
		assertEquals(testDAO.getInstrumentSessionId(),testIntValue);
		testDAO.setStartTime(ts);
		assertEquals(testDAO.getStartTime(),ts);
		testDAO.setEndTime(ts);
		assertEquals(testDAO.getEndTime(),ts);
		testDAO.setInstrumentVersionId(testIntValue);
		assertEquals(testDAO.getInstrumentVersionId(),testIntValue);
		testDAO.setUserId(testIntValue);
		assertEquals(testDAO.getUserId(),testIntValue);
		testDAO.setFirstGroup(testIntValue);
		assertEquals(testDAO.getFirstGroup(),testIntValue);
		testDAO.setLastGroup(testIntValue);
		assertEquals(testDAO.getLastGroup(),testIntValue);
		testDAO.setLastAction(testStringValue);
		assertEquals(testDAO.getLastAction(),testStringValue);
		testDAO.setLastAccess(testStringValue);
		assertEquals(testDAO.getLastAccess(),testStringValue);
		testDAO.setStatusMessage(testStringValue);
		assertEquals(testDAO.getStatusMessage(),testStringValue);
		// store a row
		assertTrue(testDAO.setInstrumentSession());
		assertTrue(testDAO.getInstrumentSessionId()> 0);
		this.lastInsertId = testDAO.getInstrumentSessionId();
		// get the row back
		assertTrue(testDAO.getInstrumentSession(this.lastInsertId));
		// test the results
		assertEquals(testDAO.getStartTime(),ts);
		assertEquals(testDAO.getEndTime(),ts);
		assertEquals(testDAO.getInstrumentVersionId(),testIntValue);
		assertEquals(testDAO.getUserId(),testIntValue);
		assertEquals(testDAO.getFirstGroup(),testIntValue);
		assertEquals(testDAO.getLastGroup(),testIntValue);
		assertEquals(testDAO.getLastAction(),testStringValue);
		assertEquals(testDAO.getLastAccess(),testStringValue);
		assertEquals(testDAO.getStatusMessage(),testStringValue);
		//update the data
		//new default values
		int testIntValue = 456;
		String testStringValue = "def";
		Timestamp ts = new Timestamp(100002000);
		long testLongValue = 98000;
		// set the new values
		
		testDAO.setStartTime(ts);
		testDAO.setEndTime(ts);
		testDAO.setInstrumentVersionId(testIntValue);
		testDAO.setUserId(testIntValue);
		testDAO.setFirstGroup(testIntValue);
		testDAO.setLastGroup(testIntValue);
		testDAO.setLastAction(testStringValue);
		testDAO.setLastAccess(testStringValue);
		testDAO.setStatusMessage(testStringValue);
		
		// perform the update
		assertTrue(testDAO.updateInstrumentSession());
		// get the row back
		assertTrue(testDAO.getInstrumentSession(this.lastInsertId));
		// test the new data
		assertEquals(testDAO.getStatusMessage(),testStringValue);
		assertEquals(testDAO.getStartTime(),ts);
		assertEquals(testDAO.getEndTime(),ts);
		assertEquals(testDAO.getInstrumentVersionId(),testIntValue);
		assertEquals(testDAO.getUserId(),testIntValue);
		assertEquals(testDAO.getFirstGroup(),testIntValue);
		assertEquals(testDAO.getLastGroup(),testIntValue);
		assertEquals(testDAO.getLastAction(),testStringValue);
		assertEquals(testDAO.getLastAccess(),testStringValue);
		// update a single column
		testDAO.setStatusMessage("updated value");
		assertTrue(testDAO.updateInstrumentSessionColumn("statusMsg"));
		// get the row back
		assertTrue(testDAO.getInstrumentSession(this.lastInsertId));
		assertEquals(testDAO.getStatusMessage(),"updated value");
		//delete the row
		assertTrue(testDAO.deleteInstrumentSession());
		assertFalse(testDAO.getInstrumentSession(this.lastInsertId));
		
		
	}

	
}
