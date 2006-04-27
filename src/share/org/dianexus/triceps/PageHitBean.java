package org.dianexus.triceps;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import org.dianexus.triceps.modules.data.DialogixDAOFactory;
import org.dianexus.triceps.modules.data.PageHitEventsDAO;
import org.dianexus.triceps.modules.data.PageHitsDAO;
import org.dianexus.triceps.modules.data.RawDataDAO;

public class PageHitBean {

	private int pageHitId=0;

	private int instrumentSessionId=0;

	private Timestamp timestamp;

	private int accessCount=0;

	private int groupNum=0;

	private int displayNum=0;

	private String lastAction="";

	private String statusMsg="";

	private int totalDuration=0;

	private int serverDuration=0;

	private int loadDuration=0;

	private int networkDuration=0;

	private int pageVacillation=0;
	
	private int currentQuestionIndex=0;
	
	private int numQuestions = 0;
	

	private long receivedRequest;
	private long sentResponse;
	

	private List eventTimingBeans = new ArrayList();
	private List questionTimingBeans = new ArrayList();

	// TODO change this to declarative
	int DBID = 1;

	public PageHitBean() {

	}

	public boolean parseSource(String src) {
		
		int displayCount = 0;
		boolean rtn = false;
		String line;
		// break src string up into lines using "\t" as eol character
		StringTokenizer st = new StringTokenizer(src, "\t", false);
		int i = 0;
		while (st.hasMoreTokens()) {
			line = st.nextToken();
			// send each line to a new bean
			EventTimingBean etb = new EventTimingBean().tokenizeEventString(line, displayCount);
			// add bean to array
			eventTimingBeans.add(i, etb);
			i++;
			// at least one line processed so return true
			rtn = true;

		}
		
		return rtn;
	}

	public boolean processEvents() {

		int serverTime = 0;
		int loadTime = 0;
		int networkTime = 0;
		int pageVacillation = 0;
		int responseLatency = 0;
		int responseDuration = 0;
		int serverSendTS = 0;
		int serverReceiveTS = 0;
		int clientReceiveTS = 0;
		int clientSendTS = 0;
		int displayTime = 0;
		int loadTS = 0;
		int lastTS = 0;
		int turnaroundTime = 0;
		int focus=0;
		int blur=0;
		int change =0;
		int click = 0;
		int mouseup =0;
		int keypress=0;
		EventTimingBean etb;
		QuestionTimingBean qtb= new QuestionTimingBean();
		String currentVarName="";
		int questionRef = 0;
		
		for (int i = 0; i < eventTimingBeans.size(); i++) {
			etb = (EventTimingBean) eventTimingBeans.get(i);
	
			//check to see if question is changed
			if(!etb.getVarName().equals(currentVarName) && !etb.getVarName().equals("") && !etb.equals(null)){
				//finished with previous question
				//populate QuestionTimingBean with data
				qtb.setBlur(blur);
				qtb.setFocus(focus);
				qtb.setChange(change);
				qtb.setClick(click);
				qtb.setMouseup(mouseup);
				qtb.setKeypress(keypress);
				// add to array
				questionTimingBeans.add(questionRef,qtb);
				//clear previous values
				focus=0;
				blur=0;
				change =0;
				click = 0;
				mouseup =0;
				keypress=0;
				// new bean
				qtb = new QuestionTimingBean();
				questionRef ++;
				currentVarName = etb.getVarName();
				
			}

			// calculate total duration
			totalDuration = etb.getDuration();
			this.setLastAction(etb.getActionType());
			if (etb.getEventType().equals("load")) {
				// total page rendering time
				// (from time received HTML to time it was displayed to user)
				loadTime =  etb.getDuration();
				// client side timestamp when received HTML
				clientReceiveTS = new Long(etb.getTimestamp().getTime()).intValue();

			} 
			if (etb.getActionType().equals("submit")
					&& etb.getEventType().equals("click")) {
				displayTime = etb.getDuration();
				clientSendTS = new Long(etb.getTimestamp().getTime()).intValue();

			}
			if(etb.getEventType().equals("focus")){
				focus++;
				
			}
			if(etb.getEventType().equals("blur")){
				blur++;
			}
			if(etb.getEventType().equals("change")){
				change++;
			}
			if(etb.getEventType().equals("click")){
				click++;
			}
			if(etb.getEventType().equals("keypress")){
				keypress++;
			}
			if(etb.getEventType().equals("mouseup")){
				mouseup++;
			}
			lastTS = new Long(etb.getTimestamp().getTime()).intValue();
		}
		this.setServerDuration(new Long(sentResponse - receivedRequest).intValue());
		this.setTotalDuration(displayTime);
		this.setLoadDuration(loadTime);
		this.setNetworkDuration(displayTime - this.getServerDuration());
		this.setPageVacillation(focus);
		
		
		



		return true;
	}

