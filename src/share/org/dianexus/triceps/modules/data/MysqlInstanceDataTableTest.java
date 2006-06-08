package org.dianexus.triceps.modules.data;

import java.util.ArrayList;

import junit.framework.TestCase;

public class MysqlInstanceDataTableTest extends TestCase {

	protected void setUp() throws Exception {
		super.setUp();
	}

	protected void tearDown() throws Exception {
		super.tearDown();
	}
	public void testMysqlInstanceDataTable(){
		// set up a vector with column names
		ArrayList cols = new ArrayList();
		cols.add("column1");
		cols.add("column2");
		cols.add("column3");
		cols.add("column4");
		cols.add("column5");
		cols.add("column6");
		// set up the rest of the data
		String instrumentName="testInstrument";
		String version = "5a";
		String md5 = "710bd9e9812c0cf0474607370f1af88a";
		String nodes ="6";
		String tableName = "testInstrument_v_5a_n_6_710bd9e9812c0cf0474607370f1af88a";
		MysqlInstanceDataTable dt = new MysqlInstanceDataTable();
		dt.setDataVector(cols);
		dt.setInstrumentName(instrumentName);
		dt.setVersion(version);
		dt.setMD5(md5);
		assertTrue(dt.create());
		assertEquals(dt.getTableName(),tableName);
		System.out.println(dt.getSQL());
	}
}
