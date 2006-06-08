package org.dianexus.triceps.modules.LOINC;

public class BuildListBean {
	
	private StringBuffer list = new StringBuffer("list|");
	
	
	public void addItem(String code, String text){
		list.append(code+"|"+text+"|");
	}
	public String getList(){
		return list.toString();
	}

}
