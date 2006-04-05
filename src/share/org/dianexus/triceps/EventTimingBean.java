package org.dianexus.triceps;

import java.sql.Timestamp;
import java.util.StringTokenizer;
import java.util.Vector;
import java.sql.Date;

import org.dianexus.triceps.modules.data.*;



public class EventTimingBean {
	private int displayCount;
	private String src;
	private String varName;
	private String actionType;
	private String eventType;
	private Timestamp timestamp;
	private int duration;
	private String value1;
	private String value2;
	private StringTokenizer str;
	private String token;
	private int tokenCount;
	private StringBuffer sb;
	// TODO make this declarative
	private int DBID = 1;
	
	

	public EventTimingBean(){
	
	}
	
	public EventTimingBean tokenizeEventString(String src,int displayCount){
		this.setDisplayCount(displayCount);
		str = new StringTokenizer(src,",",false);
		tokenCount=0;
		while (str.hasMoreTokens()){
			token = str.nextToken();
			switch (tokenCount){
			case 0:{
				this.setVarName(token);
				break;
			}
			case 1:{
				this.setActionType(token);
				break;
			}
			case 2:{
				this.setEventType(token);
				break;
			}
			case 3:{
				int ts = new Integer(token).intValue();
				Date d = new Date(ts);
				Timestamp tms = new Timestamp(d.getTime());
				this.setTimestamp(tms);
				break;
			}
			case 4: {
				this.setDuration(new Integer(token).intValue());
				break;
			}
			case 5:{
				this.setValue1(token);
				break;
			}
			case 6:{
				this.setValue2(token);
				break;
			}
			default:{
				this.setValue2(this.getValue2()+token);
			}
			
			}
			System.out.println("token is "+token+" for line "+tokenCount);
			tokenCount++;
		}
		
		
		return this;
	}
	public boolean store(){
		DialogixDAOFactory ddf = DialogixDAOFactory.getDAOFactory(DBID);
		PageHitEventsDAO phedao = ddf.getPageHitEventsDAO();
		phedao.setVarName(this.getVarName());
		phedao.setActionType(this.getActionType());
		phedao.setEventType(this.getEventType());
		phedao.setTimeStamp(this.getTimestamp());
		phedao.setDuration(this.getDuration());
		phedao.setValue1(this.getValue1());
		phedao.setValue2(this.getValue2());
		phedao.setPageHitEvent();
		
	return phedao.setPageHitEvent();
	}
	
	public String getVarName() {
		return varName;
	}

	public void setVarName(String varName) {
		this.varName = varName;
	}

	public String getActionType() {
		return actionType;
	}

	public void setActionType(String actionType) {
		this.actionType = actionType;
	}

	public int getDuration() {
		return duration;
	}

	public void setDuration(int duration) {
		this.duration = duration;
	}

	public String getEventType() {
		return eventType;
	}

	public void setEventType(String eventType) {
		this.eventType = eventType;
	}

	public Timestamp getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(Timestamp timestamp) {
		this.timestamp = timestamp;
	}

	public String getValue1() {
		return value1;
	}

	public void setValue1(String value1) {
		this.value1 = value1;
	}

	public String getValue2() {
		return value2;
	}

	public void setValue2(String value2) {
		this.value2 = value2;
	}

	public int getDisplayCount() {
		return displayCount;
	}

	public void setDisplayCount(int displayCount) {
		this.displayCount = displayCount;
	}

}
