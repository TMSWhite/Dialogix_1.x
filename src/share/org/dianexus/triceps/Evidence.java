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
	private static final int FUNCTION_INDEX = 2;
	private static final int FUNCTION_NUM_PARAMS = 1;
	private static final int FUNCTION_NAME = 0;
	private static final Integer ZERO = new Integer(0);
	private static final Integer ONE = new Integer(1);
	private static final Integer UNLIMITED = new Integer(-1);

	/* Function declarations */
	private static final int DESC = 0;
	private static final int ISASKED = 1;
	private static final int ISNA = 2;
	private static final int ISREFUSED = 3;
	private static final int ISUNKNOWN = 4;
	private static final int ISNOTUNDERSTOOD = 5;
	private static final int ISDATE = 6;
	private static final int ISANSWERED = 7;
	private static final int GETDATE = 8;
	private static final int GETYEAR = 9;
	private static final int GETMONTH = 10;
	private static final int GETMONTHNUM = 11;
	private static final int GETDAY = 12;
	private static final int GETWEEKDAY = 13;
	private static final int GETTIME = 14;
	private static final int GETHOUR = 15;
	private static final int GETMINUTE = 16;
	private static final int GETSECOND = 17;
	private static final int NOW = 18;
	private static final int STARTTIME = 19;
	private static final int COUNT = 20;
	private static final int ANDLIST = 21;
	private static final int ORLIST = 22;
	private static final int NEWDATE = 23;
	private static final int NEWTIME = 24;
	private static final int ISINVALID = 25;

	private static final Object FUNCTION_ARRAY[][] = {
		{ "desc",				ONE,		new Integer(DESC) },
		{ "isAsked",			ONE,		new Integer(ISASKED) },
		{ "isNA",				ONE,		new Integer(ISNA) },
		{ "isRefused",			ONE,		new Integer(ISREFUSED) },
		{ "isUnknown",			ONE,		new Integer(ISUNKNOWN) },
		{ "isNotUnderstood",	ONE,		new Integer(ISNOTUNDERSTOOD) },
		{ "isDate",				ONE,		new Integer(ISDATE) },
		{ "isAnswered",			ONE,		new Integer(ISANSWERED) },
		{ "toDate",				ONE,		new Integer(GETDATE) },
		{ "toYear",				ONE,		new Integer(GETYEAR) },
		{ "toMonth",			ONE,		new Integer(GETMONTH) },
		{ "toMonthNum",			ONE,		new Integer(GETMONTHNUM) },
		{ "toDay",				ONE,		new Integer(GETDAY) },
		{ "toWeekday",			ONE,		new Integer(GETWEEKDAY) },
		{ "toTime",				ONE,		new Integer(GETTIME) },
		{ "toHour",				ONE,		new Integer(GETHOUR) },
		{ "toMinute",			ONE,		new Integer(GETMINUTE) },
		{ "toSecond",			ONE,		new Integer(GETSECOND) },
		{ "getNow",				ZERO,		new Integer(NOW) },
		{ "getStartTime",		ZERO,		new Integer(STARTTIME) },
		{ "count",				UNLIMITED,	new Integer(COUNT) },
		{ "list",				UNLIMITED,	new Integer(ANDLIST) },
		{ "orlist",				UNLIMITED,	new Integer(ORLIST) },
		{ "newDate",			UNLIMITED,	new Integer(NEWDATE) },
		{ "newTime",			UNLIMITED,	new Integer(NEWTIME) },
		{ "isInvalid",			ONE,		new Integer(ISINVALID) },
	};

	private static final Hashtable FUNCTIONS = new Hashtable();

	static {
		for (int i=0;i<FUNCTION_ARRAY.length;++i) {
			FUNCTIONS.put(FUNCTION_ARRAY[i][FUNCTION_NAME], FUNCTION_ARRAY[i][FUNCTION_INDEX]);
		}
	}

	private Hashtable aliases = new Hashtable();
	private Vector values = new Vector();
	private int	numReserved = 0;
	private Date startTime = new Date(System.currentTimeMillis());
	private Logger errorLogger = new Logger();
	Lingua lingua = Lingua.NULL;	// should be available to Datum for Qss purposes

	public Evidence(Lingua lang, Schedule schedule) {
    	lingua = (lang == null) ? Lingua.NULL : lang;

		if (schedule == null) {
			return;
		}

		numReserved = Schedule.RESERVED_WORDS.length;	// these are always added at the beginning

		Node node;
		Value value;
		int idx=0;

		/* first assign the reserved words */
		for (idx=0;idx<Schedule.RESERVED_WORDS.length;++idx) {
			value = new Value(Schedule.RESERVED_WORDS[idx],new Datum(lingua, schedule.getReserved(idx),Datum.STRING),idx,schedule);
			values.addElement(value);
			addAlias(null,Schedule.RESERVED_WORDS[idx],new Integer(idx));
		}

		int size = schedule.size();

		/* then assign the user-defined words */
		for (int i = 0; i < size; ++i, ++idx) {
			node = schedule.getNode(i);
			value = new Value(node, Datum.getInstance(lingua,Datum.UNASKED),node.getAnswerTimeStampStr());

			values.addElement(value);

			Integer j = new Integer(idx);

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
				n.setParseError(lingua.get("alias_previously_used_on_line") + prevNode.getSourceLine() + ": " + alias);
			}
		}
	}

	public boolean containsKey(Object val) {
		if (val == null)
			return false;
		return aliases.containsKey(val);
	}

	public Datum getDatum(Object val) {
		int i = getNodeIndex(val);
		if (i == -1) {
			return null;
		}
		return ((Value) values.elementAt(i)).getDatum();
	}

	public Node getNode(Object val) {
		int i = getNodeIndex(val);
		if (i == -1) {
			setError(lingua.get("node_not_found") + val);
			return null;
		}
		return ((Value) values.elementAt(i)).getNode();
	}

	public int getStep(Object n) {
		if (n == null)
			return -1;
		int step = getNodeIndex(n);
		if (step == -1)
			return -1;
		else
			return (step - numReserved);
	}

	private int getNodeIndex(Object n) {
		if (n == null)
			return -1;
		Object o = aliases.get(n);	// String, or Node
		if (o != null && o instanceof Integer)
			return ((Integer) o).intValue();

		if (!(n instanceof Node))
			return -1;

		Node node = (Node) n;
		o = aliases.get(node.getConcept());
		if (o != null && o instanceof Integer)
			return ((Integer) o).intValue();

		o = aliases.get(node.getLocalName());
		if (o != null && o instanceof Integer)
			return ((Integer) o).intValue();

		return -1;
	}

	public void set(Node node, Datum val, String time) {
		if (node == null) {
			setError(lingua.get("null_node"));
			return;
		}
		if (val == null) {
			setError(lingua.get("null_datum"));
			return;
		}
		int i;

		i = getNodeIndex(node);
		if (i == -1) {
			setError(lingua.get("node_does_not_exist"));
			return;
		}

		val.setName(node.getLocalName());
		((Value) values.elementAt(i)).setDatum(val,time);
	}

	public void set(Node node, Datum val) {
		set(node,val,null);
	}

	public void set(String name, Datum val) {
		if (name == null) {
			setError(lingua.get("null_node"));
			return;
		}
		if (val == null) {
			setError(lingua.get("null_datum"));
			return;
		}

		int i = getNodeIndex(name);
		if (i == -1) {
			i = size();	// append to end
			val.setName(name);
			Value value = new Value(name,val);
			values.addElement(value);
			aliases.put(name, new Integer(i));

			String errmsg = lingua.get("new_variable_will_be_transient") + name;
			setError(errmsg);
		}
		else {
			Value v = (Value) values.elementAt(i);
			Node n = v.getNode();
			if (n != null) {
				val.setName(n.getLocalName());
			}
			v.setDatum(val,null);
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

	public Date getStartTime() { return startTime; }

	private Datum getParam(Object o) {
		if (o == null)
			return Datum.getInstance(lingua,Datum.INVALID);
		else if (o instanceof String)
			return getDatum(o);
		else
			return (Datum) o;
	}


	public Datum function(String name, Vector params, int line, int column) {
		/* passed a vector of Datum values */
		try {
			Integer func = (Integer) FUNCTIONS.get(name);
			int funcNum = 0;

			if (func == null || ((funcNum = func.intValue()) < 0)) {
				/* then not found - could consider calling JavaBean! */
				setError(lingua.get("unsupported_function") + name, line, column);
				return Datum.getInstance(lingua,Datum.INVALID);
			}
			
			Integer	numParams = (Integer) FUNCTION_ARRAY[funcNum][FUNCTION_NUM_PARAMS];

			if (!(UNLIMITED.equals(numParams) || params.size() == numParams.intValue())){
				setError(lingua.get("function") + name + lingua.get("expects") + numParams + lingua.get("parameters"), line, column);
				return Datum.getInstance(lingua,Datum.INVALID);
			}

			Object o = null;
			Datum datum = null;

			if (params.size() > 0) {
				o = params.elementAt(0);
				datum = getParam(o);
			}


			switch(funcNum) {
				case DESC: {
					String nodeName = datum.getName();
					Node node = null;
					if (nodeName == null || ((node = getNode(nodeName)) == null)) {
						setError(lingua.get("unknown_node") + nodeName, line, column);
						return Datum.getInstance(lingua,Datum.INVALID);
					}
					return new Datum(lingua, node.getReadback(),Datum.STRING);
				}
				case ISINVALID:
					return new Datum(lingua, datum.isType(Datum.INVALID));
				case ISASKED:
					return new Datum(lingua, !(datum.isType(Datum.NA)));
				case ISNA:
					return new Datum(lingua, datum.isType(Datum.NA));
				case ISREFUSED:
					return new Datum(lingua, datum.isType(Datum.REFUSED));
				case ISUNKNOWN:
					return new Datum(lingua, datum.isType(Datum.UNKNOWN));
				case ISNOTUNDERSTOOD:
					return new Datum(lingua, datum.isType(Datum.NOT_UNDERSTOOD));
				case ISDATE:
					return new Datum(lingua, datum.isType(Datum.DATE));
				case ISANSWERED:
					return new Datum(lingua, datum.exists());
				case GETDATE:
					return new Datum(lingua, datum.dateVal(),Datum.DATE);
				case GETYEAR:
					return new Datum(lingua, datum.dateVal(),Datum.YEAR);
				case GETMONTH:
					return new Datum(lingua, datum.dateVal(),Datum.MONTH);
				case GETMONTHNUM:
					return new Datum(lingua, datum.dateVal(),Datum.MONTH_NUM);
				case GETDAY:
					return new Datum(lingua, datum.dateVal(),Datum.DAY);
				case GETWEEKDAY:
					return new Datum(lingua, datum.dateVal(),Datum.WEEKDAY);
				case GETTIME:
					return new Datum(lingua, datum.dateVal(),Datum.TIME);
				case GETHOUR:
					return new Datum(lingua, datum.dateVal(),Datum.HOUR);
				case GETMINUTE:
					return new Datum(lingua, datum.dateVal(),Datum.MINUTE);
				case GETSECOND:
					return new Datum(lingua, datum.dateVal(),Datum.SECOND);
				case NOW:
					return new Datum(lingua, new Date(System.currentTimeMillis()),Datum.DATE);
				case STARTTIME:
					return new Datum(lingua, startTime,Datum.TIME);
				case COUNT:	// unlimited number of parameters
				{
					long count=0;
					for (int i=0;i<params.size();++i) {
						datum = getParam(params.elementAt(i));
						if (datum.booleanVal()) {
							++count;
						}
					}
					return new Datum(lingua, count);
				}
				case ANDLIST:
				case ORLIST:	// unlimited number of parameters
				{
					StringBuffer sb = new StringBuffer();
					Vector v = new Vector();
					for (int i=0;i<params.size();++i) {
						datum = getParam(params.elementAt(i));
						if (datum.exists()) {
							v.addElement(datum);
						}
					}
					for (int i=0;i<v.size();++i) {
						datum = (Datum) v.elementAt(i);
						if (sb.length() > 0) {
							if ((v.size() > 2)) {
								sb.append(", ");
							}
							else {
								sb.append(" ");
							}
						}
						if ((i == (v.size() - 1)) && (v.size() > 1)) {
							if (funcNum == ANDLIST) {
								sb.append(lingua.get("and") + " ");
							}
							else if (funcNum == ORLIST) {
								sb.append(lingua.get("or") + " ");
							}
						}
						sb.append(datum.stringVal());
					}
					return new Datum(lingua, sb.toString(),Datum.STRING);
				}
				case NEWDATE:
					if (params.size() == 1) {
						/* newDate(int weekdaynum) */
						GregorianCalendar gc = new GregorianCalendar();	// should happen infrequently (not a garbage collection problem?)
						gc.set(Calendar.DAY_OF_WEEK,Calendar.SUNDAY);
						gc.add(Calendar.DAY_OF_WEEK,((int) (getParam(params.elementAt(0)).doubleVal()) - 1));
						return new Datum(lingua, gc.getTime(),Datum.WEEKDAY);
					}
					if (params.size() == 2) {
						/* newDate(String image, String mask) */
						return new Datum(lingua, getParam(params.elementAt(0)).stringVal(), Datum.DATE, getParam(params.elementAt(1)).stringVal());
					}
					else if (params.size() == 3) {
						/* newDate(int y, int m, int d) */
						StringBuffer sb = new StringBuffer();
						sb.append(getParam(params.elementAt(0)).stringVal() + "/");
						sb.append(getParam(params.elementAt(1)).stringVal() + "/");
						sb.append(getParam(params.elementAt(2)).stringVal());
						return new Datum(lingua, sb.toString(), Datum.DATE, "yy/mm/dd");
					}
					break;
				case NEWTIME:
					if (params.size() == 2) {
						/* newTime(String image, String mask) */
						return new Datum(lingua, getParam(params.elementAt(0)).stringVal(), Datum.TIME, getParam(params.elementAt(1)).stringVal());
					}
					else if (params.size() == 3) {
						/* newTime(int hh, int mm, int ss) */
						StringBuffer sb = new StringBuffer();
						sb.append(getParam(params.elementAt(0)).stringVal() + ":");
						sb.append(getParam(params.elementAt(1)).stringVal() + ":");
						sb.append(getParam(params.elementAt(2)).stringVal());
						return new Datum(lingua, sb.toString(), Datum.TIME, "hh:mm:ss");
					}			
					break;
			}
		}
		catch (Throwable t) { 
			Logger.printStackTrace(t);
		}
		setError("unexpected error running function " + name, line, column);
		return Datum.getInstance(lingua,Datum.INVALID);
	}

	private void setError(String s, int line, int column) { errorLogger.println(s,line,column); }
	private void setError(String s) { errorLogger.println(s); }
	public boolean hasErrors() { return (errorLogger.size() > 0); }
	public String getErrors() { return errorLogger.toString(); }
}
