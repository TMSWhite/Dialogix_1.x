import java.lang.*;
import java.util.*;

/**
 * Contains data generated at each node.  Such data are produced either by the person running the interview in response to
 * questions, or by the system evaluating previously stored evidence
 */
public class Evidence {
    Hashtable aliases;
    Vector data;
    Vector nodes;
    int size;

    public Evidence(int size) {
        aliases = new Hashtable();
        data = new Vector(size);
        nodes = new Vector(size);
        this.size = size;
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
        if (o instanceof Node)
            return (Node)o;
        else
            return null;
    }

    public void set(Node node, Datum val) {
        if (node == null || val == null) {
            System.out.println("null value for node or val");
            return;
        }
        Integer i;
        i = (Integer)aliases.get(node.getName());
        if (i == null) {
            i = new Integer(node.getStep());
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

    public String toString() {
        StringBuffer sb = new StringBuffer();
        Enumeration e = aliases.keys();
        while (e.hasMoreElements()) {
            String s = (String)e.nextElement();
            sb.append(s + "->" + toString(s) + "\n");
        }
        return sb.toString();
    }

    public String toString(Object val) {
        Datum d = getDatum(val);
        if (d == null)
            return "null";
        else
            return d.StringVal();
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

