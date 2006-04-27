package src.share.org.dianexus.triceps.modules.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class MysqlInstrumentVersionDAO implements InstrumentVersionDAO{
	
	private static final String SQL_GET_LAST_INSERT_ID = "SELECT LAST_INSERT_ID()";

	private static final String SQL_INSTRUMENT_VERSION_NEW = "INSERT INTO instrument_version SET instrument_id = ? , "
			+ " instance_table_name= ? , instrument_notes = ? , instrument_status = ? ";


	private static final String SQL_INSTRUMENT_VERSION_DELETE = "DELETE FROM instrument_version WHERE instrument_version_id = ?";

	private static final String SQL_INSTRUMENT_VERSION_UPDATE = "UPDATE instrument_version SET instrument_id = ? , "
			+ " instance_table_name= ? , instrument_notes = ? , instrument_status = ? ";

	private static final String SQL_INSTRUMENT_VERSION_GET = "SELECT * FROM instrument_version WHERE instrument_version_id = ?";
	
	private String instrumentNotes;
	private String instanceTableName;
	private int instrumentId;
	private int instrumentStatus;
	private int instrumentVersionId;
	
	public boolean setInstrumentVersion() {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = con.prepareStatement(SQL_INSTRUMENT_VERSION_NEW);
			ps.clearParameters();
			ps.setInt(1, this.getInstrumentId());
			ps.setString(2, this.getInstanceTableName());
			ps.setString(3, this.getInstrumentNotes());;
			ps.setInt(4, this.getInstrumentStatus());
			
			
			
			ps.execute();
			// get the raw data id as last insert id 
			ps = con.prepareStatement(SQL_GET_LAST_INSERT_ID);
			rs = ps.executeQuery();
			if(rs.next()){
				this.setInstrumentVersionId(rs.getInt(1));
			}

		} catch (Exception e) {

			e.printStackTrace();
			return false;

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
		return false;
	}
	public boolean getInstrumentVersion(int _id) {
		// TODO Auto-generated method stub
		return false;
	}

	public boolean getInstrumentVersion(String _name) {
		// TODO Auto-generated method stub
		return false;
	}

	public boolean deleteInstrumentVersion(int _id) {
		// TODO Auto-generated method stub
		return false;
	}
	public boolean updateInstrumentversion(String _column, String value) {
		// TODO Auto-generated method stub
		return false;
	}

	public String getInstrumentNotes() {
		
		return this.instrumentNotes;
	}

	public String getInstanceTableName() {
		
		return this.instanceTableName;
	}

	public int getInstrumentId() {
		
		return this.instrumentId;
	}

	public int getInstrumentStatus() {
		
		return this.instrumentStatus;
	}

	

	public int getInstrumentVersionId() {
		
		return this.instrumentVersionId;
	}

	public int getInstrumentVersionLastInsertId() {
		// TODO Auto-generated method stub
		return 0;
	}

	public void setInstrumentNotes(String notes) {
		this.instrumentNotes = notes;
		
	}

	public void setInstanceTableName(String name) {
		this.instanceTableName = name;
		
	}

	public void setInstrumentId(int id) {
		this.instrumentId = id;
		
	}

	public void setInstrumentStatus(int status) {
		this.instrumentStatus = status;
		
	}


	public void setInstrumentVersionId(int id) {
		/this.instrumentVersionId = id;
		
	}

	
	

}
