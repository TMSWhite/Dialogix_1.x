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
	private static final String QUESTION_TYPES[] = {"radio", "check", "combo", "date", "month", "text", "double", "nothing" };
	private static final int DATA_TYPES[] = { Datum.DOUBLE, Datum.DOUBLE, Datum.DOUBLE, Datum.DATE, Datum.MONTH, Datum.STRING, Datum.STRING, Datum.STRING};
	private static final String QUESTION_MASKS[] = { "", "", "", " (e.g. 7/23/1982)", " (e.g. February)", "", "", ""};
	
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
	
	// loading from extended Schedule with default answers
	// XXX hack - Node shouldn't know values of evidence - Schedule should know how to load itself.
	private transient String debugAnswer = null;
	
	/* N.B. need this obtuse way of checking for adjacent TABs from tokenizer - no other way seems to work */
	/* XXX - there is no reliable way to tokenize tab delimited files - constantly dropped null values - 
	so must have dummy variables in empty columns */

	public Node(int step, String tsv) {
		String token;
		int count = 0;
		try {
			StringTokenizer st = new StringTokenizer(tsv, "\t");
			this.step = step;
			count = st.countTokens();
			
			concept = st.nextToken();
			description = st.nextToken();
			stepName = st.nextToken();
			if (stepName.charAt(0) != '_') {
				stepName = "_" + stepName;
			}
			dependencies = st.nextToken();
			questionRef = st.nextToken();
			actionType = st.nextToken();
			action = st.nextToken();
			answerOptions = st.nextToken();

			int index = answerOptions.indexOf(";");
			if (index != -1) {
				token = answerOptions.substring(0, index);
			}
			else {
				token = answerOptions;
			}
						
//			System.out.println("actionType=" + actionType + ",action=" + action + ",answerType=" + token + ",answerOptions=" + answerOptions);
						
			for (int z=0;z<QUESTION_TYPES.length;++z) {
				if (token.equalsIgnoreCase(QUESTION_TYPES[z])) {
					answerType = z;
					datumType = DATA_TYPES[z];
					break;
				}
			}
			if (!"e".equals(actionType) && answerType == UNKNOWN) {
				System.out.println("Unknown data type (" + token + ") on line " + step);
				answerType = NOTHING;
				datumType = DATA_TYPES[answerType];
			}
			
			debugAnswer = st.nextToken();
		}
		catch(Exception e) {
			if (count < 8) {
				System.out.println("Error tokenizing line " + step + " (" + count + "/8 tokens found)" + e.getMessage());
			}			
		}
	}
	
	public boolean parseTSV(String src) {
		switch (answerType) {
			case RADIO:
				break;
			case CHECK:
				break;
			case COMBO:
				break;
			case DATE:
				break;
			case MONTH:
				break;
			case TEXT:
				break;
			case DOUBLE:
				break;
			case NOTHING:
				break;
		}
		return true;
	}
	
	public String prepareChoicesAsHTML(Datum datum) {
		StringTokenizer ans;
		StringBuffer sb = new StringBuffer();
		String val;
		String msg;
		String defaultValue = "";
		
		try {
			ans = new StringTokenizer(answerOptions, ";");
			ans.nextToken();	// discard the answerType
			switch (answerType) {
			case RADIO:	// will store integers
				while (ans.hasMoreTokens()) { // for however many radio buttons there are
					val = ans.nextToken();
					msg = ans.nextToken();
					sb.append("<input type='radio'" + "name='" + getName() + "' " + "value=" + val + 
						(DatumMath.eq(datum,new Datum(val,Datum.DOUBLE)).booleanVal() ? " CHECKED" : "") + ">" + msg + "<br>");
				}
				break;
			case CHECK:
				while (ans.hasMoreTokens()) { // for however many check boxes there are
					val = ans.nextToken();
					msg = ans.nextToken();
					sb.append("<input type='checkbox'" + "name='" + getName() + "' " + "value=" + val + 
						(DatumMath.eq(datum, new Datum(val,Datum.DOUBLE)).booleanVal() ? " CHECKED" : "") + ">" + msg + "<br>");
				}		
				break;
			case COMBO:	// stores string as value
				sb.append("<select name='" + getName() + "'>");
				sb.append("<option>");	// first choice is empty
				while (ans.hasMoreTokens()) { 
					val = ans.nextToken();
					msg = ans.nextToken();
					sb.append("<option value='" + val + "'" + 
						(DatumMath.eq(datum, new Datum(val,Datum.STRING)).booleanVal() ? " SELECTED" : "") + ">" + msg + "</option>");
				}
				sb.append("</select>");		
				break;
			case DATE:	// stores Date type
				if (datum != null) {
					Date date = datum.dateVal();
					if (date != null)
						defaultValue = Datum.mdy.format(date);
				}
				sb.append("<input type='text' name='" + getName() + "' value='" + defaultValue + "'>");
				break;
			case MONTH: // stores Month type
				if (datum != null && datum.exists())
					defaultValue = datum.monthVal();			
				sb.append("<input type='text' name='" + getName() + "' value='" + defaultValue + "'>");
				break;
			case TEXT:	// stores Text type
				if (datum != null && datum.exists())
					defaultValue = datum.stringVal();
				sb.append("<input type='text' name='" + getName() + "' value='" + defaultValue + "'>");
				break;
			case DOUBLE:	// stores Double type
				if (datum != null && datum.exists())
					defaultValue = datum.stringVal();
				sb.append("<input type='text' name='" + getName() + "' value='" + defaultValue + "'>");
				break;
			default:
			case NOTHING:
				break;
			}
		}
		catch (NullPointerException e) {
			System.out.println("Error tokenizing answer options: " + e);
		}
		catch (NoSuchElementException e) {
			System.out.println("Error tokenizing answer options: " + e);
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
	
	/**
	 * Prints out the components of a node in the schedule.
	 */
	public String toString() {
		return "Node (" + step + "): <B>" + stepName + "</B><BR>\n" + "Concept: <B>" + concept + "</B><BR>\n" +
			"Description: <B>" + description + "</B><BR>\n" + "Dependencies: <B>" + dependencies + "</B><BR>\n" +
			"Question Reference: <B>" + questionRef + "</B><BR>\n" + "Action Type: <B>" + actionType + "</B><BR>\n" +
			"Action: <B>" + action + "</B><BR>\n" + "AnswerType: <B>" + QUESTION_TYPES[answerType] + "</B><BR>\n" + "AnswerOptions: <B>" +
			answerOptions + "</B><BR>\n";
	}
	
	public String toTSV() {
		return concept + "\t" + description + "\t" + stepName + "\t" + dependencies + "\t" + questionRef +
			"\t" + actionType + "\t" + action + "\t" + answerOptions;
	}
}
