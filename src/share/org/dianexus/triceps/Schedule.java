import java.lang.*;
import java.util.*;
import java.io.*;
import java.net.*;

/**
 * Schedule holds a collection of nodes.
*/
public class Schedule  {
	public static final int TITLE = 0;
	public static final int ICON = 1;
	public static final int HEADER_MSG = 2;
	public static final int STARTING_STEP = 3;
	public static final int PASSWORD_FOR_REFUSED = 4;
	public static final int PASSWORD_FOR_UNKNOWN = 5;
	public static final int PASSWORD_FOR_NOT_UNDERSTOOD = 6;
	public static final int LANGUAGES = 7;
	public static final int SHOW_QUESTION_REF = 8;
	public static final int AUTOGEN_OPTION_NUM = 9;
	public static final int DEVELOPER_MODE = 10;
	public static final int DEBUG_MODE = 11;
	public static final int START_TIME = 12;
	public static final int FILENAME = 13;
	public static final int SHOW_INVISIBLE_OPTIONS = 14;

	public static final String[] RESERVED_WORDS = {
		"__TITLE__", "__ICON__", "__HEADER_MSG__", "__STARTING_STEP__",
		"__PASSWORD_FOR_REFUSED__", "__PASSWORD_FOR_UNKNOWN__", "__PASSWORD_FOR_NOT_UNDERSTOOD__",
		"__LANGUAGES__",
		"__SHOW_QUESTION_REF__", "__AUTOGEN_OPTION_NUM__",
		"__DEVELOPER_MODE__", "__DEBUG_MODE__",
		"__START_TIME__", "__FILENAME__", "__SHOW_INVISIBLE_OPTIONS__"
	};

	private String title = null;
	private Integer startingStep = null;
	private Date startTime = null;
	private String passwordForRefused = null;
	private String filename = null;
	private String passwordForUnknown = null;
	private String passwordForNotUnderstood = null;
	private String icon = null;
	private String headerMsg = null;
	private boolean developerMode = false;
	private boolean showQuestionRef = false;
	private boolean debugMode = false;
	private boolean autoGenOptionNum = true;
	private int languageCount = 0;
	private Vector languages = null;
	private int currentLanguage = 0;


	private Vector nodes = new Vector();
	private Vector comments = new Vector();
	private Hashtable reserved = new Hashtable();

	public Schedule() {
		setDefaultReserveds();
	}

	public void setDefaultReserveds() {
		setReserved(TITLE,"Triceps System");
		setReserved(STARTING_STEP,"0");
		setReserved(START_TIME,Datum.TIME_MASK.format(new Date(System.currentTimeMillis())));
		setReserved(PASSWORD_FOR_REFUSED,"");
		setReserved(AUTOGEN_OPTION_NUM,"true");
		setReserved(FILENAME,getReserved(START_TIME));
		setReserved(PASSWORD_FOR_UNKNOWN,"");
		setReserved(PASSWORD_FOR_NOT_UNDERSTOOD,"");
		setReserved(ICON,"");
		setReserved(HEADER_MSG,"Triceps System");
		setReserved(SHOW_QUESTION_REF,"false");
		setReserved(DEVELOPER_MODE,"false");
		setReserved(DEBUG_MODE,"false");
		setReserved(LANGUAGES,"English");
		setReserved(SHOW_INVISIBLE_OPTIONS,"false");
	}

	public boolean load(BufferedReader br, String filename) {
		if (br == null)
			return false;

		boolean err = false;

		try {
			int line = 0;
			int count=0;
			String fileLine;

			while ((fileLine = br.readLine()) != null) {
				++line;
				if (fileLine.trim().equals(""))
					continue;

				if (fileLine.startsWith("COMMENT")) {
					comments.addElement(fileLine);
					continue;
				}
				if (fileLine.startsWith("RESERVED")) {
					parseReserved(line, filename, fileLine);
					continue;
				}

				Node node = new Node(line, filename, fileLine, languageCount);
				++count;
				nodes.addElement(node);
			}
			System.err.println("Read " + count + " nodes from " + filename);
		}
		catch(Throwable t) {
			System.err.println("Unable to access " + filename + ": " + t.getMessage());
			err = true;
		}
		if (br != null) {
			try { br.close(); } catch (Throwable t) {
				System.err.println("Error closing file:" + t.getMessage());
			}
		}
		setStartTime(startTime);
		return (!err);
	}

