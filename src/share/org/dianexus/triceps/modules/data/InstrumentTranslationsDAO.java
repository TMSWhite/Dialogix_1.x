package org.dianexus.triceps.modules.data;
/* ********************************************************
 ** Copyright (c) 2000-2006, Thomas Maxwell White, all rights reserved.
 ** InstrumentTranslationsDAO.java ,v 3.0.0 Created on March 9, 2006, 1:14 PM
 ** @author Gary Lyons
 ******************************************************** 
 */

 
 
 public interface InstrumentTranslationsDAO {
     
  
     
     boolean getInstrumentTranslations(int _id);
     boolean getInstrumentTranslations(String _name);
     boolean setInstrumentTranslations();
     boolean updateInstrumentTranslations(String _column, String value);
     boolean deleteInstrumentTranslations(int _id);
     int getInstrumentTranslationsLastInsertId();
     
     void setInstrumentTranslationsId(int _id);
     int getInstrumentTranslationsId();
     void setInstrumentName(String _instrumentName);
     public String getInstrumentName();
     void setLanguageNum(int _languageNum);
     int getLanguageNum();
     void setLanguageName(String _languageName);
     public String getLanguageName();
     void setVarNum(int _varNum);
     int getVarNum();
     void setVarName(String _varName);
     String getVarName();
     void setC8Name(String _c8Name);
     public String getC8Name();
     void setActionType(char _actionType);
     char getActionType();
     void setReadback(String _readback);
     String getReadback();
     void setActionPhrase(String _actionPhrase);
     String getActionPhrase();
     void setDisplayType(String _displayType);
     public String getDisplayType();
     void setAnswerOptions(String _answerOptions);
     public String getAnswerOptions();
     String[] getAnswerOptionsArray();
     void setHelpURL(String _helpURL);
     public String getHelpURL();
     void setQuestionLen(int _questionLen);
     int getQuestionLen();
     void setAnswerLen(int _answerLen);
     int getAnswerLen();
     void setQuestionMD5(String _questionMD5);
     public String getQuestionMD5();
     
 }
