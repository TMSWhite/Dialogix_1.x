package org.dianexus.triceps.modules.data;

import java.sql.Timestamp;

public interface ReportQueryDAO {
	
	
	public boolean setReportQueryDAO();
	public boolean getReportQueryDAO( int id);
	public boolean updateReportQueryDAO();
	public boolean deleteReportQueryDAO(int id);
	
	public void setId(int id);
	public int getId();
	public void setUserId(int user_id);
	public int getUserId();
	public void setInstrumentVersionId(int instrument_version_id);
	public int getInstrumentVersionId();
	public void setTs(Timestamp ts);
	public Timestamp getTs();
	public void setQueryString(String qs);
	public String getQueryString();

}
