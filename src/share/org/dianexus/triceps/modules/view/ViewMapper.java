package org.dianexus.triceps.modules.view;

import java.util.ArrayList;
import java.util.HashMap;

public class ViewMapper {
	
	// list of user_agent to view_type mappings
	private HashMap maps;
	
	public int getMapping(String user_agent){
	
		Integer view_type =  (Integer)this.maps.get(user_agent);
		return view_type.intValue();
	}
	
	public void setMapping(String user_agent, int mapType){
		maps.put(user_agent, new Integer(mapType));
	}
	public void setMap(HashMap map){
		this.maps = map;
		
	}
}
