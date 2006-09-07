package org.dianexus.triceps.modules.data.oracle;

import java.sql.Connection;

import oracle.jdbc.pool.OracleDataSource;

import org.dianexus.triceps.modules.data.DialogixDAOFactory;
import org.dianexus.triceps.modules.data.HL7OBX3DBO;
import org.dianexus.triceps.modules.data.HL7OBX5DBO;
import org.dianexus.triceps.modules.data.InstanceDataTable;
import org.dianexus.triceps.modules.data.InstrumentContentsDAO;
import org.dianexus.triceps.modules.data.InstrumentDAO;
import org.dianexus.triceps.modules.data.InstrumentHeadersDAO;
import org.dianexus.triceps.modules.data.InstrumentMetaDAO;
import org.dianexus.triceps.modules.data.InstrumentSessionDAO;
import org.dianexus.triceps.modules.data.InstrumentSessionDataDAO;
import org.dianexus.triceps.modules.data.InstrumentTranslationsDAO;
import org.dianexus.triceps.modules.data.InstrumentVersionDAO;
import org.dianexus.triceps.modules.data.MappingDAO;
import org.dianexus.triceps.modules.data.MappingItemDAO;
import org.dianexus.triceps.modules.data.PageHitEventsDAO;
import org.dianexus.triceps.modules.data.PageHitsDAO;
import org.dianexus.triceps.modules.data.RawDataDAO;
import org.dianexus.triceps.modules.data.SandBoxDAO;
import org.dianexus.triceps.modules.data.SandBoxItemDAO;
import org.dianexus.triceps.modules.data.SandBoxUserDAO;
import org.dianexus.triceps.modules.data.SessionDataDAO;
import org.dianexus.triceps.modules.data.UserDAO;
import org.dianexus.triceps.modules.data.UserPermissionDAO;
import org.dianexus.triceps.modules.data.UserSessionDAO;

public class DialogixOracleDAOFactory extends DialogixDAOFactory {

	
	

	
	
	
	public static Connection createConnection() {
		Connection conn = null;
		try{
			
			OracleDataSource ods = new OracleDataSource();
			String URL = "jdbc:oracle:thin:@//omhex1:1521/alaya.omh.state.ny.us";
			ods.setURL(URL);
			ods.setUser("istcgxl");
			ods.setPassword("istcgxl1");
			conn = ods.getConnection();
			
		}catch (Exception e){
			e.printStackTrace();
			return null;
		}
		return conn;
	}
	public InstanceDataTable getInstanceDataTable() {
		
		return new OracleInstanceDataTable();
	}

	public InstrumentContentsDAO getInstrumentContentsDAO() {
		// TODO Auto-generated method stub
		return null;
	}

	public InstrumentDAO getInstrumentDAO() {
		// TODO Auto-generated method stub
		return null;
	}

	public InstrumentHeadersDAO getInstrumentHeadersDAO() {
		// TODO Auto-generated method stub
		return null;
	}

	public InstrumentMetaDAO getInstrumentMetaDAO() {
		// TODO Auto-generated method stub
		return null;
	}

	public InstrumentSessionDAO getInstrumentSessionDAO() {
		// TODO Auto-generated method stub
		return null;
	}

	public InstrumentSessionDataDAO getInstrumentSessionDataDAO() {
		// TODO Auto-generated method stub
		return null;
	}

	public InstrumentTranslationsDAO getInstrumentTranslationsDAO() {
		// TODO Auto-generated method stub
		return null;
	}

	public InstrumentVersionDAO getInstrumentVersionDAO() {
		// TODO Auto-generated method stub
		return null;
	}

	public PageHitEventsDAO getPageHitEventsDAO() {
		// TODO Auto-generated method stub
		return null;
	}

	public PageHitsDAO getPageHitsDAO() {
		// TODO Auto-generated method stub
		return null;
	}

	public RawDataDAO getRawDataDAO() {
		// TODO Auto-generated method stub
		return null;
	}

	public SessionDataDAO getSessionDataDAO() {
		// TODO Auto-generated method stub
		return null;
	}

	public UserSessionDAO getUserSessionDAO() {
		// TODO Auto-generated method stub
		return null;
	}
	public MappingDAO getMappingDAO() {
		// TODO Auto-generated method stub
		return null;
	}
	public MappingItemDAO getMappingItemDAO() {
		// TODO Auto-generated method stub
		return null;
	}
	public UserDAO getUserDAO() {
		// TODO Auto-generated method stub
		return null;
	}
	public HL7OBX3DBO getHL7OBX3DBO() {
		// TODO Auto-generated method stub
		return null;
	}
	public HL7OBX5DBO getHL7OBX5DBO() {
		// TODO Auto-generated method stub
		return null;
	}
	public UserPermissionDAO getUserPermissionDAO() {
		// TODO Auto-generated method stub
		return null;
	}
	public SandBoxDAO getSandBoxDAO() {
		// TODO Auto-generated method stub
		return null;
	}
	public SandBoxItemDAO getSandBoxItemDAO() {
		// TODO Auto-generated method stub
		return null;
	}
	public SandBoxUserDAO getSandBoxUserDAO() {
		// TODO Auto-generated method stub
		return null;
	}
}
