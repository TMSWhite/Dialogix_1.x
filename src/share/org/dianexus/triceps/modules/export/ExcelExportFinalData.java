package org.dianexus.triceps.modules.export;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;

public class ExcelExportFinalData extends HttpServlet {
	
	
	private final static String SQL_GET_QUERY = "SELECT * FROM  downloads WHERE download_id = ?";
	
	
	public void doGet(HttpServletRequest req,
					  HttpServletResponse res)
					  throws ServletException, IOException {
		

		
		Connection con = null;
		PreparedStatement ps = null;
		Statement stmt = null;
		ResultSet rs = null;
		String url = "";
		String id = "";
		String pw = "";
		String downloadQuery = "";
		int downLoadId = new Integer(req.getParameter("download_id")).intValue();
        try{
        	Class.forName("org.gjt.mm.mysql.Driver");
        	con = DriverManager.getConnection(url, id, pw);
            ps = con.prepareStatement(SQL_GET_QUERY);
            ps.clearParameters();
            ps.setInt(1,downLoadId);
            rs = ps.executeQuery();
            if(rs.next()){
            	downloadQuery = rs.getString(1);
            }
            stmt = con.createStatement();
            rs = stmt.executeQuery(downloadQuery);
            while(rs.next()){
            	
            }
            
        }catch(Exception e){
        	e.printStackTrace();
        }finally{
        	try{
        		if(rs != null){
        			rs.close();
        		}
        		if(stmt != null){
        			stmt.close();
        		}
        		if(ps != null){
        			ps.close();
        		}
        		if(con != null){
        			con.close();
        		}
        	}catch(Exception e){
        		e.printStackTrace();
        	}
        }
        
		
		
		
	}
	
	public void doPost(HttpServletRequest req,
			  HttpServletResponse res)
			  throws ServletException, IOException {
			  doGet(req,res);
}
					  

}
