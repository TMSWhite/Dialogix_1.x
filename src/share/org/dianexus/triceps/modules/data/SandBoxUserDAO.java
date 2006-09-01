package org.dianexus.triceps.modules.data;

import java.util.ArrayList;

public interface SandBoxUserDAO {
	
	public boolean getSandUserSandboxes(int user_id);
	public boolean getSandBoxUsers(int sandbox_id);
	public boolean setSandBoxUser();
	public boolean updateSandBoxUser();
	public boolean deleteSandBoxUser();
	
	public void setSandBoxId(int sandbox_id);
	public int getSandBoxId();
	public void setSandBoxUserId(int user_id);
	public int getSandBoxUserId();
	public void setSandBoxUserRoleId(int role_id);
	public int getSandBoxUserRoleId();
	public void setId(int id);
	public int getId();
	public ArrayList getSandboxes();

}
