package org.dianexus.triceps.modules.data;

import java.sql.Timestamp;

import junit.framework.TestCase;

public class MysqlPageHitsDAOTest extends TestCase {
	int testIntValue = 123;
	String testStringValue = "abc";
	Timestamp ts = new Timestamp(100000000);
	long testLongValue = 98;
	PageHitsDAO testDAO;
	DialogixDAOFactory mdao;
	int lastInsertId=0;

	public static void main(String[] args) {
	}

	protected void setUp() throws Exception {
		mdao =  DialogixDAOFactory.getDAOFactory(1);
		testDAO = mdao.getPageHitsDAO();
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
	 * Test method for 'org.dianexus.triceps.modules.data.MysqlPageHitsDAO.setPageHit()'
	 */
	public void testPageHit() {
		//test getters and setters
		testDAO.setPageHitId(testIntValue);
		assertEquals(testDAO.getPageHitId(),testIntValue);
		testDAO.setInstrumentSessionId(testIntValue);
		assertEquals(testDAO.getInstrumentSessionId(),testIntValue);
		testDAO.setAccessCount(testIntValue);
		assertEquals(testDAO.getAccessCount(),testIntValue);
		testDAO.setGroupNum(testIntValue);
		assertEquals(testDAO.getGroupNum(),testIntValue);
		testDAO.setDisplayNum(testIntValue);
		assertEquals(testDAO.getDisplayNum(),testIntValue);
		testDAO.setLastAction(testStringValue);
		assertEquals(testDAO.getLastAction(),testStringValue);
		testDAO.setStatusMessage(testStringValue);
		assertEquals(testDAO.getStatusMessage(),testStringValue);
		testDAO.setTotalDuration(testIntValue);
		assertEquals(testDAO.getTotalDutation(),testIntValue);
		testDAO.setServerDuration(testIntValue);
		assertEquals(testDAO.getServerDuration(),testIntValue);
		testDAO.setLoadDuration(testIntValue);
		assertEquals(testDAO.getLoadDuration(),testIntValue);
		testDAO.setNetworkDuration(testIntValue);
		assertEquals(testDAO.getNetworkDuration(),testIntValue);
		testDAO.setPageVacillation(testIntValue);
		assertEquals(testDAO.getPageVacillation(),testIntValue);
		testDAO.setTimeStamp(ts);
		assertEquals(testDAO.getTimeStamp(),ts);
		
		// test insert new row

		assertTrue(testDAO.setPageHit());
		this.lastInsertId = testDAO.getPageHitId();
		assertTrue(this.lastInsertId > 0);
		// get the row back
		assertTrue(testDAO.getPageHit(this.lastInsertId));
		//update rows
		int testIntValue = 345;
		String testStringValue = "def";
		Timestamp ts = new Timestamp(100003000);
		long testLongValue = 9800000;
		testDAO.setPageHitId(this.lastInsertId);
		assertEquals(testDAO.getPageHitId(),this.lastInsertId);
		testDAO.setInstrumentSessionId(testIntValue);
		assertEquals(testDAO.getInstrumentSessionId(),testIntValue);
		testDAO.setAccessCount(testIntValue);
		assertEquals(testDAO.getAccessCount(),testIntValue);
		testDAO.setGroupNum(testIntValue);
		assertEquals(testDAO.getGroupNum(),testIntValue);
		testDAO.setDisplayNum(testIntValue);
		assertEquals(testDAO.getDisplayNum(),testIntValue);
		testDAO.setLastAction(testStringValue);
		assertEquals(testDAO.getLastAction(),testStringValue);
		testDAO.setStatusMessage(testStringValue);
		assertEquals(testDAO.getStatusMessage(),testStringValue);
		testDAO.setTotalDuration(testIntValue);
		assertEquals(testDAO.getTotalDutation(),testIntValue);
		testDAO.setServerDuration(testIntValue);
		assertEquals(testDAO.getServerDuration(),testIntValue);
		testDAO.setLoadDuration(testIntValue);
		assertEquals(testDAO.getLoadDuration(),testIntValue);
		testDAO.setNetworkDuration(testIntValue);
		assertEquals(testDAO.getNetworkDuration(),testIntValue);
		testDAO.setPageVacillation(testIntValue);
		assertEquals(testDAO.getPageVacillation(),testIntValue);
		testDAO.setTimeStamp(ts);
		assertEquals(testDAO.getTimeStamp(),ts);
		assertTrue(testDAO.updatePageHit());
		assertTrue(testDAO.getPageHit(this.lastInsertId));
		assertEquals(testDAO.getPageHitId(),this.lastInsertId);
		assertEquals(testDAO.getInstrumentSessionId(),testIntValue);
		assertEquals(testDAO.getAccessCount(),testIntValue);
		assertEquals(testDAO.getGroupNum(),testIntValue);
		assertEquals(testDAO.getDisplayNum(),testIntValue);
		assertEquals(testDAO.getLastAction(),testStringValue);
		assertEquals(testDAO.getStatusMessage(),testStringValue);
		assertEquals(testDAO.getTotalDutation(),testIntValue);
		assertEquals(testDAO.getServerDuration(),testIntValue);
		assertEquals(testDAO.getLoadDuration(),testIntValue);
		assertEquals(testDAO.getNetworkDuration(),testIntValue);
		assertEquals(testDAO.getPageVacillation(),testIntValue);
		assertEquals(testDAO.getTimeStamp(),ts);
		
		//update a column
		testDAO.setStatusMessage("new test string?");
		assertTrue(testDAO.updatePageHitColumn("statusMsg"));
		assertTrue(testDAO.getPageHit(this.lastInsertId));
		assertEquals(testDAO.getStatusMessage(),"new test string?");
		//delete a  row
		assertTrue(testDAO.deletePageHit());
		assertFalse(testDAO.getPageHit(this.lastInsertId));
		

	}


}
