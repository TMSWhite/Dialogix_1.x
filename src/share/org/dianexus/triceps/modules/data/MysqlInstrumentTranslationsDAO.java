package org.dianexus.triceps.modules.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class MysqlInstrumentTranslationsDAO implements InstrumentTranslationsDAO {
	
	private int ID;
	private String instrumentName;
	private int languageNum;
	private String languageName;
	private int varNum;
	private String varName;
	private String c8name;
	private char actionType;
	private String readback;
	private String actionPhrase;
	private String displayType;
	private String answerOptions;
	private String helpURL;
	private int questionLen;
	private int answerLen;
	private String questionMD5;
	private String answerMD5;
	
	private static final String SQL_GET_LAST_INSERT_ID = "SELECT LAST_INSERT_ID()";

	private static final String SQL_INSTRUMENT_TRANSLATIONS_INSERT = "INSERT INTO InstrumentTranslations VALUES(null,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

	private static final String SQL_INSTRUMENT_TRANSLATIONS_DELETE = "DELETE FROM InstrumentTranslations where pageHitEventsID = ?";

	private static final String SQL_INSTRUMENT_TRANSLATIONS_UPDATE = "UPDATE InstrumentTranslations SET InstrumentName=?,LanguageNum=?," +
			"LanguageName = ?, VarNum=?, VarName=?,c8name=?,ActionType=?,Readback=?,ActionPhrase=?,DisplayType=?,AnswerOptions=?,HelpURL =?," +
			"QuestionLen=?,AnswerLen=?,QuestionMD5=?,AnswerMD5=?";
	
	private static final String SQL_INSTRUMENT_TRANSLATIONS_GET = "SELECT * FROM InstrumentTranslations WHERE ID = ?";
	
	private static final String SQL_INSTRUMENT_TRANSLATIONS_NAME_GET = "SELECT * FROM InstrumentTranslations WHERE InstrumentName = ?";

	public boolean deleteInstrumentTranslations(int _id) {
		// TODO Auto-generated method stub
		return false;
	}
	public boolean getInstrumentTranslations(int _id) {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean ret = false;
		try {
			ps = con.prepareStatement(SQL_INSTRUMENT_TRANSLATIONS_GET);
			ps.clearParameters();
			ps.setInt(1, _id);
			
			rs = ps.executeQuery();
			if (rs.next()) {
				this.instrumentName= rs.getString(2);
				this.languageNum = rs.getInt(3);    
				this.languageName = rs.getString(4);  
				this.varNum = rs.getInt(5);         
				this.varName = rs.getString(6);       
				this.c8name = rs.getString(7);  
				StringBuffer sb = new StringBuffer();
				sb.append(rs.getString(8));
				this.actionType = sb.charAt(0);     
				this.readback =  rs.getString(9);      
				this.actionPhrase = rs.getString(10);  
				this.displayType = rs.getString(11);   
				this.answerOptions =  rs.getString(12); 
				this.helpURL = rs.getString(13);       
				this.questionLen = rs.getInt(14);    
				this.answerLen = rs.getInt(15);      
				this.questionMD5 = rs.getString(16);   
				this.answerMD5 =  rs.getString(17);     
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

	public boolean getInstrumentTranslations(String _name) {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean ret = false;
		try {
			ps = con.prepareStatement(SQL_INSTRUMENT_TRANSLATIONS_NAME_GET);
			ps.clearParameters();
			ps.setString(1, _name);
			
			rs = ps.executeQuery();
			if (rs.next()) {
				this.instrumentName= rs.getString(2);
				this.languageNum = rs.getInt(3);    
				this.languageName = rs.getString(4);  
				this.varNum = rs.getInt(5);         
				this.varName = rs.getString(6);       
				this.c8name = rs.getString(7);        
				StringBuffer sb = new StringBuffer();
				sb.append(rs.getString(8));
				this.actionType = sb.charAt(0);        
				this.readback =  rs.getString(9);      
				this.actionPhrase = rs.getString(10);  
				this.displayType = rs.getString(11);   
				this.answerOptions =  rs.getString(12); 
				this.helpURL = rs.getString(13);       
				this.questionLen = rs.getInt(14);    
				this.answerLen = rs.getInt(15);      
				this.questionMD5 = rs.getString(16);   
				this.answerMD5 =  rs.getString(17);     
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
	public boolean setInstrumentTranslations() {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		boolean ret = false;
		try {
			ps = con.prepareStatement(SQL_INSTRUMENT_TRANSLATIONS_INSERT);
			ps.clearParameters();

				ps.setString(1,this.instrumentName);
				ps.setInt(2,this.languageNum);    
				ps.setString(3,this.languageName);  
				ps.setInt(4,this.varNum);         
				ps.setString(5,this.varName);       
				ps.setString(6,this.c8name);  
				ps.setString(7,new StringBuffer(this.actionType).toString());     
				ps.setString(8,this.readback);      
				ps.setString(9,this.actionPhrase);  
				ps.setString(10,this.displayType);   
				ps.setString(11,this.answerOptions); 
				ps.setString(12,this.helpURL);      
				ps.setInt(13,this.questionLen);    
				ps.setInt(14,this.answerLen);      
				ps.setString(15,this.questionMD5);   
				ps.setString(16,this.answerMD5);     
				if(ps.execute()){
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
	public boolean updateInstrumentTranslations(String _column, String value) {
		
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		boolean ret = false;
		try {
			ps = con.prepareStatement(SQL_INSTRUMENT_TRANSLATIONS_UPDATE);
			ps.clearParameters();

				ps.setString(1,this.instrumentName);
				ps.setInt(2,this.languageNum);    
				ps.setString(3,this.languageName);  
				ps.setInt(4,this.varNum);         
				ps.setString(5,this.varName);       
				ps.setString(6,this.c8name); 
				ps.setString(7,new StringBuffer(this.actionType).toString());     
				ps.setString(8,this.readback);      
				ps.setString(9,this.actionPhrase);  
				ps.setString(10,this.displayType);   
				ps.setString(11,this.answerOptions); 
				ps.setString(12,this.helpURL);      
				ps.setInt(13,this.questionLen);    
				ps.setInt(14,this.answerLen);      
				ps.setString(15,this.questionMD5);   
				ps.setString(16,this.answerMD5);     
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

	public String getActionPhrase() {
		return this.actionPhrase;
	}

	public char getActionType() {
		return this.actionType;
	}

	public int getAnswerLen() {
		return this.answerLen;
	}

	public String getAnswerOptions() {
		return this.answerOptions;
	}

	public String[] getAnswerOptionsArray() {
		return null;
	}

	public String getC8Name() {
		return this.c8name;
	}

	public String getDisplayType() {
		return this.displayType;
	}

	public String getHelpURL() {
		return this.helpURL;
	}

	public String getInstrumentName() {
		return this.instrumentName;
	}

	

	public int getInstrumentTranslationsId() {

		return this.getInstrumentTranslationsId();
	}

	public int getInstrumentTranslationsLastInsertId() {
		return this.getInstrumentTranslationsLastInsertId();
	}

	public String getLanguageName() {
		return this.languageName;
	}

	public int getLanguageNum() {

		return this.languageNum;
	}

	public int getQuestionLen() {

		return this.questionLen;
	}

	public String getQuestionMD5() {
		return this.questionMD5;
	}

	public String getReadback() {
		return this.readback;
	}

	public String getVarName() {

		return this.varName;
	}

	public int getVarNum() {
		return this.varNum;
	}

	public void setActionPhrase(String _actionPhrase) {
		this.actionPhrase = _actionPhrase;
		
	}

	public void setActionType(char _actionType) {
		this.actionType = _actionType;
		
	}

	public void setAnswerLen(int _answerLen) {
		this.answerLen = _answerLen;
		
	}

	public void setAnswerOptions(String _answerOptions) {
		this.answerOptions = _answerOptions;
		
	}

	public void setC8Name(String _c8Name) {
		this.c8name = _c8Name;
		
	}

	public void setDisplayType(String _displayType) {
		this.displayType = _displayType;
		
	}

	public void setHelpURL(String _helpURL) {
		this.helpURL = _helpURL;
		
	}

	public void setInstrumentName(String _instrumentName) {
		this.instrumentName = _instrumentName;
		
	}

	

	public void setInstrumentTranslationsId(int _id) {
		this.ID = _id;
		
	}

	public void setLanguageName(String _languageName) {
		this.languageName = _languageName;
		
	}

	public void setLanguageNum(int _languageNum) {
		this.languageNum = _languageNum;
		
	}

	public void setQuestionLen(int _questionLen) {
		this.questionLen = _questionLen;
		
	}

	public void setQuestionMD5(String _questionMD5) {
		this.questionMD5 = _questionMD5;
		
	}

	public void setReadback(String _readback) {
		this.readback = _readback;
		
	}

	public void setVarName(String _varName) {
		this.varName = _varName;
		
	}

	public void setVarNum(int _varNum) {
		this.varNum = _varNum;
		
	}
	public String getAnswerMD5() {
		return this.answerMD5;
	}
	public void setAnswerMD5(String _answerMD5) {
		this.answerMD5 = _answerMD5;
		
	}

	

}
