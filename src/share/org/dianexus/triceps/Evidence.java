import java.lang.*;
import java.util.*;
import java.io.*;
import java.net.*;

/**
 * Contains data generated at each node.  Such data are produced either
 * by the person running the interview in response to
 * questions, or by the system evaluating previously stored evidence
 */
public class Evidence  {
	Hashtable aliases;
	Vector values;
	Schedule schedule;

	public Evidence(Schedule schedule) {
		int size=schedule.size();
		this.schedule = schedule;
		
		aliases = new Hashtable();
		values = new Vector(size);
		
		Node node;
		Value value;
		int val=0;
		
		/* first assign the reserved words */
		for (val=0;val<Schedule.RESERVED_WORDS.length;++val) {
			value = new Value(Schedule.RESERVED_WORDS[val],new Datum(schedule.getReserved(val),Datum.STRING),val);
			values.addElement(value);
			aliases.put(Schedule.RESERVED_WORDS[val],new Integer(val));
		}
		
		/* then assign the user-defined words */
		for (int i = 0; i < size; ++i, ++val) {
			node = schedule.getNode(i);
			value = new Value(node, Datum.getInstance(Datum.UNKNOWN),node.getDefaultAnswerTimeStampStr());
			
			values.addElement(value);

			Integer j = new Integer(val);

			addAlias(node,node.getConcept(),j);
			addAlias(node,node.getName(),j);
			addAlias(node,node.getQuestionRef(),j);
			aliases.put(node,j);
		}
	}

	private void addAlias(Node n, String alias, Integer index) {
		if (alias == null || alias.equals(Triceps.NULL) || alias.equals(""))
			return;	// ignore invalid aliases

		Object o = aliases.put(alias,index);
		if (o != null) {
			int pastIndex = ((Integer) o).intValue();

			if (pastIndex != index.intValue()) {
				/* Allow a single node to try to set the same alias for itself multiple times.
				However, each node must have non-overlapping aliases with other nodes */
				aliases.put(alias,o);	// restore overwritten alias?
				Node prevNode = ((Value) values.elementAt(pastIndex)).getNode();
				n.setParseError("Duplicate alias <B>" + Node.encodeHTML(alias) + "</B> previously used for node <B>" + Node.encodeHTML(prevNode.getName()) + "</B> on line " + prevNode.getSourceLine());
			}
		}
	}

	public boolean containsKey(Object val) {
		if (val == null)
			return false;
		return aliases.containsKey(val);
	}

	public Datum getDatum(Object val) {
		Integer i = (Integer) aliases.get(val);
		if (i == null)
			return null;
		return ((Value) values.elementAt(i.intValue())).getDatum();
	}

	public Node getNode(Object val) {
		Integer i = (Integer) aliases.get(val);
		if (i == null) {
			System.out.println("Node not found: " + val);
			return null;
		}
		return ((Value) values.elementAt(i.intValue())).getNode();
	}

	public int getStep(Object n) {
		if (n == null)
			return -1;
		Object o = aliases.get(n);
		if (o == null)
			return -1;
		else
			return ((Integer) o).intValue();
	}

	public void set(Node node, Datum val, String time) {
		if (node == null) {
			System.out.println("null Node");
			return;
		}
		if (val == null) {
			System.out.println("null Datum");
			return;
		}
		int i;
		
		i = getStep(node);
		if (i == -1) {
			System.out.println("Node does not exist");
			return;
		}
		
		((Value) values.elementAt(i)).setDatum(val,time);
	}
	
	public void set(Node node, Datum val) {
		set(node,val,null);
	}	

	public void set(String name, Datum val) {
		if (name == null) {
			System.out.println("null Node name");
			return;
		}
		if (val == null) {
			System.out.println("null Datum");
			return;
		}
		
		int i = getStep(name);
		if (i == -1) {
			i = size();	// append to end
			Value value = new Value(name,val);
			values.addElement(value);
			aliases.put(name, new Integer(i));
		}
		else {
			((Value) values.elementAt(i)).setDatum(val,null);
		}
	}

	public int size() {
		return values.size();
	}

	public String toXML() {
		StringBuffer sb = new StringBuffer("<Evidence>\n");
		Enumeration e = aliases.keys();

		while (e.hasMoreElements()) {
			String s = (String)e.nextElement();
			sb.append("	<datum name='" + s + "' value='" + toString(s) + "'/>\n");
		}
		sb.append("</Evidence>");
		return sb.toString();
	}

	public String toString(Object val) {
		Datum d = getDatum(val);
		if (d == null)
			return "null";
		else
			return d.stringVal();
	}

	public void unset(Node node) {
		if (node == null)
			return;
		Integer i = (Integer)aliases.remove(node);
		
		if (i != null) {
			aliases.remove(node.getConcept());
			aliases.remove(node.getName());
			aliases.remove(node.getQuestionRef());
			
			values.setElementAt(new Value(), i.intValue());
		}
	}

	public void unset(String name) {
		Integer i = (Integer)aliases.remove(name);
		if (i != null) {
			values.setElementAt(new Value(), i.intValue());
		}
	}
	
	class Value {
		Node	node=null;
		Datum	datum=null;
		Date	timeStamp=null;
		String	timeStampStr=null;
		int reserved = -1;
			
		Value() {
		}
		
		Value(Node n, Datum d, String time) {
			node = n;
			datum = d;
			if (time != null && time.trim().length() > 0) {
				n.setTimeStamp(time);
			}
		}
		
		Value(String s, Datum d) {
			// no associated node - so a temporary variable
			datum = d;
		}
		
		Value(String s, Datum d, int reserved) {
			datum = d;
			this.reserved = reserved;
		}
		
		Node getNode() { return node; }
		
		void setDatum(Datum d, String time) { 
			datum = d; 
			if (node != null)
				node.setTimeStamp(time);
				
			if (reserved >= 0) {
				schedule.setReserved(reserved,d.stringVal());
			}
		}
		Datum getDatum() { return datum; }
	}
}
