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

	public Evidence(Schedule schedule) {
		int size=schedule.size();
		
		aliases = new Hashtable();
		values = new Vector(size);
		
		Node node;
		Value value;
		int val=0;
		
		/* first assign the reserved words */
		for (val=0;val<Schedule.RESERVED_WORDS.length;++val) {
			value = new Value(Schedule.RESERVED_WORDS[val],new Datum(schedule.getReserved(val),Datum.STRING),val,schedule);
			values.addElement(value);
			aliases.put(Schedule.RESERVED_WORDS[val],new Integer(val));
		}
		
		/* then assign the user-defined words */
		for (int i = 0; i < size; ++i, ++val) {
			node = schedule.getNode(i);
			value = new Value(node, Datum.getInstance(Datum.UNASKED),node.getAnswerTimeStampStr());
			
			values.addElement(value);

			Integer j = new Integer(val);

			addAlias(node,node.getConcept(),j);
			addAlias(node,node.getLocalName(),j);
			addAlias(node,node.getExternalName(),j);
			aliases.put(node,j);
		}
	}

	private void addAlias(Node n, String alias, Integer index) {
		if (alias == null || alias.equals(""))
			return;	// ignore invalid aliases

		Object o = aliases.put(alias,index);
		if (o != null) {
			int pastIndex = ((Integer) o).intValue();

			if (pastIndex != index.intValue()) {
				/* Allow a single node to try to set the same alias for itself multiple times.
				However, each node must have non-overlapping aliases with other nodes */
				aliases.put(alias,o);	// restore overwritten alias?
				Node prevNode = ((Value) values.elementAt(pastIndex)).getNode();
				n.setParseError("Duplicate alias <B>" + Node.encodeHTML(alias) + "</B> previously used for node <B>" + Node.encodeHTML(prevNode.getLocalName()) + "</B> on line " + prevNode.getSourceLine());
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
			System.err.println("Node not found: " + val);
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
			System.err.println("null Node");
			return;
		}
		if (val == null) {
			System.err.println("null Datum");
			return;
		}
		int i;
		
		i = getStep(node);
		if (i == -1) {
			System.err.println("Node does not exist");
			return;
		}
		
		((Value) values.elementAt(i)).setDatum(val,time);
	}
	
	public void set(Node node, Datum val) {
		set(node,val,null);
	}	

	public void set(String name, Datum val) {
		if (name == null) {
			System.err.println("null Node name");
			return;
		}
		if (val == null) {
			System.err.println("null Datum");
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
			aliases.remove(node.getLocalName());
			aliases.remove(node.getExternalName());
			
			values.setElementAt(new Value(), i.intValue());
		}
	}

	public void unset(String name) {
		Integer i = (Integer)aliases.remove(name);
		if (i != null) {
			values.setElementAt(new Value(), i.intValue());
		}
	}
}
