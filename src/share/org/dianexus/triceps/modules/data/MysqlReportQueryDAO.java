package org.dianexus.triceps.modules.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;

public class MysqlReportQueryDAO implements ReportQueryDAO {

	private int id;
	private int user_id;
	private int instrument_version_id;
	private Timestamp ts;
	private String queryString;
	
	private static final String SQL_GET_REPORT_QUERY ="SELECT * FROM report_query WHERE id = ?";
	private static final String SQL_SET_REPORT_QUERY ="INSERT INTO report_query SET user_id = ?,instrument_version_id = ?, ts = ?, query_string =?";
	private static final String SQL_DELETE_REPORT_QUERY="DELETE FROM report_query WHERE id = ?";
	private static final String SQL_UPDATE_REPORT_QUERY="UPDATE report_query SET user_id = ?,instrument_version_id = ?, ts = ?, query_string =?  WHERE id =?";
	private static final String SQL_GET_LAST_INSERT_ID = "SELECT LAST_INSERT_ID()";
	
	public boolean setReportQueryDAO() {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean rtn = false;
		try {
			ps = con.prepareStatement(SQL_SET_REPORT_QUERY);
			ps.clearParameters();

			ps.setInt(1, user_id);
			ps.setInt(2, instrument_version_id);
			ps.setTimestamp(3, ts);
			ps.setString(4, queryString);
			ps.executeUpdate();
			
			ps = con.prepareStatement(SQL_GET_LAST_INSERT_ID);
			rs = ps.executeQuery();
			if(rs.next()){
				this.id = rs.getInt(1);
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
				if(rs != null){
					rs.close();
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
	public boolean getReportQueryDAO(int id) {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean rtn = false;
		try {
			ps = con.prepareStatement(SQL_GET_REPORT_QUERY);
			ps.clearParameters();

			ps.setInt(1, id);
			rs = ps.executeQuery();
			if (rs.next()) {
				
				this.setUserId(rs.getInt(1));
				this.setInstrumentVersionId(rs.getInt(2));
				this.setTs(rs.getTimestamp(3));
				this.setQueryString(rs.getString(4));
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
				if(rs != null){
					rs.close();
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
	public boolean updateReportQueryDAO() {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		boolean rtn = false;
		try {
			ps = con.prepareStatement(SQL_UPDATE_REPORT_QUERY);
			ps.clearParameters();

			ps.setInt(1, instrument_version_id);
			ps.setTimestamp(2, ts);
			ps.setString(3, queryString);
			ps.setInt(4, id);
			ps.executeUpdate();
			rtn = true;
			
				
				

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
	public boolean deleteReportQueryDAO(int id) {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean rtn = false;
		try {
			ps = con.prepareStatement(SQL_DELETE_REPORT_QUERY);
			ps.clearParameters();

			ps.setInt(1, id);
			ps.executeUpdate();
			rtn = true;

		} catch (Exception e) {
			e.printStackTrace();
			return false;
		} finally {
			try {
				
				if (ps != null) {
					ps.close();
				}
				if(rs != null){
					rs.close();
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

	public int getId() {
		return this.id;
	}

	public int getInstrumentVersionId() {
		return this.instrument_version_id;
	}

	public String getQueryString() {
		return this.queryString;
	}

	
	public Timestamp getTs() {
		return this.ts;
	}

	public int getUserId() {
		return this.user_id;
		
	}

	public void setId(int id) {
		this.id = id;
		
	}

	public void setInstrumentVersionId(int instrument_version_id) {
		this.instrument_version_id = instrument_version_id;
		
	}

	public void setQueryString(String qs) {
		this.queryString = qs;
		
	}

	

	public void setTs(Timestamp ts) {
		this.ts = ts;
		
	}

	public void setUserId(int user_id) {
		this.user_id = user_id;
		
	}

	

}
