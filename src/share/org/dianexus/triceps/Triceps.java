import java.lang.*;
import java.util.*;
import java.io.*;
import java.net.*;

/* Triceps
 */
public class Triceps {
	public static final int ERROR = 1;
	public static final int OK = 2;
	public static final int AT_END = 3;

	private Schedule nodes = null;
	private Evidence evidence = null;
	private Parser parser = null;

	private Logger errorLogger = new Logger();
	private static String fileAccessError = null;
	private int currentStep=0;
	private int numQuestions=0;	// so know how many to skip for compount question
	private Date startTime = null;
	private Date stopTime = null;
	private String startTimeStr = null;
	private String stopTimeStr = null;
	private boolean isValid = false;
	private Random random = new Random();
	private String tempPassword = null;
	private int currentLanguage = -1;
	private Lingua lingua =  null;
	
	public Triceps(String scheduleLoc) {
		/* initialize required variables */
		lingua = new Lingua("TricepsBundle");
		nodes = new Schedule(lingua, scheduleLoc);
		setLanguage(null);	// the default until overidden
		
		/* if this is a null instance, don't initialize the unnecessary, expensive variables */
		if (scheduleLoc == null)
			return;
			
		parser = new Parser();
		if (!nodes.init()) {
			setError(nodes.getErrors());
		}
		resetEvidence();
		setDefaultValues();
		createTempPassword();
		
		isValid = true;
	}

	public boolean isValid() { return isValid; }

	public boolean reloadSchedule() {
		return loadDatafile(null);
	}

	public boolean loadDatafile(String name) {
		Schedule oldNodes = nodes;
		Evidence oldEvidence = evidence;

		boolean ok = false;

		if (name != null) {
			nodes = new Schedule(lingua, name);
		}
		else {
			nodes = new Schedule(lingua, nodes.getScheduleSource());
		}

		if (!nodes.init()) {
			nodes = oldNodes;
			return false;
		}

		resetEvidence();
		setDefaultValues();

		for (int i=0;i<oldNodes.size();++i) {
			Node oldNode = oldNodes.getNode(i);
			Node newNode = evidence.getNode(oldNode);	// get newNode with same name or concept as old ones
			if (newNode != null) {
				evidence.set(newNode, oldEvidence.getDatum(oldNode),oldNode.getTimeStampStr());
			}
		}

		/* data/evidence is loaded from working file; but the nodes are from the schedule soruce directory */
		nodes.overloadReserved(oldNodes);
		return true;
	}

	public Datum getDatum(Node n) {
		return evidence.getDatum(n);
	}

	public Date getStartTime() {
		return startTime;
	}

	public String getStartTimeStr() {
		return startTimeStr;
	}
	public String getStopTimeStr() {
		return stopTimeStr;
	}

	public String getScheduleErrors() { return nodes.getErrors(); }

	public Enumeration getQuestions() {
		Vector e = new Vector();
		int braceLevel  = 0;
		int actionType;
		Node node;
		int step = currentStep;

		// should loop over available questions
		do {
			if (step >= size()) {
				if (braceLevel > 0) {
					setError(lingua.get("missing") + braceLevel + lingua.get("closing_braces"));
				}
				break;
			}
			node = nodes.getNode(step++);

			node.setAnswerLanguageNum(currentLanguage);

			actionType = node.getQuestionOrEvalType();
			e.addElement(node);	// add regardless of type

			if (actionType == Node.GROUP_OPEN) {
				++braceLevel;
			}
			else if (actionType == Node.EVAL) {
				node.setError(lingua.get("evals_disallowed_within_question_block") + braceLevel);
				break;
			}
			else if (actionType == Node.GROUP_CLOSE) {
				--braceLevel;
				if (braceLevel < 0) {
					node.setError(lingua.get("extra_closing_brace"));
					break;
				}
			}
			else if (actionType == Node.QUESTION) {
			}
			else {
				node.setError(lingua.get("invalid_action_type"));
				break;
			}
		} while (braceLevel > 0);

		numQuestions = e.size();	// what about error conditions?
		return e.elements();
	}

