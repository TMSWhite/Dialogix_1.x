import java.lang.*;
import java.util.*;
import java.io.*;


public class Node implements Serializable {
	public static final int UNKNOWN = 0;
	public static final int RADIO = 1;
	public static final int CHECK = 2;
	public static final int COMBO = 3;
	public static final int DATE = 4;
	public static final int MONTH = 5;
	public static final int TEXT = 6;
	public static final int DOUBLE=7;
	public static final int NOTHING=8;	// do nothing
	public static final int RADIO2=9;	// different layout
	public static final int PASSWORD=10;
	public static final int MEMO=11;
	private static final String QUESTION_TYPES[] = {"*unknown*","radio", "check", "combo", "date", "month", "text", "double", "nothing", "radio2", "password","memo" };
	private static final int DATA_TYPES[] = { Datum.STRING, Datum.STRING, Datum.STRING, Datum.STRING, Datum.DATE, Datum.MONTH, Datum.STRING, Datum.DOUBLE, Datum.STRING, Datum.STRING, Datum.STRING, Datum.STRING};
	private static final String QUESTION_MASKS[] = { "", "", "", "", " (e.g. 7/23/1982)", " (e.g. February)", "", "", "", "", "", ""};

	public static final int QUESTION = 1;
	public static final int EVAL = 2;
	public static final int GROUP_OPEN = 3;
	public static final int GROUP_CLOSE = 4;
	public static final String ACTION_TYPE_NAMES[] = {"*unknown*","question", "expression", "group_open", "group_close" };
	public static final String ACTION_TYPES[] = {"?","q","e","[","]"};

	private static final int MAX_TEXT_LEN_FOR_COMBO = 60;

	private String concept = "";
	private String description = "";
	private int sourceLine = 0;
	private String sourceFile = "";
	private String stepName = "";
	private String dependencies = "";
	private String questionRef = ""; // name within DISC
	private int actionType = UNKNOWN;
	private String action = "";
	private int answerType = UNKNOWN;
	private int datumType = Datum.INVALID;
	private String answerOptions = "";
	private Vector answerChoices = new Vector();
	private Vector runtimeErrors = new Vector();
	private Vector parseErrors = new Vector();

	// loading from extended Schedule with default answers
	// XXX hack - Node shouldn't know values of evidence - Schedule should know how to load itself.
	private transient String debugAnswer = null;
	private transient String questionAsAsked = "";

	/* N.B. need this obtuse way of checking for adjacent TABs from tokenizer - no other way seems to work */
	/* XXX - there is no reliable way to tokenize tab delimited files - constantly dropped null values -
	so must have dummy variables in empty columns */

	public Node(int sourceLine, String sourceFile, String tsv) {
		int	count=0;
		String token;

		try {
			StringTokenizer st = new StringTokenizer(tsv, "\t");
			this.sourceLine = sourceLine;
			this.sourceFile = sourceFile;
			count = st.countTokens();

			concept = getNextToken(st);
			description = getNextToken(st);
			stepName = getNextToken(st);

			try {
				if (Character.isDigit(stepName.charAt(0))) {
					stepName = "_" + stepName;
				}
			}
			catch (IndexOutOfBoundsException e) {
				/* Must have a null or zero-length value for stepName */
			}

			dependencies = getNextToken(st);
			questionRef = getNextToken(st);

			token = getNextToken(st);
			for (int z=0;z<ACTION_TYPES.length;++z) {
				if (token.equalsIgnoreCase(ACTION_TYPES[z])) {
					actionType = z;
					break;
				}
			}
			if (actionType == UNKNOWN) {
				setParseError("Unknown action type <B>" + Node.encodeHTML(token) + "</B> on line " + sourceLine + " in file <B>" + sourceFile + "</B>");
			}

			action = getNextToken(st);
			answerOptions = getNextToken(st);

			int index = answerOptions.indexOf(";");

			if (index != -1) {
				token = answerOptions.substring(0, index);
			}
			else {
				token = answerOptions;
			}

			for (int z=0;z<QUESTION_TYPES.length;++z) {
				if (token.equalsIgnoreCase(QUESTION_TYPES[z])) {
					answerType = z;
					break;
				}
			}

			if (actionType == EVAL) {
				answerType = NOTHING;
			}
			else if (answerType == UNKNOWN) {
				setParseError("Unknown data type for answer<B>" + Node.encodeHTML(token) + "</B> on line " + sourceLine + " in file <B>" + sourceFile + "</B>");
				answerType = NOTHING;

			}

			datumType = DATA_TYPES[answerType];

			parseTSV(answerOptions);

			// XXX these next two lines are a hack - read in, but discard, the stored questions and answers
			questionAsAsked = getNextToken(st);
			debugAnswer = getNextToken(st);
		}
		catch(NoSuchElementException e) {
			if (count < 8) {
				setParseError("Error tokenizing line " + sourceLine + "in file <B>" + Node.encodeHTML(sourceFile) + "</B>: (" + count + "/8 tokens found)" + Node.encodeHTML(e.getMessage()));
			}
		}
	}

