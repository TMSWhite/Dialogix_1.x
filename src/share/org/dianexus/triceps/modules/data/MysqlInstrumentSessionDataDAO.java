package org.dianexus.triceps.modules.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Timestamp;
import java.util.List;

public class MysqlInstrumentSessionDataDAO implements InstrumentSessionDataDAO {
	
	private static final String SQL_GET_LAST_INSERT_ID = "SELECT LAST_INSERT_ID()";
	
	private int firstGroup;
	private String instrumentName;
	private int instrumentSessionDataId;
	private String lastAccess;
	private String lastAction;
	private int lastGroup;
	private Timestamp sessionEndTime;
	private Timestamp sessionStartTime;
	private int sessionId;
	private String statusMsg;
	private String tableName;
	private List dataColumns;
	private List dataValues;
	private String instanceName;
	

	
	
	public boolean setInstrumentSessionDataDAO(String tablename) {
		// store a skeletal record that can be updated as the session progresses
		this.setTableName(tablename);
		String query = "INSERT INTO "+tablename+" (ID,InstanceName,StartTime, "
		+ "end_time, first_group,last_group,last_action,last_access,status_message,InstrumentName) VALUES(null,?,?,?,?,?,?,?,?,?)";
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = con.prepareStatement(query);
			ps.clearParameters();
			ps.setString(1, this.getInstanceName());
			ps.setTimestamp(2, this.getSessionStartTime());
			ps.setTimestamp(3, this.getSessionEndTime());
			ps.setInt(4, this.getFirstGroup());
			ps.setInt(5, this.getLastGroup());
			ps.setString(6, this.getLastAction());
			ps.setString(7, this.getLastAccess());
			ps.setString(8,this.getStatusMsg());
			ps.setString(9, this.getInstrmentName());
			ps.execute();
			// get the raw data id as last insert id 
			ps = con.prepareStatement(SQL_GET_LAST_INSERT_ID);
			rs = ps.executeQuery();
			if(rs.next()){
				this.setInstrumentSessionDataId(rs.getInt(1));
			}

		} catch (Exception e) {

			e.printStackTrace();
			return false;

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
			} catch (Exception fe) {
				fe.printStackTrace();
			}
		}
		return true;
	}
	public boolean deleteInstrumentSessionDataDAO(String table, int id) {
		// delete a row from the session data table
		String query = "DELETE FROM "+table+" WHERE session_id = ?";
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		
		try {
			ps = con.prepareStatement(query);
			ps.clearParameters();
			ps.setInt(1, id);
			
			ps.execute();
			

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
			} catch (Exception fe) {
				fe.printStackTrace();
			}
		}
		return true;
	}
	public boolean getInstrumentSessionDataDAO(String table, int id) {
		// get a row from the session data table
		String query = "SELECT * FROM "+table+" WHERE session_id = ?";
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		ResultSetMetaData rsm = null;
		try {
			ps = con.prepareStatement(query);
			ps.clearParameters();
			ps.setInt(1, id);
			
			rs = ps.executeQuery();
			rsm = rs.getMetaData();
			int numCols = rsm.getColumnCount();
			if(rs.next()){
				//TODO complete function
			}
			

		} catch (Exception e) {

			e.printStackTrace();
			return false;

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
			} catch (Exception fe) {
				fe.printStackTrace();
			}
		}
		return true;
	}
	public boolean updateInstrumentSessionDataDAO(String column, String value) {
		// update a column value and latest status
		String query ="UPDATE "+this.getTableName()+" SET "+column+" = ?,last_group = ?, last_action = ?, " +
				" last_access = ?, status_message = ? WHERE ID = ?";
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = con.prepareStatement(query);
			ps.clearParameters();
			ps.setString(1, value);
			ps.setInt(2, this.getLastGroup());
			ps.setString(3, this.getLastAction());
			ps.setString(4, this.getLastAccess());
			ps.setString(5, this.getStatusMsg());
			ps.setInt(6,this.getInstrumentSessionDataId());
			ps.execute();
			

		} catch (Exception e) {

			e.printStackTrace();
			return false;

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
			} catch (Exception fe) {
				fe.printStackTrace();
			}
		}
		return true;
	}

	public int getFirstGroup() {
		return this.firstGroup;
	}

	public String getInstrmentName() {
		
		return this.instrumentName;
	}

	

	public int getInstrumentSessionDataId() {

		return this.instrumentSessionDataId;
	}

	public String getLastAccess() {

		return this.lastAccess;
	}

	public String getLastAction() {

		return this.lastAction;
	}

	public int getLastGroup() {

		return this.lastGroup;
	}

	public Timestamp getSessionEndTime() {

		return this.sessionEndTime;
	}

	public int getSessionId() {
		return this.sessionId;
		
	}

	public Timestamp getSessionStartTime() {

		return this.sessionStartTime;
	}

	public String getStatusMsg() {

		return this.statusMsg;
	}

	public void setFirstGroup(int group) {
		this.firstGroup = group;
		
	}

	public void setInstrumentName(String name) {
		this.instrumentName = name;
		
	}

	

	public void setInstrumentSessionDataId(int id) {
		this.instrumentSessionDataId = id;
		
	}

	public void setLastAccess(String access) {
		this.lastAccess = access;
		
	}

	public void setLastAction(String action) {
		this.lastAction = action;
		
	}

	public void setLastGroup(int group) {
		this.lastGroup = group;
		
	}

	public void setSessionStartTime(Timestamp time) {
		this.sessionEndTime = time;
		
	}

	public void setSessionEndTime(Timestamp time) {
		this.sessionEndTime = time;
		
	}

	public void setSessionId(int id) {
		this.sessionId = id;
		
	}

	public void setStatusMsg(String msg) {
		this.statusMsg = msg;
		
	}
	public String getTableName() {

		return this.tableName;
	}
	public void setTableName(String table) {
		this.tableName = table;
	}
	public String getInstanceName() {
		// TODO Auto-generated method stub
		return this.instanceName;
	}
	public void setInstanceName(String name) {
		this.instanceName = name;
		
	}

	
	

}
