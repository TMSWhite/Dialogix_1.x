package org.dianexus.triceps.modules.data;

import junit.framework.TestCase;

public class HL7OBX3DBOTest extends TestCase {
	
	public static void main(String[] args) {
	}
	
	
	public void testInstrumentSession() {
		DialogixDAOFactory fact = DialogixDAOFactory.getDAOFactory(1);
		HL7OBX3DBO obx3 = fact.getHL7OBX3DBO();
		
		//test getters and setters
		obx3.setId(2);
		assertEquals(obx3.getId(), 2);
		obx3.setLoincNum("loincnum");
		assertEquals(obx3.getLoincNum(),"loincnum");
		obx3.setOBX3("string");
		assertEquals(obx3.getOBX3(),"string");
		obx3.setOBX3Umls("string");
		assertEquals(obx3.getOBX3Umls(),"string");
		obx3.setSubmittersCode("code");
		assertEquals(obx3.getSubmittersCode(),"code");
		
		assertTrue(obx3.setHL7OBX3());
		
	}

}
