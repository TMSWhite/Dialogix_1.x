import java.lang.*;
import java.util.*;
import java.text.Format;

/** This class provides the basic logic and mathematical functions for relating objects of type datum. */
public class DatumMath {
	private static final Format MONTH_AS_NUM_MASK = Datum.getDefaultMask(Datum.MONTH_NUM);
	private static GregorianCalendar calendar = new GregorianCalendar();
	
	static Datum hasError(Datum a, Datum b) {
		if (a.isType(Datum.INVALID) || (b != null && b.isType(Datum.INVALID))) {
			return new Datum(Datum.INVALID);
		}
		if (a.isType(Datum.REFUSED) || (b != null && b.isType(Datum.REFUSED))) {
			return new Datum(Datum.REFUSED);
		}
		if (a.isType(Datum.NA) || (b != null && b.isType(Datum.NA))) {
			/* throw an error message here? */
			return new Datum(Datum.INVALID);
		}
		return null;	// to indicate that there is no error that needs propagating
	}
	
	static int datumToCalendar(int datumType) {
		switch (datumType) {
			case Datum.YEAR: return Calendar.YEAR;
			case Datum.MONTH: return Calendar.MONTH;
			case Datum.DAY: return Calendar.DAY_OF_MONTH;
			case Datum.WEEKDAY: return Calendar.DAY_OF_WEEK;
			case Datum.HOUR: return Calendar.HOUR_OF_DAY;
			case Datum.MINUTE: return Calendar.MINUTE;
			case Datum.SECOND: return Calendar.SECOND;
			case Datum.MONTH_NUM: return Calendar.MONTH;
			default: return 0;	// should never get here
		}

	}
	
	static int getCalendarField(Datum d, int datumType) {
		int field = DatumMath.datumToCalendar(datumType);
		int value;
		
		synchronized (calendar) {
			calendar.setTime(d.dateVal());
			value = calendar.get(field);
		}
		return value;
	}