	public String getQuestionStr(Node q) {
		/* recompute the min and max ranges, if necessary - must be done before premature abort (if invalid entry)*/

		String s;

		s = q.getMinStr();
		if (s != null) {
			Datum d = parser.parse(evidence,s);
			q.setMinDatum(d);
		}
		else
			q.setMinDatum(null);

		s = q.getMaxStr();
		if (s != null) {
			Datum d = parser.parse(evidence,s);
			q.setMaxDatum(d);
		}
		else
			q.setMaxDatum(null);

		q.setQuestionAsAsked(parser.parseJSP(evidence, q.getQuestionOrEval()) + q.getSampleInputString());
		return q.getQuestionAsAsked();
	}

	public int gotoFirst() {
		currentStep = 0;
		numQuestions = 0;
		return gotoNext();
	}

	public int gotoStarting() {
		currentStep = Integer.parseInt(nodes.getReserved(Schedule.STARTING_STEP));
		if (currentStep < 0)
			currentStep = 0;
		numQuestions = 0;
		return gotoNext();
	}

	public int gotoNext() {
		Node node;
		int braceLevel = 0;
		int actionType;
		int step = currentStep + numQuestions;

		if (currentStep == size()) {
			/* then already at end */
			setError(lingua.get("already_at_end_of_interview"));
			return ERROR;
		}

		do {		// loop forward through nodes -- break to query user or to end
			if (step >= size()) {	// then the schedule is complete
				if (braceLevel > 0) {
					setError(lingua.get("missing") + braceLevel + lingua.get("closing_braces"));
				}
				currentStep = size();	// put at last node
				numQuestions = 0;

				/* The current state should be saved in the background after the next set of questions is retrieved.
					It is up to the calling program to call toTSV() to save the state */

				return AT_END;
			}
			if ((node = nodes.getNode(step)) == null) {
				setError(lingua.get("invalid_node_at_step") + step);
				return ERROR;
			}

			actionType = node.getQuestionOrEvalType();
			node.setAnswerLanguageNum(currentLanguage);

			if (actionType == Node.GROUP_OPEN) {
				if (braceLevel == 0) {
					if (parser.booleanVal(evidence, node.getDependencies())) {
						break;	// this is the first node of a block - break out of loop to ask it
					}
					else {
						++braceLevel;	// XXX:  skip this entire section
						evidence.set(node, Datum.getInstance(lingua,Datum.NA));	// and set all of this brace's values to NA
					}
				}
				else {
					++braceLevel;	// skip this inner block
					evidence.set(node, Datum.getInstance(lingua,Datum.NA));	// set all of this brace's values to NA
				}
			}
			else if (actionType == Node.GROUP_CLOSE) {
				--braceLevel;	// close an open block
				evidence.set(node, Datum.getInstance(lingua,Datum.NA));	// closing an open block, so set value to NA
				if (braceLevel < 0) {
					node.setError(lingua.get("extra_closing_brace"));
					return OK;	// otherwise won't be able to progress past the dangling closing brace!
//					return ERROR;
				}
			}
			else if (actionType == Node.EVAL) {
				if (braceLevel > 0) {
					evidence.set(node, Datum.getInstance(lingua,Datum.NA));	// NA if internal to a brace when going forwards
				}
				else {
					if (parser.booleanVal(evidence, node.getDependencies())) {
						Datum datum = parser.parse(evidence, node.getQuestionOrEval());
						node.setDatumType(datum.type());
						evidence.set(node, datum);						
					}
					else {
						evidence.set(node, Datum.getInstance(lingua,Datum.NA));	// if doesn't satisfy dependencies, store NA
					}
				}
			}
			else if (actionType == Node.QUESTION) {
				if (braceLevel > 0) {
					evidence.set(node, Datum.getInstance(lingua,Datum.NA));	// NA if internal to a brace when going forwards
				}
				else {
					if (parser.booleanVal(evidence, node.getDependencies())) {
						break;	// ask this question
					}
					else {
						evidence.set(node, Datum.getInstance(lingua,Datum.NA));	// if doesn't satisfy dependencies, store NA
					}
				}
			}
			else {
				node.setError(lingua.get("invalid_action_type"));
				evidence.set(node, Datum.getInstance(lingua,Datum.NA));
				return ERROR;
			}
			++step;
		} while (true);
		currentStep = step;
		numQuestions = 0;

		/* The current state should be saved in the background after the next set of questions is retrieved.
			It is up to the calling program to call toTSV() to save the state */
		return OK;
	}

