import java.util.*;
import java.lang.*;

public class Datum {
	static final int UNKNOWN = 0;	// haven't asked
	static final int DOUBLE = 1;
	static final int STRING = 2;
	static final int UNCERTAIN = 3; 	// can ask, but answer not known
	static final int REFUSED = 4; 	// can ask, but can't get answer
	static final int NA = 5; 		// don't need to ask - not applicable
	static final int INVALID = 6;       // if an exception occurs - so propagated
	String sVal;
	double dVal;
	boolean bVal;
	int type = UNKNOWN;
	private Date date = null;

	public Datum(double d) {
		type = DOUBLE;
		dVal = d;
		bVal = (Double.isNaN(d) || (d == 0)) ? false : true;
		sVal = (bVal) ? Double.toString(d) : "";
		date = new Date(System.currentTimeMillis());
	}
	public Datum(int i) {
		switch (i) {
			case UNCERTAIN:
			case REFUSED:
			case NA:
			case INVALID:
				type = i;
				sVal = "";
				bVal = false;
				dVal = Double.NaN;
				break;
			default:
				System.out.println("Invalid Datum - expected one of INVALID, UNCERTAIN, REFUSED, NA");
				type = UNKNOWN;
				sVal = "";
				bVal = false;
				dVal = Double.NaN;
				break;
		}
		date = new Date(System.currentTimeMillis());
	}
	public Datum(long l) {
		type = DOUBLE;
		dVal = (double)l;
		bVal = (l == 0) ? false : true;
		sVal = Long.toString(l);
		date = new Date(System.currentTimeMillis());
	}
	public Datum(Datum val) {
		dVal = val.doubleVal();
		bVal = val.booleanVal();
		sVal = val.StringVal();
		type = val.type();
		date = new Date(System.currentTimeMillis());
	}
	public Datum(String s) {
		type = STRING;
		sVal = s;
		try {
			dVal = Double.valueOf(s).doubleValue();
		}
		catch(NumberFormatException e) {
			dVal = Double.NaN;
		}
		bVal = ((s == null) || (dVal == 0)) ? false : true;
		date = new Date(System.currentTimeMillis());
	}
	public Datum(boolean b) {
		type = DOUBLE;
		dVal = (b ? 1 : 0);
		bVal = b;
		sVal = (b ? "1" : "0");
		date = new Date(System.currentTimeMillis());
	}
	public String StringVal() { return sVal; }
	public boolean booleanVal() { return bVal; }
	public double doubleVal() { return dVal; }
	public Date getDate() { return date; }
	public long longVal() { return (long)dVal; }
	public int type() { return type; }
}
