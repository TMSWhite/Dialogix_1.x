/* ********************************************************
 ** Copyright (c) 2000-2006, Thomas Maxwell White, all rights reserved.
 ** MysqlSessionDataDAO.java ,v 3.0.0 Created on February 23, 2006, 12:35 PM
 ** @author Gary Lyons
 ******************************************************** */

package org.dianexus.triceps.modules.data;

import java.sql.*;

/**
 * MysqlSessionDataDAO is a Mysql implementation of the Interface SessionDataDAO
 * This DAO acts as an instance bean for the istrument named table containing a
 * snapshot of the colected data at any given moment in time. It persists the
 * the values at the end of an instrument session with a given user. Data is
 * written one row per session and is constantly updated during a session. The
 * table name is based on the instrument name and must be passed in at run time.
 * 
 */
public class MysqlSessionDataDAO implements SessionDataDAO {
	// sql
	public static final String SQL_SESSION_DAO_GET_LAST_INSERT_ID = "SELECT LAST_INSERT_ID()";


	// Row ID for this session in table
	public int rowID = 0;

	// common data columns
	private String instrumentName = "";

	private String instanceName = "";

	private String tableName = "";

	private java.sql.Timestamp startTime;

	private Timestamp endTime;

	private int firstGroup;

	private int lastGroup;

	private int lastAction;

	private int lastAccess;

	private String statusMsg;
	
	/** different tables have different number of columns these arrays are populated with column
	 * 	names ans data as derived from jdbc talble metadata query
	 */
	
	String[] answerCols;
	String[] answerData;

	// Default answer text TODO put this somewhere else more appropriate
	String defaultAnswer = "N/A";

