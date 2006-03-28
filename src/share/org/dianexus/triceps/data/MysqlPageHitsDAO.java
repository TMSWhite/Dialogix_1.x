/**
 * 
 */
package org.dianexus.triceps.modules.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;

/**
 * @author ISTCGXL
 * 
 */
public class MysqlPageHitsDAO implements PageHitsDAO {

	private int pageVacillation;

	private int networkDuration;

	private int loadDuration;

	private int serverDuration;

	private int totalDuration;

	private String statusMessage;

	private String lastAction;

	private int displayNum;

	private int groupNum;

	private int accessCount;

	private int instrumentSessionId;

	private int pageHitId;

	private Timestamp timestamp;

	private static final String SQL_GET_LAST_INSERT_ID = "SELECT LAST_INSERT_ID()";

	private static final String SQL_PAGEHITS_NEW = "INSERT INTO pagehits SET instrument_session_id = ? , "
			+ " timeStamp = ? , accessCount = ? , groupNum = ? ,"
			+ " displayNum = ? , lastAction = ? , statusMsg = ? ,"
			+ " totalDuration = ? , serverDuration = ? , loadDuration = ? ,"
			+ " networkDuration = ? , pageVacillation = ? ";

	private static final String SQL_PAGEHITS_DELETE = "DELETE FROM pagehits WHERE pageHitId = ?";

	private static final String SQL_PAGEHITS_UPDATE = "UPDATE pagehits SET instrument_session_id = ? , "
			+ " timeStamp = ? , accessCount = ? , groupNum = ? ,"
			+ " displayNum = ? , lastAction = ? , statusMsg = ? ,"
			+ " totalDuration = ? , serverDuration = ? , loadDuration = ? ,"
			+ " networkDuration = ? , pageVacillation = ?  WHERE pageHitId = ?";

