/* ********************************************************
 ** Copyright (c) 2000-2006, Thomas Maxwell White, all rights reserved.
 ** MysqlInstrumentHeadersDAO.java ,v 3.0.0 Created on March 10, 2006, 9:11 AM
 ** @author Gary Lyons
 ******************************************************** */


package org.dianexus.triceps.modules.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Hashtable;

public class  MysqlInstrumentHeadersDAO implements InstrumentHeadersDAO {
    
    
    public static final String SQL_GET_LAST_INSERT_ID ="SELECT LAST_INSERT_ID FROM InstrumentHeaders";
    public static final String SQL_GET_INSTRUMENT_HEADERS = "SELECT * FROM InstrumentHeaders WHERE ID = ?";
    public static final String SQL_INSERT_INSTRUMENT_HEADERS ="";
    public static final String SQL_DELETE_ISTRUMENT_HEADERS ="";
    
    private int instrumentHeaderId;
    private String instrumentName;
    private String reservedVarName;
    private String reservedVarValue;
    private Hashtable headerValues;
    
    
    
    /** Creates a new instance of MysqlInstrumentHeadersDAO */
    public  MysqlInstrumentHeadersDAO() {
    }

    

    public boolean getInstrumentHeaders(int id) {
        Connection con = DialogixMysqlDAOFactory.createConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try{
            ps = con.prepareStatement(SQL_GET_INSTRUMENT_HEADERS);
            ps.clearParameters();
            
            ps.setInt(1, id);
            rs = ps.executeQuery();
            while(rs.next()){
            	headerValues.put(rs.getString("reservedVarName"),rs.getString("value"));
            
            }
            
            
            
        }catch(Exception e){
            e.printStackTrace();
            return false;
        }
        finally{
            try{
                
            
            if(ps != null){
                ps.close();
            }
            if(con != null){
                con.close();
            }
            }catch(Exception ee){
                ee.printStackTrace();
            }
            
        }
        
        return true;
    }



	public void addReserved(String varName, String value) {
		
		
	}



	public boolean deleteInstrumentHeader(String varName) {
		
		return false;
	}



	public boolean deleteInstrumentHeaders(int instrument_version_id) {
		
		return false;
	}



	public int getInstrumentHeadersLastInsertId() {
		
		return 0;
	}



	public int getInstrumentVersionId() {
		
		return 0;
	}



	public String getReserved(String varName) {
		// TODO Auto-generated method stub
		return null;
	}



	public String[] getReservedVarNames() {
		// TODO Auto-generated method stub
		return null;
	}



	public boolean setInstrumentHeaders() {
		// TODO Auto-generated method stub
		return false;
	}



	public void setInstrumentVersionId(int id) {
		// TODO Auto-generated method stub
		
	}



	public void setReserved(String varName, String value) {
		// TODO Auto-generated method stub
		
	}



	public boolean updateInstrumentHeader(String varname, String value) {
		// TODO Auto-generated method stub
		return false;
	}



	public boolean updateInstrumentHeaders() {
		// TODO Auto-generated method stub
		return false;
	}
}
    