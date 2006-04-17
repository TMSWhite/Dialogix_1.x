/* ********************************************************
 ** Copyright (c) 2000-2006, Thomas Maxwell White, all rights reserved.
 ** InstrumentSessionDAO.java ,v 3.0.0 Created on March 20, 2006, 1:14 PM
 ** @author Gary Lyons
 ******************************************************** 
 */
package org.dianexus.triceps.modules.data;

import java.sql.Timestamp;

/**
 * @author ISTCGXL
 *
 */
public interface InstrumentSessionDAO {
	
	public boolean setInstrumentSession();
	/**
	 * @param pageHitId
	 * @return
	 */
	public boolean getInstrumentSession(int pageHitId);
	/**
	 * @param column
	 * @param value
	 * @return
	 */
	public boolean updateInstrumentSessionColumn(String column);
	/**
	 * @return
	 */
	public boolean updateInstrumentSession();
	/**
	 * @return
	 */
	public boolean deleteInstrumentSession ();
	
	public void setInstrumentSessionId(int instrumentSessionId);
	
	public int getInstrumentSessionId();
	
	public void setStartTime (Timestamp startTime);
	
	public Timestamp getStartTime();
	
	public void setEndTime(Timestamp endTime);
	
	public Timestamp getEndTime();
	
	public void setInstrumentVersionId(int instrumentVersionId);
	
	public int getInstrumentVersionId();
	
	public void setUserId(int userId);
	
	public int getUserId();
	
	public void setFirstGroup(int firstGroup);
	
	public int getFirstGroup();
	
	public void setLastGroup(int lastGroup);
	
	public int getLastGroup();
	
	public void setLastAction(String lastAction);
	
	public String getLastAction();
	
	public void setLastAccess(String lastAccess);
	
	public String getLastAccess();
	
	public void setStatusMessage(String statusMessage);
	
	public String getStatusMessage();
	
	

}
