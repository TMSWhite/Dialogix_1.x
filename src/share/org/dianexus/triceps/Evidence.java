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
	private static final Integer TWO = new Integer(2);
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
	private static final int MIN = 26;
	private static final int MAX = 27;
	private static final int GETDAYNUM = 28;
	private static final int HASCOMMENT = 29;
	private static final int GETCOMMENT = 30;
	private static final int GETTYPE = 31;
	private static final int ISSPECIAL = 32;
	private static final int NUMANSOPTIONS = 33;
	private static final int GETANSOPTION = 34;
	private static final int CHARAT = 35;
	private static final int COMPARETO = 36;
	private static final int COMPARETOIGNORECASE = 37;
	private static final int ENDSWITH = 38;
	private static final int INDEXOF = 39;
	private static final int LASTINDEXOF = 40;
	private static final int LENGTH = 41;
	private static final int STARTSWITH = 42;
	private static final int SUBSTRING = 43;
	private static final int TOLOWERCASE = 44;
	private static final int TOUPPERCASE = 45;
	private static final int TRIM = 46;
	private static final int ISNUMBER = 47;
	private static final int FILEEXISTS = 48;

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
		{ "min",				UNLIMITED,	new Integer(MIN) },
		{ "max",				UNLIMITED,	new Integer(MAX) },
		{ "toDayNum",			ONE,		new Integer(GETDAYNUM) },
		{ "hasComment",			ONE,		new Integer(HASCOMMENT) },
		{ "getComment",			ONE,		new Integer(GETCOMMENT) },
		{ "getType",			ONE,		new Integer(GETTYPE) },
		{ "isSpecial",			ONE,		new Integer(ISSPECIAL) },
		{ "numAnsOptions",		ONE,		new Integer(NUMANSOPTIONS) },
		{ "getAnsOption",		UNLIMITED,	new Integer(GETANSOPTION) },
		{ "charAt",				TWO,		new Integer(CHARAT) },
		{ "compareTo",			TWO,		new Integer(COMPARETO) },
		{ "compareToIgnoreCase",	TWO,	new Integer(COMPARETOIGNORECASE) },
		{ "endsWith",			TWO,		new Integer(ENDSWITH) },
		{ "indexOf",			UNLIMITED,	new Integer(INDEXOF) },
		{ "lastIndexOf",		UNLIMITED,	new Integer(LASTINDEXOF) },
		{ "length",				ONE,		new Integer(LENGTH) },
		{ "startsWith",			UNLIMITED,	new Integer(STARTSWITH) },
		{ "substring",			UNLIMITED,	new Integer(SUBSTRING) },
		{ "toLowerCase",		ONE,		new Integer(TOLOWERCASE) },
		{ "toUpperCase",		ONE,		new Integer(TOUPPERCASE) },
		{ "trim",				ONE,		new Integer(TRIM) },	
		{ "isNumber",			ONE,		new Integer(ISNUMBER) },
		{ "fileExists",			ONE,		new Integer(FILEEXISTS) },
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
	Triceps triceps = null;	// need package-level access in Qss

	public Evidence(Triceps tri, boolean toUnasked) {
		if (tri == null)
			return;
		triceps = tri;
		Schedule schedule = triceps.getSchedule();

		numReserved = Schedule.RESERVED_WORDS.length;	// these are always added at the beginning

		Node node=null;
		Value value=null;
		String init=null;
		Datum datum = null;
		int idx=0;

		/* first assign the reserved words */
		for (idx=0;idx<Schedule.RESERVED_WORDS.length;++idx) {
			value = new Value(Schedule.RESERVED_WORDS[idx],new Datum(triceps, schedule.getReserved(idx),Datum.STRING),idx,schedule);
			values.addElement(value);
			addAlias(null,Schedule.RESERVED_WORDS[idx],new Integer(idx));
		}

		int size = schedule.size();
		int startingStep = Integer.parseInt(schedule.getReserved(Schedule.STARTING_STEP));
		String timeStamp = null;
		String startTime = schedule.getReserved(Schedule.START_TIME);


		/* then assign the user-defined words */
		for (int i = 0; i < size; ++i, ++idx) {
			node = schedule.getNode(i);
			
			if (toUnasked) {
				datum = Datum.getInstance(tri,Datum.UNASKED);
				timeStamp = startTime;
			}
			else {
				/* read default values from schedule file */
				init = node.getAnswerGiven();
				if (init == null || init.length() == 0) {
					if (i < startingStep && node.getAnswerType() == Node.NOTHING) {
						datum = new Datum(tri,"",Datum.STRING);	// so that not marked as UNASKED
					}
					else {
						datum = Datum.getInstance(tri,Datum.UNASKED);
					}
				}
				else {
					datum = Datum.parseSpecialType(tri,init);
					if (datum == null) {
						/* then not special, so use the init value */
						datum = new Datum(tri, init, node.getDatumType(), node.getMask());
					}
				}
				timeStamp = node.getAnswerTimeStampStr();
				if (timeStamp == null || timeStamp.trim().length() == 0)
					timeStamp = startTime;
			}
				
			value = new Value(node, datum, timeStamp);
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
				n.setParseError(triceps.get("alias_previously_used_on_line") + prevNode.getSourceLine() + ": " + alias);
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
			setError(triceps.get("node_not_found"),val);
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
			setError(triceps.get("null_node"),null);
			return;
		}
		if (val == null) {
			setError(triceps.get("null_datum"),null);
			return;
		}
		int i;

		i = getNodeIndex(node);
		if (i == -1) {
			setError(triceps.get("node_does_not_exist"),node.getLocalName());
			return;
		}
		
		Value value = (Value) values.elementAt(i);
		value.setDatum(val,time);
	}

	public void set(Node node, Datum val) {
		set(node,val,null);
	}

	public void set(String name, Datum val) {
		if (name == null) {
			setError(triceps.get("null_node"),null);
			return;
		}
		if (val == null) {
			setError(triceps.get("null_datum"),null);
			return;
		}

		int i = getNodeIndex(name);
		if (i == -1) {
			i = size();	// append to end
			Value value = new Value(name,val);
			values.addElement(value);
			aliases.put(name, new Integer(i));

			String errmsg = triceps.get("new_variable_will_be_transient") + name;
			setError(errmsg,null);
		}
		else {
			/* variables don't change their names after being created */
			Value v = (Value) values.elementAt(i);
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
			return Datum.getInstance(triceps,Datum.INVALID);
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
				setError(triceps.get("unsupported_function") + name, line, column,null);
				return Datum.getInstance(triceps,Datum.INVALID);
			}
			
			Integer	numParams = (Integer) FUNCTION_ARRAY[funcNum][FUNCTION_NUM_PARAMS];

			if (!(UNLIMITED.equals(numParams) || params.size() == numParams.intValue())){
				setError(triceps.get("function") + name + triceps.get("expects") + " " + numParams + " " + triceps.get("parameters"), line, column,params.size());
				return Datum.getInstance(triceps,Datum.INVALID);
			}

			Datum datum = null;

			if (params.size() > 0) {
				datum = getParam(params.elementAt(0));
			}


			switch(funcNum) {
				case DESC: 
				{
					String nodeName = datum.getName();
					Node node = null;
					if (nodeName == null || ((node = getNode(nodeName)) == null)) {
						setError(triceps.get("unknown_node") + nodeName, line, column,nodeName);
						return Datum.getInstance(triceps,Datum.INVALID);
					}
					return new Datum(triceps, node.getReadback(triceps.getLanguage()),Datum.STRING);
				}
				case ISINVALID:
					return new Datum(triceps, datum.isType(Datum.INVALID));
				case ISASKED:
					return new Datum(triceps, !(datum.isType(Datum.NA) || datum.isType(Datum.UNASKED) || datum.isType(Datum.INVALID)));
				case ISNA:
					return new Datum(triceps, datum.isType(Datum.NA));
				case ISREFUSED:
					return new Datum(triceps, datum.isType(Datum.REFUSED));
				case ISUNKNOWN:
					return new Datum(triceps, datum.isType(Datum.UNKNOWN));
				case ISNOTUNDERSTOOD:
					return new Datum(triceps, datum.isType(Datum.NOT_UNDERSTOOD));
				case ISDATE:
					return new Datum(triceps, datum.isType(Datum.DATE));
				case ISANSWERED:
					return new Datum(triceps, datum.exists());
				case GETDATE:
					return new Datum(triceps, datum.dateVal(),Datum.DATE);
				case GETYEAR:
					return new Datum(triceps, datum.dateVal(),Datum.YEAR);
				case GETMONTH:
					return new Datum(triceps, datum.dateVal(),Datum.MONTH);
				case GETMONTHNUM:
					return new Datum(triceps, datum.dateVal(),Datum.MONTH_NUM);
				case GETDAY:
					return new Datum(triceps, datum.dateVal(),Datum.DAY);
				case GETWEEKDAY:
					return new Datum(triceps, datum.dateVal(),Datum.WEEKDAY);
				case GETTIME:
					return new Datum(triceps, datum.dateVal(),Datum.TIME);
				case GETHOUR:
					return new Datum(triceps, datum.dateVal(),Datum.HOUR);
				case GETMINUTE:
					return new Datum(triceps, datum.dateVal(),Datum.MINUTE);
				case GETSECOND:
					return new Datum(triceps, datum.dateVal(),Datum.SECOND);
				case NOW:
					return new Datum(triceps, new Date(System.currentTimeMillis()),Datum.DATE);
				case STARTTIME:
					return new Datum(triceps, startTime,Datum.TIME);
				case COUNT:	// unlimited number of parameters
				{
					long count=0;
					for (int i=0;i<params.size();++i) {
						datum = getParam(params.elementAt(i));
						if (datum.booleanVal()) {
							++count;
						}
					}
					return new Datum(triceps, count);
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
								sb.append(triceps.get("and") + " ");
							}
							else if (funcNum == ORLIST) {
								sb.append(triceps.get("or") + " ");
							}
						}
						sb.append(datum.stringVal());
					}
					return new Datum(triceps, sb.toString(),Datum.STRING);
				}
				case NEWDATE:
					if (params.size() == 1) {
						/* newDate(int weekdaynum) */
						GregorianCalendar gc = new GregorianCalendar();	// should happen infrequently (not a garbage collection problem?)
						gc.set(Calendar.DAY_OF_WEEK,Calendar.SUNDAY);
						gc.add(Calendar.DAY_OF_WEEK,((int) (getParam(params.elementAt(0)).doubleVal()) - 1));
						return new Datum(triceps, gc.getTime(),Datum.WEEKDAY);
					}
					if (params.size() == 2) {
						/* newDate(String image, String mask) */
						return new Datum(triceps, getParam(params.elementAt(0)).stringVal(), Datum.DATE, getParam(params.elementAt(1)).stringVal());
					}
					else if (params.size() == 3) {
						/* newDate(int y, int m, int d) */
						StringBuffer sb = new StringBuffer();
						sb.append(getParam(params.elementAt(0)).stringVal() + "/");
						sb.append(getParam(params.elementAt(1)).stringVal() + "/");
						sb.append(getParam(params.elementAt(2)).stringVal());
						return new Datum(triceps, sb.toString(), Datum.DATE, "yy/mm/dd");
					}
					break;
				case NEWTIME:
					if (params.size() == 2) {
						/* newTime(String image, String mask) */
						return new Datum(triceps, getParam(params.elementAt(0)).stringVal(), Datum.TIME, getParam(params.elementAt(1)).stringVal());
					}
					else if (params.size() == 3) {
						/* newTime(int hh, int mm, int ss) */
						StringBuffer sb = new StringBuffer();
						sb.append(getParam(params.elementAt(0)).stringVal() + ":");
						sb.append(getParam(params.elementAt(1)).stringVal() + ":");
						sb.append(getParam(params.elementAt(2)).stringVal());
						return new Datum(triceps, sb.toString(), Datum.TIME, "hh:mm:ss");
					}			
					break;
				case MIN:
					if (params.size() == 0) {
						return Datum.getInstance(triceps,Datum.INVALID);
					}
					else {
						Datum minVal = null;
						
						for (int i=0;i<params.size();++i) {
							Datum a = getParam(params.elementAt(i));
							
							if (i == 0) {
								minVal = a;
							}
							else {
								if (DatumMath.lt(a,minVal).booleanVal()) {
									minVal = a;
								}
							}
						}
						return new Datum(minVal);
					}
				case MAX:
					if (params.size() == 0) {
						return Datum.getInstance(triceps,Datum.INVALID);
					}
					else {
						Datum maxVal = null;
						
						for (int i=0;i<params.size();++i) {
							Datum a = getParam(params.elementAt(i));
							
							if (i == 0) {
								maxVal = a;
							}
							else {
								if (DatumMath.gt(a,maxVal).booleanVal()) {
									maxVal = a;
								}
							}
						}
						return new Datum(maxVal);
					}
				case GETDAYNUM:
					return new Datum(triceps, datum.dateVal(),Datum.DAY_NUM);
				case HASCOMMENT:
				{
					String nodeName = datum.getName();
					Node node = null;
					if (nodeName == null || ((node = getNode(nodeName)) == null)) {
						setError(triceps.get("unknown_node") + nodeName, line, column,null);
						return new Datum(triceps,false);
					}
					String comment = node.getComment();
					return new Datum(triceps, (comment != null && comment.trim().length() > 0) ? true : false);
				}
				case GETCOMMENT:
				{
					String nodeName = datum.getName();
					Node node = null;
					if (nodeName == null || ((node = getNode(nodeName)) == null)) {
						setError(triceps.get("unknown_node") + nodeName, line, column,null);
						return Datum.getInstance(triceps,Datum.INVALID);
					}
					return new Datum(triceps, node.getComment(), Datum.STRING);
				}
				case GETTYPE:
					return new Datum(triceps, datum.getTypeName(), Datum.STRING);
				case ISSPECIAL:
					return new Datum(triceps, datum.isSpecial());
				case NUMANSOPTIONS:
				{
					String nodeName = datum.getName();
					Node node = null;
					if (nodeName == null || ((node = getNode(nodeName)) == null)) {
						setError(triceps.get("unknown_node") + nodeName, line, column,null);
						return Datum.getInstance(triceps,Datum.INVALID);
					}
					Vector choices = node.getAnswerChoices();
					return new Datum(triceps, choices.size());
				}
				case GETANSOPTION:
				{
					if (params.size() < 1 || params.size() > 2)
						break;
						
					String nodeName = datum.getName();
					Node node = null;
					if (nodeName == null || ((node = getNode(nodeName)) == null)) {
						setError(triceps.get("unknown_node") + nodeName, line, column,null);
						return Datum.getInstance(triceps,Datum.INVALID);
					}
					Vector choices = node.getAnswerChoices();
					if (params.size() == 1) {
						if (datum.isSpecial()) {
							return new Datum(datum);
						}
						else {
							String s = datum.stringVal();
							for (int i=0;i<choices.size();++i) {
								AnswerChoice ac = (AnswerChoice) choices.elementAt(i);
								if (ac.getValue().equals(s)) {
									return new Datum(triceps, ac.getMessage(), Datum.STRING);
								}
							}
							return Datum.getInstance(triceps,Datum.INVALID);	
						}
					}
					else { // if (params.size() == 2) {
						datum = getParam(params.elementAt(1));
						if (!datum.isNumeric()) {
							setError(functionError(funcNum,Datum.NUMBER,2),datum);
							return Datum.getInstance(triceps,Datum.INVALID);	
						}
						int index = (int) datum.doubleVal();
						if (index < 0) {
							setError(triceps.get("index_too_low"),index);
							return Datum.getInstance(triceps,Datum.INVALID);	
						}
						else if (index >= choices.size()) {
							setError(triceps.get("index_too_high"),index);
							return Datum.getInstance(triceps,Datum.INVALID);	
						}
						else {
							return new Datum(triceps,((AnswerChoice) choices.elementAt(index)).getMessage(), Datum.STRING);
						}
					}
				}
				case CHARAT:
				{
					String src = datum.stringVal();
					datum = getParam(params.elementAt(1));
					if (!datum.isNumeric()) {
						setError(functionError(funcNum,Datum.NUMBER,2),datum);
						return Datum.getInstance(triceps,Datum.INVALID);	
					}
					int index = (int) datum.doubleVal();
					if (index < 0) {
						setError(triceps.get("index_too_low"),index);
						return Datum.getInstance(triceps,Datum.INVALID);	
					}
					else if (index >= src.length()) {
						setError(triceps.get("index_too_high"),index);
						return Datum.getInstance(triceps,Datum.INVALID);	
					}
					else {
						return new Datum(triceps,String.valueOf(src.charAt(index)), Datum.STRING);
					}
				}
				case COMPARETO:
					return new Datum(triceps,datum.stringVal().compareTo(getParam(params.elementAt(1)).stringVal()));
				case COMPARETOIGNORECASE:
					return new Datum(triceps,datum.stringVal().compareToIgnoreCase(getParam(params.elementAt(1)).stringVal()));
				case ENDSWITH:
					return new Datum(triceps,datum.stringVal().endsWith(getParam(params.elementAt(1)).stringVal()));
				case INDEXOF: 
				{
					if (params.size() < 2 || params.size() > 3)
						break;
						
					String str1 = getParam(params.elementAt(0)).stringVal();
					String str2 = getParam(params.elementAt(1)).stringVal();
					
					if (params.size() == 2) {
						return new Datum(triceps, str1.indexOf(str2));
					}
					else if (params.size() == 3) {
						Datum datum2 = getParam(params.elementAt(2));
						if (!datum2.isNumeric()) {
							setError(functionError(funcNum,Datum.NUMBER,3),datum2);
							return Datum.getInstance(triceps,Datum.INVALID);	
						}
						int index = (int) datum2.doubleVal();
						if (index < 0) {
							setError(triceps.get("index_too_low"),index);
							return Datum.getInstance(triceps,Datum.INVALID);	
						}
						else if (index >= str1.length()) {
							setError(triceps.get("index_too_high"),index);
							return Datum.getInstance(triceps,Datum.INVALID);	
						}
						else {
							return new Datum(triceps, str1.indexOf(str2,index));
						}
					}
					else {
						break;
					}
				}
				case LASTINDEXOF:
				{
					if (params.size() < 2 || params.size() > 3)
						break;
						
					String str1 = getParam(params.elementAt(0)).stringVal();
					String str2 = getParam(params.elementAt(1)).stringVal();
											
					if (params.size() == 2) {
						return new Datum(triceps, str1.lastIndexOf(str2));
					}
					else if (params.size() == 3) {
						Datum datum2 = getParam(params.elementAt(2));
						if (!datum2.isNumeric()) {
							setError(functionError(funcNum,Datum.NUMBER,3),datum2);
							return Datum.getInstance(triceps,Datum.INVALID);	
						}
						int index = (int) datum2.doubleVal();
						if (index < 0) {
							setError(triceps.get("index_too_low"),index);
							return Datum.getInstance(triceps,Datum.INVALID);	
						}
						else if (index >= str1.length()) {
							setError(triceps.get("index_too_high"),index);
							return Datum.getInstance(triceps,Datum.INVALID);	
						}
						else {
							return new Datum(triceps, str1.lastIndexOf(str2,index));
						}
					}
					else {
						break;
					}
				}
				case LENGTH:
					return new Datum(triceps,datum.stringVal().length());
				case STARTSWITH:
				{
					if (params.size() < 2 || params.size() > 3)
						break;
						
					String str1 = getParam(params.elementAt(0)).stringVal();
					String str2 = getParam(params.elementAt(1)).stringVal();
											
					if (params.size() == 2) {
						return new Datum(triceps, str1.startsWith(str2));
					}
					else if (params.size() == 3) {
						Datum datum2 = getParam(params.elementAt(2));
						if (!datum2.isNumeric()) {
							setError(functionError(funcNum,Datum.NUMBER,3),datum2);
							return Datum.getInstance(triceps,Datum.INVALID);	
						}
						int index = (int) datum2.doubleVal();
						if (index < 0) {
							setError(triceps.get("index_too_low"),index);
							return Datum.getInstance(triceps,Datum.INVALID);	
						}
						else if (index >= str1.length()) {
							setError(triceps.get("index_too_high"),index);
							return Datum.getInstance(triceps,Datum.INVALID);	
						}
						else {
							return new Datum(triceps, str1.startsWith(str2,index));
						}
					}
					else {
						break;
					}
				}					
				case SUBSTRING:
				{
					if (params.size() < 2 || params.size() > 3)
						break;
						
					String str1 = getParam(params.elementAt(0)).stringVal();
					Datum start = getParam(params.elementAt(1));
					Datum end = null;
					int from, to;
					
					if (params.size() == 3) {
						end = getParam(params.elementAt(2));
					}
					
					if (!start.isNumeric()) {
						setError(functionError(funcNum,Datum.NUMBER,2),start);
						return Datum.getInstance(triceps,Datum.INVALID);	
					}
					else {
						from = (int) start.doubleVal();
						if (from < 0) {
							setError(triceps.get("index_too_low"),from);
							return Datum.getInstance(triceps,Datum.INVALID);	
						}
						else if (from >= str1.length()) {
							setError(triceps.get("index_too_high"),from);
							return Datum.getInstance(triceps,Datum.INVALID);								
						}
						
					}
					
					if (end != null) {
						if (!end.isNumeric()) {
							setError(functionError(funcNum,Datum.NUMBER,3),end);
							return Datum.getInstance(triceps,Datum.INVALID);
						}
						else {
							to = (int) end.doubleVal();
							if (to < from) {
								setError(triceps.get("index_too_low"),to);
								return Datum.getInstance(triceps,Datum.INVALID);	
							}
							else if (to >= str1.length()) {
								setError(triceps.get("index_too_high"),to);
								return Datum.getInstance(triceps,Datum.INVALID);								
							}
							else {
								return new Datum(triceps, str1.substring(from,to), Datum.STRING);
							}
						}
					}
					else {
						return new Datum(triceps, str1.substring(from), Datum.STRING);
					}
				}					
				case TOLOWERCASE:
					return new Datum(triceps,datum.stringVal().toLowerCase(), Datum.STRING);
				case TOUPPERCASE:
					return new Datum(triceps,datum.stringVal().toUpperCase(), Datum.STRING);
				case TRIM:
					return new Datum(triceps,datum.stringVal().trim(), Datum.STRING);
				case ISNUMBER:
					return new Datum(triceps,datum.isNumeric());
				case FILEEXISTS:
				{
					String fext = datum.stringVal();
					if (fext == null)
						return new Datum(triceps,false);
					fext = fext.trim();
					if (fext.length() == 0)
						return new Datum(triceps,false);;
						
					/* now check whether this name is available in both working and completed dirs */
					File file;
					Schedule sched = triceps.getSchedule();
					String fname;
					
					try {
						fname = sched.getReserved(Schedule.WORKING_DIR) + fext;
Logger.writeln("exists(" + fname + ")");					
						file = new File(fname);
						if (file.exists())
							return new Datum(triceps,true);;
					}
					catch (SecurityException e) {
						return Datum.getInstance(triceps,Datum.INVALID);	
					}
					try {
						fname = sched.getReserved(Schedule.COMPLETED_DIR) + fext;
Logger.writeln("exists(" + fname + ")");					
						file = new File(fname);
						if (file.exists())
							return new Datum(triceps,true);
					}
					catch (SecurityException e) {
						return Datum.getInstance(triceps,Datum.INVALID);	
					}					
					return new Datum(triceps,false);
				}
			}
		}
		catch (Throwable t) { 
			Logger.printStackTrace(t);
		}
		setError("unexpected error running function " + name, line, column, null);
		return Datum.getInstance(triceps,Datum.INVALID);
	}
	
	private void setError(String s, int line, int column, int val) { setError(s,line,column,new Integer(val)); }
	private void setError(String s, int val) { setError(s,new Integer(val)); }

	private void setError(String s, int line, int column, Object val) { 
		String msg = null;
		if (val != null) {
			msg = s + ": " + triceps.get("got") + ((val instanceof Datum) ? ((Datum) val).stringVal() : val.toString());
		}
		else {
			msg = s;
		}
		errorLogger.print(msg,line,column); 
		Logger.writeln(msg);
	}
	private void setError(String s, Object val) { 
		String msg = null;
		if (val != null) {
			msg = s + ": " + triceps.get("got") + ((val instanceof Datum) ? ((Datum) val).stringVal() : val.toString());
		}
		else {
			msg = s;
		}
		errorLogger.println(msg); 
		Logger.writeln(msg);
	}
	public boolean hasErrors() { return (errorLogger.size() > 0); }
	public String getErrors() { return errorLogger.toString(); }
	
	private String functionError(int funcNum, int datumType, int index) {
		return FUNCTION_ARRAY[funcNum][FUNCTION_NAME] + " " + 
			triceps.get("expects") + " " + 
			Datum.getTypeName(triceps,datumType) + " " + 
			triceps.get("at_index") + " " +
			index;
	}
}
