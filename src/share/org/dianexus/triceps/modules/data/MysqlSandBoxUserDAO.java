package org.dianexus.triceps.modules.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import org.dianexus.triceps.SandBoxUserBean;

public class MysqlSandBoxUserDAO implements SandBoxUserDAO {
	
	
	

	


	private int id;
	private int user_id;
	private int sandbox_id;
	private int role_id;
	private ArrayList sandboxes;
	private ArrayList sandboxUsers;
	
	
	private final String SQL_GET_USER_SANDBOXES ="SELECT * FROM sandbox_user WHERE user_id= ?";
	private final String SQL_GET_SANDBOX_USERS ="SELECT * FROM sandbox_user WHERE sandbox_id= ?";
	private final String SQL_GET_SANDBOX_ROLE_USERS ="SELECT * FROM sandbox_user WHERE sandbox_id= ? AMD role_id=?";
	private final String SQL_SET_SANDBOX_USER ="INSERT INTO sandbox_user SET  sandbox_id = ?, user_id = ?, role_id =?";
	private final String SQL_UPDATE_SANDBOX_USER ="UPDATE sandbox_user SET  sandbox_id = ?, user_id = ?, role_id =? WHERE id = ?";
	private final String SQL_DELETE_SANDBOX_USER = "DELETE sandbox_user WHERE id =?";
	private final String SQL_GET_LAST_INSERT_ID = "SELECT LAST_INSERT_ID()";
	
	
	public boolean getSandBoxUsers(int sandbox_id) {
		boolean rtn = false;
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = con.prepareStatement(SQL_GET_SANDBOX_USERS);
			ps.clearParameters();
			ps.setInt(1, sandbox_id);

			rs = ps.executeQuery();
			while(rs.next()){
				SandBoxUserBean sub = new SandBoxUserBean();
				sub.setId(rs.getInt(1));
				sub.setSandbox_id(rs.getInt(2));
				sub.setUser_id(rs.getInt(3));
				sub.setRole_id(rs.getInt(4));
				sandboxes.add(sub);
				rtn = true;
			}



		} catch (Exception e) {

			e.printStackTrace();
			rtn =  false;

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
		return rtn;
	}
	public boolean getSandBoxUsers(int sandbox_id, int role_id) {
		boolean rtn = false;
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = con.prepareStatement(SQL_GET_SANDBOX_ROLE_USERS);
			ps.clearParameters();
			ps.setInt(1, sandbox_id);
			ps.setInt(2,role_id);  

			rs = ps.executeQuery();
			while(rs.next()){
				SandBoxUserBean sub = new SandBoxUserBean();
				sub.setId(rs.getInt(1));
				sub.setSandbox_id(rs.getInt(2));
				sub.setUser_id(rs.getInt(3));
				sub.setRole_id(rs.getInt(4));
				sandboxes.add(sub);
				rtn = true;
			}



		} catch (Exception e) {

			e.printStackTrace();
			rtn =  false;

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
		return rtn;
	}
	public boolean getSandUserSandboxes(int user_id) {
		boolean rtn = false;
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = con.prepareStatement(SQL_GET_USER_SANDBOXES);
			ps.clearParameters();
			ps.setInt(1, user_id);
			rs = ps.executeQuery();
			while(rs.next()){
				SandBoxUserBean sub = new SandBoxUserBean();
				sub.setId(rs.getInt(1));
				sub.setSandbox_id(rs.getInt(2));
				sub.setUser_id(rs.getInt(3));
				sub.setRole_id(rs.getInt(4));
				sandboxes.add(sub);
				rtn = true;
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
		return false;
	}
	public boolean setSandBoxUser() {
		boolean rtn = false;
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = con.prepareStatement(SQL_SET_SANDBOX_USER);
			ps.clearParameters();
			ps.setInt(1, this.getSandBoxId());
			ps.setInt(2, this.getSandBoxUserRoleId());
			ps.setInt(3, this.getSandBoxUserRoleId());
			
			
			ps.execute();
			// get the raw data id as last insert id 
			ps = con.prepareStatement(SQL_GET_LAST_INSERT_ID);
			rs = ps.executeQuery();
			if(rs.next()){
				this.setId((rs.getInt(1)));
				rtn = true;
			}
			else{
				rtn =  false;
			}

		} catch (Exception e) {

			e.printStackTrace();
			rtn = false;

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
		return rtn;
	}
	public boolean updateSandBoxUser() {
		boolean rtn = false;
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = con.prepareStatement(SQL_SET_SANDBOX_USER);
			ps.clearParameters();
			ps.setInt(1, this.getSandBoxId());
			ps.setInt(2, this.getSandBoxUserRoleId());
			ps.setInt(3, this.getSandBoxUserRoleId());
			ps.setInt(4, this.getId());
			
			
			ps.execute();
			
				rtn = true;
			

		} catch (Exception e) {

			e.printStackTrace();
			rtn = false;

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
		return rtn;
	}
	public boolean deleteSandBoxUser() {
		boolean rtn =  false;
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = con.prepareStatement(SQL_DELETE_SANDBOX_USER);
			ps.clearParameters();
			ps.setInt(1, this.getId());
			
			ps.execute();
			rtn = true;

		} catch (Exception e) {

			e.printStackTrace();
			rtn = false;

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
		return rtn;
	}

	public int getId() {
		return this.id;
	}

	public int getSandBoxId() {
		return this.sandbox_id;
	}

	

	public int getSandBoxUserId() {
		return this.user_id;
	}

	public int getSandBoxUserRoleId() {
		return this.role_id;
	}

	public void setId(int id) {
		this.id = id;
		
	}

	public void setSandBoxId(int sandbox_id) {
		this.sandbox_id = sandbox_id;
		
	}

	

	public void setSandBoxUserId(int user_id) {
		this.user_id = user_id;
		
	}

	public void setSandBoxUserRoleId(int role_id) {
		this.role_id = role_id;
		
	}
	public ArrayList getSandboxes() {
		return this.sandboxes;
	}
	public ArrayList getSandBoxUsers() {
		return this.sandboxUsers;
	}

}
