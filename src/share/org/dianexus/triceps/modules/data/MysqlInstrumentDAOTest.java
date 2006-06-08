package org.dianexus.triceps.modules.data;

import junit.framework.TestCase;

public class MysqlInstrumentDAOTest extends TestCase {

	protected void setUp() throws Exception {
		super.setUp();
	}

	protected void tearDown() throws Exception {
		super.tearDown();
	}
	public void testInsert(){
		
		DialogixDAOFactory dff = DialogixDAOFactory.getDAOFactory(1);
		InstrumentDAO idao = dff.getInstrumentDAO();
		idao.setInstrumentDescription("dessc");
		idao.setInstrumentName("name");
		assertTrue(idao.setInstrument());
		
		
	}
}