	public int gotoNode(Object val) {
		int step = currentStep;

		Node n = evidence.getNode(val);
		if (n == null) {
			setError(lingua.get("unknown_node") + val.toString());
			return ERROR;
		}
		int result = evidence.getStep(n);
		if (result == -1) {
			setError(lingua.get("node_does_not_exist_within_schedule") + n);
			return ERROR;
		} else {
			currentStep = result;
			return OK;
		}
	}

	public int gotoPrevious() {
		Node node;
		int braceLevel = 0;
		int actionType;
		int step = currentStep;

		while (true) {
			if (--step < 0) {
				if (braceLevel < 0)
					setError(lingua.get("missing") + braceLevel + lingua.get("opening_braces"));

				setError(lingua.get("already_at_beginning"));
				return ERROR;
			}
			if ((node = nodes.getNode(step)) == null)
				return ERROR;

			actionType = node.getQuestionOrEvalType();
//			node.setAnswerLanguageNum(currentLanguage);	// do this going backwards?

			if (actionType == Node.EVAL) {
				;	// skip these going backwards, but don't reset values when going backwards
			}
			else if (actionType == Node.GROUP_CLOSE) {
				--braceLevel;
			}
			else if (actionType == Node.GROUP_OPEN) {
				++braceLevel;
				if (braceLevel > 0) {
					setError(lingua.get("extra_opening_brace"));
					return ERROR;
				}
				if (braceLevel == 0 && parser.booleanVal(evidence, node.getDependencies())) {
					break;	// ask this block of questions
				}
				else {
					// try the next question
				}
			}
			else if (actionType == Node.QUESTION) {
				if (braceLevel == 0 && parser.booleanVal(evidence, node.getDependencies())) {
					break;	// ask this block of questions
				}
				else {
					// else within a brace, or not applicable, so skip it.
				}
			}
			else {
				node.setError(lingua.get("invalid_action_type"));
				return ERROR;
			}
		}
		currentStep = step;
		return OK;
	}

	private void startTimer(Date time) {
		startTime = time;
		startTimeStr = lingua.formatDate(startTime,Datum.TIME_MASK);
		stopTime = null;	// reset stopTime, since re-starting
		nodes.setReserved(Schedule.START_TIME,startTimeStr);	// so that saved schedule knows when it was started
	}

	private void stopTimer() {
		if (stopTime == null) {
			stopTime = new Date(System.currentTimeMillis());
			stopTimeStr = lingua.formatDate(stopTime,Datum.TIME_MASK);
		}
	}

	public void resetEvidence() {
		evidence = new Evidence(lingua, this);
	}

	private void setDefaultValues() {
		Node n;
		Datum d;
		String init;
		for (int i=0;i<size();++i) {
			n = nodes.getNode(i);
			if (n == null) {
Logger.writeln("null node at index " + i);
				continue;
			}

			init = n.getAnswerGiven();
			
			d = Datum.parseSpecialType(lingua,init);
			
			if (d == null) {
				d = new Datum(lingua, init,n.getDatumType(),n.getMask());
			}

			evidence.set(n,d,n.getAnswerTimeStampStr());
		}

		startTimer(new Date(System.currentTimeMillis()));	// use current time
	}

