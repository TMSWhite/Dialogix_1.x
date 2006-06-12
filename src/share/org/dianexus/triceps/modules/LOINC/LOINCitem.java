package org.dianexus.triceps.modules.LOINC;

public class LOINCitem {
	private int id;
	private String idString;
	private String component;
	private String property;
	private String timing;
	private String system;
	private String scale;
	private String method;
	private String loincClass;
	private String survey;
	private String questionSource;
	private String surveyQuestionText;
	private String answerList;
	private String formula;
	private String comments;
	private String context;
	
	public String getAnswerList() {
		return answerList;
	}
	public void setAnswerList(String answerList) {
		this.answerList = answerList;
	}
	public String getComments() {
		return comments;
	}
	public void setComments(String comments) {
		this.comments = comments;
	}
	public String getComponent() {
		return component;
	}
	public void setComponent(String component) {
		this.component = component;
	}
	public String getContext() {
		return context;
	}
	public void setContext(String context) {
		this.context = context;
	}
	public String getFormula() {
		return formula;
	}
	public void setFormula(String formula) {
		this.formula = formula;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getIdString() {
		return idString;
	}
	public void setIdString(String idString) {
		this.idString = idString;
	}
	public String getLoincClass() {
		return loincClass;
	}
	public void setLoincClass(String loincClass) {
		this.loincClass = loincClass;
	}
	public String getMethod() {
		return method;
	}
	public void setMethod(String method) {
		this.method = method;
	}
	public String getProperty() {
		return property;
	}
	public void setProperty(String property) {
		this.property = property;
	}
	public String getQuetionSource() {
		return questionSource;
	}
	public void setQuetionSource(String quetionSource) {
		this.questionSource = quetionSource;
	}
	public String getScale() {
		return scale;
	}
	public void setScale(String scale) {
		this.scale = scale;
	}
	public String getSurvey() {
		return survey;
	}
	public void setSurvey(String survey) {
		this.survey = survey;
	}
	public String getSurveyQuestionText() {
		return surveyQuestionText;
	}
	public void setSurveyQuestionText(String surveyQuestionText) {
		this.surveyQuestionText = surveyQuestionText;
	}
	public String getSystem() {
		return system;
	}
	public void setSystem(String system) {
		this.system = system;
	}
	public String getTiming() {
		return timing;
	}
	public void setTiming(String timing) {
		this.timing = timing;
	}
	
}
