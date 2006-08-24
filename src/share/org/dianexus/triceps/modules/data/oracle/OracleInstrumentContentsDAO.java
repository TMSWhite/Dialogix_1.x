package org.dianexus.triceps.modules.data.oracle;

import org.dianexus.triceps.modules.data.InstrumentContentsDAO;

public class OracleInstrumentContentsDAO implements InstrumentContentsDAO{

	 private int instrumentId;
	 private String instrumentName;
	 private int instrumentVarNum;
	 private String instrumentVarName;
	 private String c8name;
	 private String displayName;
	 private int groupNum;
	 private String concept;
	 private String relevance;
	 private char actionType;
	 private String validation;
	 private String returnType;
	 private String minValue;
	 private String maxValue;
	 private String otherVals;
	 private String inputMask;
	 private String formatMask;
	 private String displayType;
	 private int isRequired;
	 private int isMessage;
	 private String level;
	 private String SPSSformat;
	 private String SASinFormat;
	 private String SASFormat;
	 private int answersNumeric;
	 private String defaultAnswer;
	 private String defaultComment;
	 private String LOINCproperty;
	 private String LOINCtimeAspect;
	 private String LOINCsystem;
	 private String LOINCscale;
	 private String LOINCmethod;
	 private String LOINC_NUM;
	 
	
	
	public boolean deleteInstrumentContents(int id) {
		// TODO Auto-generated method stub
		return false;
	}
	public boolean getInstrumentContents(int id) {
		// TODO Auto-generated method stub
		return false;
	}

	public boolean getInstrumentContents(String name) {
		// TODO Auto-generated method stub
		return false;
	}
	public boolean setInstrumentContents() {
		// TODO Auto-generated method stub
		return false;
	}
	public boolean updateInstrumentContents(String column, String value) {
		// TODO Auto-generated method stub
		return false;
	}


	public int getInstrumentContentsLastInsertId() {
        return this.getInstrumentId();
    }
    
    public void setInstrumentId(int id) {
    	this.instrumentId = id;
    }
    
    public int getInstrumentId() {
        return this.instrumentId;
    }
    
    public void setInstrumentName(java.lang.String instrumentName) {
    	this.instrumentName = instrumentName;
    }
    
    public java.lang.String getInstrumentName() {
        return this.instrumentName;
    }
    
    public void setInstrumentVarNum(int varNum) {
    	this.instrumentVarNum = varNum;
    }
    
    public int getInstrumentVarNum() {
        return this.instrumentVarNum;
    }
    
    public void setInstrumentVarName(java.lang.String varName) {
    	this.instrumentVarName = varName;
    }
    
    public java.lang.String getInstrumentVarName() {
        return this.instrumentVarName;
    }
    
    public void setInstrumentC8Name(java.lang.String c8Name) {
    	this.c8name = c8name;
    }
    
    public java.lang.String getInstrumentC8Name() {
        return this.c8name;
    }
    
    public void setDisplayName(java.lang.String displayName) {
    	this.displayName = displayName;
    }
    
    public java.lang.String getDisplayName() {
        return this.displayName;
    }
    
    public void setGroupNum(int groupNum) {
    	this.groupNum = groupNum;
    }
    
    public int getGroupNum() {
        return this.groupNum;
    }
    
    public void setConcept(java.lang.String concept) {
    	this.concept = concept;
    }
    public String getConcept() {
        return this.concept;
    }
    
    public void setRelevance(java.lang.String relevance) {
    	this.relevance = relevance;
    }
    
    public java.lang.String getRelevance() {
        return this.relevance;
    }
    
    public void setActionType(char actionType) {
    	this.actionType = actionType;
    }
    
    public char getActionType() {
        return this.actionType;
    }
    
    public void setValidation(java.lang.String validation) {
    	this.validation = validation;
    }
    
    public java.lang.String getValidation() {
        return this.validation;
    }
    
    public void setReturnType(java.lang.String returnType) {
    	this.returnType = returnType;
    }
    
    public java.lang.String getReturnType() {
        return this.returnType;
    }
    
    public void setMinValue(java.lang.String minValue) {
    	this.minValue = minValue;
    }
    
    public java.lang.String getMinValue() {
        return this.minValue;
    }
    public void setMaxValue(java.lang.String maxValue) {
    	this.maxValue = maxValue;
    }
    public java.lang.String getMaxValue() {
        return this.maxValue;
    }
    
