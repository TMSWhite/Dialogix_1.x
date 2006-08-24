package org.dianexus.triceps.modules.data;

public interface HL7OBX5DBO {
	
	
	boolean getHL7OBX5(int id);
	boolean getHL7OBX5(String code,String answer);
	boolean setHL7OBX5();
	boolean deleteHL7OBX5(int id);
	boolean updateHL7OBX5();
	
	void setId(int id);
	int getId();
	void setLoincNum(String num);
	String getLoincNum();
	void setSubmittersCode(String code);
	String getSubmittersCode();
	void setAnswerListId(int listId);
	int getAnswerListId();
	void setAnswerId(int answerId);
	int getAnswerId();
	void setSequenceNo(int seq);
	int getSequenceNo();
	void setCode(String code);
	String getCode();
	void setAnswer(String answer);
	String getAnswer();
	void setOBX5(String obx5);
	String getOBX5();
	void setOBX5umls(String obx5umls);
	String getOBX5umls();
	

}
