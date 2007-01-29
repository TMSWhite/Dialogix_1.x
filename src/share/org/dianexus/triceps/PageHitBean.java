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
	
	
	// variables for software state machine
	private static final int LATENCY_EMPTY = 0;
	private static final int LATENCY_START= 1;
	private static final int LATENCY_FINISH = 2;
	private static final int DURATION_EMPTY = 0;
	private static final int DURATION_START = 1;
	private static final int DURATION_FINISH = 2;
	
	// init variables
	private int latencyState = LATENCY_EMPTY;
	private int durationState = DURATION_EMPTY;

	private int pageHitId=0;

	private int instrumentSessionId=0;

	private Timestamp timestamp = new Timestamp (System.currentTimeMillis());

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
	private long lastRecievedRequest;
	private long sentResponse;
	

	private List eventTimingBeans = new ArrayList();
	private List questionTimingBeans = new ArrayList();

	// TODO change this to declarative
	int DBID = 1;

	public PageHitBean() {

	}

	/**
	 * Takes parameter src which contains the event timing data from the 
	 * http request parameter EVENT_TIMINGS and creates an event timing bean for each
	 * event. Event timing beans are stored in the ArrayList eventTimingBeans
	 * 
	 * @param src
	 * @return
	 */
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
			System.out.println("PageHitBean.parseSource() :: var line is "+line+" var i is "+i);
			rtn = true;

		}
		
		return rtn;
	}

	/**
	 * processEvents loops through the array of eventTimingBeans and generates timing values
	 * for each item, stored in a rawDataDAO bean. Page level timing is stored in pageHitBean 
	 * with individual event data stored in PageHitEventsBeans. Data is also provided for the
	 * InsturmentSessionDAO and the InstrumentSessionDataDAO. State is maintained by getting 
	 * and setting the  PageHitBean to and from the current Triceps object. 
	 * TODO add docs about interaction with Evidence and TricepsEngine
	 * @return
	 */
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
		/*
		 * For each eventTimingBean in the arrayList eventTimingBeans pass the event through
		 * the state machine to identify the event type and process the data accordingly, storing 
		 * in the questionTimingBean.
		 * When the question changes, re-initialize the question timing bean and continue.
		 * 
		 */
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
				qtb.setResponseLatency(responseLatency);
				qtb.setResponseDuration(responseDuration);
				this.latencyState = this.LATENCY_EMPTY;
				this.durationState = this.DURATION_EMPTY;
				// add to array
				questionTimingBeans.add(questionRef,qtb);
				//clear previous values
				focus=0;
				blur=0;
				change =0;
				click = 0;
				mouseup =0;
				keypress=0;
				responseLatency =0;
				responseDuration =0;
				// new bean
				qtb = new QuestionTimingBean();
				questionRef ++;
				currentVarName = etb.getVarName();
				
			}

			// This will accumulate and allways be the duration time of the current event
			// resulting in the last duration value for the total duration.
			
			totalDuration = etb.getDuration();
			this.setLastAction(etb.getActionType());
			// test for the load event (1 per page)
			if (etb.getEventType().equals("load")) {
				
				// total page rendering time
				// (from time received HTML to time it was displayed to user)
				loadTime =  etb.getDuration();
				// client side timestamp when received HTML
				clientReceiveTS = new Long(etb.getTimestamp().getTime()).intValue();
				latencyState = this.LATENCY_START;
				responseLatency = etb.getDuration();

			} 
			if (etb.getActionType().equals("submit")
					&& etb.getEventType().equals("click")) {
				displayTime = etb.getDuration();
				clientSendTS = new Long(etb.getTimestamp().getTime()).intValue();
				System.out.println("submit::: duration is"+displayTime);

			}
			if(etb.getEventType().equals("focus")){
				focus++;
				if(latencyState==this.LATENCY_EMPTY){
				latencyState = this.LATENCY_START;
				responseLatency = etb.getDuration();
				}
				
			}
			if(etb.getEventType().equals("blur")){
				blur++;
				
			}
			if(etb.getEventType().equals("change")){
				change++;
				if(durationState == this.DURATION_START){
					responseDuration = etb.getDuration() - responseDuration;
					durationState = this.DURATION_FINISH;
				}
				
				
			}
			if(etb.getEventType().equals("click")){
				click++;
				if(latencyState==this.LATENCY_START){
					latencyState = this.LATENCY_FINISH;
					responseLatency = etb.getDuration()- responseLatency;
					}
				if(durationState != this.DURATION_START){
					responseDuration = etb.getDuration();
					durationState = this.DURATION_START;
				}
			}
			if(etb.getEventType().equals("keypress")){
				keypress++;
				if(latencyState==this.LATENCY_START){
					latencyState = this.LATENCY_FINISH;
					responseLatency = etb.getDuration()- responseLatency;
					}
				if(durationState != this.DURATION_START){
					responseDuration = etb.getDuration();
					durationState = this.DURATION_START;
				}
			}
			if(etb.getEventType().equals("mouseup")){
				mouseup++;
				if(latencyState==this.LATENCY_START){
					latencyState = this.LATENCY_FINISH;
					responseLatency = etb.getDuration()- responseLatency;
					}
				if(durationState != this.DURATION_START){
					responseDuration = etb.getDuration();
					durationState = this.DURATION_START;
				}
			}
			lastTS = new Long(etb.getTimestamp().getTime()).intValue();
		}
		this.setServerDuration(new Long(sentResponse - receivedRequest).intValue());
		System.out.println("server duration is"+this.getServerDuration());
		this.setTotalDuration(new Long(this.receivedRequest - this.lastRecievedRequest).intValue() );
		System.out.println("total duration is "+this.getTotalDuration());
		timestamp = new Timestamp (System.currentTimeMillis());
		this.setLoadDuration(loadTime);
		this.setNetworkDuration(this.totalDuration - (this.getServerDuration()+ displayTime));
		System.out.println("network duration is "+this.getNetworkDuration());
		this.setPageVacillation(1);
		
		
		



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
	public void setReceivedRequest(long _receivedRequest){
		lastRecievedRequest = receivedRequest;
		receivedRequest = _receivedRequest;
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
		// TODO we need more error checking here. When instruments are mal formed we throw index out of bounds errors on this line
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
	public void clear(){
		latencyState = LATENCY_EMPTY;
		durationState = DURATION_EMPTY;
		pageHitId=0;
		instrumentSessionId=0;
		accessCount=0;
		groupNum=0;
		displayNum=0;
		lastAction="";
		statusMsg="";
		totalDuration=0;
		serverDuration=0;
		loadDuration=0;
		networkDuration=0;
		pageVacillation=0;
		currentQuestionIndex=0;
		numQuestions = 0;
		receivedRequest=0;
		sentResponse=0;
		eventTimingBeans = new ArrayList();
		questionTimingBeans = new ArrayList();
		
	}
}
