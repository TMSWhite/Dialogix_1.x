package org.dianexus.triceps.modules.data;

import java.util.ArrayList;

public interface MappingItemDAO {
	
	
	public boolean readMappingItem(int id);
	public boolean writeMappingItem();
	public boolean updateMappingItem(int id);
	public boolean deleteMappingItem(int id);
	public ArrayList  getItemsIndex(int id);
	public ArrayList getTableItemsIndex(int id, String table_name);
	
	
	
	public void setId(int id);
	public int getId();
	public void setMappingId(int mappingId);
	public int getMappingId();
	public void setSourceColumn(int sourceCol);
	public int getSourceColumn();
	public void setSourceColumnName(String sourColName);
	public String getSourceColumnName();
	public void setDestinationColumn(int destinationCol);
	public int getDestinationColumn();
	public void setDestinationColumnName(String destinationColName);
	public String getDestinationColumnName();
	public void setDescription(String description);
	public String getDescription();
	public void setTableName(String tableName);
	public String getTableName();
	public void setItemsIndex(int[] items);
	public int[] getItemsIndex();


}
