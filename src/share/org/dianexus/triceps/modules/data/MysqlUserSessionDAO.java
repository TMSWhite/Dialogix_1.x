/**
 * 
 */
package org.dianexus.triceps.modules.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;

/**
 * This CLASS provides DAO support for the user_session table. It implements
 * the UserSessionDAO interface.  This  * interface is implemented in this class
 *  to support mysql.
 *
 */
public class MysqlUserSessionDAO implements UserSessionDAO {
	
	
	private String status;
	
	private String comments;
	
	private Timestamp timestamp;
	
	private int userId;
	
	private int instrumentSessionId;
	
	private int userSessionId;
	
	
	
	
	private static final String SQL_GET_LAST_INSERT_ID = "SELECT LAST_INSERT_ID()";

	private static final String SQL_USER_SESSION_NEW = "INSERT INTO user_session SET instrument_session_id = ? , "
			+ " user_id = ? , timestamp = ? , comments = ? ,"
			+ " status = ? ";

	private static final String SQL_USER_SESSION_DELETE = "DELETE FROM user_session  WHERE user_session_id = ?";

	private static final String SQL_USER_SESSION_UPDATE = "UPDATE user_session SET instrument_session_id = ? , "
			+ " user_id = ? , timestamp = ? , comments = ? ,"
			+ " status = ? WHERE user_session_id = ?";


	private static final String SQL_USER_SESSION_GET = "SELECT * FROM user_session WHERE user_session_id = ?";


