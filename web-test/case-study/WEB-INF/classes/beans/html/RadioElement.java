package beans.html;

public class RadioElement extends StringElement
								  implements SelectableElement {
	public String selectionAttr(String value) {
		return getValue().equals(value) ? "checked" : emptyString;
	}
}
