import java.lang.*;
import java.util.*;
import java.io.*;


public class Node implements Serializable {
	public static final int UNKNOWN = -1;
	public static final int RADIO = 0;
	public static final int CHECK = 1;
	public static final int COMBO = 2;
	public static final int DATE = 3;
	public static final int MONTH = 4;
	public static final int TEXT = 5;
	public static final int DOUBLE=6;
	public static final int NOTHING=7;	// do nothing
	public static final int RADIO2=8;	// different layout
	private static final String QUESTION_TYPES[] = {"radio", "check", "combo", "date", "month", "text", "double", "nothing", "radio2" };
	private static final int DATA_TYPES[] = { Datum.STRING, Datum.STRING, Datum.STRING, Datum.DATE, Datum.MONTH, Datum.STRING, Datum.DOUBLE, Datum.STRING, Datum.STRING};
	private static final String QUESTION_MASKS[] = { "", "", "", " (e.g. 7/23/1982)", " (e.g. February)", "", "", "", ""};

	private String concept = "";
	private String description = "";
	private int step = 0;
	private String stepName = "";
	private String dependencies = "";
	private String questionRef = ""; // name within DISC
	private String actionType = "";
	private String action = "";
	private int answerType = UNKNOWN;
	private int datumType = Datum.INVALID;
	private String answerOptions = "";
	private Vector answerChoices = new Vector();
	private String error = null;

	// loading from extended Schedule with default answers
	// XXX hack - Node shouldn't know values of evidence - Schedule should know how to load itself.
	private transient String debugAnswer = null;
	private transient String questionAsAsked = "";

	/* N.B. need this obtuse way of checking for adjacent TABs from tokenizer - no other way seems to work */
	/* XXX - there is no reliable way to tokenize tab delimited files - constantly dropped null values -
	so must have dummy variables in empty columns */

	public Node(int step, String tsv) {
		int	count=0;
		try {
			StringTokenizer st = new StringTokenizer(tsv, "\t");
			this.step = step;
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
			actionType = getNextToken(st);
			action = getNextToken(st);
			answerOptions = getNextToken(st);

			int index = answerOptions.indexOf(";");

			String token;
			if (index != -1) {
				token = answerOptions.substring(0, index);
			}
			else {
				token = answerOptions;
			}

			for (int z=0;z<QUESTION_TYPES.length;++z) {
				if (token.equalsIgnoreCase(QUESTION_TYPES[z])) {
					answerType = z;
					datumType = DATA_TYPES[z];
					break;
				}
			}
			if ("e".equals(actionType) || answerType == UNKNOWN) {
//				System.out.println("Unknown data type (" + token + ") on line " + (step + 1));
				answerType = NOTHING;
				datumType = DATA_TYPES[answerType];
			}

			parseTSV(answerOptions);

			// XXX these next two lines are a hack - read in, but discard, the stored questions and answers
			questionAsAsked = getNextToken(st);
			debugAnswer = getNextToken(st);
		}
		catch(NoSuchElementException e) {
			if (count < 8) {
				System.out.println("Error tokenizing line " + (step + 1) + " (" + count + "/8 tokens found)" + e.getMessage());
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
			System.out.println("Internal error: " + e.getMessage());
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
					System.out.println("Error tokenizing answer options: " + e);
				}
				catch (NoSuchElementException e) {
					System.out.println("Error tokenizing answer options: " + e);
				}
				break;
			default:
			case DATE:
			case MONTH:
			case TEXT:
			case DOUBLE:
			case NOTHING:
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
					sb.append("<input type='radio'" + "name='" + Node.encodeHTML(getName()) + "' " + "value='" + Node.encodeHTML(ac.getValue()) + "'" +
						(DatumMath.eq(datum,new Datum(ac.getValue(),DATA_TYPES[answerType])).booleanVal() ? " CHECKED" : "") + ">" + Node.encodeHTML(ac.getMessage()) + "<br>");
				}
				break;
			case RADIO2: // will store integers
				/* table underneath questions */
				sb.append("&nbsp;</TD></TR><TR><TD>&nbsp;</TD><TD COLSPAN='2' BGCOLOR='lightgrey'>");
				sb.append("<TABLE CELLPADDING='0' CELLSPACING='2' BORDER='1'>");
				sb.append("<TR>");
				while (ans.hasMoreElements()) { // for however many radio buttons there are
					ac = (AnswerChoice) ans.nextElement();
					sb.append("<TD VALIGN='top'>");
					sb.append("<input type='radio'" + "name='" + Node.encodeHTML(getName()) + "' " + "value='" + Node.encodeHTML(ac.getValue()) + "'" +
						(DatumMath.eq(datum,new Datum(ac.getValue(),DATA_TYPES[answerType])).booleanVal() ? " CHECKED" : "") + ">" + Node.encodeHTML(ac.getMessage()));
					sb.append("</TD>");
				}
				sb.append("</TR>");
				sb.append("</TABLE>");
//				sb.append("</TD></TR>");	// closing the outside is reserverd for TricepsServlet
				break;
			case CHECK:
				while (ans.hasMoreElements()) { // for however many radio buttons there are
					ac = (AnswerChoice) ans.nextElement();
					sb.append("<input type='checkbox'" + "name='" + Node.encodeHTML(getName()) + "' " + "value='" + Node.encodeHTML(ac.getValue()) + "'" +
						(DatumMath.eq(datum, new Datum(ac.getValue(),DATA_TYPES[answerType])).booleanVal() ? " CHECKED" : "") + ">" + Node.encodeHTML(ac.getMessage()) + "<br>");
				}
				break;
			case COMBO:	// stores integers as value
				sb.append("<select name='" + Node.encodeHTML(getName()) + "'>");
				sb.append("<option value=''>--please select one of these choices--");	// first choice is empty
				while (ans.hasMoreElements()) { // for however many radio buttons there are
					ac = (AnswerChoice) ans.nextElement();
					sb.append("<option value='" + Node.encodeHTML(ac.getValue()) + "'" +
						(DatumMath.eq(datum, new Datum(ac.getValue(),DATA_TYPES[answerType])).booleanVal() ? " SELECTED" : "") + ">" + Node.encodeHTML(ac.getMessage()) + "</option>");
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
			case DOUBLE:	// stores Double type
				if (datum != null && datum.exists())
					defaultValue = datum.stringVal();
				sb.append("<input type='text' name='" + Node.encodeHTML(getName()) + "' value='" + Node.encodeHTML(defaultValue) + "'>");
				break;
			default:
			case NOTHING:
				break;
			}
		}
		catch (Throwable t) {
			setError("Internal error: " + t);
			return "";
		}

