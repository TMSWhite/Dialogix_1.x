package org.dianexus.triceps.modules.data;

import java.util.ArrayList;

public class Reserved {
	private ArrayList names;
	private ArrayList values;
	// set this declaratively
	private int instrument_version_id;
	private static final int DB_ID = 1;
	
	public Reserved(){
		this.names = new ArrayList();
		this.values = new ArrayList();
	}
	public void add(String name,String value){
		names.add(name);
		values.add(value);
	}
	public ArrayList getNames(){
		return names;
	}
	public String get(int i){
		return (String)values.get(i);
	}
	public String get(String name){
		return (String) values.get(names.indexOf(name));
	}
	public int getInstrument_version_id() {
		return instrument_version_id;
	}
	public void setInstrument_version_id(int instrument_version_id) {
		this.instrument_version_id = instrument_version_id;
	}
	
	public boolean store(){
		DialogixDAOFactory daof = DialogixDAOFactory.getDAOFactory(DB_ID);
		InstrumentHeadersDAO ih = daof.getInstrumentHeadersDAO();
		ih.setInstrumentVersionId(this.getInstrument_version_id());
		for (int i = 0; i < names.size(); i++){
			ih.setReserved((String)names.get(i), (String)values.get(i));
		}
		return ih.setInstrumentHeaders();
	}

}
