package org.dianexus.triceps.modules.map;
import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;
import jxl.write.WritableWorkbook;

public class MappingBean {

	private Map map;
	private String mapName;
	private WritableWorkbook wb;
	private Sheet ws;
	private String sheetName;
	
	
	public MappingBean(){
		
	}
	public MappingBean(WritableWorkbook wb, String sheetName){
		this.loadWorkBook(wb, sheetName);
	}
	public MappingBean(Sheet sh){
		this.loadWorkSheet(ws);
	}
	public void setMapName(String mapName){
		this.mapName = mapName;
	}
	public boolean loadMap(){
		this.map = new Map();
		return this.map.loadMap();
	}
	public boolean loadWorkBook(WritableWorkbook wb, String sheetName){
		this.wb = wb;
		return false;
	}
	public boolean loadWorkSheet(Sheet ws){
		this.ws = ws;
		return false;
	}
	public boolean importFile(){
		
		
		return false;
	}
	
}