	public Node getNode(int index) {
		if (index < 0) {
			System.err.println("Node[" + index + "] does't exist");
			return null;
		}
		if (index > size()) {
			System.err.println("Node[" + index + "/" + size() + "] doesn't exist");
			return null;
		}
		return (Node)nodes.elementAt(index);
	}

	public int size() {
		return nodes.size();
	}

	private void parseReserved(int line, String filename, String fileLine) {
		StringTokenizer ans = new StringTokenizer(fileLine,"\t",true);
		int field = 0;
		String name=null;
		String value=null;

		while(ans.hasMoreTokens()) {
			String s = null;
			try {
				s = ans.nextToken();
			}
			catch (NoSuchElementException e) {
			}

			if (s.equals("\t")) {
				++field;
				continue;
			}

			switch(field) {
				case 0: break;
				case 1: name = Node.fixExcelisms(s); break;
				case 2: value = Node.fixExcelisms(s); break;
				default: break;
			}
		}
		if (field < 2) {
			System.err.println("wrong number of tokens for RESERVED syntax (RESERVED\\tname\\tvalue\\n) on line " + line + " of file " + filename);
		}
		if (name == null || value == null)
			return;

		int resIdx=-1;
		for (int i=0;i<RESERVED_WORDS.length;++i) {
			if (RESERVED_WORDS[i].equals(name)) {
				resIdx = i;
				break;
			}
		}

		if (!setReserved(resIdx, value)) {
			System.err.println("unrecognized reserved word " + name + " on line " + line + " of file " + filename);
		}
	}

	public boolean setReserved(int resIdx, String value) {
		String s;
		switch (resIdx) {
			case TITLE: s = setTitle(value); break;
			case STARTING_STEP: s = setStartingStep(value); break;
			case START_TIME: s = setStartTime(value); break;
			case PASSWORD_FOR_REFUSED: s = setPasswordForRefused(value); break;
			case AUTOGEN_OPTION_NUM: s = setAutoGenOptionNum(value); break;
			case FILENAME: s = setFilename(value); break;
			case PASSWORD_FOR_UNKNOWN: s = setPasswordForUnknown(value); break;
			case PASSWORD_FOR_NOT_UNDERSTOOD: s = setPasswordForNotUnderstood(value); break;
			case ICON: s = setIcon(value); break;
			case HEADER_MSG: s = setHeaderMsg(value); break;
			case SHOW_QUESTION_REF: s = setShowQuestionRef(value); break;
			case DEVELOPER_MODE: s = setDeveloperMode(value); break;
			case DEBUG_MODE: s = setDebugMode(value); break;
			case LANGUAGES: s = setLanguages(value); break;
			case SHOW_INVISIBLE_OPTIONS: s = setShowInvisibleOptions(value); break;
			default: return false;
		}
		reserved.put(RESERVED_WORDS[resIdx], s);
		return true;
	}

	public String getReserved(int resIdx) {
		if (resIdx >= 0 && resIdx < RESERVED_WORDS.length) {
			return (String) reserved.get(RESERVED_WORDS[resIdx]);
		}
		else
			return null;
	}

	private String setAutoGenOptionNum(String s) {
		Boolean b = Boolean.valueOf(s);
		autoGenOptionNum = b.booleanValue();
		return b.toString();
	}
	public boolean isAutoGenOptionNum() { return autoGenOptionNum; }

