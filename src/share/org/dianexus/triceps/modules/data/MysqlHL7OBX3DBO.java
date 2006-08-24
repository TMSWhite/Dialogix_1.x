package org.dianexus.triceps.modules.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class MysqlHL7OBX3DBO implements HL7OBX3DBO{

	private int id;
	private String submittersCode;
	private String OBX3;
	private String OBX3umls;
	private String loincNum;
	
	private static final String SQL_GET_LAST_INSERT_ID = "SELECT LAST_INSERT_ID()";

	private static final String SQL_HL7OBX3_INSERT = "INSERT INTO mds_obx3 SET id = null, SUBMITTERS_CODE = ?,LOINC_NUM =?, obx3=?, obx3umls=? ";
	private static final String SQL_HL7OBX3_DELETE = "DELETE FROM mds_obx3 where id = ?";

	private static final String SQL_HL7OBX3_UPDATE = "UPDATE mds_obx3 SET SUBMITTERS_CODE = ?, LOINC_NUM =?, obx3=?, obx3umls=?  where id =?";
	
	private static final String SQL_HL7OBX3_GET = "SELECT * FROM mds_obx3 WHERE id = ?";
	private static final String  SQL_HL7OBX3_GET_SUBMITTER_CODE ="SELECT * FROM mds_obx3 WHERE SUBMITTERS_CODE = ?";
	
	
	
	public boolean deleteHL7OBX3(int id) {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		
		boolean ret = false;
		try {
			ps = con.prepareStatement(SQL_HL7OBX3_DELETE);
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
	public boolean updateHL7OBX3() {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		boolean ret = false;
		try {
			ps = con.prepareStatement(SQL_HL7OBX3_UPDATE);
			ps.clearParameters();
			
				ps.setString(1,this.submittersCode);
				ps.setString(2,this.loincNum);    
				ps.setString(3,this.OBX3);  
				ps.setString(4,this.OBX3umls);         
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

	public boolean getHL7OBX3(int id) {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean ret = false;
		try {
			ps = con.prepareStatement(SQL_HL7OBX3_GET);
			ps.clearParameters();
			ps.setInt(1, id);
			
			rs = ps.executeQuery();
			if (rs.next()) {
				this.setSubmittersCode(rs.getString(2));
				this.setLoincNum(rs.getString(3));
				this.setOBX3(rs.getString(4));
				this.setOBX3Umls(rs.getString(5));
				
				
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
	public boolean getHL7OBX3(String  code) {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean ret = false;
		try {
			ps = con.prepareStatement(SQL_HL7OBX3_GET_SUBMITTER_CODE);
			ps.clearParameters();
			ps.setString(1, code);
			
			rs = ps.executeQuery();
			if (rs.next()) {
				this.setSubmittersCode(rs.getString(2));
				this.setLoincNum(rs.getString(3));
				this.setOBX3(rs.getString(4));
				this.setOBX3Umls(rs.getString(5));
				
				
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
	public boolean setHL7OBX3() {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean ret = false;
		try {
			ps = con.prepareStatement(SQL_HL7OBX3_INSERT);
			ps.clearParameters();

			ps.setString(1,this.submittersCode);
			ps.setString(2,this.loincNum);    
			ps.setString(3,this.OBX3);  
			ps.setString(4,this.OBX3umls);     
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

	public String getLoincNum() {
		return this.loincNum;
	}

	public String getOBX3() {
		return this.OBX3;
	}

	public String getOBX3Umls() {
		return this.OBX3umls;
	}

	public String getSubmittersCode() {
		return this.submittersCode;
	}

	

	public void setLoincNum(String num) {
		this.loincNum = num;
		
	}

	public void setOBX3(String OBX3) {
		this.OBX3 = OBX3;
		
	}

	public void setOBX3Umls(String OBX3umls) {
		this.OBX3umls = OBX3umls;
		
	}

	public void setSubmittersCode(String code) {
		this.submittersCode = code;
		
	}
	public int getId() {
		return this.id;
	}
	public void setId(int id) {
		this.id = id;
		
	}

	
}
