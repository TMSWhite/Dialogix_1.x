package org.dianexus.triceps.modules.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

public class MysqlInstanceDataTable implements InstanceDataTable {
	private StringBuffer sql=null;
	private String instrumentName="";
	private String tableName="";
	private List infoVector=null;
	private List dataVector=null;
	private List timingVector=null;
	private String version=" ";
	private String md5="";
	private int numNodes=0;
	private boolean rtn = true;
	
	
	public boolean create() {
		
		sql = new StringBuffer();
		// get the number of nodes in the instrument
		numNodes = dataVector.size();
		// assemble the table name
		tableName = instrumentName+"_v_"+version+"_n_"+numNodes+"_"+md5;
		// make the create statement
		sql.append("CREATE TABLE `"+tableName+"` (");
		sql.append(" `ID` bigint(20) NOT NULL auto_increment");
		sql.append(", `InstrumentName` varchar(200) collate utf8_unicode_ci NOT NULL");
		sql.append(", `InstanceName` varchar(200) collate utf8_unicode_ci NOT NULL");
		sql.append(", `StartTime` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP");
		for(int i = 0;i<numNodes;i++){
			sql.append(", `"+(String)dataVector.get(i)+"` text collate utf8_unicode_ci NOT NULL");
		}
		sql.append(", `endTime` timestamp NULL default NULL ");
		sql.append(", `firstGroup` int(10) unsigned default NULL ");
		sql.append(", `lastGroup` int(11) default NULL ");
		sql.append(", `lastAction` int(10) unsigned default NULL ");
		sql.append(", `lastAccess` int(10) unsigned default NULL ");
		sql.append(", `statusMsg` text collate utf8_unicode_ci ");
		sql.append(", PRIMARY KEY  (ID) ");
		sql.append(") ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;");
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs =null;
		try {
			ps = con.prepareStatement(sql.toString());
			ps.clearParameters();
			
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

	public String getSQL() {
		
		return sql.toString();
	}

	public String getTableName() {
	
		return tableName;
	}

	public void setDataVector(List data) {
		this.dataVector = data;
		
	}

	public void setInfoVector(List info) {
		this.infoVector = info;
		
	}

	public void setMD5(String md5) {
		this.md5 = md5;
		
	}

	public void setTimingVector(List timing) {
		this.timingVector = timing;
		
	}

	public void setVersion(String version) {
		this.version = version;
		
	}

	public void setInstrumentName(String name) {
		this.instrumentName = name;
		
	}

	
}
