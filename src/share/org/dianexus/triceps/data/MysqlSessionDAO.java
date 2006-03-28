/* ********************************************************
 ** Copyright (c) 2000-2006, Thomas Maxwell White, all rights reserved.
 ** MysqlSessionDAO.java ,v 3.0.0 Created on March 3, 2006, 3:20 PM
 ** @author Gary Lyons
 ******************************************************** */


package org.dianexus.triceps.modules.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;


public class  MysqlSessionDAO implements SessionDAO{
    
    public static final String SQL_NEW_SESSION_DAO="INSERT INTO TABLE SET user_id = ?, session_id = ?, instrument_id = ?, study_id=?,locaton_id = ?, ts = ?";
    public static final String SQL_SESSION_DAO_GET_LAST_INSERT_ID="SELECT LAST_INSERT_ID()";
    private int id;
    private int userId;
    private int studyId;
    private int sessionId;
    private int instrumentId;
    private int locationId;
    private int rowId;
    private Timestamp ts;
            
    /** Creates a new instance of MysqlSessionDAO */
    public  MysqlSessionDAO() {
    }

    public boolean equals(Object obj) {

        boolean retValue;
        
        retValue = super.equals(obj);
        return retValue;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public void setStudyId(int studyId) {
        this.studyId = studyId;
    }

    public void setSessionId(int sessionId) {
        this.sessionId = sessionId;
    }

    public void setLocationId(int locationId) {
        this.locationId = locationId;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setInstrumentId(int instrumentId) {
    }

    public boolean updateSession() {
        return false;
    }

    public String toString() {

        String retValue;
        
        retValue = super.toString();
        return retValue;
    }

    public boolean setSession() {
        
        Connection con = DialogixMysqlDAOFactory.createConnection();
        PreparedStatement stmt = null;
        try{
            //set the instance columns 1 - 4
            stmt = con.prepareStatement(SQL_NEW_SESSION_DAO);
            stmt.clearParameters();
            //stmt.setString(1, tableName);
            stmt.setInt(1, userId);
            stmt.setInt(2, sessionId);
            stmt.setInt(3, instrumentId);
            stmt.setInt(4, studyId);
            stmt.setInt(5,locationId);
            stmt.setTimestamp(6,ts);
            stmt.execute();
            
            // get the row id of this session for future use
            stmt= con.prepareStatement(SQL_SESSION_DAO_GET_LAST_INSERT_ID);
            ResultSet rs = stmt.executeQuery();
            rs.next();
            rowId = rs.getInt(1);
            
            
            
        }catch(Exception e){
            e.printStackTrace();
        } finally{
            try{
                if(stmt!=null){
                    stmt.close();
                }
                if(con!=null){
                    con.close();
                }
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        return true;
    }
  

    protected Object clone() throws CloneNotSupportedException {

        Object retValue;
        
        retValue = super.clone();
        return retValue;
    }

    public boolean deleteSession() {
        return false;
    }

    protected void finalize() throws Throwable {

        super.finalize();
    }

    public int getId() {
        return this.id;
    }

    public int getInstrumentId() {
        return 0;
    }

    public int getLocationId() {
        return this.locationId;
    }

    public int getSessionId() {
        return this.sessionId;
    }

    public int getStudyId() {
        return this.studyId;
    }

    public int getUserId() {
        return this.userId;
    }

    public int hashCode() {

        int retValue;
        
        retValue = super.hashCode();
        return retValue;
    }

    public Timestamp getTimestamp() {
        return this.ts;
    }

    public void setTimestamp(Timestamp ts) {
        this.ts = ts;
    }
    
}
