import java.lang.*;
import java.util.*;
import java.io.*;
import java.net.*;

/**
 * Schedule holds a collection of nodes.
*/
public class Schedule  {
	public static final int TITLE = 0;
	public static final int STARTING_STEP = 1;
	public static final int START_TIME = 2;
	public static final int PASSWORD_FOR_REFUSED = 3;
	public static final int AUTOGEN_OPTION_NUM = 4;
	public static final int FILENAME = 5;
	public static final int PASSWORD_FOR_UNKNOWN = 6;
	public static final int ICON = 7;
	public static final int HEADER_MSG = 8;
	
	public static final String[] RESERVED_WORDS = {
		"__TITLE__", "__STARTING_STEP__", "__START_TIME__", "__PASSWORD_FOR_REFUSED__", "__AUTOGEN_OPTION_NUM__", "__FILENAME__",
		"__PASSWORD_FOR_UNKNOWN__", "__ICON__", "__HEADER_MSG__"
	};
	
	private String title = null;
	private Integer startingStep = null;
	private Date startTime = null;
	private String passwordForRefused = null;
	private String filename = null;
	private String passwordForUnknown = null;
	private String icon = null;
	private String headerMsg = null;
	
	
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
		setReserved(ICON,"");
		setReserved(HEADER_MSG,"Triceps System");
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

				Node node = new Node(line, filename, fileLine);
				++count;
				nodes.addElement(node);
			}
			System.out.println("Read " + count + " nodes from " + filename);
			return (!err);
		}
		catch(IOException e) {
			System.out.println("Unable to access " + filename);
			return false;
		}
		finally {
			if (br != null) {
				try { br.close(); } catch (Exception e) {}
			}
			setStartTime(startTime);
		}
	}

	public Node getNode(int index) {
		if (index < 0) {
			System.out.println("Node[" + index + "] does't exist");
			return null;
		}
		if (index > size()) {
			System.out.println("Node[" + index + "/" + size() + "] doesn't exist");
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
			catch (Exception e) {
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
		if (field != 2) {
			System.out.println("wrong number of tokens for RESERVED syntax (RESERVED\\tname\\tvalue\\n) on line " + line + " of file " + filename);
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
			System.out.println("unrecognized reserved word " + name + " on line " + line + " of file " + filename); 
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
			case ICON: s = setIcon(value); break;
			case HEADER_MSG: s = setHeaderMsg(value); break;
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
		Node.setAutoGenOptionAccelerator(b.booleanValue());	// very much of a hack - call Node directly
		return b.toString();
	}
	
	private String setPasswordForRefused(String s) { 
		passwordForRefused = s; 
		return s;
	}
	private String setPasswordForUnknown(String s) { 
		passwordForUnknown = s; 
		return s;
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
	
	private String setStartingStep(String s) { 
		try {
			startingStep = new Integer(s);
		}
		catch(NumberFormatException e) {
			System.out.println(e);
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
			System.out.println("Error parsing time " + e.getMessage());
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
	
	
	public void toTSV(Writer out) {
		Enumeration keys = reserved.keys();
		
		while (keys.hasMoreElements()) {
			String s = (String) keys.nextElement();
			try {
				out.write("RESERVED\t" + s + "\t" + reserved.get(s).toString() + "\n");
			}
			catch (IOException e) {}
		}
		
		for (int i=0;i<comments.size();++i) {
			try {
				out.write((String) comments.elementAt(i) + "\n");
			}
			catch (IOException e) {}
		}
	}
}
