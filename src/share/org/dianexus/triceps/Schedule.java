import java.lang.*;
import java.util.*;
import java.io.*;
import java.net.*;

/**
 * Schedule holds a collection of nodes.
*/
public class Schedule  {
	public static final int LANGUAGES = 0;
	public static final int TITLE = 1;
	public static final int ICON = 2;
	public static final int HEADER_MSG = 3;
	public static final int STARTING_STEP = 4;
	public static final int PASSWORD_FOR_ADMIN_MODE = 5;
	public static final int SHOW_QUESTION_REF = 6;
	public static final int AUTOGEN_OPTION_NUM = 7;
	public static final int DEVELOPER_MODE = 8;
	public static final int DEBUG_MODE = 9;
	public static final int START_TIME = 10;
	public static final int FILENAME = 11;
	public static final int SHOW_ADMIN_ICONS = 12;
	public static final int TITLE_FOR_PICKLIST_WHEN_IN_PROGRESS = 13;
	public static final int ALLOW_COMMENTS = 14;
	public static final int SCHEDULE_SOURCE = 15;
	public static final int LOADED_FROM = 16;


	public static final String[] RESERVED_WORDS = {
		"__LANGUAGES__",
		"__TITLE__", 
		"__ICON__", 
		"__HEADER_MSG__", 
		"__STARTING_STEP__",
		"__PASSWORD_FOR_ADMIN_MODE__", 
		"__SHOW_QUESTION_REF__", 
		"__AUTOGEN_OPTION_NUM__",
		"__DEVELOPER_MODE__", 
		"__DEBUG_MODE__",
		"__START_TIME__", 
		"__FILENAME__", 
		"__SHOW_ADMIN_ICONS__", 
		"__TITLE_FOR_PICKLIST_WHEN_IN_PROGRESS__",
		"__ALLOW_COMMENTS__",
		"__SCHEDULE_SOURCE__",
		"__LOADED_FROM__",
	};

	private Date startTime = null;
	private int languageCount = 0;
	private Vector languages = null;
	private int currentLanguage = 0;
	private boolean isFound = false;
	private boolean isLoaded = false;
	private String error = null;
	
	private Vector nodes = null;
	private Vector comments = null;
	private Hashtable reserved = new Hashtable();

	public Schedule(String source) {
		setDefaultReserveds();
		
		setReserved(SCHEDULE_SOURCE,source);	// this defaults to LOADED_FROM, but want to keep track of the original source location
			
		if (load(source,false)) {
			isFound = true;
		}
	}
	
	public boolean isFound() { return isFound; }
	public boolean isLoaded() { return isLoaded; }
	public String getScheduleSource() { return ((isFound) ? getReserved(SCHEDULE_SOURCE) : ""); }
	public String getLoadedFrom() { return ((isFound) ? getReserved(LOADED_FROM) : ""); }

	private void setDefaultReserveds() {
		setReserved(TITLE,"Triceps System");
		setReserved(STARTING_STEP,"0");
		setReserved(START_TIME,Datum.TIME_MASK.format(new Date(System.currentTimeMillis())));
		setReserved(PASSWORD_FOR_ADMIN_MODE,"");
		setReserved(AUTOGEN_OPTION_NUM,"true");
		setReserved(FILENAME,getReserved(START_TIME));
		setReserved(ICON,"");
		setReserved(HEADER_MSG,"Triceps System");
		setReserved(SHOW_QUESTION_REF,"false");
		setReserved(DEVELOPER_MODE,"false");
		setReserved(DEBUG_MODE,"false");
		setReserved(LANGUAGES,"English");
		setReserved(SHOW_ADMIN_ICONS,"false");
		setReserved(TITLE_FOR_PICKLIST_WHEN_IN_PROGRESS,"");	// default is unnamed until initialized
		setReserved(ALLOW_COMMENTS,"false");
		setReserved(SCHEDULE_SOURCE,"");
		setReserved(LOADED_FROM,"");
	}
	
	public boolean init() {
		nodes = new Vector();
		comments = new Vector();
		isLoaded = load(getLoadedFrom(),true); 
		return isLoaded;
	}
	
	public boolean reload() {
		return init();
	}

	private boolean load(String source, boolean parseNodes) {
		BufferedReader br = getReader(source);
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
					if (parseNodes) {
						comments.addElement(fileLine);
					}
					continue;
				}
				if (fileLine.startsWith("RESERVED")) {
					parseReserved(line, source, fileLine);
					continue;
				}
				
				if (!parseNodes)
					break;	// so that only set RESERVED values

