import java.util.*;
import java.lang.*;
import java.io.*;
import java.text.*;

public class Datum  {
	public static final int UNASKED = 0;		// haven't asked
	public static final int NA = 1;				// don't need to ask - not applicable
	public static final int REFUSED = 2;		// question asked, but subject refuses to answer
	public static final int INVALID = 3;		// if an exception occurs - so propagated
	public static final int UNKNOWN = 4;		// subject indicates that they don't know the answer
	public static final int NOT_UNDERSTOOD = 5;
	public static final int NUMBER = 6;
	public static final int STRING = 7;
	public static final int DATE = 8;
	public static final int TIME = 9;
	public static final int YEAR = 10;
	public static final int MONTH = 11;
	public static final int DAY = 12;
	public static final int WEEKDAY = 13;
	public static final int HOUR = 14;
	public static final int MINUTE = 15;
	public static final int SECOND = 16;
	public static final int MONTH_NUM = 17;
	private static final Date SAMPLE_DATE = new Date(System.currentTimeMillis());
	private static final Double SAMPLE_NUMBER = new Double(123.456);
	public static final String TYPES[] = { "*UNASKED*", "*NOT APPLICABLE*", "*REFUSED*", "*INVALID*", "*UNKNOWN*", "*NOT UNDERSTOOD*",
		"Number", "String", "Date", "Time", "Year", "Month", "Day", "Weekday", "Hour", "Minute", "Second", "Month_Num" };
	private static Datum NA_DATUM = null;
	private static Datum UNKNOWN_DATUM = null;
	private static Datum REFUSED_DATUM = null;
	private static Datum INVALID_DATUM = null;
	private static Datum UNASKED_DATUM = null;
	private static Datum NOT_UNDERSTOOD_DATUM = null;
		
	private static final SimpleDateFormat defaultDateFormat = new SimpleDateFormat("MM/dd/yyyy");
	private static final SimpleDateFormat defaultMonthFormat = new SimpleDateFormat("MMMM");
	private static final SimpleDateFormat defaultTimeFormat = new SimpleDateFormat("HH:mm:ss");
	private static final SimpleDateFormat defaultYearFormat = new SimpleDateFormat("yyyy");
	private static final SimpleDateFormat defaultDayFormat = new SimpleDateFormat("d");
	private static final SimpleDateFormat defaultWeekdayFormat = new SimpleDateFormat("E");
	private static final SimpleDateFormat defaultHourFormat = new SimpleDateFormat("H");
	private static final SimpleDateFormat defaultMinuteFormat = new SimpleDateFormat("m");
	private static final SimpleDateFormat defaultSecondFormat = new SimpleDateFormat("s");
	private static final DecimalFormat defaultNumberFormat = new DecimalFormat();
	
	public static final SimpleDateFormat defaultMonthNumFormat = new SimpleDateFormat("M");
	public static final SimpleDateFormat TIME_MASK = new SimpleDateFormat("yyyy.MM.dd..HH.mm.ss");
	
	private static final Date epoch = new Date(0);
	private GregorianCalendar calendar = new GregorianCalendar();
	
	/* XXX:  SimpleDateFormat.parse() buggy for WEEKDAY.  Default date is Thu 1/1/1970.  Add weekday to WEEKDAY_STR */
	private static final String WEEKDAY_STRS[] = { "sun", "mon", "tue", "wed", "thu", "fri", "sat" };
	private static final int CALENDAR_WEEKDAYS[] = { Calendar.SUNDAY, Calendar.MONDAY, Calendar.TUESDAY, Calendar.WEDNESDAY,
		Calendar.THURSDAY, Calendar.FRIDAY, Calendar.SATURDAY };

	private int type = UNASKED;
	private String sVal = TYPES[type];
	private double dVal = Double.NaN;
	private boolean bVal = false;
	private Date date = null;
	private Format mask = null;
	private String error = null;

	public Datum(double d) {
		type = NUMBER;
		dVal = d;
		bVal = (Double.isNaN(d) || (d == 0)) ? false : true;
		sVal = (bVal) ? Double.toString(d) : "";
	}
	
