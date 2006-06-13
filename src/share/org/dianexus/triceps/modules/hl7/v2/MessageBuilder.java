package org.dianexus.triceps.modules.hl7.v2;

import org.dianexus.triceps.modules.data.DialogixDAOFactory;
import org.dianexus.triceps.modules.data.InstrumentSessionDAO;
import org.dianexus.triceps.modules.data.InstrumentSessionDataDAO;
import org.dianexus.triceps.modules.data.InstrumentVersionDAO;

public class MessageBuilder {
	public int DBID =1; // convert to property
	Message message;
	PID pid;
	MSH msh;
	OBR4 obr;
	OBX3 obx3;
	OBX5 obx5;
	DialogixDAOFactory daof;
	String tableName;
	
	public MessageBuilder(int instrumentVersionId, int instrumentSessionId){
		// get DAO Factory
		daof = DialogixDAOFactory.getDAOFactory(DBID);
		//get DAO's for version, session and session data
		InstrumentVersionDAO iv = daof.getInstrumentVersionDAO();
		iv.getInstrumentVersion(instrumentVersionId);
		tableName=iv.getInstanceTableName();
		InstrumentSessionDAO is = daof.getInstrumentSessionDAO();
		is.getInstrumentSession(instrumentSessionId);
		InstrumentSessionDataDAO isd = daof.getInstrumentSessionDataDAO();
		isd.getInstrumentSessionDataDAO(tableName,1);// fix this
		
		
		
	}
	public boolean buildMessage(){
		return false;
	}
	public Message getMessage(){
		return message;
	}
	public String  toString(){
		return message.toString();
	}
	public MSH getMsh() {
		return msh;
	}
	public void setMsh(MSH msh) {
		this.msh = msh;
	}
	public PID getPid() {
		return pid;
	}
	public void setPid(PID pid) {
		this.pid = pid;
	}
	
}
