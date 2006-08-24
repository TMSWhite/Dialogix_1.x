package org.dianexus.triceps.modules.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class MysqlHL7OBX5DBO implements HL7OBX5DBO{

	private int id;
	private String answer;
	private int answerId;
	private int answerListId;
	private String code;
	private String loincNum;
	private String obx5;
	private String obx5umls;
	private int sequenceNo;
	private String submittersCode;
	
	
	
	private static final String SQL_GET_LAST_INSERT_ID = "SELECT LAST_INSERT_ID()";

	private static final String SQL_HL7OBX5_INSERT = "INSERT INTO mds_obx5 SET id = null, LOINC_NUM =?, SUBMITTERS_CODE=?,ANSWER_LIST_ID=?, ANSWER_ID=?, SEQUENCE_NO =?, " +
			"CODE = ?, ANSWER=?, obx5=?, obx5umls=? ";

	private static final String SQL_HL7OBX5_DELETE = "DELETE FROM mds_obx5 where id = ?";

	private static final String SQL_HL7OBX5_UPDATE = "UPDATE mds_obx5 SET LOINC_NUM =?, SUBMITTERS_CODE=?,ANSWER_LIST_ID=?,ANSWER_ID=?, SEQUENCE_NO =?, " +
			"CODE = ?, ANSWER=?, obx5=?, obx5umls=? where id =?";
	
	private static final String SQL_HL7OBX5_GET = "SELECT * FROM mds_obx5 WHERE id = ?";
	private static final String SQL_HL7OBX5_GET_ANSWER = "SELECT * FROM  mds_obx5 WHERE SUBMITTERS_CODE = ? AND CODE = ?";
	
	
	
	public boolean deleteHL7OBX5(int id) {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = con.prepareStatement(SQL_HL7OBX5_DELETE);
			ps.clearParameters();
			ps.setInt(1,id);
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
	public boolean updateHL7OBX5() {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		boolean ret = false;
		try {
			ps = con.prepareStatement(SQL_HL7OBX5_UPDATE);
			ps.clearParameters();
			
				ps.setString(1,this.loincNum);
				ps.setString(2,this.submittersCode);    
				ps.setInt(3,this.answerListId);  
				ps.setInt(4,this.answerId);         
				ps.setInt(5,this.sequenceNo);       
				ps.setString(6,this.code); 
				ps.setString(7,this.answer);     
				ps.setString(8,this.obx5);      
				ps.setString(9,this.obx5umls);  
				ps.setInt(10,id);      
				  
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
	public boolean getHL7OBX5(int id) {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean ret = false;
		try {
			ps = con.prepareStatement(SQL_HL7OBX5_GET);
			ps.clearParameters();
			ps.setInt(1,id);
  
			rs = ps.executeQuery();
			if (rs.next()) {
				this.loincNum = rs.getString(2);
				this.submittersCode = rs.getString(3);
				this.answerListId = rs.getInt(4);
				this.answerId = rs.getInt(5);
				this.sequenceNo = rs.getInt(6);
				this.code = rs.getString(7);
				this.answer = rs.getString(8);
				this.obx5 = rs.getString(9);
				this.obx5umls = rs.getString(10);
	
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
	
	public boolean getHL7OBX5(String code, String answer) {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean ret = false;
		try {
			ps = con.prepareStatement(SQL_HL7OBX5_GET_ANSWER);
			ps.clearParameters();
			ps.setString(1,code);
			ps.setString(2,answer);
  
			rs = ps.executeQuery();
			if (rs.next()) {
				this.loincNum = rs.getString(2);
				this.submittersCode = rs.getString(3);
				this.answerListId = rs.getInt(4);
				this.answerId = rs.getInt(5);
				this.sequenceNo = rs.getInt(6);
				this.code = rs.getString(7);
				this.answer = rs.getString(8);
				this.obx5 = rs.getString(9);
				this.obx5umls = rs.getString(10);
	
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
	public boolean setHL7OBX5() {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean ret = false;
		try {
			ps = con.prepareStatement(SQL_HL7OBX5_INSERT);
			ps.clearParameters();

			ps.setString(1,this.loincNum);
			ps.setString(2,this.submittersCode);    
			ps.setInt(3,this.answerListId);  
			ps.setInt(4,this.answerId);         
			ps.setInt(5,this.sequenceNo);       
			ps.setString(6,this.code); 
			ps.setString(7,this.answer);     
			ps.setString(8,this.obx5);      
			ps.setString(9,this.obx5umls);  
			        
			ps.execute();
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

	public String getAnswer() {
		return this.answer;
	}

	public int getAnswerId() {
		return this.answerId;
	}

	public int getAnswerListId() {
		return this.answerListId;
	}

	public String getCode() {
		return this.code;
	}

	

	public int getId() {
		return this.id;
	}

	public String getLoincNum() {
		return this.loincNum;
	}

	public String getOBX5() {
		return this.obx5;
	}

	public String getOBX5umls() {
		return this.obx5umls;
	}

	public int getSequenceNo() {
		return this.sequenceNo;
	}

	public String getSubmittersCode() {
		return this.submittersCode;
	}

	public void setAnswer(String answer) {
		this.answer =answer;
		
	}

	public void setAnswerId(int answerId) {
		this.answerId = answerId;
		
	}

	public void setAnswerListId(int listId) {
		this.answerListId = listId;
		
	}

	public void setCode(String code) {
		this.code = code;
		
	}

	

	public void setId(int id) {
		this.id = id;
		
	}

	public void setLoincNum(String num) {
		this.loincNum = num;
		
	}

	public void setOBX5(String obx5) {
		this.obx5 = obx5;
	}

	public void setOBX5umls(String obx5umls) {
		this.obx5umls = obx5umls;
		
	}

	public void setSequenceNo(int seq) {
		this.sequenceNo = seq;
		
	}

	public void setSubmittersCode(String code) {
		this.submittersCode = code;
		
	}

	

}
