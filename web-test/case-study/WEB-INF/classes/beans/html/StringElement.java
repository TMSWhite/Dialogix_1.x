package beans.html;

public class StringElement implements ValidatedElement {
	final protected String emptyString = "";
	private String value;

	public void setValue(String value) {
		this.value = value;
	}
	public String getValue() { 
		return value != null ? value : emptyString; 
	}
	public boolean validate() {
		return true; 
	}
	public String getValidationError() {
		return emptyString;
	}
}
