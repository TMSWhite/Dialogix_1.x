package org.dianexus.triceps.modules.data.oracle;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import org.dianexus.triceps.modules.data.DialogixMysqlDAOFactory;
import org.dianexus.triceps.modules.data.GenericDAO;

public class OracleGenericDAO implements GenericDAO {
	// TODO this is copy of mysql class, must edit for oracle
	String query;
	int lastInsertId;
	ResultSet rs = null;
	ResultSet rs2 = null;
	private static final String SQL_GET_LAST_INSERT_ID = "SELECT LAST_INSERT_ID()";
	

	public ResultSet getResultSet() {
		// TODO Auto-generated method stub
		return null;
	}

	public boolean runQuery() {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		
		boolean rtn = false;
		try {
			ps = con.prepareStatement(this.query);
			rs = ps.executeQuery();

			ps = con.prepareStatement(SQL_GET_LAST_INSERT_ID);
			ResultSet rs2 = ps.executeQuery();
			if(rs2.next()){
				this.lastInsertId = rs.getInt(1);
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
				if(rs2 != null){
					rs2.close();																																																																																																																					
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

	public int runUpdate() {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		int numRows=0;
		
		boolean rtn = false;
		try {
			ps = con.prepareStatement(this.query);
			rs = ps.executeQuery();

			ps = con.prepareStatement(SQL_GET_LAST_INSERT_ID);
			numRows =  ps.executeUpdate();
			
			
			

		} catch (Exception e) {
			e.printStackTrace();
			return 0;
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

		return numRows;
	}


	public void setQueryString(String query) {
		this.query = query;
		
	}

	public int getLastInsertId() {
		return this.lastInsertId;
	}

}
