import java.lang.*;
import java.util.*;
import java.io.*;
import java.net.*;

/* Triceps
 * TODO:
 *	Qss needs to be re-entrant or synchronized - done
 */
 
public class Triceps implements Serializable {
	private static final String NULL = "not set";	// a default value to represent null in config files
	
	private Object scheduleURL = null;
	private Schedule nodes = null;
	private Evidence evidence = null;
	static private transient Parser parser = new Parser();
	
	private Stack errors = new Stack();
	private int currentStep;
	private Node node = null;

	public Triceps() {
	}
	
	public boolean setSchedule(File file) {
		if (file == null || !file.exists())
			return false;
		scheduleURL = file;
		return (reloadSchedule() && resetEvidence() && setDebugEvidence());
	}

	public boolean setSchedule(String src) {
		try {
			URL url = new URL(src);
			return setSchedule(url);
		}
		catch(MalformedURLException e) {
			System.out.println("Malformed url '" + src + "':" + e.getMessage());
			return false;
		}			
	}
	
	public boolean setSchedule(URL url) {
		scheduleURL = url;
		return (reloadSchedule() && resetEvidence() && setDebugEvidence());
	}
	
	public boolean reloadSchedule() {
		nodes = new Schedule();
		if (scheduleURL instanceof URL)
			return nodes.load((URL) scheduleURL);
		else if (scheduleURL instanceof File)
			return nodes.load((File) scheduleURL);
		else
			return false;
	}
	
	public Datum getDatum(Node n) {
		return evidence.getDatum(n);
	}
	
	public Enumeration getErrors() {
		/* when there is an error in getting a node */
		Stack tmp = errors;
		errors = new Stack();
		return tmp.elements();
	}
	
	public Enumeration getQuestions() {
		Vector e = new Vector();
		
		// should loop over available questions
		e.addElement(node);
		return e.elements();
	}
	
	public String getQuestionStr(Node q) {
		return parser.parseJSP(evidence, q.getAction());
	}
	
	public boolean gotoFirst() {
		currentStep = -1;
		return gotoNext();
	}
	
	public boolean gotoNext() {
		while (true) {		// loop forward through nodes -- break to query user or to end
			if (++currentStep >= nodes.size()) {	// then the schedule is complete
				// store evidence here
				errors.push("The interview is completed.");
				try {
					evidence.save("/tmp/test-completed");		
				} catch (java.io.IOException e) {
					System.out.println(e);
				}
				
				return false;	// XXX - need better message passing		
			}
			if ((node = nodes.getNode(currentStep)) == null)		// just in case something wierd happens
				return false;
			
			/* Active or inactive */
			if (parser.booleanVal(evidence, node.getDependencies())) { // the node is active and requires action

				/* get answer from user or from evidence */
				if ("q".equals(node.getActionType())) {	// queryUser()
					return true;	
				}
				else if ("e".equals(node.getActionType())) {	// evaluate evidence, set the Datum for this node, and loop to next node
					evidence.set(node, new Datum(parser.StringVal(evidence, node.getAction()),node.getDatumType())); // what data type?
				}
			}
			else {	// the node is inactive and the datum value is "not applicable"

				/* store in evidence a "not applicable" Datum for this node*/
				evidence.set(node, new Datum(Datum.NA));
			}
		} // end while loop		
	}
	
	public boolean gotoNode(Object val) {
		Node n = evidence.getNode(val);
		if (n == null) {
			errors.push("Unknown node: " + val);
			return false;
		}
		int result = evidence.getStep(n);
		if (result == -1) {
			errors.push("Unable to find index for node: " + n);
			return false;
		} else {
			currentStep = result;
			node = n;
			return true;
		}
	}
		
	public boolean gotoPrevious() {
		while (true) {		// loop back through nodes -- break to query user
			if (--currentStep < 0) {
				errors.push("You can't back up any further.");
				currentStep = 0;
				return false;	// XXX need better messaging system
			}
			if ((node = nodes.getNode(currentStep)) == null)
				return false;
				
			if ("e".equals(node.getActionType())) {

				/* then can skip this going backwards */
				continue;
			}
			if (parser.booleanVal(evidence, node.getDependencies())) {

				/* if meets the criteria to ask this question ... */
				if ("q".equals(node.getActionType())) {
					return true;
				}
			}
		}
	}
	