	private static final String SQL_PAGEHITS_GET = "SELECT * FROM pagehits WHERE pageHitId = ?";

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitsDAO#setPageHit()
	 */
	public boolean setPageHit() {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs =null;
		try {
			ps = con.prepareStatement(SQL_PAGEHITS_NEW);
			ps.clearParameters();
			ps.setInt(1, this.getInstrumentSessionId());
			ps.setTimestamp(2, this.getTimeStamp());
			ps.setInt(3, this.getAccessCount());
			ps.setInt(4, this.getGroupNum());
			ps.setInt(5, this.getDisplayNum());
			ps.setString(6, this.getLastAction());
			ps.setString(7, this.getStatusMessage());
			ps.setInt(8, this.getTotalDutation());
			ps.setInt(9, this.getServerDuration());
			ps.setInt(10, this.getLoadDuration());
			ps.setInt(11, this.getNetworkDuration());
			ps.setInt(12, this.getPageVacillation());

			ps.execute();
			// get the raw data id as last insert id
			ps = con.prepareStatement(SQL_GET_LAST_INSERT_ID);
			rs = ps.executeQuery();
			if (rs.next()) {
				this.setPageHitId(rs.getInt(1));
			}
			else{
				return false;
			}

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

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitsDAO#getPageHit(int)
	 */
	public boolean getPageHit(int pageHitId) {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = con.prepareStatement(SQL_PAGEHITS_GET);
			ps.clearParameters();
			ps.setInt(1, this.getPageHitId());
			rs = ps.executeQuery();
			if (rs.next()) {
				this.setInstrumentSessionId(rs.getInt(2));
				this.setTimeStamp(rs.getTimestamp(3));
				this.setAccessCount(rs.getInt(4));
				this.setGroupNum(rs.getInt(5));
				this.setDisplayNum(rs.getInt(6));
				this.setLastAction(rs.getString(7));
				this.setStatusMessage(rs.getString(8));
				this.setTotalDuration(rs.getInt(9));
				this.setServerDuration(rs.getInt(10));
				this.setLoadDuration(rs.getInt(11));
				this.setNetworkDuration(rs.getInt(12));
				this.setPageVacillation(rs.getInt(13));
			}
			else{
				return false;
				
			}

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

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitsDAO#updatePageHitColumn(java.lang.String)
	 */
	public boolean updatePageHitColumn(String column) {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;

		String SQL_PAGEHITS_UPDATE = "UPDATE pagehits SET " + column
				+ " = ?   WHERE pageHitId = ?";
		try {
			ps = con.prepareStatement(SQL_PAGEHITS_UPDATE);
			ps.clearParameters();
			if (column.equals("instrument_session_id")) {
				ps.setInt(1, this.getInstrumentSessionId());
			} else if (column.equals("timeStamp")) {
				ps.setTimestamp(1, this.getTimeStamp());
			} else if (column.equals("accessCount")) {
				ps.setInt(1, this.getAccessCount());
			} else if (column.equals("groupNum")) {
				ps.setInt(1, this.getGroupNum());
			} else if (column.equals("displayNum")) {
				ps.setInt(1, this.getDisplayNum());
			} else if (column.equals("lastAction")) {
				ps.setString(1, this.getLastAction());
			} else if (column.equals("statusMsg")) {
				ps.setString(1, this.getStatusMessage());
			} else if (column.equals("totalDuration")) {
				ps.setInt(1, this.getTotalDutation());
			} else if (column.equals("serverDuration")) {
				ps.setInt(1, this.getServerDuration());
			} else if (column.equals("loadDuration")) {
				ps.setInt(1, this.getLoadDuration());
			} else if (column.equals("networkDuration")) {
				ps.setInt(1, this.getNetworkDuration());
			} else if (column.equals("pageVacillation")) {
				ps.setInt(11, this.getPageVacillation());
			}
			ps.setInt(2, this.getPageHitId());

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

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitsDAO#updatePageHit()
	 */
	public boolean updatePageHit() {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;

		try {
			ps = con.prepareStatement(SQL_PAGEHITS_UPDATE);
			ps.clearParameters();
			ps.setInt(1, this.getInstrumentSessionId());
			ps.setTimestamp(2, this.getTimeStamp());
			ps.setInt(3, this.getAccessCount());
			ps.setInt(4, this.getGroupNum());
			ps.setInt(5, this.getDisplayNum());
			ps.setString(6, this.getLastAction());
			ps.setString(7, this.getStatusMessage());
			ps.setInt(8, this.getTotalDutation());
			ps.setInt(9, this.getServerDuration());
			ps.setInt(10, this.getLoadDuration());
			ps.setInt(11, this.getNetworkDuration());
			ps.setInt(12, this.getPageVacillation());
			ps.setInt(13, this.getPageHitId());
			
			if(ps.executeUpdate()< 1){
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
			} catch (Exception fe) {
				fe.printStackTrace();
			}
		}
		return true;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitsDAO#deletePageHit()
	 */
	public boolean deletePageHit() {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		try {
			ps = con.prepareStatement(SQL_PAGEHITS_DELETE);
			ps.clearParameters();
			ps.setInt(1, this.getPageHitId());
			if(ps.executeUpdate()<1){
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
			} catch (Exception fe) {
				fe.printStackTrace();
			}
		}
		return true;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitsDAO#setPageHitId(int)
	 */
	public void setPageHitId(int pageHitId) {
		// TODO Auto-generated method stub
		this.pageHitId = pageHitId;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitsDAO#getPageHitId()
	 */
	public int getPageHitId() {
		// TODO Auto-generated method stub
		return this.pageHitId;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitsDAO#setInstrumentSessionId(int)
	 */
	public void setInstrumentSessionId(int instrumentSessionId) {
		// TODO Auto-generated method stub
		this.instrumentSessionId = instrumentSessionId;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitsDAO#getInstrumentSessinId()
	 */
	public int getInstrumentSessionId() {
		// TODO Auto-generated method stub
		return this.instrumentSessionId;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitsDAO#setAccessCount(int)
	 */
	public void setAccessCount(int accessCount) {
		// TODO Auto-generated method stub
		this.accessCount = accessCount;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitsDAO#getAccessCount()
	 */
	public int getAccessCount() {
		// TODO Auto-generated method stub
		return this.accessCount;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitsDAO#setGroupNum(int)
	 */
	public void setGroupNum(int groupNum) {
		// TODO Auto-generated method stub
		this.groupNum = groupNum;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitsDAO#getGroupNum()
	 */
	public int getGroupNum() {
		// TODO Auto-generated method stub
		return this.groupNum;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitsDAO#setDisplayNum(int)
	 */
	public void setDisplayNum(int displayNum) {
		// TODO Auto-generated method stub
		this.displayNum = displayNum;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitsDAO#getDisplayNum()
	 */
	public int getDisplayNum() {
		// TODO Auto-generated method stub
		return this.displayNum;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitsDAO#setLastAction(java.lang.String)
	 */
	public void setLastAction(String lastAction) {
		// TODO Auto-generated method stub
		this.lastAction = lastAction;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitsDAO#getLastAction()
	 */
	public String getLastAction() {
		// TODO Auto-generated method stub
		return this.lastAction;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitsDAO#setStatusMessage(java.lang.String)
	 */
	public void setStatusMessage(String statusMessage) {
		// TODO Auto-generated method stub
		this.statusMessage = statusMessage;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitsDAO#getStatusMessage()
	 */
	public String getStatusMessage() {
		// TODO Auto-generated method stub
		return this.statusMessage;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitsDAO#setTotalDuration(int)
	 */
	public void setTotalDuration(int totalDuration) {
		// TODO Auto-generated method stub
		this.totalDuration = totalDuration;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitsDAO#getTotalDutation()
	 */
	public int getTotalDutation() {
		// TODO Auto-generated method stub
		return this.totalDuration;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitsDAO#setServerDuration(int)
	 */
	public void setServerDuration(int serverDuration) {
		// TODO Auto-generated method stub
		this.serverDuration = serverDuration;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitsDAO#getServerDuration()
	 */
	public int getServerDuration() {
		// TODO Auto-generated method stub
		return this.serverDuration;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitsDAO#setLoadDuration(int)
	 */
	public void setLoadDuration(int loadDuration) {
		// TODO Auto-generated method stub
		this.loadDuration = loadDuration;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitsDAO#getLoadDuration()
	 */
	public int getLoadDuration() {
		// TODO Auto-generated method stub
		return this.loadDuration;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitsDAO#setNetworkDuration(int)
	 */
	public void setNetworkDuration(int networkDuration) {
		// TODO Auto-generated method stub
		this.networkDuration = networkDuration;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitsDAO#getNetworkDuration()
	 */
	public int getNetworkDuration() {
		// TODO Auto-generated method stub
		return this.networkDuration;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitsDAO#setPageVacillation(int)
	 */
	public void setPageVacillation(int pageVacillation) {
		// TODO Auto-generated method stub
		this.pageVacillation = pageVacillation;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitsDAO#getPageVacillation()
	 */
	public int getPageVacillation() {
		// TODO Auto-generated method stub
		return this.pageVacillation;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitsDAO#getTimeStamp()
	 */
	public Timestamp getTimeStamp() {
		// TODO Auto-generated method stub
		return this.timestamp;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitsDAO#setTimeStamp(java.sql.Timestamp)
	 */
	public void setTimeStamp(Timestamp timestamp) {
		// TODO Auto-generated method stub
		this.timestamp = timestamp;

	}

}
