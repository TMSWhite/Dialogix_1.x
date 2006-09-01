package org.dianexus.triceps.modules.data;

public interface SandBoxItemDAO {
	
	public boolean setSandBoxItem();
	public boolean updateSandBoxItem(int id);
	public boolean getSandBoxItem( int id);
	public boolean getSandBoxItems( int id);
	public boolean deleteSandBoxItem(int id);
	
	public void setId(int id);
	public int getId();
	public void setSandBoxId(int sandbox_id);
	public int getSandBoxId();
	public void setInstrumentId(int instrument_id);
	public int getInstrumentId();
	public void setInstrumentVersionId(int version_id);
	public int getInstrumentVersionId();
	

}
