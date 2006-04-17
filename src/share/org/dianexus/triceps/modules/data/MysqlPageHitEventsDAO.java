/**
 * 
 */
package org.dianexus.triceps.modules.data;

import java.sql.Timestamp;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;



/**
 * This CLASS provides DAO support for the page_hit_events table. It implements
 * the PageHitEventsDAO interface. There are one or more rows in this tables
 * related to the parent pagehits table which is joing by the pageHitID FK. This
 * interface is implemented in this classe to support mysql.
 * 
 */
public class MysqlPageHitEventsDAO implements PageHitEventsDAO {

	private int pageHitId;

	private int pageHitEventId;

	private int[] pageHitEventIds;

	private String varName;

	private String actionType;

	private String eventType;

	private Timestamp timestamp;

	private int duration;

	private String value1;

	private String value2;

	private static final String SQL_GET_LAST_INSERT_ID = "SELECT LAST_INSERT_ID()";

	private static final String SQL_PAGE_HIT_EVENTS_NEW = "INSERT INTO pagehitevents SET pageHitID = ? , "
			+ " varName = ? , actionType = ? , eventType = ? ,"
			+ " timestamp = ? , duration = ? , value1 = ? , value2 = ?";

	private static final String SQL_PAGE_HIT_EVENTS_DELETE = "DELETE FROM pagehitevents where pageHitEventsID = ?";

	private static final String SQL_PAGE_HIT_EVENTS_UPDATE = "UPDATE pagehitevents SET pageHitID = ? , "
			+ " varName = ? , actionType = ? , eventType = ? ,"
			+ " timestamp = ? , duration = ? , value1 = ? , value2 = ? WHERE pageHitEventsID = ?";

	private static final String SQL_PAGE_HIT_EVENTS_GET = "SELECT count(*),pageHitEventsID FROM  pagehitevents WHERE pageHitID = ?";

