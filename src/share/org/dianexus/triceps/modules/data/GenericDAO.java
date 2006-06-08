package org.dianexus.triceps.modules.data;

import java.sql.ResultSet;

public interface GenericDAO {
	
	boolean runQuery();
	int runUpdate();
	int getLastInsertId();
	void setQueryString(String query);
	ResultSet getResultSet();

}
