package org.dianexus.triceps.tests;

import java.sql.Date;
import java.sql.Timestamp;

import org.dianexus.triceps.EventTimingBean;

import junit.framework.TestCase;

public class EventTimingBeanTest extends TestCase {

	protected void setUp() throws Exception {
		super.setUp();
	}

	protected void tearDown() throws Exception {
		super.tearDown();
	}
	public static void main(String[] args) {
	}
	public void testBean(){
		String varName = "varName";
		String actionType = "actionType";
		String eventType="eventType";
		long timestamp = 512312;
		long duration = 5;
		String value1="value1";
		String value2="value2"; 
		int displayCount = 5;
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
		
		EventTimingBean etb = new EventTimingBean();
		etb  = etb.tokenizeEventString(testSource.toString(),displayCount);
		assertEquals(etb.getVarName(),varName);
		assertEquals(etb.getActionType(),actionType);
		assertEquals(etb.getEventType(),eventType);
		Timestamp tms = new Timestamp(timestamp);
		assertEquals(etb.getTimestamp(),tms);
		assertEquals(etb.getDuration(),duration);
		assertEquals(etb.getValue1(),value1);
		assertEquals(etb.getValue2(),value2);
		
	}
}
