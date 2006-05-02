package org.dianexus.triceps.tests;

import java.sql.Date;
import java.sql.Timestamp;

import org.dianexus.triceps.EventTimingBean;
import org.dianexus.triceps.modules.data.DialogixDAOFactory;
import org.dianexus.triceps.modules.data.PageHitEventsDAO;

import junit.framework.TestCase;

public class EventTimingBeanTest extends TestCase {
	DialogixDAOFactory mdao;
	PageHitEventsDAO testDAO;
	int lastInsertId=0;
	
	protected void setUp() throws Exception {
		mdao =  DialogixDAOFactory.getDAOFactory(1);
		testDAO = mdao.getPageHitEventsDAO();
	}

	protected void tearDown() throws Exception {
		if(mdao != null){
			mdao=null;
		}
		if(testDAO != null){
			testDAO = null;
		}
	}
	public static void main(String[] args) {
	}
	public void testBean(){
		// test variables
		String varName = "varName";
		String actionType = "actionType";
		String eventType="eventType";
		long timestamp = 5123000;
		long duration = 5;
		String value1="value1";
		String value2="value2"; 
		int displayCount = 5;
		// build a test source string
		StringBuffer testSource = new StringBuffer();
		//testSource.append(new Integer(displayCount).toString());
		//testSource.append(",");
		testSource.append(varName);
		testSource.append(",");
		testSource.append(actionType);
		testSource.append(",");
		testSource.append(eventType);
		testSource.append(",");
		testSource.append(new Long(timestamp).toString());
		testSource.append(",");
		testSource.append(new Long(duration).toString());
		testSource.append(",");
		testSource.append(value1);
		testSource.append(",");
		testSource.append(value2);
//		 create new instance
		EventTimingBean etb = new EventTimingBean().tokenizeEventString(testSource.toString(),displayCount);
		// check to values back out and compare
		assertEquals(etb.getVarName(),varName);
		assertEquals(etb.getActionType(),actionType);
		assertEquals(etb.getEventType(),eventType);
		Timestamp tms = new Timestamp(timestamp);
		assertEquals(etb.getTimestamp(),tms);
		assertEquals(etb.getDuration(),duration);
		assertEquals(etb.getValue1(),value1);
		assertEquals(etb.getValue2(),value2);
		// do a database store
		assertTrue(etb.store());
		// clear variables
		etb.clear();
		assertTrue(etb.read());
		// check to values back out and compare
		assertEquals(etb.getVarName(),varName);
		assertEquals(etb.getActionType(),actionType);
		assertEquals(etb.getEventType(),eventType);
		assertEquals(etb.getTimestamp(),tms);
		assertEquals(etb.getDuration(),duration);
		assertEquals(etb.getValue1(),value1);
		assertEquals(etb.getValue2(),value2);
		//delete the row
		// TODO fix this in class not deleting
		assertTrue(etb.delete());
		assertTrue(etb.read());
		
	}
}
