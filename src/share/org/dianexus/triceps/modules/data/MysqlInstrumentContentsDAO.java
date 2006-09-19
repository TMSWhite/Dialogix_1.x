/* ********************************************************
 ** Copyright (c) 2000-2006, Thomas Maxwell White, all rights reserved.
 ** MysqlInstrumentContentsDAO.java ,v 3.0.0 Created on March 10, 2006, 9:05 AM
 ** @author Gary Lyons
 ******************************************************** */


package org.dianexus.triceps.modules.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;


public class  MysqlInstrumentContentsDAO implements InstrumentContentsDAO {
	
	public static final String SQL_GET_LAST_INSERT_ID = "SELECT LAST_INSERT_ID()";

	 public static final String SQL_GET_INSTRUMENT_CONTENTS = "SELECT * FROM instrumentcontents WHERE ID = ?";
	 public static final String SQL_GET_INSTRUMENT_CONTENTS_VARNAME = "SELECT * FROM instrumentcontents WHERE VarName = ?";

	 public static final String SQL_INSERT_INSTRUMENT_CONTENTS = "INSERT INTO instrumentcontents VALUES(null,?,?,?,?,?,?,?,?,?,?," +
	 		"?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

	 public static final String SQL_DELETE_ISTRUMENT_CONTENTS = "DELETE FROM instrumentcontents WHERE ID = ?";
	 
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
	 
    
    /** Creates a new instance of MysqlInstrumentContentsDAO */
    public  MysqlInstrumentContentsDAO() {
    }
    
