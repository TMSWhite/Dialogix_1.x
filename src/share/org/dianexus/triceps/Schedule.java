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
	
	public static final String[] RESERVED_WORDS = {
		"__TITLE__", "__STARTING_STEP__"
	};
	
	private String title = "";
	private Integer startingStep = new Integer(0);
	
	private Vector nodes = new Vector();
	private Vector comments = new Vector();
	private Hashtable reserved = new Hashtable();

	public Schedule() {
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
				fileLine = fileLine.trim();
				if (fileLine.equals(""))
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

		switch (resIdx) {
			case TITLE: setTitle(value); break;
			case STARTING_STEP: setStartingStep(value); break;
			default: System.out.println("unrecognized reserved word " + name + " on line " + line + " of file " + filename); break;
		}
	}
	
	public void setTitle(String s) { 
		if (s == null)
			title = "";
		else
			title = s;
			
		reserved.put(RESERVED_WORDS[TITLE],title);
	}
	public String getTitle() { return title; }
	
	public void setStartingStep(String s) { 
		try {
			startingStep = new Integer(s);
		}
		catch(NumberFormatException e) {
			System.out.println(e);
			startingStep = new Integer(0);
		}
		reserved.put(RESERVED_WORDS[STARTING_STEP],startingStep);
	}
	public int getStartingStep() { return startingStep.intValue(); }
	
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
