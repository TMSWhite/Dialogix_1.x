package org.dianexus.triceps.modules.data;

public interface MappingDAO {
	
	public boolean loadMapping(int id);
	public boolean loadMapping(String name);
	public boolean storeMapping();
	public boolean updateMapping(int id);
	public boolean deleteMapping(int id);
	
	public void setId(int id);
	public int getId();
	public void setMapName(String mapName);
	public String getMapName();
	public void setMapDescription(String mapDescription);
	public String getMapDescription();
	public void setMap(String map);
	public String getMap();

}
