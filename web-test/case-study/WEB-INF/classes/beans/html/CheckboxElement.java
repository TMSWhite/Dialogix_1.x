package beans.html;

public class CheckboxElement extends StringArrayElement {
	public String selectionAttr(String s) {
		return contains(s) ? "checked" : emptyString;
	}
}
