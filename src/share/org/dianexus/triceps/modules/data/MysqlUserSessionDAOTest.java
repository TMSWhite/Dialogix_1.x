package org.dianexus.triceps.modules.data;

import java.sql.Timestamp;

import junit.framework.TestCase;

public class MysqlUserSessionDAOTest extends TestCase {
	
	int testIntValue = 123;
	String testStringValue = "abc";
	Timestamp ts = new Timestamp(100000000);
	UserSessionDAO testDAO;
	DialogixDAOFactory mdao;
	int lastInsertId;
	

	public static void main(String[] args) {
	}

	protected void setUp() throws Exception {
		mdao =  DialogixDAOFactory.getDAOFactory(1);
		testDAO = mdao.getUserSessionDAO();
		
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
	 * Test method for 'org.dianexus.triceps.modules.data.MysqlUserSessionDAO.setUserSession()'
	 */
	public void testUserSession() {
		//test getters and setters
		testDAO.setUserSessionId(testIntValue);
		assertEquals(testDAO.getUserSessionId(), testIntValue);
		testDAO.setInstrumentSessionId(testIntValue);
		assertEquals(testDAO.getInstrumentSessionId(),testIntValue);
		testDAO.setUserId(testIntValue);
		assertEquals(testDAO.getUserId(),testIntValue);
		testDAO.setTimestamp(ts);
		assertEquals(testDAO.getTimestamp(),ts);
		testDAO.setComments(testStringValue);
		assertEquals(testDAO.getComments(),testStringValue);
		// test insert new row
		assertTrue(testDAO.setUserSession());
		assertTrue(testDAO.getUserSessionId() > 0);
		this.lastInsertId = testDAO.getUserSessionId();
		//test get back the row
		assertTrue(testDAO.getUserSession(this.lastInsertId));
		assertEquals(testDAO.getUserSessionId(), this.lastInsertId);
		assertEquals(testDAO.getInstrumentSessionId(),testIntValue);
		assertEquals(testDAO.getUserId(),testIntValue);
		assertEquals(testDAO.getTimestamp(),ts);
		assertEquals(testDAO.getComments(),testStringValue);
		
		//test update row
		String testComment = "this is a new comment";
		int testSessionId = 88888;
		String testStatus = "testStatus";
		Timestamp ts = new Timestamp(100002000);
		int testUserId = 876876;
		testDAO.setComments(testComment);
		testDAO.setInstrumentSessionId(testSessionId);
		testDAO.setStatus(testStatus);
		testDAO.setTimestamp(ts);
		testDAO.setUserId(testUserId);
		assertTrue(testDAO.updateUserSession());
		assertEquals(testDAO.getComments(),testComment);
		assertEquals(testDAO.getStatus(),testStatus);
		assertEquals(testDAO.getInstrumentSessionId(),testSessionId);
		assertEquals(testDAO.getTimestamp(),ts);
		assertEquals(testDAO.getUserId(),testUserId);
		//test delete row
		assertTrue(testDAO.deleteUserSession());
		assertFalse(testDAO.getUserSession(this.lastInsertId)); 

	}

	

	

	

	

	
}
