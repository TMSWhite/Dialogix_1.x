package org.dianexus.triceps.modules.hl7.v2;

import java.util.ArrayList;
import java.util.Iterator;

public class Message {
	private ArrayList elements;
	private int numElements=0;
	
	
	public void addElement(Object element){
		this.elements.add(numElements, element);
		this.numElements = elements.size();
		
	}
	
	public String toString(){
		StringBuffer sb = new StringBuffer();
		Iterator it = this.elements.iterator();
		while(it.hasNext()){
			sb.append(it.next().toString());
		}
		return sb.toString();
	}
}