    public boolean getInstrumentContents(int id) {
    	// find by id
    	Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean ret = false;
		try {
			ps = con.prepareStatement(SQL_GET_INSTRUMENT_CONTENTS);
			ps.clearParameters();

			ps.setInt(1, id);
			rs = ps.executeQuery();
			if (rs.next()) {
				this.setInstrumentName(rs.getString(2));
				this.setInstrumentVarNum(rs.getInt(3));
				this.setInstrumentC8Name(rs.getString(4));
				this.setDisplayName(rs.getString(5));
				this.setGroupNum(rs.getInt(6));
				this.setConcept(rs.getString(7));
				this.setRelevance(rs.getString(8));
				//TODO better way of doing this?
				char[] action = rs.getString(9).toCharArray();
				this.setActionType(action[0]);
				this.setValidation(rs.getString(10));
				this.setReturnType(rs.getString(11));
				this.setMinValue(rs.getString(12));
				this.setMaxValue(rs.getString(13));
				this.setOtherValues(rs.getString(14));
				this.setInputMask(rs.getString(15));
				this.setFormatMask(rs.getString(16));
				this.setDisplayType(rs.getString(17));
				this.setIsRequired(rs.getInt(18));
				this.setIsMessage(rs.getInt(19));
				this.setLevel(rs.getString(20));
				this.setSPSSFormat(rs.getString(21));
				this.setSASFormat(rs.getString(22));
				this.setSASFormat(rs.getString(23));
				this.setAnswersNumeric(rs.getInt(24));
				this.setDefaultAnswer(rs.getString(25));
				this.setDefaultComment(rs.getString(26));
				this.setLOINCProperty(rs.getString(27));
				this.setLOINCTimeAspect(rs.getString(28));
				this.setLOINCSystem(rs.getString(29));
				this.setLOINCScale(rs.getString(30));
				this.setLOINCMethod(rs.getString(31));
				this.setLOINCNum(rs.getString(32));
				ret = true;
				
				

			}

		} catch (Exception e) {
			e.printStackTrace();
			ret= false;
		} finally {
			try {
				if(rs != null){
					rs.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				
			} catch (Exception ee) {
				ee.printStackTrace();
			}

		}

		
        return ret;
    }
    
    public boolean getInstrumentContents(java.lang.String name) {
    	// find by varName 
    	Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean ret = false;
		try {
			ps = con.prepareStatement(SQL_GET_INSTRUMENT_CONTENTS_VARNAME);
			ps.clearParameters();

			ps.setString(1, name);
			rs = ps.executeQuery();
			if (rs.next()) {
				this.setInstrumentName(rs.getString(2));
				this.setInstrumentVarNum(rs.getInt(3));
				this.setInstrumentVarName(rs.getString(4));
				this.setInstrumentC8Name(rs.getString(5));
				this.setDisplayName(rs.getString(6));
				this.setGroupNum(rs.getInt(7));
				this.setConcept(rs.getString(8));
				this.setRelevance(rs.getString(9));
				this.setActionType(rs.getString(10).charAt(0));
				this.setValidation(rs.getString(11));
				this.setReturnType(rs.getString(12));
				this.setMinValue(rs.getString(13));
				this.setMaxValue(rs.getString(14));
				this.setOtherValues(rs.getString(15));
				this.setInputMask(rs.getString(16));
				this.setFormatMask(rs.getString(17));
				this.setDisplayType(rs.getString(18));
				this.setIsRequired(rs.getInt(19));
				this.setIsMessage(rs.getInt(20));
				this.setLevel(rs.getString(21));
				this.setSPSSFormat(rs.getString(22));
				this.setSASFormat(rs.getString(23));
				this.setSASFormat(rs.getString(24));
				this.setAnswersNumeric(rs.getInt(25));
				this.setDefaultAnswer(rs.getString(26));
				this.setDefaultComment(rs.getString(27));
				this.setLOINCProperty(rs.getString(28));
				this.setLOINCTimeAspect(rs.getString(29));
				this.setLOINCSystem(rs.getString(30));
				this.setLOINCScale(rs.getString(31));
				this.setLOINCMethod(rs.getString(32));
				this.setLOINCNum(rs.getString(33));
				ret = true;
				
				

			}

		} catch (Exception e) {
			e.printStackTrace();
			ret= false;
		} finally {
			try {
				if(rs != null){
					rs.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				
			} catch (Exception ee) {
				ee.printStackTrace();
			}

		}

		
        return ret;
    }
    
    public boolean setInstrumentContents() {
    	//SQL_INSERT_INSTRUMENT_CONTENTS
    	Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean ret = false;
		try {
			ps = con.prepareStatement(SQL_INSERT_INSTRUMENT_CONTENTS);
			ps.clearParameters();

			ps.setString(1,this.getInstrumentName());
			ps.setInt(2,this.getInstrumentVarNum());
			ps.setString(3, this.getInstrumentVarName());
			ps.setString(4,this.getInstrumentC8Name());
			ps.setString(5,this.getDisplayName());
			ps.setInt(6,this.getGroupNum());
			ps.setString(7,this.getConcept());
			ps.setString(8, this.getRelevance());
			StringBuffer action = new StringBuffer();
			action.append(this.getActionType());
			ps.setString(9,action.toString());
			ps.setString(10, this.getValidation());
			ps.setString(11,this.getReturnType());
			ps.setString(12,this.getMinValue());
			ps.setString(13,this.getMaxValue());
			ps.setString(14,this.getOtherValues());
			ps.setString(15,this.getInputMask());
			ps.setString(16, this.getFormatMask());
			ps.setString(17,this.getDisplayType());
			ps.setInt(18,this.getIsRequired());
			ps.setInt(19,this.getIsMessage());
			ps.setString(20,this.getLevel());
			ps.setString(21,this.getSPSSFormat());
			ps.setString(22, this.getSASInformat());
			ps.setString(23, this.getSASFormat());
			ps.setInt(24,this.getAnswersNumeric());
			ps.setString(25, this.getDefaultAnswer());
			ps.setString(26,this.getDefaultComment());
			ps.setString(27, this.getLOINCProperty());
			ps.setString(28, this.getLOINCTimeAspect());
			ps.setString(29, this.getLOINCSystem());
			ps.setString(30,this.getLOINCScale());
			ps.setString(31,this.getLOINCMethod());
			ps.setString(32,this.getLOINCNum());
			ret = ps.execute();
			ps = con.prepareStatement(SQL_GET_LAST_INSERT_ID);
			rs = ps.executeQuery();
			if(rs.next()){
				this.setInstrumentId(rs.getInt(1));
			}
			
			
			
			rs = ps.executeQuery();
		} catch (Exception e) {
			e.printStackTrace();
			ret= false;
		} finally {
			try {
				if(rs != null){
					rs.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				
			} catch (Exception ee) {
				ee.printStackTrace();
			}

		}

		
        return ret;
      
    }
    
    public boolean updateInstrumentContents(java.lang.String column, java.lang.String value) {
        return true;
    }
    
    public boolean deleteInstrumentContents(int id) {
        return true;
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
