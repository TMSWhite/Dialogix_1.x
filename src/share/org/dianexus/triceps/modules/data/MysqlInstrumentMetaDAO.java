/* ********************************************************
 ** Copyright (c) 2000-2006, Thomas Maxwell White, all rights reserved.
 ** MysqlInstrumentMetaDAO.java ,v 3.0.0 Created on March 10, 2006, 9:13 AM
 ** @author Gary Lyons
 ******************************************************** */


package org.dianexus.triceps.modules.data;

import java.sql.Date;
import java.sql.*;


public class  MysqlInstrumentMetaDAO implements InstrumentMetaDAO{
    
	private String languageList;
	private String instrumentMD5;
	private int instrumentVersionId;
	private int numTailorings;
	private int numBranches;
	private int numQuestions;
	private int numEquations;
	private int numInstructions;
	private int numLanguages;
	private int numVars;
	private int instrument_meta_id;
	private Date creationDate;
	private String version;
	private String title;
	
	private String SQL_GET_METADATA_FROM_MD5 = "SELECT * FROM instrumentmeta WHERE InstrumentMD5 = ?";
	private String SQL_INSERT_METADATA="INSERT INTO instrumentmeta VALUES(null,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	public static final String SQL_GET_LAST_INSERT_ID = "SELECT LAST_INSERT_ID FROM instrumentmeta";
    /** Creates a new instance of MysqlInstrumentMetaDAO */
    public  MysqlInstrumentMetaDAO() {
    }

    public boolean getInstrumentMeta(int id) {
        return true;
    }

    public boolean getInstrumentMeta(java.lang.String name) {
    	Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean rtn = false;
		try {
			ps = con.prepareStatement(SQL_GET_METADATA_FROM_MD5);
			ps.clearParameters();

			ps.setString(1, name);
			rs = ps.executeQuery();
			if (rs.next()) {
				rtn = true;
				this.instrument_meta_id = rs.getInt(1);
				this.instrumentVersionId = rs.getInt(2);
				this.setTitle(rs.getString(3));
				this.setVersion(rs.getString(4));
				this.setCreationDate(rs.getDate(5));
				this.setNumVars(rs.getInt(6));
				this.setVarListMD5(rs.getString(7));
				this.setLanguageList(rs.getString(8));
				this.setNumLanguages(rs.getInt(9));
				this.setNumInstructions(rs.getInt(10));
				this.setNumEquations(rs.getInt(11));
				this.setNumQuestions(rs.getInt(12));
				this.setNumBranches(rs.getInt(13));
				this.setNumTailorings(rs.getInt(14));
				

			}

		} catch (Exception e) {
			e.printStackTrace();
			return false;
		} finally {
			try {

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

		return rtn;
    }

    public boolean setInstrumentMeta() {
    	Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean rtn = false;
		try {
			ps = con.prepareStatement(SQL_INSERT_METADATA);
			ps.clearParameters();

			ps.setInt(1, this.instrumentVersionId);
			ps.setString(2, this.getTitle());
			ps.setString(3, this.getVersion());
			ps.setDate(4,this.getCreationDate());
			ps.setInt(5,this.getNumVars());
			ps.setString(6,this.getVarListMD5());
			ps.setString(7,this.getInstrumentMD5());
			ps.setString(8,this.getLanguageList());
			ps.setInt(9,this.getNumLanguages());
			ps.setInt(10,this.getNumInstructions());
			ps.setInt(11,this.getNumEquations());
			ps.setInt(12,this.getNumQuestions());
			ps.setInt(13,this.getNumBranches());
			ps.setInt(14,this.getNumTailorings());
			ps.execute();
			ps = con.prepareStatement(SQL_GET_LAST_INSERT_ID);
			this.setInstrumentName(ps.toString());
			rs = ps.executeQuery();
			if(rs.next()){
				this.instrument_meta_id = rs.getInt(1);
				rtn = true;
			}

		} catch (Exception e) {
			e.printStackTrace();
			return false;
		} finally {
			try {

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

		return rtn;
    }

    public boolean updateInstrumentMeta(java.lang.String column, java.lang.String value) {
        return true;
    }

    public boolean deleteInstrumentMeta(int id) {
        return true;
    }

    public int getInstrumentMetaLastInsertId() {
        return 0;
    }

    public java.lang.String getInstrumentName() {
        return this.instrumentMD5;
    }

    public void setInstrumentName(java.lang.String name) {
    	this.instrumentMD5 = name;
    }

    public void setTitle(java.lang.String title) {
    	this.title = title;
    }

    public java.lang.String getTitle() {
        return this.title;
    }

    public void setVersion(java.lang.String version) {
    	this.version = version;
    }

    public java.lang.String getVersion() {
        return this.version;
    }

    public void setCreationDate(Date date) {
    	this.creationDate = date;
    }

    public java.sql.Date getCreationDate() {
        return this.creationDate;
    }

    public void setNumVars(int numVars) {
    	this.numVars = numVars;
    }

    public int getNumVars() {
        return this.numVars;
    }

    public void setVarListMD5(java.lang.String varListMD5) {
    }

    public java.lang.String getVarListMD5() {
        return "";
    }

  

    

    public java.lang.String[] getLanguageListArray() {
        return null;
    }

    public void setNumLanguages(int numLanguages) {
    	this.numLanguages = numLanguages;
    }

    public int getNumLanguages() {
        return this.numLanguages;
    }

    public void setNumInstructions(int numInstructions) {
    	this.numInstructions = numInstructions;
    }

    public int getNumInstructions() {
        return this.numInstructions;
    }

    public void setNumEquations(int numEquations) {
    	this.numEquations = numEquations;
    }

    public int getNumEquations() {
        return this.numEquations;
    }

    public void setNumQuestions(int numQuestions) {
    	this.numQuestions = numQuestions;
    }

    public int getNumQuestions() {
        return this.numQuestions;
    }

    public void setNumBranches(int numBranches) {
    	this.numBranches = numBranches;
    }

    public int getNumBranches() {
        return this.numBranches;
    }

    public void setNumTailorings(int numTailorings) {
    	this.numTailorings = numTailorings;
    }

    public int getNumTailorings() {
        return this.numTailorings;
    }

    public String getInstrumentMD5() {
    	return this.instrumentMD5;
    }
    public void setInstrumentMD5(String instrumentMD5) {
    	this.instrumentMD5 = instrumentMD5;
    }

    public String getLanguageList() {
        return this.languageList;
    }
    public void setLanguageList(String languageList) {
    	this.languageList = languageList;
    }

	public int getInstrumentVersionId() {
		return this.instrumentVersionId;
	}

	public void setInstrumentVersionId(int id) {
		this.instrumentVersionId = id;
		
	}

   

   
    
}
