package org.dianexus.triceps.modules.data;
/* ********************************************************
 ** Copyright (c) 2000-2006, Thomas Maxwell White, all rights reserved.
 ** InstrumentContentsDAO.java ,v 3.0.0 Created on March 9, 2006, 1:28 PM
 ** @author Gary Lyons
 ******************************************************** 
 */
 
 
 public interface InstrumentContentsDAO {
     
     boolean getInstrumentContents(int id);
     boolean getInstrumentContents(String name);
     boolean setInstrumentContents();
     boolean updateInstrumentContents(String column, String value);
     boolean deleteInstrumentContents(int id);
     int getInstrumentContentsLastInsertId();
     
     void setInstrumentId(int id);
     int getInstrumentId();
     void setInstrumentName(String instrumentName);
     String getInstrumentName();
     void setInstrumentVarNum(int varNum);
     int getInstrumentVarNum();
     void setInstrumentVarName(String varName);
     String getInstrumentVarName();
     void setInstrumentC8Name(String c8Name);
     String getInstrumentC8Name();
     void setDisplayName(String displayName);
     String getDisplayName();
     void setGroupNum(int groupNum);
     int getGroupNum();
     void setConcept(String concept);
     String getConcept();
     void setRelevance(String relevance);
     String getRelevance();
     void setActionType(char actionType);
     char getActionType();
     void setValidation(String validation);
     String getValidation();
     void setReturnType(String returnType);
     String getReturnType();
     void setMinValue(String minValue);
     String getMinValue();
     void setMaxValue(String maxValue);
     String getMaxValue();
     void setOtherValues(String otherValues);
     String getOtherValues();
     void setInputMask(String inputMask);
     String getInputMask();
     void setFormatMask(String formatMask);
     String getFormatMask();
     void setDisplayType(String displayType);
     String getDisplayType();
     void setIsRequired(int isRequired);
     int getIsRequired();
     void setIsMessage(int isMessage);
     int getIsMessage();
     void setLevel(String level);
     String getLevel();
     void setSPSSFormat(String spssFormat);
     String getSPSSFormat();
     void setSASInformat(String sasInformat);
     String getSASInformat();
     void setSASFormat(String sasFormat);
     String getSASFormat();
     void setAnswersNumeric(int answersNumeric);
     int getAnswersNumeric();
     void setDefaultAnswer(String defaultAnswer);
     String getDefaultAnswer();
     void setDefaultComment(String defaultComment);
     String getDefaultComment();
     void setLOINCProperty(String LOICProperty);
     public String getLOINCProperty();
     void setLOINCTimeAspect(String LOINCTimeAspect);
     public String getLOINCTimeAspect();
     void setLOINCSystem(String LOINCSystem);
     String getLOINCSystem();
     void setLOINCScale(String LOINCScale);
     public String getLOINCScale();
     void setLOINCMethod(String LOINCMethod);
     public String getLOINCMethod();
     void setLOINCNum(String LOINCNum);
     public String getLOINCNum();
     
 }
