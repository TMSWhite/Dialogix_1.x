package org.dianexus.triceps.modules.data;

import java.util.List;

public interface InstanceDataTable {
	
	public void setInstrumentName(String name);
	public void setVersion(String version);
	public void setMD5(String md5);
	public String getTableName();
	public void setInfoVector(List info);
	public void setDataVector (List data);
	public void setTimingVector(List timing);
	public boolean create();
	public String getSQL();
	

}
