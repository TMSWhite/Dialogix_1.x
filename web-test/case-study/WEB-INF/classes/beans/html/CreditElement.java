package beans.html;

public class CreditElement extends RadioElement {
	private String error;

	public boolean validate() {
		boolean valid = true;
		String value = getValue();

		error = "";

		if(value.length() == 0) {
			valid = false;
			error = "Credit card must be selected";
		}
		return valid;
	}
	public String getValidationError() {
		return error;	
	}
}
