import java.lang.*;
import java.util.*;

public class DatumMath {
	static Datum add(Datum a, Datum b) {
		return new Datum(a.doubleVal() + b.doubleVal());
	}
	static Datum and(Datum a, Datum b) {
		return new Datum(a.longVal() & b.longVal());
	}
	static Datum andand(Datum a, Datum b) {
		return new Datum(a.booleanVal() && b.booleanVal());
	}
	static Datum concat(Datum a, Datum b) {
		try {
			return new Datum(a.StringVal().concat(b.StringVal()));
		}
		catch (NullPointerException e) {
			return new Datum(a.StringVal());
		}
	}
	static Datum conditional(Datum a, Datum b, Datum c) {
		if (a.booleanVal())
			return b;
		else
			return c;
	}
	static Datum divide(Datum a, Datum b) {
		try {
			return new Datum(a.doubleVal() / b.doubleVal());
		}
		catch (ArithmeticException e) {
			return new Datum(Datum.INVALID);
		}
	}
	static Datum eq(Datum a, Datum b) {
		try {
			if ((a.StringVal().compareTo(b.StringVal()) == 0) ||
					(a.doubleVal() == b.doubleVal()))	
				return new Datum(true);
			else
				return new Datum(false);
		}
		catch (NullPointerException e) {}
		return new Datum(false);
	}
	static Datum ge(Datum a, Datum b) {
		try {
			if ((a.StringVal().compareTo(b.StringVal()) >= 0) ||
					(a.doubleVal() >= b.doubleVal()))	
				return new Datum(true);
			else
				return new Datum(false);
		}
		catch (NullPointerException e) {}
		return new Datum(false);
	}
	static Datum gt(Datum a, Datum b) {
		try {
			if ((a.StringVal().compareTo(b.StringVal()) > 0) ||
					(a.doubleVal() > b.doubleVal()))	
				return new Datum(true);
			else
				return new Datum(false);
		}
		catch (NullPointerException e) {}
		return new Datum(false);
	}
	static Datum le(Datum a, Datum b) {
		try {
			if ((a.StringVal().compareTo(b.StringVal()) <= 0) ||
					(a.doubleVal() <= b.doubleVal()))	
				return new Datum(true);
			else
				return new Datum(false);
		}
		catch (NullPointerException e) {}
		return new Datum(false);
	}
	static Datum lt(Datum a, Datum b) {
		try {
			if ((a.StringVal().compareTo(b.StringVal()) < 0) ||
					(a.doubleVal() < b.doubleVal()))	
				return new Datum(true);
			else
				return new Datum(false);
		}
		catch (NullPointerException e) {}
		return new Datum(false);
	}
	static Datum modulus(Datum a, Datum b) {
		try {
			return new Datum(a.doubleVal() % b.doubleVal());
		}
		catch (ArithmeticException e) {
			return new Datum(Datum.INVALID);
		}
	}
	static Datum multiply(Datum a, Datum b) {
		return new Datum(a.doubleVal() * b.doubleVal());
	}
	static Datum neg(Datum a) {
		return new Datum(-a.doubleVal());
	}
	static Datum neq(Datum a, Datum b) {
		try {
			if ((a.StringVal().compareTo(b.StringVal()) != 0) ||
					(a.doubleVal() != b.doubleVal()))	
				return new Datum(true);
			else
				return new Datum(false);
		}
		catch (NullPointerException e) {}
		return new Datum(false);
	}
	static Datum not(Datum a) {
		return new Datum(!a.booleanVal());
	}
	static Datum or(Datum a, Datum b) {
		return new Datum(a.longVal() | b.longVal());
	}
	static Datum oror(Datum a, Datum b) {
		return new Datum(a.booleanVal() || b.booleanVal());
	}
	static Datum subtract(Datum a, Datum b) {
		return new Datum(a.doubleVal() - b.doubleVal());
	}
	static Datum xor(Datum a, Datum b) {
		return new Datum(a.longVal() ^ b.longVal());
	}
}
