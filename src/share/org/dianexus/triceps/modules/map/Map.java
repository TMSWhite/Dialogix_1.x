package org.dianexus.triceps.modules.map;

import java.util.ArrayList;
import java.util.Iterator;

import org.dianexus.triceps.modules.data.DialogixDAOFactory;
import org.dianexus.triceps.modules.data.MappingDAO;
import org.dianexus.triceps.modules.data.MappingItemDAO;

public class Map {
	
	private MappingDAO mdao;
	private ArrayList mapItems = new ArrayList();
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
		System.out.println("got mdao");
		mdao.setMapName(this.getMapName());
		System.out.println("set map name to "+this.getMapName());
		if(mdao.loadMapping(this.getMapName())){
			// get index of map items
			System.out.println("in loop");
			MappingItemDAO mad = daof.getMappingItemDAO();
			System.out.println("got mad");
			mapItemIds = mad.getTableItemsIndex(mdao.getId(),this.getTableName());
			System.out.println("got ids");
			Iterator it = mapItemIds.listIterator();
			System.out.println("map size is:"+mapItemIds.size());
			int i =0;
			while(it.hasNext()){
				MappingItemDAO mad2 = daof.getMappingItemDAO();
				System.out.println("in while");
				Integer id = (Integer)it.next();
				System.out.println("in while: id is"+id.intValue());
				if(mad2.readMappingItem(id.intValue())){
					System.out.println("in while mad data is: source col "+mad2.getSourceColumn()+" dest col is "+mad2.getDestinationColumn());
					mapItems.add(i,mad2);
					i++;
				
				}
				
			}
			rtn = true;
		}
		
		return rtn;
	}

}