	public boolean store() {
		DialogixDAOFactory ddf = DialogixDAOFactory.getDAOFactory(DBID);
		PageHitsDAO phdao = ddf.getPageHitsDAO();
		//TODO find out where to get real value
		
		
		this.setStatusMsg("OK");
		phdao.setAccessCount(this.getAccessCount());
		phdao.setDisplayNum(this.getDisplayNum());
		phdao.setGroupNum(this.getGroupNum());
		phdao.setInstrumentSessionId(this.getInstrumentSessionId());
		phdao.setServerDuration(this.getServerDuration());
		phdao.setTotalDuration(this.getTotalDuration());
		phdao.setLastAction(this.getLastAction());
		phdao.setLoadDuration(this.getLoadDuration());
		phdao.setNetworkDuration(this.getNetworkDuration());
		phdao.setPageHitId(this.getPageHitId());
		phdao.setPageVacillation(this.getPageVacillation());
		phdao.setStatusMessage(this.getStatusMsg());
		boolean res = phdao.setPageHit();
		this.pageHitId = phdao.getPageHitId();
		
		// now that we have the pageHitId we can save the individual evenTimingBeans
		for(int i =0; i < eventTimingBeans.size() ;i++){
			// grab a bean off the array
			EventTimingBean evbean = (EventTimingBean)eventTimingBeans.get(i);
			//set page hit id 
			evbean.setPageHitId(this.pageHitId);
			//write to the database
			evbean.store();
		}

		return res;
	}
	public void setNumQuestions(int num){
		this.numQuestions=num;
	}
	public int getNumQuestions(){
		return this.numQuestions;
	}
	public void setCurrentQuestionIndex(int index){
		this.currentQuestionIndex = index;
	}
	public int getCurrentQuestonIndex(){
		return this.currentQuestionIndex;
	}
	public void setReceivedRequest(){
		
		receivedRequest = System.currentTimeMillis();
	}
	public long getReceivedRequest(){
		return this.receivedRequest;
	}
	public void setSentResponse(){
		sentResponse = System.currentTimeMillis();
	}
	public long getSentResponse(){
		return this.sentResponse;
	}

	public List getEventTimingBeans() {
		return eventTimingBeans;
	}

	public EventTimingBean getEventTimingBean(int i) {
		return (EventTimingBean) this.eventTimingBeans.get(i);
	}

	public void setEventTimingBeans(List eventTimingBeans) {
		this.eventTimingBeans = eventTimingBeans;
	}
	public  List getQuestionTimingBeans(){
		return questionTimingBeans;
	}
	public QuestionTimingBean getQuestionTimingBean(int i){
		if(this.questionTimingBeans.size()>0){
		return (QuestionTimingBean) this.questionTimingBeans.get(i);
		}else{
			return null;
		}
	}
	public void setQuestionTimingBeans(List questionTimingBeans){
		this.questionTimingBeans = questionTimingBeans;
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
