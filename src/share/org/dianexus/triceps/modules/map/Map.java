package org.dianexus.triceps.modules.map;

import java.util.ArrayList;
import java.util.Iterator;

import org.dianexus.triceps.modules.data.DialogixDAOFactory;
import org.dianexus.triceps.modules.data.MappingDAO;
import org.dianexus.triceps.modules.data.MappingItemDAO;

public class Map {
	
	private MappingDAO mdao;
	private ArrayList mapItems;
	private ArrayList mapItemIds;
	private String mapName;
	private String tableName;
	private int mapId;
	
	
	public Map(){
		
	}
	
	public void setMapName(String name){
		this.mapName = name;
	}
	public String getMapName(){
		return this.mapName;
	}
	public ArrayList getMapItems(){
		return this.mapItems;
	}
	public void setTableName(String table_name){
		this.tableName = table_name;
	}
	public String getTableName(){
		return this.tableName;
	}
	public MappingDAO getMappingDAO(){
		return this.mdao;
	}
	public MappingItemDAO getMappingItemDAO(int index){
		return (MappingItemDAO) this.mapItemIds.get(index);
	}
	public boolean loadMap(){
		
		boolean rtn = false;
		
		DialogixDAOFactory daof = DialogixDAOFactory.getDAOFactory(1);
		mdao = daof.getMappingDAO();
		mdao.setMapName(this.getMapName());
		if(mdao.loadMapping(this.getMapName())){
			// get index of map items
			MappingItemDAO mad = daof.getMappingItemDAO();
			mapItemIds = mad.getTableItemsIndex(mdao.getId(),this.getTableName());
			Iterator it = mapItemIds.listIterator();
			while(it.hasNext()){
				Integer id = (Integer)it.next();
				mad.readMappingItem(id.intValue());
				mapItems.add(mad);
			}
			rtn = true;
		}
		
		return rtn;
	}

}
