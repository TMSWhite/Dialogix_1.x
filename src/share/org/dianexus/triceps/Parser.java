import java.io.StringReader;
import java.io.StringWriter;
import java.lang.*;
import java.util.*;

/* Wrapper to make it easier to call Qss */
public class Parser {
	private Logger debugLogger = Logger.NULL;
	private Logger errorLogger = Logger.NULL;
	private Qss qss = null;

	public Parser() {
		qss = new Qss(new StringReader(""));
		setErrorLogger(new Logger());
	}

	public boolean booleanVal(Evidence ev, String exp) {
		return parse(ev, exp).booleanVal();
	}

	public String stringVal(Evidence ev, String exp) {
		return parse(ev, exp).stringVal(false);
	}

	public String stringVal(Evidence ev, String exp, boolean showReserved) {
		return parse(ev,exp).stringVal(showReserved);
	}

	public double doubleVal(Evidence ev, String exp) {
		return parse(ev, exp).doubleVal();
	}

	public Datum parse(Evidence ev, String exp) {
		debugLogger.println(exp);

		qss.ReInit(new StringReader(exp));
		Datum ans = qss.parse(ev);

		return ans;
	}

	public boolean hasErrors() {
		return (errorLogger.size() > 0);
	}

	public String getErrors() {
		return errorLogger.toString();
	}

	public String parseJSP(Evidence ev, String msg) {
		java.util.StringTokenizer st = new java.util.StringTokenizer(msg,"`",true);
		StringBuffer sb = new StringBuffer();
		String s;
		boolean inside = false;

		debugLogger.println(msg);

		while(st.hasMoreTokens()) {
			s = st.nextToken();
			if ("`".equals(s)) {
				inside = (inside) ? false : true;
				continue;
			}
			else {
				if (inside) {
					sb.append(stringVal(ev,s,true));	// so that see the *REFUSED*, etc as part of questions
				}
				else {
					sb.append(s);
				}
			}
		}

		return sb.toString();
	}

	public void resetErrorCount() {
		qss.resetErrorCount();
	}
	
	public void setDebugLogger(Logger l) {
		if (l != null) {
			debugLogger = l;
			qss.debugLogger = l;
			l.reset();
		}
	}
	
	public void setErrorLogger(Logger l) {
		if (l != null) {
			errorLogger = l;
			qss.errorLogger = l;
			l.reset();
		}
	}	
}