	/* (non-Javadoc)
	 * @see org.dianexus.triceps.modules.data.UserSessionDAO#setUserSession()
	 */
	public boolean setUserSession() {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = con.prepareStatement(SQL_USER_SESSION_NEW);
			ps.clearParameters();
			ps.setInt(1, instrumentSessionId);
			ps.setInt(2, userId);
			ps.setTimestamp(3, timestamp);
			ps.setString(4, comments);
			ps.setString(5, status);
			
			ps.execute();
			// get the raw data id as last insert id 
			ps = con.prepareStatement(SQL_GET_LAST_INSERT_ID);
			rs = ps.executeQuery();
			if(rs.next()){
				this.setUserSessionId(rs.getInt(1));
			}
			else{
				return false;
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

	/* (non-Javadoc)
	 * @see org.dianexus.triceps.modules.data.UserSessionDAO#getUserSession(int)
	 */
	public boolean getUserSession(int userSessionId) {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = con.prepareStatement(SQL_USER_SESSION_GET);
			ps.clearParameters();
			ps.setInt(1,userSessionId);
			rs = ps.executeQuery();
			if(rs.next()){
				this.setInstrumentSessionId(rs.getInt(2));
				this.setUserId(rs.getInt(3));
				this.setTimestamp(rs.getTimestamp(4));
				this.setComments(rs.getString(5));
				this.setStatus(rs.getString(6));
			}
			else{
				return false;
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

	/* (non-Javadoc)
	 * @see org.dianexus.triceps.modules.data.UserSessionDAO#updateUserSessionColumn(java.lang.String)
	 */
	public boolean updateUserSessionColumn(String column) {
		String SQL_USER_SESSION_COLUMN_UPDATE = "UPDATE user_session SET "+column+" = ?  WHERE user_session_id = ?";
//		 get the connection
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = con.prepareStatement(SQL_USER_SESSION_COLUMN_UPDATE);
			ps.clearParameters();
			if(column.equals("instrument_session_id")){
				ps.setInt(1,this.getInstrumentSessionId());
			}
			else if(column.equals("user_id")){
				ps.setInt(1,this.getUserId());
			}
			else if (column.equals("timestamp")){
				ps.setTimestamp(1,this.getTimestamp());
			}
			else if (column.equals("comments")){
				ps.setString(1,this.getComments());
			}
			else if (column.equals("status")){
				ps.setString(1,this.getStatus());
			}
			else {
				return false;
			}
			
			ps.setInt(2,this.getUserSessionId());
			ps.execute();
			

		} catch (Exception e) {
			e.printStackTrace();
			return false;
		} finally {
			try {
				if (rs != null) {
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

	/* (non-Javadoc)
	 * @see org.dianexus.triceps.modules.data.UserSessionDAO#updateUserSession()
	 */
	public boolean updateUserSession() {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = con.prepareStatement(SQL_USER_SESSION_UPDATE);
			ps.clearParameters();
			ps.setInt(1, instrumentSessionId);
			ps.setInt(2, userId);
			ps.setTimestamp(3, timestamp);
			ps.setString(4, comments);
			ps.setString(5, status);
			ps.setInt(6,this.getUserSessionId());
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

	/* (non-Javadoc)
	 * @see org.dianexus.triceps.modules.data.UserSessionDAO#deleteUserSession()
	 */
	public boolean deleteUserSession() {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = con.prepareStatement(SQL_USER_SESSION_DELETE);
			ps.clearParameters();
			ps.setInt(1,userSessionId);
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

	/* (non-Javadoc)
	 * @see org.dianexus.triceps.modules.data.UserSessionDAO#setUserSessionId(int)
	 */
	public void setUserSessionId(int userSessionId) {
		// TODO Auto-generated method stub
		this.userSessionId = userSessionId;

	}

	/* (non-Javadoc)
	 * @see org.dianexus.triceps.modules.data.UserSessionDAO#getUserSessionId()
	 */
	public int getUserSessionId() {
		// TODO Auto-generated method stub
		return this.userSessionId;
	}

	/* (non-Javadoc)
	 * @see org.dianexus.triceps.modules.data.UserSessionDAO#setInstrumentSessionId(int)
	 */
	public void setInstrumentSessionId(int instrumentSessionId) {
		// TODO Auto-generated method stub
		this.instrumentSessionId = instrumentSessionId;

	}

	/* (non-Javadoc)
	 * @see org.dianexus.triceps.modules.data.UserSessionDAO#getInstrumentSessionId()
	 */
	public int getInstrumentSessionId() {
		// TODO Auto-generated method stub
		return this.instrumentSessionId;
	}

	/* (non-Javadoc)
	 * @see org.dianexus.triceps.modules.data.UserSessionDAO#setUserId(int)
	 */
	public void setUserId(int userId) {
		// TODO Auto-generated method stub
		this.userId = userId;
	}

	/* (non-Javadoc)
	 * @see org.dianexus.triceps.modules.data.UserSessionDAO#getUserId()
	 */
	public int getUserId() {
		// TODO Auto-generated method stub
		return this.userId;
	}

	/* (non-Javadoc)
	 * @see org.dianexus.triceps.modules.data.UserSessionDAO#setTimestamp(java.sql.Timestamp)
	 */
	public void setTimestamp(Timestamp timestamp) {
		// TODO Auto-generated method stub
		this.timestamp = timestamp;

	}

	/* (non-Javadoc)
	 * @see org.dianexus.triceps.modules.data.UserSessionDAO#getTimestamp()
	 */
	public Timestamp getTimestamp() {
		// TODO Auto-generated method stub
		return this.timestamp;
	}

	/* (non-Javadoc)
	 * @see org.dianexus.triceps.modules.data.UserSessionDAO#setComments(java.lang.String)
	 */
	public void setComments(String comments) {
		// TODO Auto-generated method stub
		
		this.comments = comments;

	}

	/* (non-Javadoc)
	 * @see org.dianexus.triceps.modules.data.UserSessionDAO#getComments()
	 */
	public String getComments() {
		// TODO Auto-generated method stub
		return this.comments;
	}

	/* (non-Javadoc)
	 * @see org.dianexus.triceps.modules.data.UserSessionDAO#setStatus(java.lang.String)
	 */
	public void setStatus(String status) {
		// TODO Auto-generated method stub
		this.status = status;

	}

	/* (non-Javadoc)
	 * @see org.dianexus.triceps.modules.data.UserSessionDAO#getStatus()
	 */
	public String getStatus() {
		// TODO Auto-generated method stub
		return this.status;
	}

}