	public boolean storeValue(Node q, String answer, String comment, String special, boolean adminMode) {
		if (q == null) {
			setError(lingua.get("node_does_not_exist"));
			return false;
		}

		if (answer == null || answer.trim().equals("")) {
			if (q.getAnswerType() == Node.CHECK) {
				answer = "0";	// unchecked defaults to false
			}
		}
		Datum d;

		if (comment != null) {
			q.setComment(comment);
		}

		if (special != null && special.trim().length() > 0) {
			if (adminMode) {
				d = Datum.parseSpecialType(lingua, special);
				if (d != null) {
					evidence.set(q,d);
					return true;
				}
				setError(lingua.get("unknown_special_datatype"));
				return false;
			}
			else {
				setError(lingua.get("entry_into_admin_mode_disallowed"));
				return false;
			}
		}

		if (q.getAnswerType() == Node.NOTHING && q.getQuestionOrEvalType() != Node.EVAL) {
			evidence.set(q,new Datum(lingua, "",Datum.STRING));
			return true;
		}
		else {
			d = new Datum(lingua, answer,q.getDatumType(),q.getMask()); // use expected value type
		}

		/* check for type error */
		if (!d.exists()) {
			String s = d.getError();
			if (s.length() == 0) {
				q.setError("<- " + lingua.get("answer_this_question"));
			}
			else {
				q.setError("<- " + s);
			}
			evidence.set(q,Datum.getInstance(lingua,Datum.UNASKED));
			return false;
		}

		/* check if out of range */
		if (!q.isWithinRange(d)) {
			evidence.set(q,Datum.getInstance(lingua,Datum.UNASKED));
			return false;	// shouldn't wording of error be done here, not in Node?
		}
		else {
			evidence.set(q, d);
			return true;
		}
	}

	public int size() { return nodes.size(); }

	public Node getNode(int i) {
		return nodes.getNode(i);	// XXX should not allow direct access to this?
	}

	public String toString(Node n) {
		return toString(n,false);
	}

	public String toString(Node n, boolean showReserved) {
		Datum d = getDatum(n);
		if (d == null)
			return "null";
		else
			return d.stringVal(showReserved);
	}

	public boolean isSet(Node n) {
		Datum d = getDatum(n);
		if (d == null || d.isType(Datum.UNASKED))
			return false;
		else
			return true;
	}

	public String evidenceToXML() {
		return evidence.toXML();
	}

	public String toXML() {
		StringBuffer sb = new StringBuffer("<Evidence>\n");
		Node n;
		Datum d;

		for (int i=0;i<size();++i) {
			n = nodes.getNode(i);
			if (n == null)
				continue;

			d = evidence.getDatum(n);
			if (d == null)
				continue;

			sb.append(" <datum name='" + n.getLocalName() + "' value='" + d.stringVal(true) + "'/>\n");
		}
		sb.append("</Evidence>\n");
		return sb.toString();
	}

	public Vector collectParseErrors() {
		/* Simply cycle through nodes, processing dependencies & actions */

		Node n = null;
		Datum d = null;
		Vector parseErrors = new Vector();
		String dependenciesErrors = null;
		String actionErrors = null;
		String answerChoicesErrors = null;
		String readbackErrors = null;
		String nodeParseErrors = null;
		String nodeNamingErrors = null;
		boolean hasErrors = false;

		parser.resetErrorCount();

		for (int i=0;i<size();++i) {
			n = nodes.getNode(i);
			if (n == null)
				continue;

			hasErrors = false;
			dependenciesErrors = null;
			actionErrors = null;
			answerChoicesErrors = null;
			readbackErrors = null;
			nodeParseErrors = null;
			nodeNamingErrors = null;

			parser.booleanVal(evidence, n.getDependencies());

			if (parser.hasErrors()) {
				hasErrors = true;
				dependenciesErrors = parser.getErrors();
			}

			int actionType = n.getQuestionOrEvalType();
			String s = n.getQuestionOrEval();

			/* Check questionOrEval for syntax errors */
			if (s != null) {
				if (actionType == Node.QUESTION) {
					parser.parseJSP(evidence, s);
				}
				else if (actionType == Node.EVAL) {
					parser.stringVal(evidence, s);
				}
			}

			/* Check min & max range delimiters for syntax errors */
			s = n.getMinStr();
			if (s != null) {
				parser.stringVal(evidence, s);
			}
			s = n.getMaxStr();
			if (s != null) {
				parser.stringVal(evidence, s);
			}

			if (parser.hasErrors()) {
				hasErrors = true;
				actionErrors = parser.getErrors();
			}

			Vector v = n.getAnswerChoices();
			if (v != null) {
				for (int j=0;j<v.size();++j) {
					AnswerChoice ac = (AnswerChoice) v.elementAt(j);
					if (ac != null)
						ac.parse(parser, evidence);	// any errors will be associated with the parser, not the node (although this is misleading)
				}
			}

			if (parser.hasErrors()) {
				hasErrors = true;
				answerChoicesErrors = parser.getErrors();
			}

			if (n.hasParseErrors()) {
				hasErrors = true;
				nodeParseErrors = n.getParseErrors();
			}
			if (n.hasNamingErrors()) {
				hasErrors = true;
				nodeNamingErrors = n.getNamingErrors();
			}

			if (n.getReadback(currentLanguage) != null) {
				parser.parseJSP(evidence,n.getReadback(currentLanguage));
			}
			if (parser.hasErrors()) {
				hasErrors = true;
				readbackErrors = parser.getErrors();
			}

			if (hasErrors) {
				parseErrors.addElement(new ParseError(n, dependenciesErrors, actionErrors, answerChoicesErrors, readbackErrors, nodeParseErrors, nodeNamingErrors));
			}
		}
		return parseErrors;
	}

