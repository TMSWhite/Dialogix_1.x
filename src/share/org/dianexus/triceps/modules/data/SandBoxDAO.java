package org.dianexus.triceps.modules.data;

public interface SandBoxDAO {
	
	public boolean setSandBox();
	public boolean getSandBox(int sandBoxId);
	public boolean updateSandBox(int sandBoxId);
	public boolean deleteSandBox(int sandBoxId);
	
	public void setId(int id);
	public int getId();
	public void setName(String name);
	public String getName();
	public void setApplicationPath(String path);
	public String getApplicationPath();
	public void setURL(String url);
	public String getURL();
	public void setPort(int port);
	public int getPort();

}
