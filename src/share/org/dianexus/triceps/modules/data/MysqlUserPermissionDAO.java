package org.dianexus.triceps.modules.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class MysqlUserPermissionDAO implements UserPermissionDAO{
	private ArrayList userPermissions = null;
	private String comment = "";
	private int instrumentId;
	private int permissionId;
	private String role ="";
	private int userId;
	
	private static final String 	SQL_GET_USER_PERMISSIONS ="SELECT role FROM user_permissions WHERE user_id = ? AND instrument_id =0";
	private static final String 	SQL_GET_USER_PERMISSIONS_INSTRUMENT ="SELECT role FROM user_permissions WHERE user_id = ? AND instrument_id = ?";
	private static final String		SQL_GET_USER_PERMISSION="SELECT * FROM user_permissions WHERE id = ?";
	private static final String 	SQL_SET_USER_PERMISSION="INSERT INTO user_permissions SET user_id = ? , instrument_id = ?, role = ?, comment = ?";
	private static final String 	SQL_UPDATE_USER_PERMISSION = "UPDATE user_permissions SET user_id = ? , instrument_id = ?, role = ?, comment = ?";
	private static final String 	SQL_DELETE_USER_PERMISSION = "DELETE FROM user_permissions WHERE id = ?";
	
	
	
	public boolean getUserPermission(int permission_id) {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean ret = false;
		try {
			ps = con.prepareStatement(SQL_GET_USER_PERMISSION);
			ps.clearParameters();

			ps.setInt(1, permission_id);
			rs = ps.executeQuery();
			if (rs.next()) {
				this.permissionId = rs.getInt(1);
				this.userId = rs.getInt(2);
				this.instrumentId = rs.getInt(3);
				this.role = rs.getString(4);
				this.comment = rs.getString(5);
				this.userPermissions.clear();
				this.userPermissions.add(this.role);
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
	public ArrayList getUserPermissions(int user_id) {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean ret = false;
		try {
			ps = con.prepareStatement(SQL_GET_USER_PERMISSIONS);
			ps.clearParameters();

			ps.setInt(1, user_id);
			rs = ps.executeQuery();
			userPermissions.clear();
			while (rs.next()) {
				userPermissions.add(rs.getString(1));
				
				
				

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

		
        return userPermissions;
	}
	public ArrayList getUserPermissions(int user_id, int instrument_id) {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean ret = false;
		try {
			ps = con.prepareStatement(SQL_GET_USER_PERMISSIONS_INSTRUMENT);
			ps.clearParameters();

			ps.setInt(1, user_id);
			ps.setInt(2,instrument_id);
			rs = ps.executeQuery();
			userPermissions.clear();
			while (rs.next()) {
				userPermissions.add(rs.getString(1));
				
				
				

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

		
        return userPermissions;
	}
	public boolean deleteUserPermission(int id) {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean ret = false;
		try {
			ps = con.prepareStatement(SQL_DELETE_USER_PERMISSION);
			ps.clearParameters();

			ps.setInt(1, id);
			ps.execute();
			
			ret = true;
				
				

			

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
	public boolean setUserPermission() {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		
		boolean ret = false;
		try {
			ps = con.prepareStatement(SQL_SET_USER_PERMISSION);
			ps.clearParameters();
			ps.setInt(1, this.getUserId());
			ps.setInt(2,this.getInstrumentId());
			ps.setString(3,this.getRole());
			ps.setString(4, this.getComment());
			
			ps.executeUpdate();
			

		} catch (Exception e) {
			e.printStackTrace();
			ret= false;
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

		
        return ret;
	}

	public boolean updateUserPermission(int id) {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		
		boolean ret = false;
		try {
			ps = con.prepareStatement(SQL_UPDATE_USER_PERMISSION);
		
			ps.clearParameters();
			ps.setInt(1, this.getUserId());
			ps.setInt(2,this.getInstrumentId());
			ps.setString(3,this.getRole());
			ps.setString(4, this.getComment());
			
			ps.executeUpdate();
			

		} catch (Exception e) {
			e.printStackTrace();
			ret= false;
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

		
        return ret;
	}
	public String getComment() {
		return this.comment;
	}

	public int getInstrumentId() {
		return this.instrumentId;
	}

	public int getPermissionId() {
		return this.permissionId;
	}

	public String getRole() {
		return this.role;
	}

	public int getUserId() {
		return this.userId;
	}

	

	

	public void setComment(String comment) {
		this.comment = comment;
		
	}

	public void setInstrumentId(int instrument_id) {
		this.instrumentId = instrument_id;
		
	}

	public void setPermissionId(int id) {
		this.permissionId = id;
		
	}

	public void setRole(String role) {
		this.role = role;
		
	}

	public void setUserId(int user_id) {
		this.userId = user_id;
		
	}

	

}
