package org.dianexus.triceps;

/*import java.io.StringReader;*/
/*import java.io.StringWriter;*/
/*import java.lang.*;*/
/*import java.util.*;*/
import java.io.StringReader;

/* Wrapper to make it easier to call Qss */
/*public*/ class Parser implements VersionIF {
	private Logger debugLogger = Logger.NULL;
	private Logger errorLogger = Logger.NULL;
	private Qss qss = null;

	/*public*/ Parser() {
		qss = new Qss(new StringReader(""));
		setErrorLogger(new Logger());
	}

	/*public*/ boolean booleanVal(Triceps triceps, String exp) {
		return parse(triceps, exp).booleanVal();
	}

	/*public*/ String stringVal(Triceps triceps, String exp) {
		return parse(triceps, exp).stringVal(false);
	}

	/*public*/ String stringVal(Triceps triceps, String exp, boolean showReserved) {
		return parse(triceps,exp).stringVal(showReserved);
	}

	/*public*/ double doubleVal(Triceps triceps, String exp) {
		return parse(triceps, exp).doubleVal();
	}

	/*public*/ Datum parse(Triceps triceps, String exp) {
		debugLogger.println(exp);

		qss.ReInit(new StringReader(exp));
		Datum ans = qss.parse(triceps);

		return ans;
	}

	/*public*/ boolean hasErrors() {
		return (errorLogger.size() > 0);
	}

	/*public*/ String getErrors() {
		return errorLogger.toString();
	}

	/*public*/ String parseJSP(Triceps triceps, String msg) {
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
					sb.append(stringVal(triceps,s,true));	// so that see the *REFUSED*, etc as part of questions
				}
				else {
					sb.append(s);
				}
			}
		}

		return sb.toString();
	}

	/*public*/ void resetErrorCount() {
		qss.resetErrorCount();
	}

	/*public*/ void setDebugLogger(Logger l) {
		if (l != null) {
			debugLogger = l;
			qss.debugLogger = l;
			l.reset();
		}
	}

	/*public*/ void setErrorLogger(Logger l) {
		if (l != null) {
			errorLogger = l;
			qss.errorLogger = l;
			l.reset();
		}
	}
}
