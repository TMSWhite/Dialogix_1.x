package org.dianexus.triceps.modules.map.tests;

import org.dianexus.triceps.modules.map.Map;

import junit.framework.TestCase;

public class MapTest extends TestCase {
	public static void main(String[] args) {
	}
	public void testMap(){
		
		Map map = new Map();
		map.setMapName("loinc2");
		assertEquals(map.getMapName(), "loinc2");
		map.setTableName("instrument_items");
		assertEquals(map.getTableName(),"instrument_items");
		assertTrue(map.loadMap());
	}
	
}
