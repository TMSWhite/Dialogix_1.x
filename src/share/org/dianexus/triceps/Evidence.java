import java.lang.*;
import java.util.*;
import java.io.*;
import java.net.*;

/**
 * Contains data generated at each node.  Such data are produced either
 * by the person running the interview in response to
 * questions, or by the system evaluating previously stored evidence
 * TODO:
 *	who should maintain aliases? - is evidence self knowing, or is that Triceps' role?
 */
public class Evidence implements Serializable {
	Hashtable aliases;
	Vector data;
	Vector nodes;
	Schedule schedule = null;
	int size;

	public Evidence(Schedule schedule) {
		aliases = new Hashtable();
		data = new Vector(size);
		nodes = new Vector(size);
		this.schedule = schedule;
		size = schedule.size();

		Node node;
		int i;
		for (i = 0; i < size; ++i) {
			data.addElement(new Datum(Datum.UNKNOWN));
			node = schedule.getNode(i);
			if (node == null) {
				System.out.println("Inaccessible node # " + i);
				nodes.addElement(null);
				continue;
			}
			nodes.addElement(node);
			Integer j = new Integer(i);

			addAlias(node,node.getConcept(),j);
			addAlias(node,node.getName(),j);
			addAlias(node,node.getQuestionRef(),j);
		}
	}

	private void addAlias(Node n, String alias, Integer index) {
		if (alias == null || alias.equals(Triceps.NULL))
			return;	// ignore invalid aliases

		Object o = aliases.put(alias,index);
		if (o != null) {
			int pastIndex = ((Integer) o).intValue();

			if (pastIndex != index.intValue()) {
				/* Allow a single node to try to set the same alias for itself multiple times.
				However, each node must have non-overlapping aliases with other nodes */
				aliases.put(alias,o);	// restore overwritten alias
				Node prevNode = schedule.getNode(pastIndex);
				n.setParseError("Duplicate alias <B>" + Node.encodeHTML(alias) + "</B> previously used for node <B>" + Node.encodeHTML(prevNode.getName()) + "</B> on line " + prevNode.getSourceLine());
//				prevNode.setParseError("Node '" + n.getName() + "' is trying to steal your alias '" + alias + "'");
			}
		}
	}


	public Evidence(int size) {
		schedule = null;
		this.size = size;
		aliases = new Hashtable();
		data = new Vector(size);
		nodes = new Vector(size);
		for (int i = 0; i < size; ++i) {
			data.addElement(null);
			nodes.addElement(null);
		}
	}

	public boolean containsKey(Object val) {
		if (val == null)
			return false;
		if (val instanceof String)
			return aliases.containsKey(val);
		if (val instanceof Node)
			return aliases.containsKey(((Node)val).getName());
		return false;
	}

	public Datum getDatum(Object val) {
		if (!containsKey(val))
			return null;
		Integer i = null;
		if (val instanceof String)
			i = (Integer)aliases.get(val);
		if (val instanceof Node)
			i = (Integer)aliases.get(((Node)val).getName());
		if (i == null)
			return null;
		return (Datum)data.elementAt(i.intValue());
	}

	public Node getNode(Object val) {
		if (!containsKey(val)) {
			System.out.println("Node not found: " + val);
			return null;
		}
		Integer i = null;
		if (val instanceof String)
			i = (Integer)aliases.get(val);
		if (val instanceof Node)
			i = (Integer)aliases.get(((Node)val).getName());
		if (i == null) {
			System.out.println("Index for Node not found: " + val);
			return null;
		}
		Object o = nodes.elementAt(i.intValue());
		if (o instanceof Node) {
			return (Node)o;
		}

		else
			return null;
	}

	public int getStep(Node n) {
		if (n == null)
			return -1;
		if (nodes.contains(n)) {
			return nodes.indexOf(n);
		} else {
			return -1;
		}
	}

	public void set(Node node, Datum val) {
		if (node == null || val == null) {
			System.out.println("null value for node or val");
			return;
		}
		Integer i;
		i = (Integer)aliases.get(node.getName());	// fast way to access value - via hash
		if (i == null)
			i = (Integer)aliases.get(node.getQuestionRef());	// fast way to access value - via hash
		if (i == null)
			i = (Integer)aliases.get(node.getConcept());	// fast way to access value - via hash
		if (i == null)
			i = new Integer(getStep(node));	// potentially slow way - search for identical node within vector
		if (i == null) {
			System.out.println("Node does not exist within evidence");
			return;
		}

		data.setElementAt(val, i.intValue());
		nodes.setElementAt(node, i.intValue());
		aliases.put(node.getConcept(), i);
		aliases.put(node.getName(), i);
		aliases.put(node.getQuestionRef(), i);
	}

	public void set(String name, Datum val) {
		if (name == null || val == null) {
			System.out.println("null value for name or val");
			return;
		}
		Integer i;
		i = (Integer)aliases.get(name);
		if (i == null) {
			i = new Integer(data.size());
			data.addElement(val);
			nodes.addElement(name);
		}
		else {
			data.setElementAt(val, i.intValue());
			nodes.setElementAt(name, i.intValue());
		}
		aliases.put(name, i);
	}

	public int size() {
		return data.size();
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
		Integer i = (Integer)aliases.remove(node.getConcept());
		aliases.remove(node.getName());
		aliases.remove(node.getQuestionRef());
		if (i != null) {
			data.setElementAt(null, i.intValue());
			nodes.setElementAt(null, i.intValue());
		}
	}

	public void unset(String name) {
		Integer i = (Integer)aliases.remove(name);
		if (i != null) {
			data.setElementAt(null, i.intValue());
			nodes.setElementAt(null, i.intValue());
		}
	}
}