	/** This method returns the sum of two Datum objects of type double. */
	static Datum add(Datum a, Datum b) {
		Datum d = DatumMath.hasError(a,b);
		if (d != null)
			return d;
			
		switch (a.type()) {
			default:
				return new Datum(a.doubleVal() + b.doubleVal());
			case Datum.MONTH:
				int val = Integer.parseInt(Datum.format(a.dateVal(),Datum.DATE,MONTH_AS_NUM_MASK));
				val += (int) b.doubleVal();
				Date newMonth = (new Datum("" + val, Datum.MONTH, MONTH_AS_NUM_MASK)).dateVal();
				return (new Datum(newMonth, Datum.MONTH));
		}
	}
	static Datum and(Datum a, Datum b) {
		Datum d = DatumMath.hasError(a,b);
		if (d != null)
			return d;
					
		return new Datum(a.longVal() & b.longVal());
	}
	static Datum andand(Datum a, Datum b) {
		Datum d = DatumMath.hasError(a,b);
		if (d != null)
			return d;
					
		return new Datum(a.booleanVal() && b.booleanVal());
	}
	/** This method concatenates two Datum objects of type String and returns the resulting Datum object. */
	static Datum concat(Datum a, Datum b) {
		Datum d = DatumMath.hasError(a,b);
		if (d != null)
			return d;
					
		try {
			return new Datum(a.stringVal().concat(b.stringVal()),Datum.STRING);
		}
		catch(NullPointerException e) {
			return new Datum(a.stringVal(),Datum.STRING);
		}
	}
	/**
	 * This method evaluates the boolean value of the first Datum object, returns the second Datum object if true,
	 * returns the third Datum object if false.
	 */
	static Datum conditional(Datum a, Datum b, Datum c) {
		Datum d = DatumMath.hasError(a,null);	// if conditional based upon a REFUSED or INVALID, always return that type
		if (d != null)
			return d;
					
		if (a.booleanVal())
			return b;
		else
			return c;
	}
	/** This method returns the division of two Datum objects of type double. */
	static Datum divide(Datum a, Datum b) {
		Datum d = DatumMath.hasError(a,b);
		if (d != null)
			return d;
					
		try {
			return new Datum(a.doubleVal() / b.doubleVal());
		}
		catch(ArithmeticException e) {
			return new Datum(Datum.INVALID);
		}
	}
	/**
	 * This method returns a Datum of type boolean, value true, if two Datum objects of type String or double are equal
	 * or value false if not equal.
	 */
	static Datum eq(Datum a, Datum b) {
		Datum d = DatumMath.hasError(a,b);
		if (d != null)
			return d;
					
		try {
			switch (a.type()) {
				case Datum.DATE:
				case Datum.TIME:
					return new Datum(
						(a.dateVal().equals(b.dateVal()))
						);				
				case Datum.WEEKDAY: 
				case Datum.MONTH:
				case Datum.YEAR:
				case Datum.DAY:
				case Datum.HOUR:
				case Datum.MINUTE:
				case Datum.SECOND:
				case Datum.MONTH_NUM:
					return new Datum(DatumMath.getCalendarField(a,a.type()) == DatumMath.getCalendarField(b,a.type()));
				case Datum.STRING:
					return new Datum(a.stringVal().compareTo(b.stringVal()) == 0);
				case Datum.NUMBER:
					return new Datum(a.doubleVal() == b.doubleVal());
				default:
					return new Datum(false);
			}			
		}
		catch(NullPointerException e) {}
		return new Datum(false);
	}
	/**
	 * This method returns a Datum of type boolean upon comparing two Datum objects of type String or double for
	 * greater than or equal.
	 */
	static Datum ge(Datum a, Datum b) {
		Datum d = DatumMath.hasError(a,b);
		if (d != null)
			return d;
					
		try {
			switch (a.type()) {
				case Datum.DATE:
				case Datum.TIME:
					return new Datum(
						(a.dateVal().after(b.dateVal())) ||
						(a.dateVal().equals(b.dateVal()))
						);				
				case Datum.WEEKDAY: 
				case Datum.MONTH:
				case Datum.YEAR:
				case Datum.DAY:
				case Datum.HOUR:
				case Datum.MINUTE:
				case Datum.SECOND: 
				case Datum.MONTH_NUM:
					return new Datum(DatumMath.getCalendarField(a,a.type()) >= DatumMath.getCalendarField(b,a.type()));
				case Datum.STRING:
					return new Datum(a.stringVal().compareTo(b.stringVal()) >= 0);
				case Datum.NUMBER:
					return new Datum(a.doubleVal() >= b.doubleVal());
				default:
					return new Datum(false);
			}
		}
		catch(NullPointerException e) {}
		return new Datum(false);
	}
	/**
	 * This method returns a Datum of type boolean upon comparing two Datum objects of type String or double for greater than.
	 */
	static Datum gt(Datum a, Datum b) {
		Datum d = DatumMath.hasError(a,b);
		if (d != null)
			return d;
					
		try {
			switch (a.type()) {
				case Datum.DATE:
				case Datum.TIME:
					return new Datum(
						(a.dateVal().after(b.dateVal()))
						);				
				case Datum.WEEKDAY: 
				case Datum.MONTH:
				case Datum.YEAR:
				case Datum.DAY:
				case Datum.HOUR:
				case Datum.MINUTE:
				case Datum.SECOND: 
				case Datum.MONTH_NUM:
					return new Datum(DatumMath.getCalendarField(a,a.type()) > DatumMath.getCalendarField(b,a.type()));
				case Datum.STRING:
					return new Datum(a.stringVal().compareTo(b.stringVal()) > 0);
				case Datum.NUMBER:
					return new Datum(a.doubleVal() > b.doubleVal());
				default:
					return new Datum(false);
			}
		}
		catch(NullPointerException e) {}
		return new Datum(false);
	}
	/**
	 * This method returns a Datum of type boolean upon comparing two Datum objects of type String or double for
	 * less than or equal.
	 */
	static Datum le(Datum a, Datum b) {
		Datum d = DatumMath.hasError(a,b);
		if (d != null)
			return d;
					
		try {
			switch (a.type()) {
				case Datum.DATE:
				case Datum.TIME:
					return new Datum(
						(a.dateVal().before(b.dateVal())) ||
						(a.dateVal().equals(b.dateVal()))
						);				
				case Datum.WEEKDAY: 
				case Datum.MONTH:
				case Datum.YEAR:
				case Datum.DAY:
				case Datum.HOUR:
				case Datum.MINUTE:
				case Datum.SECOND: 
				case Datum.MONTH_NUM:
					return new Datum(DatumMath.getCalendarField(a,a.type()) <= DatumMath.getCalendarField(b,a.type()));
				case Datum.STRING:
					return new Datum(a.stringVal().compareTo(b.stringVal()) <= 0);
				case Datum.NUMBER:
					return new Datum(a.doubleVal() <= b.doubleVal());
				default:
					return new Datum(false);
			}
		}
		catch(NullPointerException e) {}
		return new Datum(false);
	}
	/** This method returns a Datum of type boolean upon comparing two Datum objects of type String or double for less than. */
	static Datum lt(Datum a, Datum b) {
		Datum d = DatumMath.hasError(a,b);
		if (d != null)
			return d;
					
		try {
			switch (a.type()) {
				case Datum.DATE:
				case Datum.TIME:
					return new Datum(
						(a.dateVal().before(b.dateVal()))
						);				
				case Datum.WEEKDAY: 
				case Datum.MONTH:
				case Datum.YEAR:
				case Datum.DAY:
				case Datum.HOUR:
				case Datum.MINUTE:
				case Datum.SECOND: 
				case Datum.MONTH_NUM:
					return new Datum(DatumMath.getCalendarField(a,a.type()) < DatumMath.getCalendarField(b,a.type()));
				case Datum.STRING:
					return new Datum(a.stringVal().compareTo(b.stringVal()) < 0);
				case Datum.NUMBER:
					return new Datum(a.doubleVal() < b.doubleVal());
				default:
					return new Datum(false);
			}
		}
		catch(NullPointerException e) {}
		return new Datum(false);
	}
	/** This method returns a Datum object of type double that is the modulus of two Datum objects of type double. */
	static Datum modulus(Datum a, Datum b) {
		Datum d = DatumMath.hasError(a,b);
		if (d != null)
			return d;
					
		try {
			return new Datum(a.doubleVal() % b.doubleVal());
		}
		catch(ArithmeticException e) {
			return new Datum(Datum.INVALID);
		}
	}
	/** This method returns the product of two Datum objects of type double. */
	static Datum multiply(Datum a, Datum b) {
		Datum d = DatumMath.hasError(a,b);
		if (d != null)
			return d;
					
		return new Datum(a.doubleVal() * b.doubleVal());
	}
	/** This method returns a Datum object of type double that is the negative of the passed Datum object. */
	static Datum neg(Datum a) {
		Datum d = DatumMath.hasError(a,null);
		if (d != null)
			return d;
					
		return new Datum(-a.doubleVal());
	}
	/**
	 * This method returns a Datum of type boolean, value true, if two Datum objects of type String or double are not equal
	 * or value false if equal.
	 */
	static Datum neq(Datum a, Datum b) {
		Datum d = DatumMath.hasError(a,b);
		if (d != null)
			return d;
					
		try {
			switch (a.type()) {
				case Datum.DATE:
				case Datum.TIME:
					return new Datum(!
						(a.dateVal().equals(b.dateVal()))
						);				
				case Datum.WEEKDAY: 
				case Datum.MONTH:
				case Datum.YEAR:
				case Datum.DAY:
				case Datum.HOUR:
				case Datum.MINUTE:
				case Datum.SECOND: 
				case Datum.MONTH_NUM:
					return new Datum(DatumMath.getCalendarField(a,a.type()) != DatumMath.getCalendarField(b,a.type()));
				case Datum.STRING:
					return new Datum(a.stringVal().compareTo(b.stringVal()) != 0);
				case Datum.NUMBER:
					return new Datum(a.doubleVal() != b.doubleVal());
				default:
					return new Datum(false);
			}			
		}
		catch(NullPointerException e) {}
		return new Datum(false);
	}
	/** This method returns a Datum object of the opposite value of the Datum object passed. */
	static Datum not(Datum a) {
		Datum d = DatumMath.hasError(a,null);
		if (d != null)
			return d;
					
		return new Datum(!a.booleanVal());
	}
	/** This method returns a Datum of type boolean, value true, if either of two Datum objects of type long are true. */
	static Datum or(Datum a, Datum b) {
		Datum d = DatumMath.hasError(a,b);
		if (d != null)
			return d;
					
		return new Datum(a.longVal() | b.longVal());
	}
	static Datum oror(Datum a, Datum b) {
		Datum d = DatumMath.hasError(a,b);
		if (d != null)
			return d;
					
		return new Datum(a.booleanVal() || b.booleanVal());
	}
	/** This method returns the difference between two Datum objects of type double. */
	static Datum subtract(Datum a, Datum b) {
		Datum d = DatumMath.hasError(a,b);
		if (d != null)
			return d;
					
		switch (a.type()) {
			default:
				return new Datum(a.doubleVal() - b.doubleVal());
			case Datum.MONTH:
				int val = Integer.parseInt(Datum.format(a.dateVal(),Datum.DATE,MONTH_AS_NUM_MASK));
				val -= (int) b.doubleVal();
				Date newMonth = (new Datum("" + val, Datum.MONTH, MONTH_AS_NUM_MASK)).dateVal();
				return (new Datum(newMonth, Datum.MONTH));
		}
	}
	static Datum xor(Datum a, Datum b) {
		Datum d = DatumMath.hasError(a,b);
		if (d != null)
			return d;
					
		return new Datum(a.longVal() ^ b.longVal());
	}
}