	private String getNextToken(StringTokenizer st) {
		try {
			String s = st.nextToken();
			if (s == null)
				return "";

			/* Fix Excel-isms, in which strings with internal quotes have all quotes replaced with double quotes (\"\"), and
				whole string surrounded by quotes.
				XXX - this requires assumption that if a field starts AND stops with a quote, then probably an excel-ism
			*/

			if (s.startsWith("\"") && s.endsWith("\"")) {
				StringBuffer sb = new StringBuffer();

				int start=1;
				int stop=0;
				while ((stop = s.indexOf("\"\"",start)) != -1) {
					sb.append(s.substring(start,stop));
					sb.append("\"");
					start = stop+2;
				}
				sb.append(s.substring(start,s.length()-1));
				return sb.toString();
			}
			else {
				return s;
			}
		}
		catch(NoSuchElementException e) {
			return "";
		}
		catch (IndexOutOfBoundsException e) {
			setParseError("Internal error: " + Node.encodeHTML(e.getMessage()));
			return "";
		}
	}


	public boolean parseTSV(String src) {
		switch (answerType) {
			case CHECK:
			case COMBO:
			case RADIO:
			case RADIO2:
				try {
					StringTokenizer ans;
					String val;
					String msg;

					ans = new StringTokenizer(answerOptions,";");
					ans.nextToken();	// discard the answerType

					while (ans.hasMoreTokens()) { // for however many radio buttons there are
						val = ans.nextToken();
						msg = ans.nextToken();
						answerChoices.addElement(new AnswerChoice(val,msg));
					}
				}
				catch (NullPointerException e) {
					setParseError("Error tokenizing answer options: " + Node.encodeHTML(e.getMessage()));
				}
				catch (NoSuchElementException e) {
					setParseError("Error tokenizing answer options: " + Node.encodeHTML(e.getMessage()));
				}
				break;
			default:
			case DATE:
			case MONTH:
			case TEXT:
			case DOUBLE:
			case NOTHING:
			case PASSWORD:
			case MEMO:
				break;
		}

		return true;
	}