	public boolean resetEvidence() {
		evidence = new Evidence(nodes.size());
		return true;
	}
	
	private boolean setDebugEvidence() {
		Node n;
		String init;
		for (int i=0;i<nodes.size();++i) {
			n = nodes.getNode(i);
			if (n == null)
				continue;
			
			init = n.getDebugAnswer();
			
			if (init == null || init.equals(NULL))
				continue;
			
			evidence.set(n,new Datum(init,node.getDatumType()));	// set an initial value for the node
		}
		return true;
	}
	
	public boolean save(String filename) {
		try {
			FileOutputStream fos = new FileOutputStream(filename);
			ObjectOutputStream out = new ObjectOutputStream(fos);
			out.writeObject(this);
			out.flush();
			out.close();
			System.out.println("Saved interview to " + filename);
			return true;
		}
		catch (IOException e) {
			System.out.println(e);
			return false;
		}
	}
	
	public boolean storeValue(Node q, String answer) {
		try {	// set answer to the value returned with the "name" of the node
			if (answer == null) {
				if (q.getAnswerType() == Node.CHECK) {
					answer = "0";
				}
			}
		}
		catch(NullPointerException e) {
			e.printStackTrace();
		}

		if ((answer == null || answer.trim().equals("")) && currentStep >= 0) {
			errors.push("<bold>You cannot proceed without answering.</bold>");
			return false;
		}
		else {	// got a proper answer -- handle it
			if (currentStep >= 0 && q != null) {
				Datum d = new Datum(answer,q.getDatumType()); // use expected value type
				if (d.isInvalid()) {
					errors.push(d.getError());
					return false;
				}
				evidence.set(q, d);
			}
			return true;
		}	// end handling of proper answer					
	}
		
	public static Triceps restore(String filename) {
		Triceps triceps = null;
		try {
			FileInputStream fis = new FileInputStream(filename);
			ObjectInputStream ois = new ObjectInputStream(fis);
			triceps = (Triceps) ois.readObject();
			ois.close();
			triceps.parser = new Parser();	// restore unsaved parser
			return triceps;
		}
		catch (IOException e) {
			System.out.println(e);
			return null;
		}
		catch (java.lang.ClassNotFoundException e) {
			System.out.println(e);
			return null;
		}
	}
	
	public int size() { return nodes.size(); }
	
	public Node getNode(int i) { 
		return nodes.getNode(i);	// XXX should not allow direct access to this?
	}
	
	public String toString(Node n) {
		Datum d = getDatum(n);
		if (d == null)
			return "null";
		else
			return d.StringVal();
	}
	
	public String evidenceToXML() {
		return evidence.toXML();
	}
	
	public String toXML() {
		StringBuffer sb = new StringBuffer("<Evidence>\n");
		Node n;
		Datum d;
		
		for (int i=0;i<nodes.size();++i) {
			n = nodes.getNode(i);
			if (n == null)
				continue;
				
			d = evidence.getDatum(n);
			if (d == null)
				continue;
				
			sb.append(" <datum name='" + n.getName() + "' value='" + d.StringVal() + "'/>\n");
		}
		sb.append("</Evidence>\n");
		return sb.toString();
	}
	
	public boolean toTSV(String filename) {
		FileWriter fw;
		
		try {
			fw = new FileWriter(filename);
			boolean ok = writeTSV(fw);
			fw.close();
			return ok;
		}
		catch (IOException e) {
			errors.push("error writing to " + filename + ": " + e);
			return false;
		}
	}
	
	public boolean writeTSV(Writer out) {
		Node n;
		Datum d;
		String ans;
		
		if (out == null)
			return false;
			
		try {
			for (int i=0;i<nodes.size();++i) {
				n = nodes.getNode(i);
				if (n == null)
					continue;
					
				d = evidence.getDatum(n);
				if (d == null) {
					ans = NULL;
				}
				else {
					ans = d.StringVal();
				}
					
				out.write(n.toTSV() + "\t" + ans + "\n");
			}
			out.flush();
			return true;
		}
		catch (IOException e) {
			errors.push("Unable to write schedule file: " + e);
			return false;
		}
	}
}