	public static Datum getInstance(int i) {
		switch(i) {
			case NA: 
				if (Datum.NA_DATUM == null) {
					Datum.NA_DATUM = new Datum(NA);
				}
				return Datum.NA_DATUM;
			case UNKNOWN: 
				if (Datum.UNKNOWN_DATUM == null) {
					Datum.UNKNOWN_DATUM = new Datum(UNKNOWN);
				}
				return Datum.UNKNOWN_DATUM;
			case REFUSED: 
				if (Datum.REFUSED_DATUM == null) {
					Datum.REFUSED_DATUM = new Datum(REFUSED);
				}
				return Datum.REFUSED_DATUM;
			case UNASKED: 
				if (Datum.UNASKED_DATUM == null) {
					Datum.UNASKED_DATUM = new Datum(UNASKED);
				}
				return Datum.UNASKED_DATUM;			
			case NOT_UNDERSTOOD: 
				if (Datum.NOT_UNDERSTOOD_DATUM == null) {
					Datum.NOT_UNDERSTOOD_DATUM = new Datum(NOT_UNDERSTOOD);
				}
				return Datum.NOT_UNDERSTOOD_DATUM;						
			default:
			case INVALID: 
				if (Datum.INVALID_DATUM == null) {
					Datum.INVALID_DATUM = new Datum(INVALID);
				}
				return Datum.INVALID_DATUM;
		}
	}
	
	private Datum(int i) {
		type = i;
		sVal = null;
		bVal = false;
		dVal = Double.NaN;
		date = null;

		switch (i) {
			case NA:
			case UNKNOWN:
			case UNASKED:
			case NOT_UNDERSTOOD:
			case REFUSED:
				break;
			default:
			case INVALID:
				type = INVALID;
				break;
		}
	}
	public Datum(long l) {
		type = NUMBER;
		dVal = (double)l;
		bVal = (l == 0) ? false : true;
		sVal = Long.toString(l);
	}
	public Datum(Datum val) {
		dVal = val.doubleVal();
		bVal = val.booleanVal();
		sVal = val.stringVal();
		date = val.date;
		type = val.type();
		mask = val.getMask();
	}

	public Datum(Date d, int t) {
		this(d,t,Datum.getDefaultMask(t));
	}

	public Datum(Date d, int t, Format mask) {
		String s = Datum.format(d,t,mask);
		init(s,t,mask);
	}

	public Datum(String s, int t) {
		init(s,t,Datum.getDefaultMask(t));
	}

	public Datum(String s, int t, Format mask) {
		init(s,t,mask);
	}
/*
	public static Datum cast(Datum d, int t, Format mask) {
		int type = d.type();
		
		if (d.isType(DATE)) {
			switch (t) {
				case DATE:
				case TIME:
					return new Datum(d);
				case YEAR:
				case MONTH:
				case WEEKDAY:			
				case DAY:
				case HOUR:
				case MINUTE:
				case SECOND: 
				case MONTH_NUM: 
				{
					int val = DatumMath.getCalendarField(d,t);
					calendar.setTime(epoch);
					calendar.set(val,val);
					return new calendar.getTime();
				}
			}
		}
		else if (isType(NUMBER)) {
		}
		else if (d.isType(STRING)) {
		}
		else {
			// new data type is same as old?  INVALID, UNKNOWN, REFUSED, NA 
		}
				
		switch (t) {
			case DATE:
			case TIME:
			case YEAR:
			case MONTH:
			case WEEKDAY:			
			case DAY:
			case HOUR:
			case MINUTE:
			case SECOND:
			case MONTH_NUM:
				if (d.isType(Datum.DATE)) {
				}
				else if (d.isType(Datum.NUMBER)) {
				}
				else if (d.isType(Datum.STRING)) {
				}
				break;
			case NUMBER:
			case STRING:
			case INVALID:
			case UNKNOWN:
			case UNASKED:
			case NOT_UNDERSTOOD
			case REFUSED:
			case NA:
		}
	}
*/	