	public String prepareChoicesAsHTML(Datum datum) {
		StringBuffer sb = new StringBuffer();
		String defaultValue = "";
		AnswerChoice ac;
		Enumeration ans = answerChoices.elements();

		try {
			switch (answerType) {
			case RADIO:	// will store integers
				while (ans.hasMoreElements()) { // for however many radio buttons there are
					ac = (AnswerChoice) ans.nextElement();
					sb.append("<input type='radio' name='" + Node.encodeHTML(getName()) + "' " + "value='" + Node.encodeHTML(ac.getValue()) + "'" +
						(DatumMath.eq(datum,new Datum(ac.getValue(),DATA_TYPES[answerType])).booleanVal() ? " CHECKED" : "") + ">" + Node.encodeHTML(ac.getMessage()) + "<br>");
				}
				break;
			case RADIO2: // will store integers
				/* table underneath questions */
				int count = answerChoices.size();

				sb.append("&nbsp;</TD></TR>");

				if (count > 0) {
					Double pct = new Double(100. / (double) count);
					sb.append("<TR><TD>&nbsp;</TD>");
					sb.append("<TD COLSPAN='2' BGCOLOR='lightgrey'>");
					sb.append("\n<TABLE CELLPADDING='0' CELLSPACING='2' BORDER='1' WIDTH='100%'>");
					sb.append("\n<TR>");
					while (ans.hasMoreElements()) { // for however many radio buttons there are
						ac = (AnswerChoice) ans.nextElement();
						sb.append("\n<TD VALIGN='top' WIDTH='" + pct.toString() + "%'>");
						sb.append("<input type='radio' name='" + Node.encodeHTML(getName()) + "' " + "value='" + Node.encodeHTML(ac.getValue()) + "'" +
							(DatumMath.eq(datum,new Datum(ac.getValue(),DATA_TYPES[answerType])).booleanVal() ? " CHECKED" : "") + ">" + Node.encodeHTML(ac.getMessage()));
						sb.append("</TD>");
					}
				}
				sb.append("\n</TR>");
				sb.append("\n</TABLE>");
//				sb.append("</TD></TR>");	// closing the outside is reserverd for TricepsServlet
				break;
			case CHECK:
				while (ans.hasMoreElements()) { // for however many radio buttons there are
					ac = (AnswerChoice) ans.nextElement();
					sb.append("<input type='checkbox' name='" + Node.encodeHTML(getName()) + "' " + "value='" + Node.encodeHTML(ac.getValue()) + "'" +
						(DatumMath.eq(datum, new Datum(ac.getValue(),DATA_TYPES[answerType])).booleanVal() ? " CHECKED" : "") + ">" + Node.encodeHTML(ac.getMessage()) + "<br>");
				}
				break;
			case COMBO:	// stores integers as value
				sb.append("\n<select name='" + Node.encodeHTML(getName()) + "'>");
				sb.append("\n<option value=''>--select one of the following--");	// first choice is empty
				int optionNum=0;
				while (ans.hasMoreElements()) { // for however many radio buttons there are
					ac = (AnswerChoice) ans.nextElement();
					++optionNum;

					String option = ac.getMessage();
					String prefix = "<option value='" + Node.encodeHTML(ac.getValue()) + "'";
					boolean selected = DatumMath.eq(datum, new Datum(ac.getValue(),DATA_TYPES[answerType])).booleanVal();
					int stop;
					int line=0;

					while (option.length() > 0) {
						if (option.length() < MAX_TEXT_LEN_FOR_COMBO) {
							stop = option.length();
						}
						else {
							stop = option.lastIndexOf(' ',MAX_TEXT_LEN_FOR_COMBO);
							if (stop <= 0) {
								stop = MAX_TEXT_LEN_FOR_COMBO;	// if no extra space, take entire string
							}
						}

						sb.append(prefix);
						if (line++ == 0) {
							if (selected) {
								sb.append(" SELECTED>" + optionNum + ")&nbsp;");
							}
							else {
								sb.append(">" + optionNum + ")&nbsp;");
							}
						}
						else {
							sb.append(">&nbsp;&nbsp;&nbsp;");
						}
						sb.append(Node.encodeHTML(option.substring(0,stop)));

						if (stop<option.length())
							option = option.substring(stop+1,option.length());
						else
							option = "";
					}

					sb.append("</option>");
				}
				sb.append("</select>");
				break;
			case DATE:	// stores Date type
				if (datum != null) {
					Date date = datum.dateVal();
					if (date != null)
						defaultValue = Datum.mdy.format(date);
				}
				sb.append("<input type='text' name='" + Node.encodeHTML(getName()) + "' value='" + Node.encodeHTML(defaultValue) + "'>");
				break;
			case MONTH: // stores Month type
				if (datum != null && datum.exists())
					defaultValue = datum.monthVal();
				sb.append("<input type='text' name='" + Node.encodeHTML(getName()) + "' value='" + Node.encodeHTML(defaultValue) + "'>");
				break;
			case TEXT:	// stores Text type
				if (datum != null && datum.exists())
					defaultValue = datum.stringVal();
				sb.append("<input type='text' name='" + Node.encodeHTML(getName()) + "' value='" + Node.encodeHTML(defaultValue) + "'>");
				break;
			case MEMO:
				if (datum != null && datum.exists())
					defaultValue = datum.stringVal();
				sb.append("<textarea rows='5' name='" + Node.encodeHTML(getName()) + ">" + Node.encodeHTML(defaultValue) + "</TEXTAREA>");
				break;
			case PASSWORD:	// stores Text type
				if (datum != null && datum.exists())
					defaultValue = datum.stringVal();
				sb.append("<input type='password' name='" + Node.encodeHTML(getName()) + "'>");
				break;
			case DOUBLE:	// stores Double type
				if (datum != null && datum.exists())
					defaultValue = datum.stringVal();
				sb.append("<input type='text' name='" + Node.encodeHTML(getName()) + "' value='" + Node.encodeHTML(defaultValue) + "'>");
				break;
			default:
			case NOTHING:
				sb.append("&nbsp;");
				break;
			}
		}
		catch (Throwable t) {
			setError("Internal error: " + Node.encodeHTML(t.getMessage()));
			return "";
		}

		return sb.toString();
	}


