import java.lang.*;
import java.util.*;
import java.text.*;

/** This class provides the basic logic and mathematical functions for relating objects of type datum. */
public class DatumMath {
	private static final SimpleDateFormat month2num = new SimpleDateFormat("M");

	/** This method returns the sum of two Datum objects of type double. */
	static Datum add(Datum a, Datum b) {
		switch (a.type()) {
			default:
				return new Datum(a.doubleVal() + b.doubleVal());
			case Datum.MONTH: 
				try {
					int val = Integer.parseInt(month2num.format(a.dateVal()));
					val += (int) b.doubleVal();
					Date d = month2num.parse("" + val);
					return new Datum(Datum.month.format(d),Datum.MONTH);
				}
				catch (java.text.ParseException e) {
					System.out.println(e);
					return new Datum(Datum.INVALID);
				}
		}
	}
	static Datum and(Datum a, Datum b) {
		return new Datum(a.longVal() & b.longVal());
	}
	static Datum andand(Datum a, Datum b) {
		return new Datum(a.booleanVal() && b.booleanVal());
	}
	/** This method concatenates two Datum objects of type String and returns the resulting Datum object. */
	static Datum concat(Datum a, Datum b) {
		try {
			return new Datum(a.StringVal().concat(b.StringVal()),Datum.STRING);
		}
		catch(NullPointerException e) {
			return new Datum(a.StringVal(),Datum.STRING);
		}
	}
	/**
	 * This method evaluates the boolean value of the first Datum object, returns the second Datum object if true,
	 * returns the third Datum object if false.
	 */
	static Datum conditional(Datum a, Datum b, Datum c) {
		if (a.booleanVal())
			return b;
		else
			return c;
	}
	/** This method returns the division of two Datum objects of type double. */
	static Datum divide(Datum a, Datum b) {
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
		try {
			if ((a.StringVal().compareTo(b.StringVal()) == 0) || (a.doubleVal() == b.doubleVal()))
				return new Datum(true);
			else
				return new Datum(false);
		}
		catch(NullPointerException e) {}
		return new Datum(false);
	}
	/**
	 * This method returns a Datum of type boolean upon comparing two Datum objects of type String or double for
	 * greater than or equal.
	 */
	static Datum ge(Datum a, Datum b) {
		try {
			if ((a.StringVal().compareTo(b.StringVal()) >= 0) || (a.doubleVal() >= b.doubleVal()))
				return new Datum(true);
			else
				return new Datum(false);
		}
		catch(NullPointerException e) {}
		return new Datum(false);
	}
	/**
	 * This method returns a Datum of type boolean upon comparing two Datum objects of type String or double for greater than.
	 */
	static Datum gt(Datum a, Datum b) {
		try {
			if ((a.StringVal().compareTo(b.StringVal()) > 0) || (a.doubleVal() > b.doubleVal()))
				return new Datum(true);
			else
				return new Datum(false);
		}
		catch(NullPointerException e) {}
		return new Datum(false);
	}
	/**
	 * This method returns a Datum of type boolean upon comparing two Datum objects of type String or double for
	 * less than or equal.
	 */
	static Datum le(Datum a, Datum b) {
		try {
			if ((a.StringVal().compareTo(b.StringVal()) <= 0) || (a.doubleVal() <= b.doubleVal()))
				return new Datum(true);
			else
				return new Datum(false);
		}
		catch(NullPointerException e) {}
		return new Datum(false);
	}
	/** This method returns a Datum of type boolean upon comparing two Datum objects of type String or double for less than. */
	static Datum lt(Datum a, Datum b) {
		try {
			if ((a.StringVal().compareTo(b.StringVal()) < 0) || (a.doubleVal() < b.doubleVal()))
				return new Datum(true);
			else
				return new Datum(false);
		}
		catch(NullPointerException e) {}
		return new Datum(false);
	}
	/** This method returns a Datum object of type double that is the modulus of two Datum objects of type double. */
	static Datum modulus(Datum a, Datum b) {
		try {
			return new Datum(a.doubleVal() % b.doubleVal());
		}
		catch(ArithmeticException e) {
			return new Datum(Datum.INVALID);
		}
	}
	/** This method returns the product of two Datum objects of type double. */
	static Datum multiply(Datum a, Datum b) {
		return new Datum(a.doubleVal() * b.doubleVal());
	}
	/** This method returns a Datum object of type double that is the negative of the passed Datum object. */
	static Datum neg(Datum a) {
		return new Datum(-a.doubleVal());
	}
	/**
	 * This method returns a Datum of type boolean, value true, if two Datum objects of type String or double are not equal
	 * or value false if equal.
	 */
	static Datum neq(Datum a, Datum b) {
		try {
			if ((a.StringVal().compareTo(b.StringVal()) != 0) || (a.doubleVal() != b.doubleVal()))
				return new Datum(true);
			else
				return new Datum(false);
		}
		catch(NullPointerException e) {}
		return new Datum(false);
	}
	/** This method returns a Datum object of the opposite value of the Datum object passed. */
	static Datum not(Datum a) {
		return new Datum(!a.booleanVal());
	}
	/** This method returns a Datum of type boolean, value true, if either of two Datum objects of type long are true. */
	static Datum or(Datum a, Datum b) {
		return new Datum(a.longVal() | b.longVal());
	}
	static Datum oror(Datum a, Datum b) {
		return new Datum(a.booleanVal() || b.booleanVal());
	}
	/** This method returns the difference between two Datum objects of type double. */
	static Datum subtract(Datum a, Datum b) {
		switch (a.type()) {
			default:
				return new Datum(a.doubleVal() - b.doubleVal());
			case Datum.MONTH: 
				try {
					int val = Integer.parseInt(month2num.format(a.dateVal()));
					val -= (int) b.doubleVal();
					Date d = month2num.parse("" + val);
					return new Datum(Datum.month.format(d),Datum.MONTH);
				}
				catch (java.text.ParseException e) {
					System.out.println(e);
					return new Datum(Datum.INVALID);
				}
		}
	}
	static Datum xor(Datum a, Datum b) {
		return new Datum(a.longVal() ^ b.longVal());
	}
}
