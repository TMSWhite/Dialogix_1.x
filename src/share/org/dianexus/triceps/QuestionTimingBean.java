package org.dianexus.triceps;

public class QuestionTimingBean {
	
	private int rawDataId = 0;
	private int pageVacillation = 0;
	private int responseLatency = 0;
	private int responseDuration = 0;
	private int itemVacillation = 0;
	private int turnaroundTime = 0;
	private int focus=0;
	private int blur=0;
	private int change =0;
	private int click = 0;
	private int mouseup =0;
	private int keypress=0;
	
	public int getBlur() {
		return blur;
	}
	public void setBlur(int blur) {
		this.blur = blur;
	}
	public int getChange() {
		return change;
	}
	public void setChange(int change) {
		this.change = change;
	}
	public int getClick() {
		return click;
	}
	public void setClick(int click) {
		this.click = click;
	}
	public int getFocus() {
		return focus;
	}
	public void setFocus(int focus) {
		this.focus = focus;
	}
	public int getItemVacillation() {
		return itemVacillation;
	}
	public void setItemVacillation(int itemVacillation) {
		this.itemVacillation = itemVacillation;
	}
	public int getKeypress() {
		return keypress;
	}
	public void setKeypress(int keypress) {
		this.keypress = keypress;
	}
	public int getMouseup() {
		return mouseup;
	}
	public void setMouseup(int mouseup) {
		this.mouseup = mouseup;
	}
	public int getPageVacillation() {
		return pageVacillation;
	}
	public void setPageVacillation(int pageVacillation) {
		this.pageVacillation = pageVacillation;
	}
	public int getRawDataId() {
		return rawDataId;
	}
	public void setRawDataId(int rawDataId) {
		this.rawDataId = rawDataId;
	}
	public int getResponseDuration() {
		return responseDuration;
	}
	public void setResponseDuration(int responseDuration) {
		this.responseDuration = responseDuration;
	}
	public int getResponseLatency() {
		return responseLatency;
	}
	public void setResponseLatency(int responseLatency) {
		this.responseLatency = responseLatency;
	}
	public int getTurnaroundTime() {
		return turnaroundTime;
	}
	public void setTurnaroundTime(int turnaroundTime) {
		this.turnaroundTime = turnaroundTime;
	}
	
	
	

}