	private void init(String s, int t, Format mask) {
		dVal = Double.NaN;
		bVal = false;
		date = null;
		sVal = null;
		type = INVALID;	// default is to indicate failure to create new Datum object
		this.mask = mask;	// what happens when convert data types?

		if (s == null) {
			t = INVALID;
		}

		switch (t) {
			case NUMBER:
				try {
					if (mask != null && mask instanceof NumberFormat) {
						dVal = ((NumberFormat) mask).parse(s).doubleValue();
						sVal = Datum.format(new Double(dVal),t,mask);
						if (TYPES[INVALID].equals(sVal)) {
							type = INVALID;
						}
						else {
							type = NUMBER;	// only if successfully parsed
						}
					}
					else {
						type = INVALID;
					}
				}
				catch (java.text.ParseException e) {
					type = INVALID;
				}
				if (type == INVALID) {
					String ex = Datum.getExampleFormatStr(mask,t);
					if (ex.length() > 0)
						ex = " (e.g. " + ex + ")";
					error = "Please enter a " + TYPES[t] + ex;
					sVal = "";
					dVal = Double.NaN;
				}
				bVal = (Double.isNaN(dVal) || (dVal == 0)) ? false : true;
				break;
			case STRING:
				type = STRING;
				sVal = s;
				/* also check whether can be considered a number */
				try {
					dVal = Double.valueOf(s).doubleValue();
				}
				catch(NumberFormatException e) {
					dVal = Double.NaN;
				}
				bVal = (Double.isNaN(dVal) || (dVal == 0)) ? false : true;
				if (Boolean.valueOf(s).booleanValue()) {
					bVal = true;	// accept the String word 'true' as booelan true
				}
				break;
			case WEEKDAY:	{ // XXX: need a hack for this, since SimpleDateFormat has bug in way parses Weekdays
				String day = s.trim().toLowerCase();
				int i=0;
				for (i=0;i<WEEKDAY_STRS.length;++i) {
					if (day.startsWith(WEEKDAY_STRS[i])) {
						calendar.setTime(epoch);
						
						calendar.set(Calendar.DAY_OF_WEEK, CALENDAR_WEEKDAYS[i]);
								
						date = calendar.getTime();
						type = WEEKDAY;
						break;
					}
				}
				if (i == WEEKDAY_STRS.length) {
					type = INVALID;
				}
			}
			/** Fall through **/
			case MONTH:
			case DATE:
			case TIME:
			case YEAR:
			case DAY:
			case HOUR:
			case MINUTE:
			case SECOND:
			case MONTH_NUM:
				try {
					if (t != WEEKDAY) {
						if (mask != null && mask instanceof DateFormat) {
							date = ((DateFormat) mask).parse(s);
						}
						else {
							type = INVALID;
						}
					}

					sVal = Datum.format(date, t, mask);
					if (TYPES[INVALID].equals(sVal)) {
						type = INVALID;
					}
					else {
						type = t;	// only if successfully parsed
					}
				}
				catch (java.text.ParseException e) {
					type = INVALID;
				}
				if (type == INVALID) {
					String ex = Datum.getExampleFormatStr(mask,t);
					if (ex.length() > 0)
						ex = " (e.g. " + ex + ")";
					error = "Please enter a " + TYPES[t] + ex;
					date = null;
				}
				break;
			case REFUSED:
				type = REFUSED;
				/* allow subject to skip over this question */
				break;
			case INVALID:
				type = INVALID;
				error = "Please answer this question";
				break;
			case NA:
				type = NA;
				/* this means can skip over the question */
				break;
			default:
				type = INVALID;
				error = "Internal error: Unexpected data format: " + type;
				break;
		}
	}

	public Datum(boolean b) {
		type = NUMBER;
		dVal = (b ? 1 : 0);
		bVal = b;
		sVal = (b ? "1" : "0");
	}

	public String stringVal() {
		return stringVal(false);
	}

	public String stringVal(boolean showReserved) {
		if (isType(Datum.STRING)) {
			return sVal;
		}
		else {
			if (showReserved)
				return TYPES[type];
			else
				return "";
		}
	}

	public boolean booleanVal() { return bVal; }
	public double doubleVal() { return dVal; }
	public Date dateVal() { return date; }
	public String monthVal() { if (date == null) return ""; return Datum.format(date,Datum.MONTH); }
	public String timeVal() { if (date == null) return ""; return Datum.format(date,Datum.TIME); }
	public long longVal() { return (long)dVal; }
	public int type() { return type; }
	public Format getMask() { return mask; }
	public void setMask(Format mask) { this.mask = mask; }

	public boolean isValid() {
		return (isType(type) && type != INVALID);
	}

	public boolean exists() {
		/* not only must it be valid, but STRING vals must be non-null */
		return (type != UNASKED && isValid() && ((type == STRING) ? !sVal.equals("") : true));
	}

	public boolean isType(int t) {
		switch(t) {
			case TIME:
			case MONTH:
			case DATE:
			case YEAR:
			case DAY:
			case WEEKDAY:
			case HOUR:
			case MINUTE:
			case SECOND:
			case MONTH_NUM:
				return (date != null);
			case NUMBER:
				return (dVal != Double.NaN);
			case STRING:
				return (sVal != null);
			case INVALID:
				return (type == INVALID);
			case NA:
				return (type == NA);
			case UNKNOWN:
				return (type == UNKNOWN);
			case REFUSED:
				return (type == REFUSED);
			case UNASKED:
				return (type == UNASKED);
			case NOT_UNDERSTOOD:
				return (type == NOT_UNDERSTOOD);
			default:
				return false;
		}
	}

	public String getError() {
		if (error == null)
			return "";

		String temp = error;
		error = null;
		return temp;
	}

