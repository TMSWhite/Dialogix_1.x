package org.dianexus.triceps.modules.data;

import java.sql.Timestamp;;

/**
 * This interface provides DAO support for the page_hit_events table. There are one or more rows in this tables
 * related to the parent pagehits table which is joing by the pageHitID FK. This interface is implemented in classes 
 * that support specific RDBM's
 *
 */
public interface PageHitEventsDAO {
	
	
	/**
	 * @return
	 */
	public boolean setPageHitEvent();
	/**
	 * @param pageHitId
	 * @return
	 */
	public boolean getPageHitEvents(int pageHitEventId);
	/**
	 * @param column
	 * @param value
	 * @return
	 */
	public boolean updatePageHitEventColumn(String column);
	/**
	 * @return
	 */
	public boolean updatePageHitEvent();
	/**
	 * @return
	 */
	public boolean deletePageHitEvent();
	
	/**
	 * @param pageHitEventId
	 */
	public void setPageHitEventId(int pageHitEventId);
	/**
	 * @param pageHitId
	 * @return
	 */
	public int[] getPageHitEventIds(int pageHitId);
	/**
	 * @return
	 */
	public int getPageHitEventId();
	/**
	 * @param pageHitId
	 */
	public void setPageHitId(int pageHitId);
	/**
	 * @return
	 */
	public int getPageHitId();
	/**
	 * @param varName
	 */
	public void setVarName(String varName);
	/**
	 * @return
	 */
	public String getVarName();
	/**
	 * @param actionType
	 */
	public void setActionType(String actionType);
	/**
	 * @return
	 */
	public String getActionType();
	/**
	 * @param eventType
	 */
	public void setEventType(String eventType);
	/**
	 * @return
	 */
	public String getEventType();
	/**
	 * @param timestamp
	 */
	public void setTimeStamp(Timestamp timestamp);
	/**
	 * @return
	 */
	public Timestamp getTimeStamp();
	/**
	 * @param duration
	 */
	public void setDuration(int duration);
	/**
	 * @return
	 */
	public int getDuration();
	/**
	 * @param value1
	 */
	public void setValue1(String value1);
	/**
	 * @return
	 */
	public String getValue1();
	/**
	 * @param value2
	 */
	public void setValue2(String value2);
	/**
	 * @return
	 */
	public String getValue2();

}