	public boolean toTSV(String dir) {
		return toTSV(dir,nodes.getReserved(Schedule.FILENAME));
	}

	public boolean toTSV(String dir, String targetName) {
		String filename = dir + targetName;
		FileWriter fw = null;
		boolean ok = false;

		stopTimer();

		try {
			File f = new File(filename);

			fw = new FileWriter(filename);
			ok = writeTSV(fw);
		}
		catch (IOException e) {
			String msg = lingua.get("error_writing_to") + filename + ": " + e.getMessage();
			setError(msg);
		}
		if (fw != null) {
			try { fw.close(); } catch (IOException t) { }
		}
		return ok;
	}

	public boolean writeTSV(Writer out) {
		Node n;
		Datum d;
		String ans;

		if (out == null)
			return false;


		try {
			/* Write header information */
			/* set save file so can resume at same position */
			nodes.setReserved(Schedule.STARTING_STEP,Integer.toString(currentStep));
			nodes.toTSV(out);

			/* Write comments saying when started and stopped.  If multiply resumed, will list these several times */
			out.write("COMMENT " + "Schedule: " + nodes.getReserved(Schedule.LOADED_FROM) + "\n");
			out.write("COMMENT " + "Started: " + getStartTimeStr() + "\n");
			out.write("COMMENT " + "Stopped: " + getStopTimeStr() + "\n");

			/* Show the names of the output columns */
			out.write("COMMENT " + "concept\tinternalName\texternalName\tdependencies\tquestionOrEvalType");
			for (int i=0;i<nodes.getLanguages().size();++i) {
				out.write("\treadback[" + i + "]" +
					"\tquestionOrEval[" + i + "]" +
					"\tanswerChoices[" + i + "]" +
					"\thelpURL[" + i + "]");
			}
			out.write("\tlanguageNum\tquestionAsAsked\tanswerGiven\tcomment\ttimeStamp\n");

			for (int i=0;i<size();++i) {
				n = nodes.getNode(i);
				if (n == null)
					continue;

				d = evidence.getDatum(n);
				if (d == null) {
					ans = "";	// NULL
				}
				else {
					ans = d.stringVal(true);
				}
				String comment = n.getComment();
				if (comment == null)
					comment = "";

				out.write(n.toTSV() +
					"\t" + n.getAnswerLanguageNum() +
					"\t" + n.getQuestionAsAsked() +
					"\t" + ans +
					"\t" + comment +
					"\t" + n.getTimeStampStr() + "\n");
			}
			out.flush();
			return true;
		}
		catch (IOException e) {
			String msg = lingua.get("Unable_to_write_schedule_file") + e.getMessage();
			setError(msg);
			return false;
		}
	}

