package org.dianexus.triceps.modules.data.oracle;
import java.sql.*;
import oracle.jdbc.*;
import oracle.jdbc.pool.*;
import oracle.sql.*;
public class TestConn {
	
	Connection conn;
	public void makeConn(){
	
	try{
		
		OracleDataSource ods = new OracleDataSource();
		String URL = "jdbc:oracle:thin:@//omhex1:1521/alaya.omh.state.ny.us";
		//String URL = "jdbc:oracle://omhex1:1521/";
		ods.setURL(URL);
		ods.setUser("istcgxl");
		ods.setPassword("istcgxl1");
		conn = ods.getConnection();
		
	}catch (Exception e){
		e.printStackTrace();
	}


		
	}
	public void insert(String sql){
		try{
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.execute();
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}
		
		
}