		return sb.toString();
	}


	public String getAction() { return action; }
	public String getActionType() { return actionType; }
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
	public int getStep() { return step; }
	public String getQuestionAsAsked() { return questionAsAsked; }
	public void setQuestionAsAsked(String s) { questionAsAsked = s; }

	public boolean focusable() { return (answerType != UNKNOWN && answerType != NOTHING); }

	public void setError(String error) {
		if (this.error == null)
			this.error = error;
		else
			this.error = this.error + "<BR>" + error;

	}

	public String getError() {
		String temp = error;
		error = null;
		return temp;
	}

	public boolean hasError() { return (error != null); }

	/**
	 * Prints out the components of a node in the schedule.
	 */
	public String toString() {
		return "Node (" + step + "): <B>" + Node.encodeHTML(stepName) + "</B><BR>\n" + "Concept: <B>" + Node.encodeHTML(concept) + "</B><BR>\n" +
			"Description: <B>" + Node.encodeHTML(description) + "</B><BR>\n" + "Dependencies: <B>" + Node.encodeHTML(dependencies) + "</B><BR>\n" +
			"Question Reference: <B>" + Node.encodeHTML(questionRef) + "</B><BR>\n" + "Action Type: <B>" + Node.encodeHTML(actionType) + "</B><BR>\n" +
			"Action: <B>" + Node.encodeHTML(action) + "</B><BR>\n" + "AnswerType: <B>" + Node.encodeHTML(QUESTION_TYPES[answerType]) + "</B><BR>\n" + "AnswerOptions: <B>" +
			Node.encodeHTML(answerOptions) + "</B><BR>\n";
	}

	public String toTSV() {
		return concept + "\t" + description + "\t" + stepName + "\t" + dependencies + "\t" + questionRef +
			"\t" + actionType + "\t" + action + "\t" + answerOptions;
	}


	static public String encodeHTML(String s) {
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
		return dst.toString();
	}
}
