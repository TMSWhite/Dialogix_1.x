package org.dianexus.triceps.modules.hl7.v2;

import java.util.ArrayList;
import java.util.Iterator;

public class Message {
	private ArrayList elements = new ArrayList();
	private int numElements=0;
	private String status="";
	private char VT = 11;
	private char FS = 28;
	private char CR = 13;
	
	
	public void addElement(Object element){
		this.elements.add(numElements, element);
		this.numElements = elements.size();
		
	}
	
	public String toString(){
		StringBuffer sb = new StringBuffer();
		Iterator it = this.elements.iterator();
		sb.append(VT);
		while(it.hasNext()){
			sb.append(it.next().toString());
		}
		sb.append(FS);
		sb.append(CR);
		return sb.toString();
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
}
