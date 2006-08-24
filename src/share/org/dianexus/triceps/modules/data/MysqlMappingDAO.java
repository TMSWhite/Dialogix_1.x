package org.dianexus.triceps.modules.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class MysqlMappingDAO implements MappingDAO{
	
	private static final String SQL_GET_LAST_INSERT_ID = "SELECT LAST_INSERT_ID()";

	private static final String SQL_MAPPING_NEW = "INSERT INTO mapping_defs SET  id=null, map_name = ? ,map_description = ?, map = ?";

	private static final String SQL_MAPPING_DELETE = "DELETE FROM mapping_defs WHERE id = ?";

	private static final String SQL_MAPPING_UPDATE = "UPDATE mapping_defs SET  map_name = ? ,map_description = ?, map = ? WHERE id = ?";

	private static final String SQL_MAPPING_LOAD = "SELECT * FROM mapping_defs WHERE id = ?";
	private static final String SQL_MAPPING_NAME_LOAD = "SELECT * FROM mapping_defs WHERE map_name = ?";
	
	
	private int Id;
	private String map="";
	private String description="";
	private String name="";
	
	public boolean loadMapping(String name) {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean rtn = false;
		try {
			ps = con.prepareStatement(SQL_MAPPING_NAME_LOAD);
			ps.clearParameters();

			ps.setString(1, name);
			rs = ps.executeQuery();
			if (rs.next()) {
				rtn = true;
				this.setId(rs.getInt(1));
				this.setMapName(rs.getString(2));
				this.setMapDescription(rs.getString(3));
				this.setMap(rs.getString(4));

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
	public boolean loadMapping(int id) {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean rtn = false;
		try {
			ps = con.prepareStatement(SQL_MAPPING_LOAD);
			ps.clearParameters();

			ps.setInt(1, id);
			rs = ps.executeQuery();
			if (rs.next()) {
				rtn = true;
				this.setMapName(rs.getString(2));
				this.setMapDescription(rs.getString(3));
				this.setMap(rs.getString(4));

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
	public boolean deleteMapping(int id) {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		boolean rtn = false;
		try {
			ps = con.prepareStatement(SQL_MAPPING_DELETE);
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
				if (con != null) {
					con.close();
				}
			} catch (Exception ee) {
				ee.printStackTrace();
			}

		}

		return rtn;
	}
	public boolean storeMapping() {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs =null;
		boolean rtn = false;
		try {
			ps = con.prepareStatement(SQL_MAPPING_NEW);
			ps.clearParameters();

			ps.setString(1, this.getMapName());
			ps.setString(2, this.getMapDescription());
			ps.setString(3, this.getMap());
			ps.executeUpdate();
			ps = con.prepareStatement(SQL_GET_LAST_INSERT_ID);
			rs = ps.executeQuery();
			if(rs.next()){
				this.setId(rs.getInt(1));
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
			} catch (Exception ee) {
				ee.printStackTrace();
			}

		}

		return rtn;
	}

	public boolean updateMapping(int id) {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean rtn = false;
		try {
			ps = con.prepareStatement(SQL_MAPPING_NEW);
			ps.clearParameters();

			ps.setString(1, this.getMapName());
			ps.setString(2, this.getMapDescription());
			ps.setString(3, this.getMap());
			ps.setInt(4,id);
			ps.executeUpdate();

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
	public int getId() {
		return this.Id;
	}

	public String getMap() {
		return this.map;
	}

	public String getMapDescription() {
		return this.description;
	}

	public String getMapName() {
		return this.name;
	}

	public void setId(int id) {
		this.Id =id;
		
	}

	public void setMap(String map) {
		this.map = map;
		
	}

	public void setMapDescription(String mapDescription) {
		this.description = mapDescription;
		
	}

	public void setMapName(String mapName) {
		this.name = mapName;
		
	}

	

}
