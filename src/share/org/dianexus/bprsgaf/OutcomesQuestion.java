package org.dianexus.bprsgaf;

import java.util.*;

public class OutcomesQuestion 
{
	private String index;
	private String name;
	private String prefix;
	private Hashtable ht;
	private String selection = null;
	
	public OutcomesQuestion(String index, String name, String prefix) {
		this.index = index;
		this.name = name;
		this.prefix = prefix;
		
		ht = new Hashtable();
	}
	
	public void put(String score, String option) {
		ht.put(score,option);
	}
	
	public void setValue(String sel) {
	    selection = sel;
	}
	
	public String getName() {
	    return name;
	}
	
	public String getFormIndex() {
	    return index;
	}
	
	public String getAnchor() {
	    return (String) ht.get(selection);
	}
	
	public String getPrefix() {
	    return prefix;
	}
	
	public int getAnswer() {
	    int i = 0;
	    try {
	        i = Integer.parseInt(selection);
	    } catch (Exception e) { }
	    return i;
	}
}   