	public String getAction() { return action; }
	public int getActionType() { return actionType; }
	public String getAnswerOptions() { return answerOptions; }
	public int getAnswerType() { return answerType; }
	public int getDatumType() { return datumType; }
	public String getConcept() { return concept; }
	public String getDependencies() { return dependencies; }
	public String getDescription() { return description; }
	public String getName() { return stepName; }
	public String getQuestionRef() { return questionRef; }
	public String getDebugAnswer() { return debugAnswer; }
	public String getQuestionMask() { return QUESTION_MASKS[answerType]; }
	public int getSourceLine() { return sourceLine; }
	public String getSourceFile() { return sourceFile; }
	public String getQuestionAsAsked() { return questionAsAsked; }
	public void setQuestionAsAsked(String s) { questionAsAsked = s; }

	public boolean focusable() { return (answerType != UNKNOWN && answerType != NOTHING); }

	public void setParseError(String error) {
		parseErrors.addElement(error);
	}
	public void setError(String error) {
		runtimeErrors.addElement(error);
	}

	public Vector getErrors() {
		Vector errs = new Vector();
		for (int j=0;j<parseErrors.size();++j) { errs.addElement(parseErrors.elementAt(j)); }
		for (int j=0;j<runtimeErrors.size();++j) { errs.addElement(runtimeErrors.elementAt(j)); }
		runtimeErrors = new Vector();	// clear the runtime errors;
		return errs;
	}

	public Vector getRuntimeErrors() {
		Vector errs = runtimeErrors;
		runtimeErrors = new Vector();	// clear them.
		return errs;
	}


	public boolean hasErrors() { return ((runtimeErrors.size() + parseErrors.size()) > 0); }
	public boolean hasRuntimeErrors() { return (runtimeErrors.size() > 0); }


	/**
	 * Prints out the components of a node in the schedule.
	 */
	public String toString() {
		return "Node (" + sourceLine + "): <B>" + Node.encodeHTML(stepName) + "</B><BR>\n" + "Concept: <B>" + Node.encodeHTML(concept) + "</B><BR>\n" +
			"Description: <B>" + Node.encodeHTML(description) + "</B><BR>\n" + "Dependencies: <B>" + Node.encodeHTML(dependencies) + "</B><BR>\n" +
			"Question Reference: <B>" + Node.encodeHTML(questionRef) + "</B><BR>\n" + "Action Type: <B>" + Node.encodeHTML(ACTION_TYPE_NAMES[actionType]) + "</B><BR>\n" +
			"Action: <B>" + Node.encodeHTML(action) + "</B><BR>\n" + "AnswerType: <B>" + Node.encodeHTML(QUESTION_TYPES[answerType]) + "</B><BR>\n" + "AnswerOptions: <B>" +
			Node.encodeHTML(answerOptions) + "</B><BR>\n";
	}

	public String toTSV() {
		return concept + "\t" + description + "\t" + stepName + "\t" + dependencies + "\t" + questionRef +
			"\t" + ACTION_TYPES[actionType] + "\t" + action + "\t" + answerOptions;
	}


	static public String encodeHTML(String s, boolean disallowEmpty) {
		char[] src = s.toCharArray();
		StringBuffer dst = new StringBuffer();

		for (int i=0;i<src.length;++i) {
			switch (src[i]) {
				case '\'': dst.append("&#39;"); break;
				case '\"': dst.append("&#34;"); break;
				case '<': dst.append("&#60;"); break;
				case '>': dst.append("&#62;"); break;
				case '&': dst.append("&#38;"); break;
				default: dst.append(src[i]); break;
			}
		}
		String ans = dst.toString().trim();
		if (disallowEmpty && ans.length() == 0) {
			return "&nbsp;";
		}
		else {
			return ans;
		}
	}

	static public String encodeHTML(String s) {
		return encodeHTML(s,false);
	}
}
