package org.dianexus.triceps.modules.export;

import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;

public interface ExcelExportSessionData {
	
	
	public ResultSet getData(String tablename,Timestamp start, Timestamp stop);
	public boolean buildFile(String fileName, String path);

	

}
