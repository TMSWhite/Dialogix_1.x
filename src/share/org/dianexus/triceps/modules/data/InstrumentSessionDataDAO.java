package org.dianexus.triceps.modules.data;

import java.sql.Timestamp;
import java.util.ArrayList;

public interface InstrumentSessionDataDAO {
	
	
	public boolean setInstrumentSessionDataDAO(String tablename);
	public boolean getInstrumentSessionDataDAO(String table, int id);
	public boolean updateInstrumentSessionDataDAO(String column, String value);
	public boolean deleteInstrumentSessionDataDAO(String table, int id);
	
	
	
	
	
	public void setSessionId(int id);
	public int getSessionId();
	public void setInstrumentSessionDataId(int id);
	public int getInstrumentSessionDataId();
	public void setInstrumentName(String name);
	public String getInstrmentName();
	public void setInstanceName(String name);
	public String getInstanceName();
	public void setSessionStartTime(Timestamp time);
	public Timestamp getSessionStartTime();
	public void setSessionEndTime(Timestamp time);
	public Timestamp getSessionEndTime();
	public void setFirstGroup (int group);
	public int getFirstGroup();
	public void setLastGroup (int group);
	public int getLastGroup();
	public void setLastAction(String action);
	public String getLastAction();
	public void setLastAccess(String access);
	public String getLastAccess();
	public void setStatusMsg(String msg);
	public String getStatusMsg();
	public void setTableName(String table);
	public String getTableName();
	public ArrayList getDataArray();
	public ArrayList getColumnArray(); 

}
