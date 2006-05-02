package org.dianexus.triceps.modules.data;

public interface InstrumentVersionDAO {
	
	package org.dianexus.triceps.modules.data;

	public interface InstrumentVersionDAO {
		
		boolean getInstrumentVersion(int _id);
	    boolean getInstrumentVersion(String _name);
	    boolean setInstrumentVersion();
	    boolean updateInstrumentversion(String _column, String value);
	    boolean deleteInstrumentVersion(int _id);
	    int getInstrumentVersionLastInsertId();
	    
	    void setInstrumentVersionId(int id);
	    int getInstrumentVersionId();
	    void setInstrumentId(int id);
	    int getInstrumentId();
	    void setInstanceTableName(String name);
	    String getInstanceTableName();
	    void setInstrumentNotes(String notes);
	    String getInstrumentNotes();
	    void setInstrumentStatus(int status);
	    int getInstrumentStatus();

	}


}