	static public Format buildMask(String maskStr, int t) {
		if (maskStr == null || maskStr.trim().equals(""))
			return getDefaultMask(t);

		switch (t) {
			case TIME:
			case MONTH:
			case DATE:
			case YEAR:
			case DAY:
			case WEEKDAY:
			case HOUR:
			case MINUTE:
			case SECOND:
			case MONTH_NUM:
				try {
					return new SimpleDateFormat(maskStr);
				}
				catch (IllegalArgumentException e) {
					return null;
				}
			default:
			case NUMBER:
				try {
					return new DecimalFormat(maskStr);
				}
				catch (IllegalArgumentException e) {
					return null;
				}
			case INVALID:
			case STRING:
			case NA:
			case UNKNOWN:
			case UNASKED:
			case NOT_UNDERSTOOD:
			case REFUSED:
				break;
		}
		return null;
	}

	static public Format getDefaultMask(int t) {
		switch (t) {
			case MONTH:
				return defaultMonthFormat;
			case DATE:
				return defaultDateFormat;
			case TIME:
				return defaultTimeFormat;
			case NUMBER:
				return defaultNumberFormat;
			case YEAR:
				return defaultYearFormat;
			case DAY:
				return defaultDayFormat;
			case WEEKDAY:
				return defaultWeekdayFormat;
			case HOUR:
				return defaultHourFormat;
			case MINUTE:
				return defaultMinuteFormat;
			case SECOND:
				return defaultSecondFormat;
			case MONTH_NUM:
				return defaultMonthNumFormat;
			default:
			case INVALID:
			case NA:
			case UNKNOWN:
			case UNASKED:
			case NOT_UNDERSTOOD:
			case STRING:
			case REFUSED:
				break;
		}
		return null;
	}

	static public String format(Datum d, Format mask) {
		if (mask == null)
			return d.stringVal();

		String s;

		switch (d.type()) {
			case MONTH:
			case DATE:
			case TIME:
			case YEAR:
			case DAY:
			case WEEKDAY:
			case HOUR:
			case MINUTE:
			case SECOND:
			case MONTH_NUM:
				try {
					s = mask.format(d.dateVal());
					if (s == null)
						return TYPES[INVALID];
					else
						return s;
				}
				catch (IllegalArgumentException e) {
					return TYPES[INVALID];
				}
			case NUMBER:
				try {
					s = mask.format(new Double(d.doubleVal()));
					if (s == null)
						return TYPES[INVALID];
					else
						return s;
				}
				catch (IllegalArgumentException e) {
					return TYPES[INVALID];
				}
			default:
			case INVALID:
			case NA:
			case REFUSED:
			case UNKNOWN:
			case NOT_UNDERSTOOD:
				return TYPES[d.type()];
			case UNASKED:
				return "";	// empty string to indicate that has not been assessed yet.
			case STRING:
				return d.stringVal();
		}
	}

	static public String format(Object o, int t) {
		return Datum.format(o,t,Datum.getDefaultMask(t));
	}

	static public String format (Object o, int t, String maskStr) {
		return Datum.format(o,t,Datum.buildMask(maskStr,t));
	}

	static public String format(Object o, int t, Format mask) {
		switch (t) {
			case MONTH:
			case DATE:
			case TIME:
			case NUMBER:
			case YEAR:
			case DAY:
			case WEEKDAY:
			case HOUR:
			case MINUTE:
			case SECOND:
			case MONTH_NUM:
				if (mask == null)
					return o.toString();

				String s;
				try {
					s = mask.format(o);
					if (s == null)
						return TYPES[INVALID];
					else
						return s;
				}
				catch (IllegalArgumentException e) {
					return TYPES[INVALID];
				}
			default:
			case INVALID:
			case NA:
			case REFUSED:
			case UNKNOWN:
			case NOT_UNDERSTOOD:
				return TYPES[t];
			case UNASKED:
				return "";	// empty string to indicate that has not been assessed yet.
			case STRING:
				return o.toString();
		}
	}

	static public String getExampleFormatStr(Format mask, int t) {
		if (mask == null)
			return "";

		switch (t) {
			case MONTH:
			case DATE:
			case TIME:
			case YEAR:
			case DAY:
			case WEEKDAY:
			case HOUR:
			case MINUTE:
			case SECOND:
			case MONTH_NUM:
				return format(SAMPLE_DATE, t, mask);
			case NUMBER:
				if (mask == defaultNumberFormat)
					return "";
				else
					return format(SAMPLE_NUMBER, t, mask);
			default:
			case INVALID:
			case NA:
			case UNKNOWN:
			case NOT_UNDERSTOOD:
			case UNASKED:
			case STRING:
			case REFUSED:
				return "";	// no formatting string to contrain input
		}
	}
}
