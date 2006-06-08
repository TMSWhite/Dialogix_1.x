package org.dianexus.triceps.modules.data.oracle;

import junit.framework.TestCase;

public class TestConnTest extends TestCase {
	
	public void testContest() {
		
		TestConn ct = new TestConn();
		ct.makeConn();
		ct.insert("insert into instrument values(2,1,'test')");
		
	}

}
