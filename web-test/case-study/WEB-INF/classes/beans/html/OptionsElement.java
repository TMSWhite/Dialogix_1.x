package beans.html;

public class OptionsElement extends StringArrayElement {
	public String selectionAttr(String s) {
		return contains(s) ? "selected" : emptyString;
	}
}
