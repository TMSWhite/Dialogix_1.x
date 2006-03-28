package org.dianexus.triceps.modules.data;

/* ********************************************************
 ** Copyright (c) 2000-2006, Thomas Maxwell White, all rights reserved.
 ** RawDataCDAO.java ,v 3.0.0 Created on February 23, 2006, 11:51 AM
 ** @author Gary Lyons
 ******************************************************** 
 */

import java.sql.Timestamp;

public interface RawDataDAO {

	/**
	 * data persistence operations
	 */

	/**
	 * store the row in the db that is indicated by the rawDataId
	 * 
	 * @return
	 */
	public boolean setRawData();

	/**
	 * select the row in the db that is indicated by the rawDataId
	 * 
	 * @return
	 */
	public boolean getRawData();

	/**
	 * * delete the row in the db that is indicated by the rawDataId
	 * 
	 * @return
	 */
	public boolean deleteRawData();

	/**
	 * Update the row in the db that is indicated by the rawDataId
	 * 
	 * @return
	 */
	public boolean updateRawData();

	/**
	 * clear Local Instance Variables
	 */
	public void clearRawDataStructure();

	/**
	 * load data element operations
	 */
	/**
	 * @param rawDataId
	 */
	public void setRawDataId(int rawDataId);

	/**
	 * @return
	 */
	public int getRawDataId();

	/**
	 * @param instrumentSessionId
	 */
	public void setInstrumentSessionId(int instrumentSessionId);

	/**
	 * @return
	 */
	public int getInstrumentSessionId();

	/**
	 * @param instrumentName
	 */
	public void setInstrumentName(String instrumentName);

	/**
	 * @return
	 */
	public String getInstrumentName();

	/**
	 * @param instanceName
	 */
	public void setInstanceName(String instanceName);

	/**
	 * @return
	 */
	public String getInstanceName();

	/**
	 * @param varName
	 */
	public void setVarName(String varName);

	/**
	 * @return
	 */
	public String getVarName();

	/**
	 * @param varNum
	 */
	public void setVarNum(int varNum);

	/**
	 * @return
	 */
	public int getVarNum();

	/**
	 * @param groupNum
	 */
	public void setGroupNum(int groupNum);

	/**
	 * @return
	 */
	public int getGroupNum();

	/**
	 * @param displanNum
	 */
	public void setDisplayNum(int displayNum);

	/**
	 * @return
	 */
	public int getDisplayNum();

	/**
	 * @param langNum
	 */
	public void setLangNum(int langNum);

	/**
	 * @return
	 */
	public int getLangNum();

	/**
	 * @param whenAsMS
	 */
	public void setWhenAsMS(long whenAsMS);

	/**
	 * @return
	 */
	public long getWhenAsMS();

	/**
	 * @param timeStamp
	 */
	public void setTimeStamp(Timestamp timeStamp);

	/**
	 * @return
	 */
	public Timestamp getTimeStamp();

	/**
	 * @param answerType
	 */
	public void setAnswerType(int answerType);

	/**
	 * @return
	 */
	public int getAnswerType();

	/**
	 * @param answer
	 */
	public void setAnswer(String answer);

	/**
	 * @return
	 */
	public String getAnswer();

	/**
	 * @param questionAsAsked
	 */
	public void setQuestionAsAsked(String questionAsAsked);

	/**
	 * @return
	 */
	public String getQuestionAsAsked();

	/**
	 * @param itemVacillation
	 */
	public void setItemVacillation(int itemVacillation);

	/**
	 * @return
	 */
	public int getItemVacillation();

	/**
	 * @param responseLatency
	 */
	public void setResponseLatency(int responseLatency);

	/**
	 * @return
	 */
	public int getResponseLatency();

	/**
	 * @param responseDuration
	 */
	public void setResponseDuration(int responseDuration);

	/**
	 * @return
	 */
	public int getResponseDuration();

	/**
	 * @param nullFlavor
	 */
	public void setNullFlavor(int nullFlavor);

	/**
	 * @return
	 */
	public int getNullFlavor();

	/**
	 * @param comment
	 */
	public void setComment(String comment);

	/**
	 * @return
	 */
	public String getComment();

}
