/* ******************************************************** 
** Copyright (c) 2000-2001, Thomas Maxwell White, all rights reserved. 
** $Header$
******************************************************** */ 

package org.dianexus.triceps;

/*import java.lang.*;*/
/*import java.util.*;*/
/*import java.text.*;*/
/*import java.io.*;*/
/*import java.net.*;*/
/*import java.util.zip.*;*/
/*import java.util.jar.*;*/

import java.util.Date;
import java.lang.String;
import java.util.Random;
import java.util.Locale;
import java.util.ResourceBundle;
import java.util.Hashtable;
import java.io.File;
import java.util.Enumeration;
import java.util.Vector;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.StringTokenizer;
import java.util.MissingResourceException;
import java.text.SimpleDateFormat;
import java.io.FileNotFoundException;
import java.lang.SecurityException;
import java.io.InputStream;
import java.io.FileInputStream;
import java.util.zip.ZipFile;
import java.util.zip.ZipEntry;

/*public*/ class Triceps implements VersionIF {
	private static final String DATAFILE_PREFIX = "tri";
	private static final String DATAFILE_SUFFIX = ".dat";
	private static final String EVENTFILE_SUFFIX = ".evt";
	static final String ERRORLOG_SUFFIX = ".log.err";
	
	/*public*/ static final int ERROR = 1;
	/*public*/ static final int OK = 2;
	/*public*/ static final int AT_END = 3;
	/*public*/ static final int AT_START = 4;
	/*public*/ static final int WORKING_DIR = 1;
	/*public*/ static final int COMPLETED_DIR = 2;
	/*public*/ static final int FLOPPY_DIR = 3;
	/*public*/ static final String SUSPEND_DIR = "suspended/";


	private Schedule nodes = null;
	private Evidence evidence = null;
	private Parser parser = null;

	private Logger errorLogger = null;
	private int currentStep=0;
	private int numQuestions=0;	// so know how many to skip for compount question
	private int firstStep = 0;
	private Date startTime = null;
	private Date stopTime = null;
	private String startTimeStr = null;
	private String stopTimeStr = null;
	private boolean isValid = false;
	private Random random = new Random();
	private String tempPassword = null;
	Logger dataLogger = Logger.NULL;	
	Logger eventLogger = Logger.NULL;
	private int displayCount = -1;	// count the number of times data has been sent 
	private String displayCountStr = null;
	private long timeSent = 0;
	private long timeReceived = 0;
	
	/** formerly from Lingua */
	private static final Locale defaultLocale = Locale.getDefault();
	private ResourceBundle bundle = null;
	private static final String BUNDLE_NAME = "TricepsBundle";
	private Locale locale = defaultLocale;
	private Vector currentNodeSet = new Vector();	// starts with zero nodes

	/* Hold on to instances of Date and Number format for fast and easy retrieval */
	private static final Hashtable dateFormats = new Hashtable();
	private static final Hashtable numFormats = new Hashtable();
	private static final String DEFAULT = "null";

	/*public*/ static final Triceps NULL = new Triceps();

	private Triceps() {
		this(null,null,null,null);
		isValid = false;
	}


	/*public*/ Triceps(String scheduleLoc, String workingFilesDir, String completedFilesDir, String floppyDir) {
		/* initialize required variables */
		timeSent = timeReceived = System.currentTimeMillis();	// gets a sense of the class load time
		parser = new Parser();	
		setLocale(null);	// the default
		errorLogger = new Logger();
		if (scheduleLoc != null) {
			createDataLogger(workingFilesDir,null);
		}
		isValid = init(scheduleLoc,workingFilesDir,completedFilesDir,floppyDir,true);
		initDisplayCount();
	}
	
	private boolean init(String scheduleLoc, String workingFilesDir, String completedFilesDir, String floppyDir,boolean log) {
		evidence = new Evidence(this);
		boolean val = setSchedule(scheduleLoc,workingFilesDir,completedFilesDir,floppyDir,log);
//if (DEBUG)	showNodes();
		return val;		
	}
	
	/*public*/ void deleteDataLoggers() {
		dataLogger.delete();
		dataLogger = Logger.NULL;
		eventLogger.delete();
		eventLogger = Logger.NULL;
	}
	
	/*public*/ void closeDataLogger() {
if (DEPLOYABLE) {
		if (dataLogger != null)
			dataLogger.close();
		if (eventLogger != null)
			eventLogger.close();
}			
	}
	
	/*public*/ void createDataLogger(String dir, String name) {
if (DEPLOYABLE) {		
		try {
			File tempDataFile = null;
			File tempEventFile = null;
			
			if (name == null) {
				tempDataFile = EvidenceIO.createTempFile(DATAFILE_PREFIX, DATAFILE_SUFFIX, new File(dir));
				tempEventFile = new File(tempDataFile.toString() + EVENTFILE_SUFFIX);
			}
			else {
				tempDataFile = new File(name);
				tempEventFile = new File(name + EVENTFILE_SUFFIX);
			}
			if (!tempDataFile.toString().equals(dataLogger.getFilename())) {
				dataLogger.delete();
			}
			if (!tempEventFile.toString().equals(eventLogger.getFilename())) {
				eventLogger.delete();
			}
			
			dataLogger = new Logger(Logger.UNIX_EOL,true,tempDataFile);
			eventLogger = new Logger(Logger.UNIX_EOL,true,tempEventFile);
		}
		catch (Throwable t) {
			setError("Triceps.createDataLogger()-unable to create temp file" + t.getMessage());
		}
}	// DEPLOYABLE
		if (dataLogger == null) {
			dataLogger = Logger.NULL;
			setError("Triceps.createDataLogger()->writer is null");			
		}
		if (eventLogger == null) {
			eventLogger = Logger.NULL;
			setError("Triceps.createEventLogger()->writer is null");			
		}
if (DEPLOYABLE) {
		eventLogger.println("**" + VERSION_NAME + " Log file started on " + new Date(System.currentTimeMillis()));
}			
	}

	/*public*/ boolean setSchedule(String scheduleLoc, String workingFilesDir, String completedFilesDir, String floppyDir, boolean log) {
		if (scheduleLoc == null) {
			nodes = Schedule.NULL;
			return false;
		}
		
		nodes = new Schedule(this, scheduleLoc);
		setLanguage(null);	// the default until overidden

		createTempPassword();

		if (nodes.init(log) && setExpertValues()) {
			nodes.setReserved(Schedule.WORKING_DIR,workingFilesDir);
			nodes.setReserved(Schedule.COMPLETED_DIR,completedFilesDir);
			nodes.setReserved(Schedule.FLOPPY_DIR,floppyDir);
			return true;
		}
		else {
			setError(nodes.getErrors());
			return false;
		}
	}
	
	/** Some variables must not be modifiable from the datafile - detect tampering
	*/
	/*public*/ boolean setExpertValues() {
		/* FIXME:
			compare Triceps versions - abort if incompatible
			compare Schedule versions - abort if incompatible
		*/
		return true;
	}

	/*public*/ boolean isValid() { return isValid; }

	/*public*/ boolean reloadSchedule() {
if (AUTHORABLE) {
		Schedule oldNodes = nodes;
		Evidence oldEvidence = evidence;
		boolean ok = false;
		
		ok = init(oldNodes.getReserved(Schedule.SCHEDULE_SOURCE), 
			oldNodes.getReserved(Schedule.WORKING_DIR), 
			oldNodes.getReserved(Schedule.COMPLETED_DIR), 
			oldNodes.getReserved(Schedule.FLOPPY_DIR),
			false);
			
		if (!ok) {
			setError("Unable to reload schedule");			
			nodes = oldNodes;
			evidence = oldEvidence;
			return false;
		}
		
		for (int i=0;i<oldNodes.size();++i) {
			Node oldNode = oldNodes.getNode(i);
			Node newNode = evidence.getNode(oldNode);	// get newNode with same name or concept as old ones
			if (newNode != null) {
				evidence.set(newNode, oldEvidence.getDatum(oldNode),oldNode.getTimeStampStr(),false);	// don't record this, since already recorded
			}
		}

		/* data/evidence is loaded from working file; but the nodes are from the schedule source directory */
		nodes.overloadReserved(oldNodes);
}
		return true;
	}

	/*public*/ Datum getDatum(Node n) {
		return evidence.getDatum(n);
	}

	/*public*/ Date getStartTime() {
		return startTime;
	}

	/*public*/ String getStartTimeStr() {
		return startTimeStr;
	}
	/*public*/ String getStopTimeStr() {
		return stopTimeStr;
	}

	/*public*/ String getScheduleErrors() { return nodes.getErrors(); }

	/*public*/ String getQuestionStr(Node q) {
		/* recompute the min and max ranges, if necessary - must be done before premature abort (if invalid entry)*/

		String s;

		s = q.getMinStr();
		if (s != null) {
			Datum d = parser.parse(this,s);
			q.setMinDatum(d);
		}
		else
			q.setMinDatum(null);

		s = q.getMaxStr();
		if (s != null) {
			Datum d = parser.parse(this,s);
			q.setMaxDatum(d);
		}
		else
			q.setMaxDatum(null);

		Vector v = q.getAllowableValues();
		if (v != null) {
			Vector vd = new Vector();
			for (int i=0;i<v.size();++i) {
				vd.addElement(parser.parse(this,(String) v.elementAt(i)));
			}
			q.setAllowableDatumValues(vd);
		}

		q.setQuestionAsAsked(parser.parseJSP(this, q.getQuestionOrEval()) + q.getSampleInputString());
		return q.getQuestionAsAsked();
	}

	/*public*/ int gotoFirst() {
		currentStep = 0;
		numQuestions = 0;
		int ok = gotoNext();
		firstStep = currentStep;
		return ok;
	}

	/*public*/ int gotoStarting() {
//		gotoFirst();	// to set firstStep for determining minimum step number
		currentStep = Integer.parseInt(nodes.getReserved(Schedule.STARTING_STEP));
		if (currentStep < 0)
			currentStep = 0;
		numQuestions = 0;
		return gotoNext();
	}

	/*public*/ int jumpToFirstUnasked() {
		int ok=OK;
		Node node;
		Datum datum;
		Enumeration enum;
		
		while(true) {
			enum = getQuestions();
			while(enum.hasMoreElements()) {
				node = (Node) enum.nextElement();
				datum = evidence.getDatum(node);
				if (datum.isUnasked()) {
					return ok;	// break to use this set of questions
				}
			}
			ok = gotoNext();
			if (ok != OK) {
				return ok;
			}
		}
	}

	/*public*/ int gotoNode(Object val) {
		int step = currentStep;

		Node n = evidence.getNode(val);
		if (n == null) {
			setError(get("unknown_node") + val.toString());
			return ERROR;
		}
		int result = evidence.getStep(n);
		if (result == -1) {
			setError(get("node_does_not_exist_within_schedule") + n);
			return ERROR;
		} else {
			currentStep = result;
			numQuestions = 0;	// so that selects next group of nodes (and skips over 'e's and not applicables)
			return gotoNext();
//			// will jump to that single node (and not show surrounding issues)
//			currentNodeSet = new Vector();
//			currentNodeSet.addElement(n);
//			numQuestions = 1;
//			return OK;
		}
	}

	private void startTimer(Date time) {
		startTime = time;
		startTimeStr = formatDate(startTime,Datum.TIME_MASK);
		stopTime = null;	// reset stopTime, since re-starting
		nodes.setReserved(Schedule.START_TIME,Long.toString(time.getTime()));	// so that saved schedule knows when it was started
	}

	private void stopTimer() {
		stopTime = new Date(System.currentTimeMillis());
		stopTimeStr = formatDate(stopTime,Datum.TIME_MASK);
	}

	/*public*/ void resetEvidence(boolean toUnasked) {
		startTimer(new Date(System.currentTimeMillis()));	// use current time
		evidence.reset();
	}

	/*public*/ void resetEvidence() {
		resetEvidence(true);
	}

	/*public*/ boolean storeValue(Node q, String answer, String comment, String special, boolean adminMode) {
		boolean ok = false;
		Datum d = null;
		
		if (q == null) {
			setError(get("node_does_not_exist"));
			return false;
		}

		if (answer == null || answer.trim().equals("")) {
			if (q.getAnswerType() == Node.CHECK) {
				answer = "0";	// unchecked defaults to false
			}
		}

		if (comment != null) {
			q.setComment(comment);
		}

		if (special != null && special.trim().length() > 0) {
			if (q.getAnswerType() == Node.PASSWORD) {
				/* 9/24/2002 - Modify this to prevent bypassing of password fields */
				q.setError(get("passwords_cannot_be_bypassed"));
				return false;
			}
			if (adminMode) {
				d = Datum.parseSpecialType(this, special);
				if (d != null) {
					evidence.set(q,d);
					return true;
				}
				else {
					setError(get("unknown_special_datatype"));
					return false;
				}
			}
			else {
				setError(get("entry_into_admin_mode_disallowed"));
				return false;
			}
		}

		if (q.getAnswerType() == Node.NOTHING && q.getQuestionOrEvalType() != Node.EVAL) {
			evidence.set(q,new Datum(this, "",Datum.STRING));
			return true;
		}
		else {
			d = new Datum(this, answer,q.getDatumType(),q.getMask()); // use expected value type
			/* check for type error */
			
			if (!d.exists()) {
				String s = d.getError();
				if (s.length() == 0) {
					q.setError(get("answer_this_question"));	// remove arrow - might bias towards a certain answer
				}
				else {
					q.setError(s);	// remove arrow - might bias answer
				}
				d = Datum.getInstance(this,Datum.UNASKED);
				ok = false;
			}
			else {
				/* check if out of range */
				if (!q.isWithinRange(d)) {
					d = Datum.getInstance(this,Datum.UNASKED);
					ok = false;	// shouldn't wording of error be done here, not in Node?
				}
				else {
					ok = true;
				}
			}
			evidence.set(q,d);
			return ok;			
		}
	}
	
	/*public*/ int size() { return nodes.size(); }

	/*public*/ String toString(Node n) {
		return toString(n,false);
	}

	/*public*/ String toString(Node n, boolean showReserved) {
		Datum d = getDatum(n);
		if (d == null)
			return "null";
		else
			return d.stringVal(showReserved);
	}

	/*public*/ boolean isSet(Node n) {
		Datum d = getDatum(n);
		if (d == null || d.isType(Datum.UNASKED))
			return false;
		else
			return true;
	}

	/*public*/ Vector collectParseErrors() {
		/* Simply cycle through nodes, processing dependencies & actions */

		Node n = null;
		Datum d = null;
		Vector parseErrors = new Vector();
if (AUTHORABLE) {
		String dependenciesErrors = null;
		String actionErrors = null;
		String answerChoicesErrors = null;
		String readbackErrors = null;
		String nodeParseErrors = null;
		String nodeNamingErrors = null;
		boolean hasErrors = false;
		int currentLanguage = nodes.getLanguage();

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

			parser.booleanVal(this, n.getDependencies());

			if (parser.hasErrors()) {
				hasErrors = true;
				dependenciesErrors = parser.getErrors();
			}

			int actionType = n.getQuestionOrEvalType();
			String s = n.getQuestionOrEval();

			/* Check questionOrEval for syntax errors */
			if (s != null) {
				if (actionType == Node.QUESTION) {
					parser.parseJSP(this, s);
				}
				else if (actionType == Node.EVAL) {
					parser.stringVal(this, s);
				}
			}

			/* Check min & max range delimiters for syntax errors */
			s = n.getMinStr();
			if (s != null) {
				parser.stringVal(this, s);
			}
			s = n.getMaxStr();
			if (s != null) {
				parser.stringVal(this, s);
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
						ac.parse(this);	// any errors will be associated with the parser, not the node (although this is misleading)
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
				parser.parseJSP(this,n.getReadback(currentLanguage));
			}
			if (parser.hasErrors()) {
				hasErrors = true;
				readbackErrors = parser.getErrors();
			}

			if (hasErrors) {
				parseErrors.addElement(new ParseError(n, dependenciesErrors, actionErrors, answerChoicesErrors, readbackErrors, nodeParseErrors, nodeNamingErrors));
			}
		}
}
		return parseErrors;
	}

	/*public*/ String saveCompletedInfo(String subdir) {
if (DEPLOYABLE) {
		if (dataLogger == Logger.NULL || eventLogger == Logger.NULL) {
			setError("Triceps.saveCompletedInfo:  data and/or event loggers already closed");			
			return null;	// indicates that info was already logged, or some more fundamental error occurred
		}

		String name = saveAsJar(subdir, nodes.getReserved(Schedule.FILENAME));
		if (name != null) {
			return name;
		}
		setError("Triceps.saveCompletedInfo: unable to saveAsJar");						
		return null;
}
		return null;		
	}
	
	public boolean createDir(String subdir) {
		if ("".equals(subdir) || ".".equals(subdir)) {
			return true;	// indicates that writing to current directory
		}
		
		File dir = new File(subdir);
		try {
			if (!dir.isDirectory()) {
				if (dir.isFile()) {
					setError("unable to create directory with the same name as a file: " + subdir);
					return false;
				}
				else {
					if (!dir.mkdir()) {
						setError("unable to create directory " + subdir);
						return false;
					}
				}
			}
			if (!dir.canWrite()) {
				setError("unable to write to directory " + subdir);
				return false;
			}
			if (!dir.canRead()) {
				setError("unable to read from directory " + subdir);
				return false;
			}
			return true;
					
		}
		catch (Exception e) {
			setError("Triceps.testDir:  " + e.getMessage());
			return false;
		}
	}
	
	private String saveAsJar(String subdir, String fn) {
if (DEPLOYABLE) {
		/* create jar or zip file of data and events */
		JarWriter jw = null;
		
		String sourceDir = nodes.getReserved(Schedule.COMPLETED_DIR) + subdir;
		String name = sourceDir + fn + ".jar";
		
		if (!createDir(sourceDir)) {
			return null;
		}
		
		jw = JarWriter.getInstance(name);
		
		if (jw == null)
			return null;
			
		boolean ok = true;
		ok = jw.addEntry(fn + DATAFILE_SUFFIX, dataLogger.getInputStream());
		ok = jw.addEntry(fn + DATAFILE_SUFFIX + EVENTFILE_SUFFIX, eventLogger.getInputStream()) && ok;
if (SAVE_ERROR_LOG_WITH_DATA) {
		ok = jw.addEntry(fn + ERRORLOG_SUFFIX, Logger.getDefaultInputStream()) && ok;		
}
		jw.close();
		
		File f = new File(name);
		if (f.length() == 0L) {
			setError("saveAsJar: file has 0 size");
			ok = false;
		}
		
		/* integrity check - ensure that JarFile has two entries of proper size */
		ZipFile jf = null;
		File srcFile = null;
		
		try {
			jf = new ZipFile(name);
			ZipEntry je = null;
			String srcName = null;
			String srcLogger = null;
			
			for (int i=0;i<2;++i) {
				if (i == 0) {
					srcName = fn + DATAFILE_SUFFIX;
					srcLogger = dataLogger.getFilename();
				}
				else {
					srcName = fn + DATAFILE_SUFFIX + EVENTFILE_SUFFIX;
					srcLogger = eventLogger.getFilename();
				}
				// ignore whether saved Triceps.err.log correctly
				je = jf.getEntry(srcName);
				srcFile = new File(srcLogger);
				
				if (je.getSize() != srcFile.length()) {
					setError("Error saving data:  " + srcName + "(" + srcFile.getName() + ") has size " + srcFile.length() + ", but copy stored in " + jf.getName() + " has size " + je.getSize());
					ok = false;
				}
			}
		}
		catch (Throwable e) {
			setError("##saveAsJar " + e.getMessage());
			ok = false;
		}
		if (jf != null) try { jf.close(); } catch (Throwable t) { }
		
		if (!ok) {
			setError("Please try again!");
		}
		
		return ((ok) ? name : null);
}
		return null;		
	}
	
	/*public*/ String copyCompletedToFloppy(String subdir) {
		// change this so that copies to a:\suspended directory
		String name = nodes.getReserved(Schedule.FILENAME) + ".jar";
		String sourceDir = nodes.getReserved(Schedule.COMPLETED_DIR) + subdir;
		String floppyDir = nodes.getReserved(Schedule.FLOPPY_DIR) + subdir;
		
		if (!createDir(sourceDir)) {
			return null;
		}
		
		if (!createDir(floppyDir)) {
			return null;
		}
		
		boolean ok = JarWriter.NULL.copyFile(sourceDir + name, floppyDir + name);
		if (JarWriter.NULL.hasErrors()) {
			setError(JarWriter.NULL.getErrors());
		}
		if (ok)
			return name;
		else {
			setError(get("error_saving_data_to") + floppyDir);
			return null;
		}
	}
	
	
	/*public*/ String suspendToFloppy() {
		String savedName = this.saveCompletedInfo(Triceps.SUSPEND_DIR);
		savedName = this.copyCompletedToFloppy(Triceps.SUSPEND_DIR);
		if (savedName != null) {
			// now delete copy from completed dir so that they don't accumulate?
			String name = nodes.getReserved(Schedule.COMPLETED_DIR) + Triceps.SUSPEND_DIR + nodes.getReserved(Schedule.FILENAME) + ".jar";
			File file = new File(name);
			try {
				file.delete(); 
			}
			catch (Exception e) {
				this.setError("unable to delete " + name + ": " + e.getMessage());
			}				
			return savedName;
		}
		else {
			return null;
		}
	}	
	
	/*public*/ String getTitle() {
		return nodes.getReserved(Schedule.TITLE);
	}

	/*public*/ String getPasswordForAdminMode() {
		String s = nodes.getReserved(Schedule.PASSWORD_FOR_ADMIN_MODE);
		if (s == null || s.trim().length() == 0)
			return null;
		else
			return s;
	}

	/*public*/ String getIcon() { return nodes.getReserved(Schedule.ICON); }
	/*public*/ String getHeaderMsg() { return nodes.getReserved(Schedule.HEADER_MSG); }

	/*public*/ Datum evaluateExpr(String expr) {
if (AUTHORABLE) {
		return parser.parse(this,expr);
} else { return null; }
	}

	/*public*/ String getFilename() { return nodes.getReserved(Schedule.FILENAME); }

	/*public*/ boolean setLanguage(String language) {
		return nodes.setReserved(Schedule.CURRENT_LANGUAGE,language);
	}
	/*public*/ int getLanguage() { return nodes.getLanguage(); }

	/*public*/ String createTempPassword() {
		tempPassword = Long.toString(random.nextLong());
		return tempPassword;
	}

	/*public*/ boolean isTempPassword(String s) {
		String temp = tempPassword;
		createTempPassword();	// reset it

		if (s == null)
			return false;
		return s.equals(temp);
	}

	/*public*/ void setError(String s) { 
if (DEBUG) Logger.writeln("##" + s);		
		errorLogger.println(s); 
	}
	/*public*/ boolean hasErrors() { return (errorLogger.size() > 0); }
	/*public*/ String getErrors() { return errorLogger.toString(); }

	/*public*/ Schedule getSchedule() { return nodes; }
	/*public*/ Evidence getEvidence() { return evidence; }
	/*public*/ Parser getParser() { return parser; }

	/*public*/ boolean isAtBeginning() { return (currentStep <= firstStep); }
	/*public*/ boolean isAtEnd() { return (currentStep >= size()); }
	/*public*/ int getCurrentStep() { return currentStep; }

	/*public*/ void processEventTimings(String src) {
if (DEPLOYABLE) {		
		if (src == null) {
			return;
		}

		StringTokenizer lines = new StringTokenizer(src,"\t",false);
		StringTokenizer vals = null;
		String line = null;
		String token = null;
		int tokenCount = 0;
		StringBuffer sb = null;
		
		while(lines.hasMoreTokens()) {
			line = (String) lines.nextToken();
			vals = new StringTokenizer(line,",",true);
			tokenCount = vals.countTokens();
//if (DEBUG) Logger.writeln("" + tokenCount + "\t" + line);			
			eventLogger.print(displayCountStr + "\t");
			
			tokenCount = 0;
			while(vals.hasMoreTokens()) {
				token = (String) vals.nextToken();
				if (tokenCount >= 6) {
					sb = new StringBuffer(token);
					// remaining contents may contain commas, and thus be incorrectly treated as tokens
					// so, merge remaining contents into a single value
					while (vals.hasMoreTokens()) {
						sb.append((String) vals.nextToken());
					}
					token = sb.toString();
				}
				else if (token.equals(",")) {
					eventLogger.print("\t");
					++tokenCount;
					continue;
				}
				if (tokenCount >= 5) {
					eventLogger.print(InputEncoder.encode(token));
				}
				else {
					eventLogger.print(token);
				}
			}
			eventLogger.println("");
		}
		
		eventLogger.flush();	// so that committed to disk
}		
	}

	private void initDisplayCount() {
		displayCountStr = nodes.getReserved(Schedule.DISPLAY_COUNT);
		displayCount = 0;
		try {
			displayCount = Integer.parseInt(displayCountStr);
		}
		catch (NumberFormatException e) {
if (DEBUG) Logger.writeln("##NumberFormatException @ Triceps.initDisplayCount()" + e.getMessage());
			displayCount = 0;
		}
		nodes.setReserved(Schedule.DISPLAY_COUNT,Integer.toString(displayCount));
	}

	/*public*/ void sentRequestToUser() {
		incrementDisplayCount();
if (DEPLOYABLE) {		
		timeSent = System.currentTimeMillis();
		eventLogger.println(displayCountStr + "\t\t\tsent_request\t" + timeSent + "\t" + (timeSent - timeReceived) + "\t\t");
		eventLogger.flush();	// so that committed to disk
}		
	}
	
	/*public*/ void receivedResponseFromUser() {
if (DEPLOYABLE) {		
		timeReceived = System.currentTimeMillis();
		eventLogger.println(displayCountStr + "\t\t\treceived_response\t" + timeReceived + "\t" + (timeReceived - timeSent) + "\t\t");
		eventLogger.flush();	// so that committed to disk
}
	}
	
	private void incrementDisplayCount() {
		displayCountStr = Integer.toString(++displayCount);
		nodes.setReserved(Schedule.DISPLAY_COUNT,displayCountStr);	// so that can track the screen count over temporally disjointed sessions
	}
	
	String getDisplayCount() {
		return displayCountStr;
	}

	/* Formerly from Lingua */

	/*public*/ static Locale getLocale(String lang, String country, String extra) {
		return new Locale((lang == null) ? "" : lang,
			(country == null) ? "" : country,
			(extra == null) ? "" : extra);
	}

	/*public*/ void setLocale(Locale loc) {
		locale = (loc == null) ? defaultLocale : loc;
		loadBundle();
	}

	private void loadBundle() {
		try {
			bundle = ResourceBundle.getBundle(BUNDLE_NAME,locale);
		}
		catch (MissingResourceException t) {
			setError("error loading resources '" + BUNDLE_NAME + "': " + t.getMessage());
		}
	}

	/*public*/ String get(String localizeThis) {
		if (bundle == null || localizeThis == null) {
			return "";
		}
		else {
			String s = null;

			try {
				s = bundle.getString(localizeThis);
			}
			catch (MissingResourceException e) {
				setError("MissingResourceException @ Triceps.get()" + e.getMessage());
			}

			if (s == null || s.trim().length() == 0) {
				setError("error accessing resource '" + BUNDLE_NAME + "[" + localizeThis + "]'");
				return "";
			}
			else {
				return s;
			}
		}
	}

	private DateFormat getDateFormat(String mask) {
		String key = locale.toString() + "_" + ((mask == null) ? DEFAULT : mask);

		Object obj = dateFormats.get(key);
		if (obj != null) {
			return (DateFormat) obj;
		}

		DateFormat sdf = null;

		if (mask != null) {
			sdf = new SimpleDateFormat(mask,locale);
		}

		if (sdf == null) {
			Locale.setDefault(locale);
			sdf = new SimpleDateFormat();	// get the default for the locale
			Locale.setDefault(defaultLocale);
		}
		dateFormats.put(key,sdf);
		return sdf;
	}

	private DecimalFormat getDecimalFormat(String mask) {
		String key = locale.toString() + "_" + ((mask == null) ? DEFAULT : mask);

		Object obj = numFormats.get(key);
		DecimalFormat df = null;

		if (obj != null) {
			return (DecimalFormat) obj;
		}
		else {
			try {
				if (mask != null) {
					Locale.setDefault(locale);
					df = new DecimalFormat(mask);
					Locale.setDefault(defaultLocale);
				}
			}
			catch (SecurityException e ) {
if (DEBUG) Logger.writeln("##SecurityException @ Triceps.getDecimalFormat()" + e.getMessage());
				}
			catch (NullPointerException e) {
if (DEBUG) Logger.writeln("##error creating DecimalFormat for locale " + locale.toString() + " using mask " + mask);
			}
			if (df == null) {
				;	// allow this - will use Double.format() internally
			}
			numFormats.put(key,df);
			return df;
		}
	}

	/*public*/ Number parseNumber(Object obj, String mask) {
		Number num = null;

		if (obj == null || obj instanceof Date) {
			num = null;
		}
		else if (obj instanceof Number) {
			num = (Number) obj;
		}
		else {
			DecimalFormat df;
			String str = (String) obj;
			if (str.trim().length() == 0)
				return null;

			if (mask == null || ((df = getDecimalFormat(mask)) == null)) {
				Double d = null;

				try {
					d = Double.valueOf(str);
				}
				catch (NumberFormatException t) {}
				catch (NullPointerException e) {}
				if (d != null) {
					num = assessDouble(d);
				}
			}
			else {
				try {
					num = df.parse(str);
				}
				catch (java.text.ParseException e) {
if (DEBUG) Logger.writeln("##ParseException @ Triceps.parseNumber()" + e.getMessage());
				}
			}
		}

		return num;
	}

	/*public*/ Date parseDate(Object obj, String mask) {
		Date date = null;
		if (obj == null) {
			date = null;
		}
		else if (obj instanceof Date) {
			date = (Date) obj;
		}
		else if (obj instanceof String) {
			String src = (String) obj;
			try {
				if (src.trim().length() > 0) {
					DateFormat df = getDateFormat(mask);
					date = df.parse(src);
				}
				else {
					date = null;
				}
			}
			catch (java.text.ParseException e) {
if (DEBUG) Logger.writeln("##Error parsing date " + obj + " with mask " + mask);
			}
		}
		else {
			date = null;
		}
		return date;
	}

	/*public*/ boolean parseBoolean(Object obj) {
		if (obj == null) {
			return false;
		}
		else if (obj instanceof Number) {
			return (((Number) obj).doubleValue() != 0);
		}
		else if (obj instanceof String) {
			return Boolean.valueOf((String) obj).booleanValue();
		}
		else {
			return false;
		}
	}

	private Number assessDouble(Double d) {
		Double nd = new Double((double) d.longValue());
		if (nd.equals(d)) {
			return new Long(d.longValue());
		}
		else {
			return d;
		}
	}


	/*public*/ String formatNumber(Object obj, String mask) {
		String s = null;

		if (obj == null) {
			return null;
		}

		DecimalFormat df;

		if (mask == null || ((df = getDecimalFormat(mask)) == null)) {
			if (obj instanceof Date) {
				s = "**DATE**";		// FIXME
			}
			else if (obj instanceof Long) {
				s = ((Long) obj).toString();
			}
			else if (obj instanceof Boolean) {
				s = ((Boolean) obj).toString();
			}
			else if (obj instanceof Double) {
				Number num = assessDouble((Double) obj);
				s = num.toString();
			}
			else if (obj instanceof Number) {
				s = ((Number) obj).toString();
			}
			else {
				try {
					Double d = Double.valueOf((String) obj);
					if (d == null) {
						s = null;
					}
					else {
						s = d.toString();
					}
				}
				catch(NumberFormatException t) { }
			}
		}
		else {
			try {
				s = df.format(obj);
			}
			catch(IllegalArgumentException e) {
if (DEBUG) Logger.writeln("##IllegalArgumentException @ Triceps.formatNumber()" + e.getMessage());
			}
		}

		return s;
	}

	/*public*/ String formatDate(Object obj, String mask) {
		if (obj == null) {
			return null;
		}

		DateFormat df = getDateFormat(mask);

		try {
			return df.format(obj);
		}
		catch (IllegalArgumentException e) {
if (DEBUG) Logger.writeln("##IllegalArgumentException @ Triceps.formatDate()" + e.getMessage());
			return null;
		}
	}
	
