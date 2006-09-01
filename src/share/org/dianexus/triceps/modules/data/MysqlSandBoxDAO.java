package org.dianexus.triceps.modules.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import org.dianexus.triceps.SandBoxUserBean;

public class MysqlSandBoxDAO implements SandBoxDAO{

	private int id;
	private String name;
	private String path;
	private String url;
	private int port;
	
	private final String SQL_GET_SANDBOX ="SELECT * FROM sandbox WHERE id= ?";
	private final String SQL_SET_SANDBOX ="INSERT INTO sandbox SET  name = ?, path = ?, url =? , port =?";
	private final String SQL_UPDATE_SANDBOX ="UPDATE sandbox SET  SET  name = ?, path = ?, url =? , port =? WHERE id= ?";
	private final String SQL_DELETE_SANDBOX = "DELETE sandbox WHERE id =?";
	private final String SQL_GET_LAST_INSERT_ID = "SELECT LAST_INSERT_ID()";
	
	
	
	public boolean getSandBox(int sandBoxId) {
		boolean rtn = false;
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = con.prepareStatement(SQL_GET_SANDBOX);
			ps.clearParameters();
			ps.setInt(1, sandBoxId);

			rs = ps.executeQuery();
			if(rs.next()){
				this.setId(rs.getInt(1));
				this.setName(rs.getString(2));
				this.setApplicationPath(rs.getString(3));
				this.setURL(rs.getString(4));
				this.setPort(rs.getInt(5));
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
	public boolean setSandBox() {
		boolean rtn = false;
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = con.prepareStatement(SQL_SET_SANDBOX);
			ps.clearParameters();
			
			ps.setString(1, this.getName());
			ps.setString(2, this.getApplicationPath());
			ps.setString(3,this.getURL());
			ps.setInt(4,this.getPort());
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
	public boolean deleteSandBox(int sandBoxId) {
		boolean rtn =  false;
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = con.prepareStatement(SQL_DELETE_SANDBOX);
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

	
	public boolean updateSandBox(int sandBoxId) {
		boolean rtn = false;
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = con.prepareStatement(SQL_UPDATE_SANDBOX);
			ps.clearParameters();
			ps.setString(1, this.getName());
			ps.setString(2, this.getApplicationPath());
			ps.setString(3,this.getURL());
			ps.setInt(4,this.getPort());
			ps.setInt(5, this.getId());
			
			
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

	public String getName() {
		return this.name;
	}

	public int getPort() {
		return this.port;
	}

	

	public String getURL() {
		return this.url;
	}

	
	public String getApplicationPath() {
		return this.path;
	}
	public void setId(int id) {
		this.id = id;
		
	}

	public void setName(String name) {
		this.name = name;
		
	}

	public void setPort(int port) {
		this.port = port;
		
	}

	

	public void setURL(String url) {
		this.url = url;
		
	}

	public void setApplicationPath(String path) {
		this.path = path;
	}

}
