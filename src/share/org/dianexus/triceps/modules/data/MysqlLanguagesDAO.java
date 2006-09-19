package org.dianexus.triceps.modules.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class MysqlLanguagesDAO implements LanguagesDAO {

	
	private static final String SQL_GET_LAST_INSERT_ID = "SELECT LAST_INSERT_ID()";

	private static final String SQL_LANGUAGES_SET = "INSERT INTO languages SET  language_name= ? ,dialogix_abbrev = ?, code = ?, desc = ? ";


	private static final String SQL_LANGUAGES_DELETE = "DELETE FROM languages WHERE id = ?";

	private static final String SQL_LANGUAGES_UPDATE = "UPDATE languages SET  language_name= ? ,dialogix_abbrev = ?, code = ?, desc = ? WHERE id =?";

	private static final String SQL_LANGUAGES_GET = "SELECT * FROM languages WHERE instrument_id = ?";
	private static final String SQL_LANGUAGES_CODE_GET = "SELECT * FROM languages WHERE  code = ?";
	
	private int id;
	private String languageName;
	private String dialogixAbbrev;
	private String code;
	private String desc;
	
	public boolean setLanguagesDAO() {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean rtn = false;
		try {
			ps = con.prepareStatement(SQL_LANGUAGES_SET);
			ps.clearParameters();
			ps.setString(1, this.getLanguageName());
			ps.setString(2,this.getDialogixAbbrev());
			ps.setString(3,this.getCode());
			ps.setString(4, this.getDesc());
			ps.execute();
			// get the raw data id as last insert id
			ps = con.prepareStatement(SQL_GET_LAST_INSERT_ID);
			rs = ps.executeQuery();
			if (rs.next()) {
				this.setId(rs.getInt(1));
				rtn = true;
			}

		} catch (Exception e) {

			e.printStackTrace();
			rtn = false;

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
		return rtn;
	}
	public boolean getLanguagesDAO() {
		// TODO Auto-generated method stub
		return false;
	}
	public boolean updateLanguagesDAO() {
		// TODO Auto-generated method stub
		return false;
	}
	public boolean deleteLanguagesDAO() {
		// TODO Auto-generated method stub
		return false;
	}

	public String getCode() {
		return this.code;
	}

	public String getDesc() {
		return this.desc;
	}

	public String getDialogixAbbrev() {
		return this.dialogixAbbrev;
	}

	public int getId() {
		return this.getId();
	}

	public String getLanguageName() {
		return this.languageName;
	}

	

	public void setCode(String code) {
		this.code = code;
		
	}

	public void setDesc(String desc) {
		this.desc = desc;
		
	}

	public void setDialogixAbbrev(String abbrev) {
		this.dialogixAbbrev = abbrev;
		
	}

	public void setId(int id) {
		this.id =  id;
		
	}

	public void setLanguageName(String name) {
		this.languageName = name;
		
	}

	

}
