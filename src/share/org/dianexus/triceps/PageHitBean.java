package org.dianexus.triceps;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

public class PageHitBean {
	
	private int pageHitId;
	private int instrumentSessionId;
	private Timestamp timestamp;
	private int accessCount;
	private int groupNum;
	private int displayNum;
	private String lastAction;
	private String statusMsg;
	private int totalDuration;
	private int serverDuration;
	private int loadDuration;
	private int networkDuration;
	private int pageVacillation;
	private List eventTimingBeans = new ArrayList();
	
	public PageHitBean(){
		
	}
	
	public boolean parseSource(String src){
		int displayCount = 0;
		boolean rtn = false;
		String line;
		StringTokenizer st = new StringTokenizer(src,"\t",false);
		int i = 0;
		while(st.hasMoreTokens()){
			line = st.nextToken();
			EventTimingBean etb = new EventTimingBean().tokenizeEventString(line,displayCount);
			eventTimingBeans.add(i,etb);
			i++;
			rtn = true;
			
		}
		
		return rtn;
	}
	
	public boolean processEvents(){
		
		
		
		return false;
	}
	
	public List getEventTimingBeans() {
		return eventTimingBeans;
	}
	public EventTimingBean getEventTimingBean(int i){
		return (EventTimingBean)this.eventTimingBeans.get(i);
	}

	public void setEventTimingBeans(List eventTimingBeans) {
		this.eventTimingBeans = eventTimingBeans;
	}

	public int getAccessCount() {
		return accessCount;
	}
	public void setAccessCount(int accessCount) {
		this.accessCount = accessCount;
	}
	public int getDisplayNum() {
		return displayNum;
	}
	public void setDisplayNum(int displayNum) {
		this.displayNum = displayNum;
	}
	public int getGroupNum() {
		return groupNum;
	}
	public void setGroupNum(int groupNum) {
		this.groupNum = groupNum;
	}
	public int getInstrumentSessionId() {
		return instrumentSessionId;
	}
	public void setInstrumentSessionId(int instrumentSessionId) {
		this.instrumentSessionId = instrumentSessionId;
	}
	public String getLastAction() {
		return lastAction;
	}
	public void setLastAction(String lastAction) {
		this.lastAction = lastAction;
	}
	public int getLoadDuration() {
		return loadDuration;
	}
	public void setLoadDuration(int loadDuration) {
		this.loadDuration = loadDuration;
	}
	public int getNetworkDuration() {
		return networkDuration;
	}
	public void setNetworkDuration(int networkDuration) {
		this.networkDuration = networkDuration;
	}
	public int getPageHitId() {
		return pageHitId;
	}
	public void setPageHitId(int pageHitId) {
		this.pageHitId = pageHitId;
	}
	public int getPageVacillation() {
		return pageVacillation;
	}
	public void setPageVacillation(int pageVacillation) {
		this.pageVacillation = pageVacillation;
	}
	public int getServerDuration() {
		return serverDuration;
	}
	public void setServerDuration(int serverDuration) {
		this.serverDuration = serverDuration;
	}
	public String getStatusMsg() {
		return statusMsg;
	}
	public void setStatusMsg(String statusMsg) {
		this.statusMsg = statusMsg;
	}
	public Timestamp getTimestamp() {
		return timestamp;
	}
	public void setTimestamp(Timestamp timestamp) {
		this.timestamp = timestamp;
	}
	public int getTotalDuration() {
		return totalDuration;
	}
	public void setTotalDuration(int totalDuration) {
		this.totalDuration = totalDuration;
	}

}
