import java.util.*;
import java.lang.*;
import java.io.*;
import java.text.*;

public class Datum implements Serializable {
	public static final int UNKNOWN = 0;		// haven't asked
	public static final int NA = 1;				// don't need to ask - not applicable
	public static final int INVALID = 2;		// if an exception occurs - so propagated	
	public static final int DOUBLE = 3;
	public static final int STRING = 4;
	public static final int DATE = 5;
	public static final int MONTH = 6;
	public static final String TYPES[] = { "*UNKNOWN*", "*NOT APPLICABLE*", "*INVALID*", "DOUBLE", "STRING", "DATE", "MONTH" };
	
	public static final SimpleDateFormat mdy = new SimpleDateFormat("MM/dd/yyyy");
	public static final SimpleDateFormat month = new SimpleDateFormat("MMMM");
	
	private int type = UNKNOWN;
	private String sVal = TYPES[type];
	private double dVal = Double.NaN;
	private boolean bVal = false;
	private Date timestamp = null;
	private Date date = null;
	private String error = null;

	public Datum(double d) {
		type = DOUBLE;
		dVal = d;
		bVal = (Double.isNaN(d) || (d == 0)) ? false : true;
		sVal = (bVal) ? Double.toString(d) : "";
		timestamp = new Date(System.currentTimeMillis());
	}
	public Datum(int i) {
		type = i;
		sVal = null;
		bVal = false;
		dVal = Double.NaN;
		date = null;
		timestamp = new Date(System.currentTimeMillis());
		
		switch (i) {
			case NA:
			case UNKNOWN:
				break;
			default:
				error = "Invalid Datum - expected one of INVALID, UNKNOWN or NA";
				/* fall through */			
			case INVALID:
				type = INVALID;
				break;
		}
	}
	public Datum(long l) {
		type = DOUBLE;
		dVal = (double)l;
		bVal = (l == 0) ? false : true;
		sVal = Long.toString(l);
		timestamp = new Date(System.currentTimeMillis());
	}
	public Datum(Datum val) {
		dVal = val.doubleVal();
		bVal = val.booleanVal();
		sVal = val.stringVal();
		date = val.date;
		type = val.type();
		timestamp = new Date(System.currentTimeMillis());
	}
	public Datum(String s, int t) {
		sVal = s;
		dVal = Double.NaN;
		date = null;
		type = INVALID;	// default is to indicate failure to create new Datum object
		
		switch (t) {
			case DOUBLE:
				try {
					dVal = Double.valueOf(s).doubleValue();
					type = DOUBLE;
				}
				catch(NumberFormatException e) {
					error = "Invalid number " + s + ": " + e;
					dVal = Double.NaN;
				}
				break;
			case STRING:
				type = STRING;
				break;
			case DATE:
				try {
					date = mdy.parse(s);
					sVal = mdy.format(date);
					type = DATE;
				}
				catch (java.text.ParseException e) {
					error = "Invalid date " + s + ": " + e;
					date = null;
				}
				break;
			case MONTH:
				try {
					date = month.parse(s);
					sVal = month.format(date);
					type = MONTH;
				}
				catch (java.text.ParseException e) {
					error = "Invalid month " + s + ": " + e;
					date = null;
				}			
				break;
			default:
				error = "Unexpected data format: " + type;
				break;
		}
		bVal = ((s == null) || (dVal == 0)) ? false : true;
		timestamp = new Date(System.currentTimeMillis());
	}
	
	public Datum(boolean b) {
		type = DOUBLE;
		dVal = (b ? 1 : 0);
		bVal = b;
		sVal = (b ? "1" : "0");
		timestamp = new Date(System.currentTimeMillis());
	}
	public String stringVal() { if (exists()) return sVal; else return TYPES[type]; }
	public boolean booleanVal() { return bVal; }
	public double doubleVal() { return dVal; }
	public Date dateVal() { return date; }
	public String monthVal() { if (date == null) return ""; return month.format(date); }
	public long longVal() { return (long)dVal; }
	public int type() { return type; }
	public Date getTimeStamp() { return timestamp; }
	public boolean isInvalid() { return (type == INVALID); }
	public boolean isUnknown() { return (type == UNKNOWN); }
	public boolean isNA() { return (type == NA); }
	public boolean exists() { return !(isInvalid() || isUnknown() || isNA()); }
	
	
	public String getError() {
		if (error == null)
			return "";
		
		String temp = error;
		error = null;
		return temp;
	}
		
}
