package org.dianexus.triceps.modules.data;

import java.util.ArrayList;

public interface UserPermissionDAO {
	
	public ArrayList getUserPermissions(int user_id);
	public ArrayList getUserPermissions(int user_id, int instrument_id);
	public boolean getUserPermission(int user_id);
	public boolean setUserPermission();
	public boolean deleteUserPermission(int id);
	public boolean updateUserPermission(int id);
	
	
	public void setPermissionId(int id);
	public int getPermissionId();
	public void setUserId(int user_id);
	public int getUserId();
	public void setInstrumentId (int instrument_id);
	public int getInstrumentId();
	public void setRole(String role);
	public String getRole();
	public void setComment(String comment);
	public String getComment();

}