				Node node = new Node(line, source, fileLine, languageCount);
				++count;
				nodes.addElement(node);
			}
			if (parseNodes)
				System.err.println("Read " + count + " nodes from " + source);
		}
		catch(Throwable t) {
			System.err.println("Unable to access " + source + ": " + t.getMessage());
			err = true;
		}
		if (br != null) {
			try { br.close(); } catch (Throwable t) {
				System.err.println("Error closing file:" + t.getMessage());
			}
		}
		setReserved(START_TIME,Datum.TIME_MASK.format(startTime));	// XXX is this really needed?
		
		String s = getReserved(TITLE_FOR_PICKLIST_WHEN_IN_PROGRESS);
		if (s == null || s.trim().length() == 0) {
			// set a reasonable default value
			setReserved(TITLE_FOR_PICKLIST_WHEN_IN_PROGRESS,getReserved(TITLE) + " [" + getReserved(START_TIME) + "]");
		}
		setReserved(LOADED_FROM,source);	// keep LOADED_FROM up to date
		
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
			System.err.println("Incorrect syntax for " + ((name != null) ? name : "") + " [" + filename + "(" + line + ")]");
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
			System.err.println(name + " not recognized [" + filename + "(" + line + ")]");
		}
	}
	
	public boolean overloadReserved(Schedule oldNodes) {
		/* FIXME - need to use String Objects for reserved words, not integers, otherwise subject to re-ordering! */
		if (nodes == null)
			return false;
		boolean ok = true;
			
		for (int i=0;i<RESERVED_WORDS.length;++i) {
			ok = setReserved(i,oldNodes.getReserved(i)) && ok;
		}
		return ok;
	}

	public boolean setReserved(int resIdx, String value) {
		String s;
		if (value == null)
			value = "";
		switch (resIdx) {
			case TITLE: s = value; break;
			case STARTING_STEP: s = setStartingStep(value); break;
			case START_TIME: s = setStartTime(value); break;
			case PASSWORD_FOR_ADMIN_MODE: s = value; break;
			case AUTOGEN_OPTION_NUM: s = Boolean.valueOf(value.trim()).toString(); break;
			case FILENAME: s = value; break;
			case ICON: s = value; break;
			case HEADER_MSG: s = value; break;
			case SHOW_QUESTION_REF: s = Boolean.valueOf(value.trim()).toString(); break;
			case DEVELOPER_MODE: s = Boolean.valueOf(value.trim()).toString(); break;
			case DEBUG_MODE: s = Boolean.valueOf(value.trim()).toString(); break;
			case LANGUAGES: s = setLanguages(value); break;
			case SHOW_ADMIN_ICONS: s = Boolean.valueOf(value.trim()).toString(); break;
			case TITLE_FOR_PICKLIST_WHEN_IN_PROGRESS: s = value; break;
			case ALLOW_COMMENTS: s = Boolean.valueOf(value.trim()).toString(); break;
			case SCHEDULE_SOURCE: s = value; break;
			case LOADED_FROM: s = value; break;
			default: return false;
		}
		if (s != null) {
			reserved.put(RESERVED_WORDS[resIdx], s);
			return true;
		}
		else {
			return false;
		}
	}

	public String getReserved(int resIdx) {
		if (resIdx >= 0 && resIdx < RESERVED_WORDS.length) {
			return (String) reserved.get(RESERVED_WORDS[resIdx]);
		}
		else
			return null;
	}

	private String setStartingStep(String s) {
		Integer startingStep = null;
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
		String str = Datum.TIME_MASK.format(t);
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
	
	private BufferedReader getReader(String source) {
		boolean ok = false;
		BufferedReader br = null;

		/* First try to access the source as a file */
		try {
			if (source != null) {
				File file = new File(source);
				if (!file.exists()) {
					error = "Error: file '" + source + "' doesn't exist";
				}
				else if (!file.isFile()) {
					error = "Error: file '" + source + "' isn't a file";
				}
				else if (!file.canRead()) {
					error = "Error: file '" + source + "' is not accessible";
				}
				else {
					br = new BufferedReader(new FileReader(file));
					ok = true;
				}
			}
			else {
				error = "Error: null filename";
			}
		}
		catch (Throwable t) {
			error = "error accessing file: " + t.getMessage();
		}
		if (ok) {
			return br;
		}
		else {
			if (br != null) {
				try { br.close(); } catch (Throwable t) {
					System.err.println("error closing reader: " + t.getMessage());
				}
			}
			System.err.println(error);
		}

/* Shows how URLs can be accessed.  No longer supported.
		// Is source a URL pointing to a file? If so, try reading from it
		try {
			URL url = new URL(source);
			br = new BufferedReader(new InputStreamReader(url.openStream()));

			String fileLine;
			while ((fileLine = br.readLine()) != null) {
				fileLine = fileLine.trim();
				if (fileLine.equals(""))
					continue;

				// If this is an HTML page instead of a text file, then an error has occurred
				if (fileLine.startsWith("<")) {
					error = "unable to access " + url.toExternalForm();
					break;
				}
				else {
					// Close, then re-open the stream (resetting a BufferedReader isn't supported on all platforms)
					if (br != null) {
						try { br.close(); } catch (Throwable t) {
							System.err.println("error closing reader: " + t.getMessage());
						}
					}
					br = new BufferedReader(new InputStreamReader(url.openStream()));
					ok = true;
					break;
				}
			}
		}
		catch (MalformedURLException t) {
		}
		catch (Throwable t) {
			error = "can't access as url: " + t.getMessage();
		}
		if (ok) {
			return br;
		}
		else {
			if (br != null) {
				try { br.close(); } catch (Throwable t) {
					System.err.println("error closing reader: " + t.getMessage());
				}
			}
			System.err.println(error);
		}
*/
		return null;
	}

	public String getErrors() {
		String tmp = error;
		error = null;
		return tmp;
	}
	
	public boolean hasErrors() { return (error != null); }
}