	private static final String SQL_PAGE_HIT_EVENT_GET = "SELECT * FROM pagehitevents WHERE pageHitEventsID = ?";

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitEventsDAO#setPageHitEvent()
	 * Inserts a new row of page hit event data into pagehitevents table
	 * Assumes data elements have been loaded via setter methods
	 * Reference to row is obtained by getlastinserid and set into pageHitEventId via setter
	 */
	public boolean setPageHitEvent() {
		// insert a page hit event into the table
		// get the connection
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = con.prepareStatement(SQL_PAGE_HIT_EVENTS_NEW);
			ps.clearParameters();
			ps.setInt(1, this.pageHitId);
			ps.setString(2, this.varName);
			ps.setString(3, this.actionType);
			ps.setString(4, this.eventType);
			ps.setTimestamp(5, this.timestamp);
			ps.setInt(6, this.duration);
			ps.setString(7, this.value1);
			ps.setString(8, this.value2);
			ps.execute();
			ps = con.prepareStatement(SQL_GET_LAST_INSERT_ID);
			rs = ps.executeQuery();
			if (rs.next()) {
				this.setPageHitEventId(rs.getInt(1));
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
	 * @see org.dianexus.triceps.modules.data.PageHitEventsDAO#getPageHitEvents(int)
	 * Get a row from the pagehitevents table by the pageHitEventId
	 * put data in local instance variables via setter methods
	 */
	public boolean getPageHitEvents(int pageHitEventId) {
		// get a row based on pageHitEventId
		// get the connection
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = con.prepareStatement(SQL_PAGE_HIT_EVENT_GET);
			ps.clearParameters();
			ps.setInt(1, pageHitEventId);
			rs = ps.executeQuery();
			if (rs.next()) {
				this.setPageHitId(rs.getInt("pageHitID"));
				this.setVarName(rs.getString("varName"));
				this.setActionType(rs.getString("actionType"));
				this.setEventType(rs.getString("eventType"));
				this.setTimeStamp(rs.getTimestamp("timestamp"));
				this.setDuration(rs.getInt("duration"));
				this.setValue1(rs.getString("value1"));
				this.setValue2(rs.getString("value2"));
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
	 * @see org.dianexus.triceps.modules.data.PageHitEventsDAO#getPageHitEventIds(int)
	 * Get a list of pageHitEventIds as an int array for a given page hit id.
	 */
	public int[] getPageHitEventIds(int pageHitId) {
		
		// array of event ids
		
		int[] ids;
		
		// get the connection
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = con.prepareStatement(SQL_PAGE_HIT_EVENTS_GET);
			ps.clearParameters();
			ps.setInt(1, pageHitEventId);
			rs = ps.executeQuery();
			rs.next();
			ids = new int[rs.getInt(1)];
			ids[0] = rs.getInt(2);
			int i = 1;
			while (rs.next()) {
					ids[i]=rs.getInt(2);
					i++;
			}

		} catch (Exception e) {
			e.printStackTrace();
			return  null;
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
		
		
		return ids;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitEventsDAO#updatePageHitEvent()
	 * Update any or all columns of a pagehitevent row based on the present local
	 * instance variables set via setters.
	 */
	public boolean updatePageHitEvent() {
//		 insert a page hit event into the table
		// get the connection
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = con.prepareStatement(SQL_PAGE_HIT_EVENTS_UPDATE);
			ps.clearParameters();
			ps.setInt(1, this.pageHitId);// should we do this??
			ps.setString(2, this.varName);
			ps.setString(3, this.actionType);
			ps.setString(4, this.eventType);
			ps.setTimestamp(5, this.timestamp);
			ps.setInt(6, this.duration);
			ps.setString(7, this.value1);
			ps.setString(8, this.value2);
			ps.setInt(9,this.getPageHitEventId());
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
	 * @see org.dianexus.triceps.modules.data.PageHitEventsDAO#updatePageHitEventColumn(java.lang.String)
	 * Update one column of a pagehitdataevent row. Set the data useing data setter method and pass the column
	 * name into this method.
	 */
	public boolean updatePageHitEventColumn(String column) {
		String SQL_PAGE_HIT_EVENTS_UPDATE = "UPDATE pagehitevents SET "+column+" = ?  WHERE pageHitEventsID = ?";
//		 get the connection
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = con.prepareStatement(SQL_PAGE_HIT_EVENTS_UPDATE);
			ps.clearParameters();
			if(column.equals("duration")){
				ps.setInt(1,this.getDuration());
			}
			else if(column.equals("varName")){
				ps.setString(1,this.getVarName());
			}
			else if(column.equals("actionType")){
				ps.setString(1,this.getActionType());
			}
			else if(column.equals("eventType")){
				ps.setString(1,this.getEventType());
			}
			else if (column.equals("timestamp")){
				ps.setTimestamp(1,this.getTimeStamp());
			}
			else if (column.equals("value1")){
				ps.setString(1,this.getValue1());
			}
			else if (column.equals("value2")){
				ps.setString(1,this.getValue2());
			}
			else {
				return false;
			}
			
			ps.setInt(2,this.getPageHitEventId());
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

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitEventsDAO#deletePageHitEvent()
	 * delete a row of the pagehitevents table based on pagehiteventid in local instance
	 * variable.
	 */
	public boolean deletePageHitEvent() {
		// delete a row
		// get the connection
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = con.prepareStatement(SQL_PAGE_HIT_EVENTS_DELETE);
			ps.clearParameters();
			ps.setInt(1,this.getPageHitEventId());
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

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitEventsDAO#setPageHitEventId(int)
	 */
	public void setPageHitEventId(int pageHitEventId) {
		// TODO Auto-generated method stub
		this.pageHitEventId = pageHitEventId;

	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitEventsDAO#getPageHitEventId()
	 */
	public int getPageHitEventId() {

		return this.pageHitEventId;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitEventsDAO#setPageHitId(int)
	 */
	public void setPageHitId(int pageHitId) {
		// TODO Auto-generated method stub
		this.pageHitId = pageHitId;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitEventsDAO#getPageHitId()
	 */
	public int getPageHitId() {
		// TODO Auto-generated method stub
		return this.pageHitId;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitEventsDAO#setVarName(java.lang.String)
	 */
	public void setVarName(String varName) {
		// TODO Auto-generated method stub
		this.varName = varName;

	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitEventsDAO#getVarName()
	 */
	public String getVarName() {
		// TODO Auto-generated method stub
		return this.varName;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitEventsDAO#setActionType(java.lang.String)
	 */
	public void setActionType(String actionType) {
		// TODO Auto-generated method stub
		this.actionType = actionType;

	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitEventsDAO#getActionType()
	 */
	public String getActionType() {
		// TODO Auto-generated method stub
		return this.actionType;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitEventsDAO#setEventType(java.lang.String)
	 */
	public void setEventType(String eventType) {
		// TODO Auto-generated method stub
		this.eventType = eventType;

	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitEventsDAO#getEventType()
	 */
	public String getEventType() {
		// TODO Auto-generated method stub
		return this.eventType;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitEventsDAO#setTimeStamp(java.sql.Timestamp)
	 */
	public void setTimeStamp(Timestamp timestamp) {
		// TODO Auto-generated method stub
		this.timestamp = timestamp;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitEventsDAO#getTimeStamp()
	 */
	public Timestamp getTimeStamp() {
		// TODO Auto-generated method stub
		return this.timestamp;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitEventsDAO#setDuration(int)
	 */
	public void setDuration(int duration) {
		// TODO Auto-generated method stub
		this.duration = duration;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitEventsDAO#getDuration()
	 */
	public int getDuration() {
		// TODO Auto-generated method stub
		return this.duration;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitEventsDAO#setValue1(java.lang.String)
	 */
	public void setValue1(String value1) {
		// TODO Auto-generated method stub
		this.value1 = value1;

	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitEventsDAO#getValue1()
	 */
	public String getValue1() {
		// TODO Auto-generated method stub
		return this.value1;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitEventsDAO#setValue2(java.lang.String)
	 */
	public void setValue2(String value2) {
		// TODO Auto-generated method stub
		this.value2 = value2;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.dianexus.triceps.modules.data.PageHitEventsDAO#getValue2()
	 */
	public String getValue2() {
		// TODO Auto-generated method stub
		return this.value2;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see java.lang.Object#hashCode()
	 */
	public int hashCode() {
		// TODO Auto-generated method stub
		return super.hashCode();
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see java.lang.Object#equals(java.lang.Object)
	 */
	public boolean equals(Object arg0) {
		// TODO Auto-generated method stub
		return super.equals(arg0);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see java.lang.Object#clone()
	 */
	protected Object clone() throws CloneNotSupportedException {
		// TODO Auto-generated method stub
		return super.clone();
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see java.lang.Object#toString()
	 */
	public String toString() {
		// TODO Auto-generated method stub
		return super.toString();
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see java.lang.Object#finalize()
	 */
	protected void finalize() throws Throwable {
		// TODO Auto-generated method stub
		super.finalize();
	}

	

}