	public String getTitle() {
		return nodes.getReserved(Schedule.TITLE);
	}

	public String getPasswordForAdminMode() {
		String s = nodes.getReserved(Schedule.PASSWORD_FOR_ADMIN_MODE);
		if (s == null || s.trim().length() == 0)
			return null;
		else
			return s;
	}

	public boolean isShowAdminModeIcons() {
		return Boolean.valueOf(nodes.getReserved(Schedule.SHOW_ADMIN_ICONS)).booleanValue();
	}
	public boolean isShowQuestionRef() {
		return Boolean.valueOf(nodes.getReserved(Schedule.SHOW_QUESTION_REF)).booleanValue();
	}
	public boolean isAutoGenOptionNum() {
		return Boolean.valueOf(nodes.getReserved(Schedule.AUTOGEN_OPTION_NUM)).booleanValue();
	}
	public boolean isDebugMode() {
		return Boolean.valueOf(nodes.getReserved(Schedule.DEBUG_MODE)).booleanValue();
	}
	public boolean isDeveloperMode() {
		return Boolean.valueOf(nodes.getReserved(Schedule.DEVELOPER_MODE)).booleanValue();
	}
	public boolean isAllowComments() {
		return Boolean.valueOf(nodes.getReserved(Schedule.ALLOW_COMMENTS)).booleanValue();
	}
	public boolean isAllowLanguageSwitching() {
		return Boolean.valueOf(nodes.getReserved(Schedule.ALLOW_LANGUAGE_SWITCHING)).booleanValue();
	}

	public String getIcon() { return nodes.getReserved(Schedule.ICON); }
	public String getHeaderMsg() { return nodes.getReserved(Schedule.HEADER_MSG); }

	public void setPasswordForAdminMode(String s) { nodes.setReserved(Schedule.PASSWORD_FOR_ADMIN_MODE,s); }

	public Datum evaluateExpr(String expr) {
		return parser.parse(evidence,expr);
	}

	public String getFilename() { return nodes.getReserved(Schedule.FILENAME); }
	public boolean setFilename(String name) { return nodes.setReserved(Schedule.FILENAME, name); }

	public boolean setLanguage(String language) {
		boolean ok = false;

		ok = nodes.setReserved(Schedule.CURRENT_LANGUAGE,language);
		int lang = getLanguage();
		
		if (lang == currentLanguage) {
			return ok;
		}
		currentLanguage = lang;
		
		if (!nodes.isLoaded())
			return ok;
		
		/* re-calculate all eval nodes that meet dependencies, using the new language */
		for (int i=0;i<=currentStep;++i) {	// XXX: <, or <=?
			Node node = nodes.getNode(i);
			if (node == null)
				continue;
				
			if (node.getQuestionOrEvalType() == Node.EVAL) {
				node.setAnswerLanguageNum(currentLanguage);	// don't change the language for non-EVAL nodes - want to know what was asked
				if (parser.booleanVal(evidence, node.getDependencies())) {
					Datum datum = parser.parse(evidence, node.getQuestionOrEval());
					node.setDatumType(datum.type());
					evidence.set(node, datum);
				}
				else {
					evidence.set(node, Datum.getInstance(lingua,Datum.NA));	// if doesn't satisfy dependencies, store NA
				}
			}
		}
		
		return ok;
	}
	public int getLanguage() { return nodes.getLanguage(); }

	public String createTempPassword() {
		tempPassword = Long.toString(random.nextLong());
		return tempPassword;
	}

	public boolean isTempPassword(String s) {
		String temp = tempPassword;
		createTempPassword();	// reset it

		if (s == null)
			return false;
		return s.equals(temp);
	}

	private void setError(String s) { errorLogger.println(s); }
	public boolean hasErrors() { return (errorLogger.size() > 0); }
	public String getErrors() { return errorLogger.toString(); }
	
	public int getCurrentLanguage() { return currentLanguage; }
	public Schedule getSchedule() { return nodes; }
	public Evidence getEvidence() { return evidence; }
	public Parser getParser() { return parser; }
	public Lingua getLingua() { return lingua; }
}
