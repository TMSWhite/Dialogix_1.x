/* ********************************************************
 ** Copyright (c) 2000-2006, Thomas Maxwell White, all rights reserved.
 ** PageHitsDAO.java ,v 3.0.0 Created on March 20, 2006, 1:14 PM
 ** @author Gary Lyons
 ******************************************************** 
 */
package org.dianexus.triceps.modules.data;

import java.sql.Timestamp;


public interface PageHitsDAO {
	
	public boolean setPageHit();
	/**
	 * @param pageHitId
	 * @return
	 */
	public boolean getPageHit(int pageHitId);
	/**
	 * @param column
	 * @param value
	 * @return
	 */
	public boolean updatePageHitColumn(String column);
	/**
	 * @return
	 */
	public boolean updatePageHit();
	/**
	 * @return
	 */
	public boolean deletePageHit();
	
	public void setPageHitId(int pageHitId);
	
	public int getPageHitId();
	
	public void setInstrumentSessionId(int instrumentSessionId);
	
	public int getInstrumentSessionId();
	
	public void setAccessCount(int accessCount);
	
	public int getAccessCount();
	
	public void setGroupNum(int groupNum);
	
	public int getGroupNum();
	
	public void setDisplayNum(int displayNum);
	
	public int getDisplayNum();
	
	public void setLastAction(String lastAction);
	
	public String getLastAction();
	
	public void setStatusMessage(String statusMessage);
	
	public String getStatusMessage();
	
	public void setTotalDuration(int totalDuration);
	
	public int getTotalDutation();
	
	public void setServerDuration(int serverDuration);
	
	public int getServerDuration();
	
	public void setLoadDuration(int loadDuration);
	
	public int getLoadDuration();
	
	public void setNetworkDuration( int networkDuration);
	
	public int getNetworkDuration();
	
	public void setPageVacillation(int pageVacillation);
	
	public int getPageVacillation();
	
	public void setTimeStamp(Timestamp timestamp);
	
	public Timestamp getTimeStamp();

}
