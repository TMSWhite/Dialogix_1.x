package beans.html;

public abstract class StringArrayElement 
					implements SelectableElement, ValidatedElement {
	final String emptyString = "";
	private String[] value;

	public void setValue(String[] value) {
		this.value = value;
	}
	public String[] getValue() {
		return value != null ? value : new String[]{};	
	}
	public boolean validate() {
		return true;
	}
	public String getValidationError() {
		return "";
	}	
	public boolean contains(String s) {
		String[] strings = getValue();

		for(int i=0; i < strings.length; ++i) {
			if(strings[i].equals(s))
				return true;
		}
		return false;
	}
}
