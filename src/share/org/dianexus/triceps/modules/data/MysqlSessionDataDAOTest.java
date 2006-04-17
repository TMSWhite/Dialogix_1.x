package org.dianexus.triceps.modules.data;

import java.sql.Timestamp;

import junit.framework.TestCase;

public class MysqlSessionDataDAOTest extends TestCase {

	int testIntValue = 123;

	String testStringValue = "abc";

	Timestamp ts = new Timestamp(100000000);

	SessionDataDAO testDAO;

	DialogixDAOFactory mdao;

	String testTableName = "parkinsonsratingscale_v__n16_710bd9e9812c0cf0474607370f1af88a";

	int lastInsertId;

	public static void main(String[] args) {
	}

	protected void setUp() throws Exception {
		mdao = DialogixDAOFactory.getDAOFactory(1);
		testDAO = mdao.getSessionDataDAO();
	}

	protected void tearDown() throws Exception {
		if (mdao != null) {
			mdao = null;
		}
		if (testDAO != null) {
			testDAO = null;
		}
	}

	/*
	 * Test method for
	 * 'org.dianexus.triceps.modules.data.MysqlSessionDataDAO.newSession(String)'
	 */
	public void testSessionData() {
		// test getters and setters
		testDAO.setInstrumentName(testStringValue);
		assertEquals(testDAO.getInstrumentName(), testStringValue);
		testDAO.setInstanceName(testStringValue);
		assertEquals(testDAO.getInstanceName(), testStringValue);
		testDAO.setStartTime(ts);
		assertEquals(testDAO.getStartTime(), ts);
		testDAO.setEndTime(ts);
		assertEquals(testDAO.getEndTime(), ts);
		testDAO.setFirstGroup(testIntValue);
		assertEquals(testDAO.getFirstGroup(), testIntValue);
		testDAO.setLastGroup(testIntValue);
		assertEquals(testDAO.getLastGroup(), testIntValue);
		testDAO.setLastAction(testIntValue);
		assertEquals(testDAO.getLastAction(), testIntValue);
		testDAO.setLastAccess(testIntValue);
		assertEquals(testDAO.getLastAccess(), testIntValue);
		testDAO.setStatusMsg(testStringValue);
		assertEquals(testDAO.getStatusMsg(), testStringValue);

		// insert a new row

		assertTrue(testDAO.setSessionData(testTableName));
		assertTrue(testDAO.getRowId() > 0);
		this.lastInsertId = testDAO.getRowId();

		// add column data

		String[] colnames = testDAO.getDataColumnNames();

		int numCols = colnames.length;
		for (int i = 5; i <= numCols - 7; i++) {

			assertTrue(testDAO.updateSessionData(colnames[i], testStringValue) > 0);

		}
		// get it back and test
		assertTrue(testDAO.getSessionData(this.lastInsertId));
		String[] columnDataFromUpdate = testDAO.getColumnData();
		for (int i = 6; i <= numCols - 8; i++) {
			
			assertEquals(columnDataFromUpdate[i], testStringValue);

		}
		//delete the row
		assertTrue(testDAO.deleteSessionData());
		assertFalse(testDAO.getSessionData(this.lastInsertId));
	}
	

}
