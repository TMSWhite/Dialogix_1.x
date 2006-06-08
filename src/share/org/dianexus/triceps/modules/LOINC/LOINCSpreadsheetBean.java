package org.dianexus.triceps.modules.LOINC;

import java.io.File;
import java.util.ArrayList;
import java.util.Iterator;

import jxl.*;
import jxl.write.*;


public class LOINCSpreadsheetBean {
	
	
	private WritableWorkbook wb;
	private WritableSheet ws;
	
	public void init(){
		try{
			wb = Workbook.createWorkbook(new File ("LOINC.xls"));
			ws = wb.createSheet("LOINC",0);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public void addRow(ArrayList row, int rowId){
		Iterator it = row.iterator();
		int j=0;
		while(it.hasNext()){
			Label label = new Label(j,rowId, (String)it.next());
			try{
				ws.addCell(label);
				j++;
			}catch(Exception we){
				we.printStackTrace();
			}
			
			
		}
		
	}
	public boolean writeSheet(){
		try{
			wb.write();
			wb.close();
			return true;
		}catch(Exception wr){
			wr.printStackTrace();
			return false;
		}
		
	}
}
