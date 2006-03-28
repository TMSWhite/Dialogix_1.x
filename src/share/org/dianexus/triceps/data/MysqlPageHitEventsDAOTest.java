package org.dianexus.triceps.modules.data;

import java.sql.Timestamp;

import junit.framework.TestCase;

public class MysqlPageHitEventsDAOTest extends TestCase {
	int testIntValue = 123;

	String testStringValue = "abc";

	Timestamp ts = new Timestamp(100000000);

	long testLongValue = 98;

	PageHitEventsDAO testDAO;

	DialogixDAOFactory mdao;

	int lastInsertId;

	public static void main(String[] args) {
	}

	protected void setUp() throws Exception {
		mdao = DialogixDAOFactory.getDAOFactory(1);
		testDAO = mdao.getPageHitEventsDAO();
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
	 * 'org.dianexus.triceps.modules.data.MysqlPageHitEventsDAO.setPageHitEvent()'
	 */
	public void testPageHitEvent() {
		// test getters and setters
		testDAO.setPageHitEventId(testIntValue);
		assertEquals(testDAO.getPageHitEventId(), testIntValue);
		testDAO.setPageHitId(testIntValue);
		assertEquals(testDAO.getPageHitId(), testIntValue);
		testDAO.setVarName(testStringValue);
		assertEquals(testDAO.getVarName(), testStringValue);
		testDAO.setActionType(testStringValue);
		assertEquals(testDAO.getActionType(), testStringValue);
		testDAO.setEventType(testStringValue);
		assertEquals(testDAO.getEventType(), testStringValue);
		testDAO.setTimeStamp(ts);
		assertEquals(testDAO.getTimeStamp(), ts);
		testDAO.setDuration(testIntValue);
		assertEquals(testDAO.getDuration(), testIntValue);
		testDAO.setValue1(testStringValue);
		assertEquals(testDAO.getValue1(), testStringValue);
		testDAO.setValue2(testStringValue);
		assertEquals(testDAO.getValue2(), testStringValue);
		// test insert new row
		assertTrue(testDAO.setPageHitEvent());
		lastInsertId = testDAO.getPageHitEventId();
		assertTrue(lastInsertId > 0);

		// test get row back
		assertTrue(testDAO.getPageHitEvents(lastInsertId));

		assertEquals(testDAO.getPageHitId(), testIntValue);

		assertEquals(testDAO.getPageHitId(), testIntValue);

		assertEquals(testDAO.getVarName(), testStringValue);

		assertEquals(testDAO.getActionType(), testStringValue);

		assertEquals(testDAO.getEventType(), testStringValue);

		assertEquals(testDAO.getTimeStamp(),ts);

		assertEquals(testDAO.getDuration(), testIntValue);

		assertEquals(testDAO.getValue1(), testStringValue);

		assertEquals(testDAO.getValue2(), testStringValue);
		// test update row
		int testIntValue = 456;
		String testStringValue = "cde";
		Timestamp ts = new Timestamp(100000000);
		long testLongValue = 12345;
		testDAO.setPageHitId(testIntValue);
		testDAO.setVarName(testStringValue);
		testDAO.setActionType(testStringValue);
		testDAO.setEventType(testStringValue);
		testDAO.setTimeStamp(ts);
		testDAO.setDuration(testIntValue);
		testDAO.setValue1(testStringValue);
		testDAO.setValue2(testStringValue);
		assertTrue(testDAO.updatePageHitEvent());
		assertEquals(testDAO.getPageHitId(), testIntValue);
		assertEquals(testDAO.getVarName(), testStringValue);
		assertEquals(testDAO.getActionType(), testStringValue);
		assertEquals(testDAO.getEventType(), testStringValue);
		assertEquals(testDAO.getEventType(), testStringValue);
		assertEquals(testDAO.getEventType(), testStringValue);
		assertEquals(testDAO.getTimeStamp(), ts);
		assertEquals(testDAO.getDuration(), testIntValue);
		assertEquals(testDAO.getValue1(), testStringValue);
		assertEquals(testDAO.getValue2(), testStringValue);
		// test update column
		testDAO.setActionType("newAction");
		assertTrue(testDAO.updatePageHitEventColumn("actionType"));
		assertEquals(testDAO.getActionType(),"newAction");
		// test delete row
		assertTrue(testDAO.deletePageHitEvent());
		assertFalse(testDAO.getPageHitEvents(lastInsertId));
		

	}

	

}
