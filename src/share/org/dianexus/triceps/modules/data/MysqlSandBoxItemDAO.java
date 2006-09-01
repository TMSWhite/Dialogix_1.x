package org.dianexus.triceps.modules.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import org.dianexus.triceps.SandBoxItem;

public class MysqlSandBoxItemDAO implements SandBoxItemDAO{

	
	private int id;
	private int sandbox_id;
	private int instrument_id;
	private int instrument_version_id;
	private ArrayList sandbox_items;
	
	private final String SQL_GET_SANDBOX_ITEM ="SELECT * FROM sandbox_item WHERE id= ?";
	private final String SQL_GET_SANDBOX_ITEMS ="SELECT * FROM sandbox_item WHERE sandbox_id= ?";
	private final String SQL_SET_SANDBOX_ITEM ="INSERT INTO sandbox_items SET  sandbox_id =?, instrument_id = ?, instrument_version_id =?";
	private final String SQL_UPDATE_SANDBOX_ITEM ="UPDATE sandbox_items SET  SET  sandbox_id =?, instrument_id = ?, instrument_version_id =?  WHERE id= ?";
	private final String SQL_DELETE_SANDBOX_ITEM = "DELETE sandbox_items WHERE id =?";
	private final String SQL_GET_LAST_INSERT_ID = "SELECT LAST_INSERT_ID()";
	
	
	
	public boolean getSandBoxItem(int id) {
		boolean rtn = false;
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = con.prepareStatement(SQL_GET_SANDBOX_ITEM);
			ps.clearParameters();
			ps.setInt(1, id);

			rs = ps.executeQuery();
			if(rs.next()){
				this.setId(rs.getInt(1));
				this.setSandBoxId(rs.getInt(2));
				this.setInstrumentId(rs.getInt(3));
				this.setInstrumentVersionId(rs.getInt(4));
				
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
	public boolean getSandBoxItems(int id) {
		boolean rtn = false;
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = con.prepareStatement(SQL_GET_SANDBOX_ITEMS);
			ps.clearParameters();
			ps.setInt(1, id);

			rs = ps.executeQuery();
			while(rs.next()){
				SandBoxItem sbi = new SandBoxItem();
				sbi.setId(rs.getInt(1));
				sbi.setSandbox_id(rs.getInt(2));
				sbi.setInstrument_id(rs.getInt(3));
				sbi.setInstrument_version_id(rs.getInt(4));
				sandbox_items.add(sbi);
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
	public boolean setSandBoxItem() {
		boolean rtn = false;
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = con.prepareStatement(SQL_SET_SANDBOX_ITEM);
			ps.clearParameters();
			
			ps.setInt(1, this.getSandBoxId());
			ps.setInt(2, this.getInstrumentId());
			ps.setInt(3,this.getInstrumentVersionId());
			
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
	public boolean updateSandBoxItem(int id) {
		boolean rtn = false;
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = con.prepareStatement(SQL_UPDATE_SANDBOX_ITEM);
			ps.clearParameters();
			ps.setInt(1, this.getSandBoxId());
			ps.setInt(2, this.getInstrumentId());
			ps.setInt(3,this.getInstrumentVersionId());
			ps.setInt(4,id);
		
			
			
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
	public boolean deleteSandBoxItem(int id) {
		boolean rtn =  false;
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = con.prepareStatement(SQL_DELETE_SANDBOX_ITEM);
			ps.clearParameters();
			ps.setInt(1, id);
			
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

	public int getInstrumentId() {
		return this.instrument_id;
	}

	public int getInstrumentVersionId() {
		return this.instrument_version_id;
	}

	

	public int getSandBoxId() {
		return this.sandbox_id;
	}

	public void setId(int id) {
		this.id = id;
		
	}

	public void setInstrumentId(int instrument_id) {
		this.instrument_id = instrument_id;
		
	}

	public void setInstrumentVersionId(int version_id) {
		this.instrument_version_id = version_id;
		
	}

	

	public void setSandBoxId(int sandbox_id) {
		this.sandbox_id = sandbox_id;
	}

	public ArrayList getSandBoxItemList(){
		return this.sandbox_items;
	}
	

}
