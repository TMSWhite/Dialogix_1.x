package org.dianexus.triceps.modules.data;

public interface LanguagesDAO {
	
	public boolean getLanguagesDAO();
	public boolean setLanguagesDAO();
	public boolean updateLanguagesDAO();
	public boolean deleteLanguagesDAO();
	
	public void setId(int id);
	public int getId();
	public void setLanguageName(String name);
	public String getLanguageName();
	public void setDialogixAbbrev(String abbrev);
	public String getDialogixAbbrev();
	public void setCode(String code);
	public String getCode();
	public void setDesc(String desc);
	public String getDesc();

}