	/**
	 * create new row in table for update. Needs starting values present??
	 */
	public boolean setSessionData(String tableName) {

		this.tableName = tableName;
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement stmt = null;
		try {
			// set the static column data and retrive the insert id

			stmt = con.prepareStatement("INSERT INTO "+ tableName + " "
							+ "SET InstrumentName = ?,InstanceName = ?, StartTime = ? ,"
							+ "endTime = ? , firstGroup = ? , lastGroup = ? , lastAction = ?, "
							+ "lastAccess = ? , statusMsg = ? ");
			stmt.clearParameters();
			stmt.setString(1, instrumentName);
			stmt.setString(2, instanceName);
			stmt.setTimestamp(3, startTime);
			stmt.setTimestamp(4, endTime);
			stmt.setInt(5, firstGroup);
			stmt.setInt(6, lastGroup);
			stmt.setInt(7, lastAction);
			stmt.setInt(8, lastAccess);
			stmt.setString(9, statusMsg);
			stmt.execute();
			// get the row id of this session for future use
			stmt = con.prepareStatement(SQL_SESSION_DAO_GET_LAST_INSERT_ID);
			ResultSet rs = stmt.executeQuery();
			rs.next();
			rowID = rs.getInt(1);

			// get ths column names and types to set default values
			stmt = con.prepareStatement("SELECT * from " + tableName);
			rs = stmt.executeQuery();
			rs.next();
			ResultSetMetaData rsmd = rs.getMetaData();
			int colCount = rsmd.getColumnCount();
			answerCols = new String[colCount + 1];

			for (int i = 5; i <= colCount -6; i++) {

				String name = rsmd.getColumnName(i);

				answerCols[i] = name;

			}
			//setStartingValues(defaultAnswer, tableName, answerCols);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (stmt != null) {
					stmt.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return true;
	}

	
	public boolean getSessionData(int sessionDataId) {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = con.prepareStatement("SELECT * FROM "+this.tableName+" WHERE session_id = "+sessionDataId );

			//ps.setInt(1,this.rowID);
			
			rs = ps.executeQuery();
			if(rs.next()){
				ResultSetMetaData rsmd = rs.getMetaData();
				int colCount = rsmd.getColumnCount();
				answerCols = new String[colCount + 1];
				answerData = new String[colCount + 1];

				for (int i = 5; i <= colCount -7; i++) {

					String name = rsmd.getColumnName(i);

					answerCols[i] = name;
					answerData[i] = rs.getString(i);

				}
				
			}else
			{
				return false;
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
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return true;
	}



	/**
	 * update columns of current row with new data
	 */
	public int updateSessionData(String columnName, String dataValue) {
		if (rowID != 0) {
			Connection con = DialogixMysqlDAOFactory.createConnection();
			PreparedStatement ps = null;
			try {
				ps = con.prepareStatement("UPDATE " + this.tableName + " SET "
						+ columnName + " = ? WHERE session_id = ?");

				ps.setString(1, dataValue);
				ps.setInt(2, rowID);
				ps.execute();

			} catch (Exception e) {
				e.printStackTrace();

			} finally {
				try {
					if (ps != null) {
						ps.close();
					}
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			return 1;
		}
		return 0;
	}

	/**
	 * remove the current row
	 */
	public boolean deleteSessionData() {

		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		try {
			ps = con.prepareStatement("DELETE FROM " + this.tableName + " WHERE session_id = ?");
			ps.setInt(1, rowID);
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
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return true;
	
	

	}

	/**
	 * set the starting values for this row
	 */
	public boolean setStartingValues(String defaultText, String tableName,
			String[] colNames) {
		// create query string and do update???
		StringBuffer sb = new StringBuffer();
		sb.append("UPDATE " + tableName + " SET  ");
		for (int i = 5; i < colNames.length; i++) {
			sb.append(" " + colNames[i] + " = '" + defaultText + "',");
		}

		// hack to remove trailing ',' "
		sb.deleteCharAt(sb.length() - 1);
		sb.append(" WHERE session_id = " + new Integer(rowID).toString());
		// write the data
		Connection con3 = DialogixMysqlDAOFactory.createConnection();
		Statement stmt = null;
		try {
			stmt = con3.createStatement();
			stmt.execute(sb.toString());

		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			try {
				if (con3 != null) {
					// con.close();
				}
				if (stmt != null) {
					// stmt.close();
				}
				return true;
			} catch (Exception fe) {
				fe.printStackTrace();
			}

		}

		// call writeStartingValues to do update??
		return true;
	}

	/**
	 * set the items for this item TODO is data string OK ??
	 */
	public boolean setSessionValue(String col, String data) {
		Connection con4 = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement stmt = null;
		try {
			stmt = con4.prepareStatement("");
			stmt.setString(1, tableName);
			stmt.setString(2, col);
			stmt.setString(3, data);
			stmt.setInt(4, rowID);
			stmt.execute();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			try {
				if (con4 != null) {
					// con.close();
				}
				if (stmt != null) {
					// stmt.close();
				}
				return true;
			} catch (Exception fe) {
				fe.printStackTrace();
			}

		}
		return false;
	}

	/**
	 * using introspection get all data col values and write default values for
	 * each
	 */
	public void writeStartingValues() {
		// get the col names
		// generate a query to set to value

	}
	
	public String[] getDataColumnNames() {
		
		return this.answerCols;
	}
	

	public String[] getColumnData() {
		
		return this.answerData;
	}


	public void getDaoFactory() {

	}
	public void setInstrumentName(String instrumentName) {
		this.instrumentName = instrumentName;
	}
	public String getInstrumentName() {
		return this.instrumentName;
	}
	public void setInstanceName(String instanceName) {
		this.instanceName = instanceName;
	}
	public String getInstanceName() {
		return this.instanceName;
	}
	public void setStartTime(java.sql.Timestamp startTime) {
		this.startTime = startTime;
	}
	public Timestamp getStartTime() {
		return this.startTime;
	}
	public void setEndTime(Timestamp endTime) {
		this.endTime = endTime;
	}
	public Timestamp getEndTime() {
		return this.endTime;
	}
	public void setFirstGroup(int firstGroup) {
		this.firstGroup = firstGroup;
	}
	public int getFirstGroup() {
		return this.firstGroup;
	}
	public void setLastGroup(int lastGroup) {
		this.lastGroup = lastGroup;
	}
	public int getLastGroup() {
		return this.lastGroup;
	}
	public void setLastAction(int lastAction) {
		this.lastAction = lastAction;
	}
	public int getLastAction() {
		return this.lastAction;
	}
	public void setLastAccess(int lastAccess) {
		this.lastAccess = lastAccess;
	}
	public int getLastAccess() {
		return this.lastAccess;
	}
	public void setStatusMsg(String statusMsg) {
		this.statusMsg = statusMsg;
	}
	public String getStatusMsg() {
		return this.statusMsg;
	}


	public int getRowId() {
		
		return this.rowID;
	}
	
}