	private String setPasswordForRefused(String s) {
		passwordForRefused = s;
		return s;
	}
	private String setPasswordForUnknown(String s) {
		passwordForUnknown = s;
		return s;
	}
	private String setPasswordForNotUnderstood(String s) {
		passwordForNotUnderstood = s;
		return s;
	}
	private String setShowInvisibleOptions(String s) {
		Boolean b = Boolean.valueOf(s);
		autoGenOptionNum = b.booleanValue();
		return b.toString();
	}
	private String setIcon(String s) {
		icon = s;
		return s;
	}

	private String setHeaderMsg(String s) {
		headerMsg = s;
		return s;
	}

	private String setTitle(String s) {
		if (s == null)
			title = "";
		else
			title = s;

		return title;
	}

	private String setShowQuestionRef(String s) {
		Boolean b = Boolean.valueOf(s);
		showQuestionRef = b.booleanValue();
		return b.toString();
	}
	public boolean isShowQuestionRef() { return showQuestionRef; }

	private String setDeveloperMode(String s) {
		Boolean b = Boolean.valueOf(s);
		developerMode = b.booleanValue();
		return b.toString();
	}
	public boolean isDeveloperMode() { return developerMode; }

	private String setDebugMode(String s) {
		Boolean b = Boolean.valueOf(s);
		debugMode = b.booleanValue();
		return b.toString();
	}
	public boolean isDebugMode() { return debugMode; }

	private String setStartingStep(String s) {
		try {
			startingStep = new Integer(s);
		}
		catch(NumberFormatException e) {
			System.err.println("Invalid number for starting step: " + e.getMessage());
			startingStep = new Integer(0);
		}
		return startingStep.toString();
	}

	private String setStartTime(Date t) {
		startTime = t;
		String str = Datum.TIME_MASK.format(startTime);
		reserved.put(RESERVED_WORDS[START_TIME], str);
		return str;
	}

	private String setStartTime(String t) {
		Date time = null;
		try {
			time = Datum.TIME_MASK.parse(t);
		}
		catch (java.text.ParseException e) {
			System.err.println("Error parsing time " + e.getMessage());
		}
		if (time == null) {
			time = new Date(System.currentTimeMillis());
		}
		return setStartTime(time);
	}

	private String setFilename(String value) {
		filename = value;
		return filename;
	}

	private String setLanguages(String value) {
		StringBuffer sb = new StringBuffer();
		if (value == null) {
			return setLanguages("English");
		}

		languageCount = 0;
		languages = new Vector();
		StringTokenizer ans = new StringTokenizer(value,"|");
		while(ans.hasMoreTokens()) {
			String s = null;
			try {
				s = ans.nextToken();
				if (s == null || s.trim().length() == 0)
					continue;
				s = s.trim();
			}
			catch (NoSuchElementException e) {
			}
			/* regenerate the string, stipping excess pipe characters */
			++languageCount;
			if (sb.length() != 0) {
				sb.append("|" + s);
			}
			else {
				sb.append(s);
			}
			languages.addElement(s);
		}
		return sb.toString();
	}

	public Vector getLanguages() {
		return languages;
	}

	public boolean setLanguage(String s) {
		if (s == null) {
			currentLanguage = 0;
			System.err.println("Tried to set language to null");
			return false;
		}
		for (int i=0;i<languages.size();++i) {
			if (s.equals((String) languages.elementAt(i))) {
				currentLanguage = i;
				return true;
			}
		}
		currentLanguage = 0;
		System.err.println("Tried to switch to unsupported language " + s);
		return false;
	}

	public int getLanguage() { return currentLanguage; }

	public void toTSV(Writer out) {
		Enumeration keys = reserved.keys();

		for (int i=0;i<RESERVED_WORDS.length;++i) {
			String s = RESERVED_WORDS[i];
			try {
				out.write("RESERVED\t" + s + "\t" + reserved.get(s).toString() + "\n");
			}
			catch (Throwable t) {
				System.err.println("Error writing to " + out + ": " + t.getMessage());
			}
		}

		for (int i=0;i<comments.size();++i) {
			try {
				out.write((String) comments.elementAt(i) + "\n");
			}
			catch (Throwable t) {
				System.err.println("Error writing to " + out + ": " + t.getMessage());
			}
		}
	}
}
