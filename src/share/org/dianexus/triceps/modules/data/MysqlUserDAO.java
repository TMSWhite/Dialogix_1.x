package org.dianexus.triceps.modules.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class MysqlUserDAO implements UserDAO {
	
	
	private int id;
	private String userName;
	private String password;
	private String firstName;
	private String lastName;
	private String email;
	private String phone;
	
	private static final String SQL_GET_LAST_INSERT_ID = "SELECT LAST_INSERT_ID()";

	private static final String SQL_USERS_INSERT = "INSERT INTO users SET id = null, user_name = ?, password = ?, first_name = ?, last_name = ?, phone =?, email = ? ";
	private static final String SQL_USERS_DELETE = "DELETE FROM users where id = ?";

	private static final String SQL_USERS_UPDATE = "UPDATE users SET user_name = ?, password = ?, first_name = ?, last_name = ?, phone =?, email = ?   where id =?";
	
	private static final String SQL_USERS_GET = "SELECT * FROM users WHERE id = ?";
	
	private static final String SQL_USERS_LOGIN_GET = "SELECT * FROM users WHERE user_name = ? AND password = ?";
	

	public boolean deleteUser(int id) {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		
		boolean ret = false;
		try {
			ps = con.prepareStatement(SQL_USERS_DELETE);
			ps.clearParameters();
			ps.setInt(1,id);
			ps.execute();
			ret = true;
			

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
			} catch (Exception fe) {
				fe.printStackTrace();
			}
		}

		return ret;
	}
	public boolean getUser(int id) {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean ret = false;
		try {
			ps = con.prepareStatement(SQL_USERS_GET);
			ps.clearParameters();
			ps.setInt(1, id);
			
			rs = ps.executeQuery();
			if (rs.next()) {
				this.setUserName(rs.getString(1));
				this.setPassword(rs.getString(2));
				this.setFirstName(rs.getString(3));
				this.setLastName(rs.getString(4));
				this.setPhone(rs.getString(5));
				this.setEmail(rs.getString(6));
				
				
				ret = true;
			}
			

		} catch (Exception e) {
			e.printStackTrace();
			ret = false;
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

		return ret;
	}
	public boolean getUser(String userName, String password) {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean ret = false;
		try {
			ps = con.prepareStatement(SQL_USERS_LOGIN_GET);
			ps.clearParameters();
			ps.setString(1, userName);
			ps.setString(2,password);
			
			rs = ps.executeQuery();
			if (rs.next()) {
				this.setId(rs.getInt(1));
				this.setUserName(rs.getString(2));
				this.setPassword(rs.getString(3));
				this.setFirstName(rs.getString(4));
				this.setLastName(rs.getString(5));
				this.setPhone(rs.getString(6));
				this.setEmail(rs.getString(7));
				
				
				ret = true;
			}
			

		} catch (Exception e) {
			e.printStackTrace();
			ret = false;
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

		return ret;
	}
	public boolean setUser() {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean ret = false;
		try {
			ps = con.prepareStatement(SQL_USERS_INSERT);
			ps.clearParameters();

			ps.setString(1,this.getUserName());
			ps.setString(2,this.getPassword());    
			ps.setString(3,this.getFirstName());  
			ps.setString(4,this.getLastName());  
			ps.setString(5,this.getPhone());
			ps.setString(6,this.getEmail());
			ps.execute();
			ps = con.prepareStatement(SQL_GET_LAST_INSERT_ID);
			rs = ps.executeQuery();
			if(rs.next()){
				this.setId(rs.getInt(1));
				ret = true;
			}
			else{
				ret= false;
			}
			

		} catch (Exception e) {
			e.printStackTrace();
			ret = false;
		} finally {
			try {
				
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if(rs != null){
					rs.close();
				}
			} catch (Exception fe) {
				fe.printStackTrace();
			}
		}

		return ret;
	}
	public boolean updateUser(int id) {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		boolean ret = false;
		try {
			ps = con.prepareStatement(SQL_USERS_UPDATE);
			ps.clearParameters();
			
			ps.setString(1,this.getUserName());
			ps.setString(2,this.getPassword());    
			ps.setString(3,this.getFirstName());  
			ps.setString(4,this.getLastName());  
			ps.setString(5,this.getPhone());
			ps.setString(6,this.getEmail());      
			ps.setInt(5,this.getId()); 
				if(ps.executeUpdate()>0){
					ret = true;
				}
			

		} catch (Exception e) {
			e.printStackTrace();
			ret = false;
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

		return ret;
	}


	public String getEmail() {
		return this.email;
	}

	public String getFirstName() {
		return this.firstName;
	}

	public int getId() {
		return this.id;
	}

	public String getLastName() {
		return this.lastName;
	}

	public String getPassword() {
		return this.password;
	}

	public String getPhone() {
		return this.phone;
	}

	

	public String getUserName() {
		return this.userName;
	}

	public void setEmail(String email) {
		this.email = email;
		
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
		
	}

	public void setId(int id) {
		this.id = id;
		
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
		
	}

	public void setPassword(String password) {
		this.password = password;
		
	}

	public void setPhone(String phone) {
		this.phone = phone;
		
	}

	  

	public void setUserName(String userName) {
		this.userName = userName;
		
	}

	

}
