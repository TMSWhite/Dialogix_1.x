package org.dianexus.triceps.modules.data;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class MysqlMappingItemDAO implements MappingItemDAO,Serializable{
	
	

	private static final String SQL_GET_LAST_INSERT_ID = "SELECT LAST_INSERT_ID()";

	private static final String SQL_MAPPING_ITEM_NEW = "INSERT INTO mapping_items SET id=null, mapping_def_id= ? ,source_col = ?, source_col_name = ?," +
			"dest_col = ?, dest_col_name = ?, table_name =?, description = ? ";


	private static final String SQL_MAPPING_ITEM_DELETE = "DELETE FROM mapping_items WHERE WHERE id = ?";

	private static final String SQL_MAPPING_ITEM_UPDATE = "UPDATE mapping_items SET mapping_def_id= ? ,source_col = ?, source_col_name = ?," +
			"dest_col = ?, dest_col_name = ?, table_name=?, description = ? WHERE id = ?";

	private static final String SQL_MAPPING_ITEM_GET = "SELECT * FROM mapping_items WHERE id = ?";
	
	private static final String SQL_MAPPING_GET_INDEX = "SELECT id  FROM mapping_items WHERE mapping_def_id = ?";
	
	private static final String SQL_MAPPING_GET_TABLE_INDEX="SELECT id FROM mapping_items WHERE mapping_def_id = ? AND table_name =? ";

	
	
	private int Id;
	private int mappingId=0;
	private String description="";
	private int destinationColumn=0;
	private int sourceColumn=0;
	private String destinationColumnName="";
	private String sourceColumnName="";


	public boolean deleteMappingItem(int id) {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		boolean rtn = false;
		try {
			ps = con.prepareStatement(SQL_MAPPING_ITEM_DELETE);
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
	public boolean readMappingItem(int id) {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean rtn = false;
		try {
			ps = con.prepareStatement(SQL_MAPPING_ITEM_GET);
			ps.clearParameters();

			ps.setInt(1, id);
			rs = ps.executeQuery();
			if (rs.next()) {
				rtn = true;
				this.setMappingId(rs.getInt(1));
				this.setSourceColumn(rs.getInt(2));
				this.setSourceColumnName(rs.getString(3));
				this.setDestinationColumn(rs.getInt(4));
				this.setDestinationColumnName(rs.getString(5));
				this.setDescription(rs.getString(6));
				

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
	public boolean updateMappingItem(int id) {
		
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		boolean rtn = false;
		try {
			ps = con.prepareStatement(SQL_MAPPING_ITEM_UPDATE);
			ps.clearParameters();

			
			ps.setInt(1,this.getMappingId());
			ps.setInt(2,this.getSourceColumn());
			ps.setString(3,this.getSourceColumnName());
			ps.setInt(4,this.getDestinationColumn());
			ps.setString(5,this.getDestinationColumnName());
			ps.setString(6,this.getDescription());
			ps.setInt(7,id);
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

	public boolean writeMappingItem() {
		 //= "UPDATE mapping_tems SET mapping_def_id= ? ,source_col = ?, source_col_name = ?" +
		//"dest+col = ?, dest_col_name = ?, description = ? WHERE id = ?";
	

		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean rtn = false;
		try {
			ps = con.prepareStatement(SQL_MAPPING_ITEM_NEW);
			ps.clearParameters();

			ps.setInt(1,this.getMappingId());
			ps.setInt(2,this.getSourceColumn());
			ps.setString(3,this.getSourceColumnName());
			ps.setInt(4,this.getDestinationColumn());
			ps.setString(5,this.getDestinationColumnName());
			ps.setString(6,this.getDescription());
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
	
	public ArrayList getItemsIndex(int id) {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		ArrayList itemList = new ArrayList();
		try {
			ps = con.prepareStatement(SQL_MAPPING_GET_INDEX);
			ps.clearParameters();

			ps.setInt(1, id);
			rs = ps.executeQuery();
			while (rs.next()) {
				
				itemList.add(new Integer(rs.getInt(1)));
				
				

			}

		} catch (Exception e) {
			e.printStackTrace();
			return null;
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

		return itemList;
	}

	public ArrayList getTableItemsIndex(int id, String table_name) {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		ArrayList itemList = new ArrayList();
		try {
			ps = con.prepareStatement(SQL_MAPPING_GET_TABLE_INDEX);
			ps.clearParameters();

			ps.setInt(1, id);
			ps.setString(2,table_name);
			rs = ps.executeQuery();
			while (rs.next()) {
				
				itemList.add(new Integer(rs.getInt(1)));
				
				

			}

		} catch (Exception e) {
			e.printStackTrace();
			return null;
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

		return itemList;
	}
	public String getDescription() {
		return this.description;
	}

	public int getDestinationColumn() {
		return this.destinationColumn;
        }
	public String getDestinationColumnName() {
		return this.destinationColumnName;
	}

	public int getId() {
		return this.Id;
	}

	public int getMappingId() {
		return this.mappingId;
	}

	public int getSourceColumn() {
		return this.sourceColumn;
	}

	public String getSourceColumnName() {
		return this.sourceColumnName;
	}

	
	public void setDescription(String description) {
		this.description = description;
		
	}

	public void setDestinationColumn(int destinationCol) {
		this.destinationColumn = destinationCol;
		
	}

	public void setDestinationColumnName(String destinationColName) {
		this.destinationColumnName = destinationColName;
		
	}

	public void setId(int id) {
		this.Id = id;
		
	}

	public void setMappingId(int mappingId) {
		this.mappingId = mappingId;
		
	}

	public void setSourceColumn(int sourceCol) {
		this.sourceColumn = sourceCol;
		
	}

	public void setSourceColumnName(String sourColName) {
		this.sourceColumnName = sourColName;
		
	}
	public int[] getItemsIndex() {
		// TODO Auto-generated method stub
		return null;
	}
	public void setItemsIndex(int[] items) {
		// TODO Auto-generated method stub
		
	}
	public String getTableName() {
		// TODO Auto-generated method stub
		return null;
	}
	public void setTableName(String tableName) {
		// TODO Auto-generated method stub
		
	}

	

	

}