    public void setOtherValues(java.lang.String otherValues) {
    	this.otherVals = otherValues;
    }
    
    public java.lang.String getOtherValues() {
        return this.otherVals;
    }
    
    public void setInputMask(java.lang.String inputMask) {
    	this.inputMask = inputMask;
    }
    
    public java.lang.String getInputMask() {
        return this.inputMask;
    }
    
    public void setFormatMask(java.lang.String formatMask) {
    	this.formatMask = formatMask;
    }
    
    public java.lang.String getFormatMask() {
        return this.formatMask;
    }
    
    public void setDisplayType(java.lang.String displayType) {
    	this.displayType = displayType;
    }
    
    public java.lang.String getDisplayType() {
        return this.displayType;
    }
    
    public void setIsRequired(int isRequired) {
    	this.isRequired = isRequired;
    }
    
    public int getIsRequired() {
        return this.isRequired;
    }
    
    public void setIsMessage(int isMessage) {
    	this.isMessage = isMessage;
    }
    
    public int getIsMessage() {
        return this.isMessage;
    }
    
    public void setLevel(java.lang.String level) {
    	this.level = level;
    }
    
    public java.lang.String getLevel() {
        return this.level;
    }
    
    public void setSPSSFormat(java.lang.String spssFormat) {
    	this.SPSSformat = spssFormat;
    }
    
    public java.lang.String getSPSSFormat() {
        return this.SPSSformat;
    }
    
    public void setSASInformat(java.lang.String sasInformat) {
    	this.SASinFormat = sasInformat;
    }
    
    public java.lang.String getSASInformat() {
        return this.SASinFormat;
    }
    
    public void setSASFormat(java.lang.String sasFormat) {
    	this.SASFormat = sasFormat;
    }
    
    public java.lang.String getSASFormat() {
        return this.SASFormat;
    }
    
    public void setAnswersNumeric(int answersNumeric) {
    	this.answersNumeric = answersNumeric;
    }
    
    public int getAnswersNumeric() {
        return this.answersNumeric;
    }
    
    public void setDefaultAnswer(java.lang.String defaultAnswer) {
    	this.defaultAnswer = defaultAnswer;
    }
    
    public java.lang.String getDefaultAnswer() {
        return this.defaultAnswer;
    }
    
    public void setDefaultComment(java.lang.String defaultComment) {
    	this.defaultComment = defaultComment;
    }
    
    public java.lang.String getDefaultComment() {
        return this.defaultComment;
    }
    
    public void setLOINCProperty(java.lang.String LOINCProperty) {
    	this.LOINCproperty = LOINCProperty;
    }
    
    public java.lang.String getLOINCProperty() {
        return this.LOINCproperty;
    }
    
    public void setLOINCTimeAspect(java.lang.String LOINCTimeAspect) {
    	this.LOINCtimeAspect = LOINCTimeAspect;
    }
    
    public java.lang.String getLOINCTimeAspect() {
        return this.LOINCtimeAspect;
    }
    
    public void setLOINCSystem(java.lang.String LOINCSystem) {
    	this.LOINCsystem = LOINCSystem;
    }
    
    public java.lang.String getLOINCSystem() {
        return this.LOINCsystem;
    }
    
    public void setLOINCScale(java.lang.String LOINCScale) {
    	this.LOINCscale = LOINCScale;
    }
    
    public java.lang.String getLOINCScale() {
        return this.LOINCscale;
    }
    
    public void setLOINCMethod(java.lang.String LOINCMethod) {
    	this.LOINCmethod = LOINCMethod;
    }
    
    public java.lang.String getLOINCMethod() {
        return this.LOINCmethod;
    }
    
    public void setLOINCNum(java.lang.String LOINCNum) {
    	this.LOINC_NUM = LOINCNum;
    }
    
    public java.lang.String getLOINCNum() {
        return this.LOINC_NUM;
    }

    public boolean equals(Object obj) {

        boolean retValue;
        
        retValue = super.equals(obj);
        return retValue;
    }

    public String toString() {

        String retValue;
        
        retValue = super.toString();
        return retValue;
    }

    public int hashCode() {

        int retValue;
        
        retValue = super.hashCode();
        return retValue;
    }

   

    protected void finalize() throws Throwable {

        super.finalize();
    }

    protected Object clone() throws CloneNotSupportedException {

        Object retValue;
        
        retValue = super.clone();
        return retValue;
    }
	    
}
