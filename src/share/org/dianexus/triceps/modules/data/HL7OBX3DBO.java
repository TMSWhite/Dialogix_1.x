package org.dianexus.triceps.modules.data;

public interface HL7OBX3DBO {
	
	boolean getHL7OBX3(int id);
	boolean getHL7OBX3(String code);
	boolean setHL7OBX3();
	boolean deleteHL7OBX3(int id);
	boolean updateHL7OBX3();
	
	void setSubmittersCode(String code);
	String getSubmittersCode();
	void setLoincNum(String num);
	String getLoincNum();
	void setOBX3(String OBX3);
	String getOBX3();
	void setOBX3Umls(String OBX3umls);
	String getOBX3Umls();
	void setId(int id);
	int getId();

}
