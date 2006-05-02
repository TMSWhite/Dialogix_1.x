package org.dianexus.triceps;

import java.sql.Timestamp;

import org.dianexus.triceps.modules.data.DialogixDAOFactory;
import org.dianexus.triceps.modules.data.InstrumentSessionDAO;

public class InstrumentSessionBean {
	int instrumentSessionId;
	Timestamp start_time;
	Timestamp end_time;
	int instrumentVersionId;
	int userId;
	int first_group=0;
	int last_group;
	String last_action;
	String last_access;
	String statusMessage;
	//TODO make declarative
	private int DBID=1;
	
	
	boolean store(){
		DialogixDAOFactory ddf = DialogixDAOFactory.getDAOFactory(DBID);
		InstrumentSessionDAO isdao = ddf.getInstrumentSessionDAO();
		isdao.setStartTime(this.getStart_time());
		isdao.setEndTime(this.getEnd_time());
		isdao.setInstrumentVersionId(this.getInstrumentVersionId());
		isdao.setUserId(this.getUserId());
		isdao.setFirstGroup(this.getFirst_group());
		isdao.setLastGroup(this.getLast_group());
		isdao.setLastAction(this.getLast_action());
		isdao.setLastAccess(this.getLast_access());
		isdao.setStatusMessage(this.getStatusMessage());
		boolean rtn = isdao.setInstrumentSession();
		this.setInstrumentSessionId(isdao.getInstrumentSessionId());
		return rtn;
	}
	boolean load(){
		return false;
	}
	boolean update(){
		DialogixDAOFactory ddf = DialogixDAOFactory.getDAOFactory(DBID);
		InstrumentSessionDAO isdao = ddf.getInstrumentSessionDAO();
		isdao.setStartTime(this.getStart_time());
		isdao.setEndTime(this.getEnd_time());
		isdao.setInstrumentVersionId(this.getInstrumentVersionId());
		isdao.setUserId(this.getUserId());
		isdao.setFirstGroup(this.getFirst_group());
		isdao.setLastGroup(this.getLast_group());
		isdao.setLastAction(this.getLast_action());
		isdao.setLastAccess(this.getLast_access());
		isdao.setStatusMessage(this.getStatusMessage());
		isdao.setInstrumentSessionId(this.getInstrumentSessionId());
		boolean rtn = isdao.updateInstrumentSession();
		
		return rtn;
	}
	boolean delete(){
		return false;
	}
	public void setGroup(int group){
		
		if( this.getFirst_group()==0){
			this.setFirst_group(group);
		}
		this.setLast_group(group);
	}
	
	
	
	public Timestamp getEnd_time() {
		return end_time;
	}
	public void setEnd_time(Timestamp end_time) {
		this.end_time = end_time;
	}
	public int getFirst_group() {
		return first_group;
	}
	public void setFirst_group(int first_group) {
		this.first_group = first_group;
	}
	public int getInstrumentSessionId() {
		return instrumentSessionId;
	}
	public void setInstrumentSessionId(int instrumentSessionId) {
		this.instrumentSessionId = instrumentSessionId;
	}
	public int getInstrumentVersionId() {
		return instrumentVersionId;
	}
	public void setInstrumentVersionId(int instrumentVersionId) {
		this.instrumentVersionId = instrumentVersionId;
	}
	public String getLast_access() {
		return last_access;
	}
	public void setLast_access(String last_access) {
		this.last_access = last_access;
	}
	public String getLast_action() {
		return last_action;
	}
	public void setLast_action(String last_action) {
		this.last_action = last_action;
	}
	public int getLast_group() {
		return last_group;
	}
	public void setLast_group(int last_group) {
		this.last_group = last_group;
	}
	public Timestamp getStart_time() {
		return start_time;
	}
	public void setStart_time(Timestamp start_time) {
		this.start_time = start_time;
	}
	public String getStatusMessage() {
		return statusMessage;
	}
	public void setStatusMessage(String statusMessage) {
		this.statusMessage = statusMessage;
	}
	public int getUserId() {
		return userId;
	}
	public void setUserId(int userId) {
		this.userId = userId;
	}
	
	
	
	
	

}
