import java.util.*;
import java.lang.*;
import java.io.*;
import java.text.*;

public class Datum implements Serializable {
	public static final int UNKNOWN = 0;		// haven't asked
	public static final int DOUBLE = 1;
	public static final int STRING = 2;
	public static final int UNCERTAIN = 3; 	// can ask, but answer not known
	public static final int REFUSED = 4;	// can ask, but can't get answer
	public static final int NA = 5;			// don't need to ask - not applicable
	public static final int INVALID = 6;		// if an exception occurs - so propagated
	public static final int DATE = 7;
	public static final int MONTH = 8;
	
	public static final SimpleDateFormat mdy = new SimpleDateFormat("MM/dd/yyyy");
	public static final SimpleDateFormat month = new SimpleDateFormat("MMMM");
	
	private String sVal;
	private double dVal;
	private boolean bVal;
	private int type = UNKNOWN;
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
		switch (i) {
			case UNCERTAIN:
			case REFUSED:
			case NA:
				type = i;
				sVal = "Not applicable.";
				bVal = false;
				dVal = Double.NaN;
				break;
			case INVALID:
				type = i;
				sVal = "";
				bVal = false;
				dVal = Double.NaN;
				break;
			default:
				error = "Invalid Datum - expected one of INVALID, UNCERTAIN, REFUSED, NA";
				type = INVALID;
				sVal = "";
				bVal = false;
				dVal = Double.NaN;
				break;
		}
		date = null;
		timestamp = new Date(System.currentTimeMillis());
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
		sVal = val.StringVal();
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
	public String StringVal() { return sVal; }
	public boolean booleanVal() { return bVal; }
	public double doubleVal() { return dVal; }
	public Date dateVal() { return date; }
	public String monthVal() { if (date == null) return ""; return month.format(date); }
	public long longVal() { return (long)dVal; }
	public int type() { return type; }
	public Date getTimeStamp() { return timestamp; }
	public boolean isInvalid() { return (type == INVALID); }
	
	public String getError() {
		if (error == null)
			return "";
		
		String temp = error;
		error = null;
		return temp;
	}
		
}
