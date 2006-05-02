package org.dianexus.triceps.tests;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import org.dianexus.triceps.PageHitBean;

//import org.dianexus.triceps.Logger;

import junit.framework.TestCase;

public class PageHitBeanTest extends TestCase {
	StringBuffer sb ;

	protected void setUp() throws Exception {
		super.setUp();
		// build simulated data string
		sb = new StringBuffer();
		sb.append("null,null,sent_request,1098226016424,77,null\t");
		sb.append("null,null,load,1098224823789,130,null\t");
		sb.append("Uncooperativeness,select-one,focus,1098224823799,140,--Select one of the following--\t");
		sb.append("Uncooperativeness,select-one,change,1098224824640,981,4 4)??MODERATE: fails to elaborate spontaneously\t");
		sb.append("Uncooperativeness,select-one,click,1098224824640,981,4 4)??MODERATE: fails to elaborate spontaneously\t");
		sb.append("next,submit,focus,1098224825602,1943,\t");
		sb.append("next,submit,click,1098224825682,2023,\t");	
		sb.append("null,null,received_response,1098226018536,2112,\t");
		sb.append("null,null,sent_request,1098226016424,77,null\t");
		sb.append("null,null,load,1098224823789,130,null\t");
		sb.append("Uncooperativeness,select-one,focus,1098224823799,140,--Select one of the following--\t");
		sb.append("Uncooperativeness,select-one,change,1098224824640,981,4 4)??MODERATE: fails to elaborate spontaneously\t");
		sb.append("Uncooperativeness,select-one,click,1098224824640,981,4 4)??MODERATE: fails to elaborate spontaneously\t");
		sb.append("next,submit,focus,1098224825602,1943,\t");
		sb.append("next,submit,click,1098224825682,2023,\t");	
		sb.append("null,null,received_response,1098226018536,2112,\t");

		
		
	}

	protected void tearDown() throws Exception {
		super.tearDown();
	}
	
	public void testBean(){
		assertEquals(1,1);
		PageHitBean phb = new PageHitBean();
		phb.parseSource(sb.toString());
		phb.processEvents();
		
		
	}
	
	
}