/*** Additions on 12/05/2001 to support variable numbers of nodes within display groups ***/
	/** Collect next set of nodes that might be relevant (collect them first, determine relevance later)
	* as a side effect, want to set current language for each node as go forward (XXX?) */
			
	
	private Vector collectNextNodeSet() {
		Vector e = collectNextNodeSet1();
//		showVector("collectNextNodeSet1",e);
		if (e == null) {
			return null;	// indicates that at end
		}
		numQuestions = e.size();
		return e;
	}
	
	private Vector collectNextNodeSet1() {
		Node node=null;
		int step=0;
		Vector e = new Vector();
		int braceLevel = 0;
		int actionType;
		
		step = currentStep;	//  + numQuestions;	// skips past current block of questions.  If successful, will update currentStep
		// return null if already at the end, and no elements in vector
		if (step >= size()) {
			return null;
		}
		while(true) {
			if (step >= size()) {	
				// return block if at end, regardless of whether matching braces found
				return e;
			}
			
			if ((node = nodes.getNode(step)) == null) {
				setError(get("invalid_node_at_step") + step);
				return e;
			}
			
			// add the node to the collection
			e.addElement(node);
			
			actionType = node.getQuestionOrEvalType();			
			if (actionType == Node.GROUP_OPEN) {
				++braceLevel;
			}
			else if (actionType == Node.GROUP_CLOSE) {
				--braceLevel;	// close an open block
			}
			else if (actionType == Node.EVAL) {
				;
			}
			else if (actionType == Node.QUESTION) {
				;
			}
			if (braceLevel == 0) {
				return e;
			}
			// finally, ++ step
			++step;
		}
	}

	private Vector collectPreviousNodeSet() {
		Vector e = collectPreviousNodeSet1();
//		showVector("collectPreviousNodeSet1",e);
		if (e == null) {
			return null;
		}
		numQuestions = e.size();
		// reverse order of nodes (since collected backwards!)
		Vector dst = new Vector();
		for (int i=(numQuestions-1);i>=0;--i) {
			dst.addElement(e.elementAt(i));
		}
		return dst;
	}
	
	/** FIXME Do I need to reset currentStep when going backwards? Yes, but where? */
	private Vector collectPreviousNodeSet1() {
		Node node=null;
		int step = currentStep;
		Vector e = new Vector();
		int braceLevel = 0;
		int actionType;
		
		while (true) {
			if (--step < firstStep) {	// find previous block of questions.  If successful, will update currentStep
				if (e.size() == 0) {
					return null;	// indicates already at beginning
				}
				else {
					return e;
				}
			}
			
			if ((node = nodes.getNode(step)) == null) {
				setError(get("invalid_node_at_step") + step);
				return e;
			}
			
			// add the node to the collection
			e.addElement(node);
			
			actionType = node.getQuestionOrEvalType();			
			if (actionType == Node.EVAL) {
				;	// skip these going backwards, but don't reset values when going backwards
			}
			else if (actionType == Node.GROUP_CLOSE) {
				--braceLevel;
			}
			else if (actionType == Node.GROUP_OPEN) {
				++braceLevel;
			}
			else if (actionType == Node.QUESTION) {
				;
			}
			else {
				node.setError(get("invalid_action_type"));
				return e;
			}
			if (braceLevel == 0) {
				return e;
			}
		}
	}
	
	/** As a side effect, this marks irrelevant nodes as NA **/
	
	private Vector getRelevantNodes(Vector src) {
		Node node;
		int actionType;
		Vector dst = new Vector();
		
		if (src == null) {
			return null;	// should never happen
		}
		
		for (int i=0;i<src.size();++i) {
			node = (Node) src.elementAt(i);
			actionType = node.getQuestionOrEvalType();
			
			if (parser.booleanVal(this, node.getDependencies())) {
				dst.addElement(node);
			}
			else {
				evidence.set(node, Datum.getInstance(this,Datum.NA));	// if doesn't satisfy dependencies, store NA
			}
		}
		return dst;
	}
	
	/** checks whether there are errors in a collected block of nodes **/
	private boolean isBlockOK(Vector v) {
		int braceLevel = 0;
		
		if (v == null) {
			return false;	// should not be called, since null means that at beginning or end
		}
		
		int size = v.size();
		Node node = null;
		int actionType = 0;
		
		if (size == 0) {
			return false;	// should not be zero sized
		}
		for (int i=0;i<size;++i) {
			node = (Node) v.elementAt(i);
			actionType = node.getQuestionOrEvalType();
			
			if (actionType == Node.GROUP_OPEN) {
				++braceLevel;
			}
			else if (actionType == Node.GROUP_CLOSE) {
				--braceLevel;
			}
			
			if (size == 1 && i == 0) {
				if (!(actionType == Node.EVAL || actionType == Node.QUESTION)) {
					setError("invalid block of nodes");	// FIXME -- need better error, and translation file
					return false;
				}
				return true;	// block contains single item - an 'e' or a 'q'
			}
			if (i == 0) {
				if (actionType != Node.GROUP_OPEN) {
					setError("first node in a block must be '['");	// FIXME -- need better error, and translation file
					return false;
				}
			}
			else if (i == (size-1)) {
				if (actionType != Node.GROUP_CLOSE) {
					setError("last node in block must be ']'");	// FIXME -- need better error, and translation file
					return false;
				}
			}
			else {
				if (actionType == Node.EVAL) {
					node.setError(get("evals_disallowed_within_question_block"));	// and don't add it to the collection
					evidence.set(node, Datum.getInstance(this,Datum.INVALID));	// evals can't be embedded in a block, so mark as INVALID
					return false;
				}
				else if (actionType == Node.GROUP_OPEN) {
					node.setError(get("extra_opening_brace"));
					return false;
				}
				else if (actionType == Node.GROUP_CLOSE){
					node.setError(get("extra_closing_brace"));
					return false;
				}
			}
		}
		if (braceLevel > 0) {
			setError(get("missing") + braceLevel + get("closing_braces"));
			return false;
		}
		else if (braceLevel < 0) {
			setError(get("missing") + braceLevel + get("opening_braces"));
			return false;
		}
		return true;
	}
	
	/*public*/ int gotoNext() {
//		showVector("gotoNext@start",currentNodeSet);
		int old_step = currentStep;	// so know where started
		Vector old_nodeSet = currentNodeSet;
		int old_numQuestions = numQuestions;
		int ans = gotoNext1();
		
		if (ans == AT_END) {
			numQuestions = 0;
			currentNodeSet = new Vector();
			if (old_step >= currentStep) {
				setError(get("already_at_end_of_interview"));	
			}
		}
		if (ans == ERROR) {
			currentStep = old_step;
			numQuestions = old_numQuestions;
			currentNodeSet = old_nodeSet;
			setError("invalid block of nodes");	// FIXME -- need better error, and translation file
		}

		nodes.setReserved(Schedule.STARTING_STEP,Integer.toString(currentStep));
		dataLogger.flush();	
//		showVector("gotoNext@end",currentNodeSet);
		return ans;		
	}

	private int gotoNext1() {
		Vector e = null;
		
		currentStep += numQuestions;	// jump over the currently active block of questions (since know they are valid)
		
		e = collectNextNodeSet();
		if (e == null) {
			return AT_END;
		}
		
		if (!isBlockOK(e)) {
			return ERROR;
		}
		
		e = getRelevantNodes(e);	// will mark as NA those embedded which are not relevant; and will set numQuestions
		currentNodeSet = e;	// store for getQuestions()? -- so that don't recalculate each step
//		showVector("getNextRelevant",currentNodeSet);
		
		if (e.size() == 0) {
			// then no relevent in this block
			return gotoNext1();
		}
		if (e.size() == 1) {
			Node node;
			int actionType;
			node = (Node) e.elementAt(0);
			if (node.getQuestionOrEvalType() == Node.EVAL) {
				Datum datum = parser.parse(this, node.getQuestionOrEval());
				int type = node.getDatumType();
				if (type != Datum.STRING && type != datum.type()) {
					datum = datum.cast(type,null);
				}
				evidence.set(node, datum);
				return gotoNext1();	// since want to find next non-eval node -- FIXME -- what happens if last node in instrument is eval?
			}
		}
		return OK;
	}
	
	/*public*/ int gotoPrevious() {
//		showVector("gotoPrevious@start",currentNodeSet);
		int old_step = currentStep;
		Vector old_nodeSet = currentNodeSet;
		int old_numQuestions = numQuestions;
		int ans = gotoPrevious1();
		
		if (ans != OK) {
			currentStep = old_step;
			numQuestions = old_numQuestions;
			currentNodeSet = old_nodeSet;
			if (ans == AT_START) {
				setError(get("already_at_beginning"));
			}
		}
		nodes.setReserved(Schedule.STARTING_STEP,Integer.toString(currentStep));
		dataLogger.flush();			
		
//		showVector("gotoPrevious@end",currentNodeSet);
		return ans;		
	}
	
	private void showVector(String msg, Vector v) {
if (DEBUG) {
		StringBuffer sb = new StringBuffer();
		sb.append("![");
		sb.append(currentStep);
		sb.append(",");
		sb.append(numQuestions);
		sb.append("] ");
		sb.append(msg);
		sb.append(" Elements(");
		
		if (v == null) {
			sb.append("0) - null vector");
			Logger.writeln(sb.toString());
			return;
		}
		int size = v.size();
		sb.append(size);
		sb.append("): ");
		Node node;
		String actionTypeName;
		for (int i=0;i<size;++i) {
			node = (Node) v.elementAt(i);
			actionTypeName = Node.ACTION_TYPES[node.getQuestionOrEvalType()];
			if (i > 0) {
				sb.append(",");
			}
			sb.append(node.getLocalName());
			sb.append("(");
			sb.append(actionTypeName);
			sb.append(")");
		}
		Logger.writeln(sb.toString());
}		
	}
			
	
	private int gotoPrevious1() {
		Vector e = null;
		
		e = collectPreviousNodeSet();
		if (e == null) {
			return AT_START;
		}
		
		if (!isBlockOK(e)) {
			return ERROR;
		}
		
		currentStep -= numQuestions;	// set here, after detecting potential errors
		
		e = getRelevantNodes(e);	// will mark as NA those embedded which are not relevant; and will set numQuestions
		currentNodeSet = e;	// store for getQuestions()? -- so that don't recalculate each step
//		showVector("gotoPreviousRelevant",currentNodeSet);
		
		if (e.size() == 0) {
			// then no relevent in this block
			return gotoPrevious1();
		}
		if (e.size() == 1) {
			Node node = (Node) e.elementAt(0);
			if (node.getQuestionOrEvalType() == Node.EVAL) {
				// ignore it going backwards (or undo, once supported)
				return gotoPrevious1();
			}
		}
		return OK;		
	}
	
	/*public*/ Enumeration getQuestions() {
		Enumeration enum = currentNodeSet.elements();
		// set default language for them (how many times should this be done?)
		int lang = getLanguage();
		while (enum.hasMoreElements()) {
			Node node = (Node) enum.nextElement();
			node.setAnswerLanguageNum(lang);
		}
		return currentNodeSet.elements();
	}
	
	private void showNodes() {
if (DEBUG) {
		Node node;
		for (int i=0;i<size();++i) {
			node = nodes.getNode(i);
			Logger.writeln("+[" + i + "] " + node.getLocalName());
		}
}		
	}

	void shutdown() {
		/* graceful shutdown */
		closeDataLogger();
	}
}


