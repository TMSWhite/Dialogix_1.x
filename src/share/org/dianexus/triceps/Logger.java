import java.util.*;
import java.io.*;

/* Inner class for logging - this is needed to support localization of error messages */
public class Logger {
	public static final Logger NULL = new Logger(null,null,true);
	
	private static PrintWriter STDERR = null;
	private static final String STDERR_NAME = "Triceps.log.err";
	
	static {
		try {
			STDERR = new PrintWriter(new FileWriter(STDERR_NAME));
		}
		catch (IOException e) {
			System.err.println("unable to create '" + STDERR_NAME + "'");
		}
	}

	public static final String DOS_EOL = "\n\r";
	public static final String MAC_EOL = "\r";
	public static final String UNIX_EOL = "\n";
	public static final String HTML_EOL = "<br>";

	private Writer out = null;
	private String eol = HTML_EOL;
	private int callCount = 0;
	private int errCount = 0;
	private boolean alsoLogToStderr = false;
	private StringBuffer sb = null;		// backup copy of everything sent to Logger
	private boolean discard = false;


	public Logger() { this(null,HTML_EOL,false); }
	public Logger(String eol) { this(null,eol,false); }
	public Logger(Writer out) { this(out,HTML_EOL,false); }
	public Logger(Writer out, String eol) { this(out,eol,false); }

	public Logger(Writer w, String eol, boolean discard) {
		this.discard = discard;
		out = w;
		this.eol = ((eol == null) ? HTML_EOL : eol);
		reset();
	}

	public void setAlsoLogToStderr(boolean ok) { alsoLogToStderr = ok; }
	public boolean isAlsoLogToStderr() { return alsoLogToStderr; }

	public String getEol() { return eol; }
	public void setEol(String eol) { this.eol = ((eol == null) ? HTML_EOL : eol); }
	public Writer getWriter() { return out; }
	public void setWriter(Writer w) { out = w; }

	public void print(String s) { write(s,0,0,false); }
	public void print(String s, int line, int column) { write(s,line,column,false); }
	public void println(String s) { write(s,0,0,true); }
	public void println(String s, int line, int column) { write(s,line,column,true); }

	private void write(String s, int line, int column, boolean addEol) {
		if (discard)
			return;
		try {
			++callCount;
			if (addEol) {
				++errCount;
			}
			
			String msg =
					((addEol && line != 0) ? ("[" + line + "," + column + "] " + errCount + ") ") : "") +
					((s != null) ? s : "") +
					((addEol) ? eol : "");

			if (out != null) {
				out.write(msg);
				out.flush();
			}
			if (sb != null) {
				sb.append(msg);
			}
			if (alsoLogToStderr) {
				writeln(msg);
			}
		}
		catch (IOException e) {
			writeln(e.getMessage());
		}
	}
	
	public static void writeln(String s) { Logger.write(s,true); }
	public static void write(String s) { Logger.write(s,false); }
	
	public static void write(String s, boolean eol) {
		if (STDERR != null) {
			STDERR.write(s);
			if (eol)
				STDERR.write(DOS_EOL);
			STDERR.flush();
		}
		else {
			System.err.print(s);
			if (eol)
				System.err.print(DOS_EOL);
			System.err.flush();
		}
	}
	
	public static void printStackTrace(Throwable t) {
		if (STDERR != null) {
			t.printStackTrace(STDERR);
			STDERR.flush();
		}
		else {
			t.printStackTrace(System.err);
			System.err.flush();
		}
	}

	public int size() { return callCount; }

	public void reset() {
		callCount = 0;
		errCount = 0;
		if (!discard) {
			sb = new StringBuffer();	// otherwise, this is the NULL Logger, which discards all messages
		}
	}
	
	public String toString() { return toString(true); }

	public String toString(boolean erase) {
		String temp = "";

		if (sb != null) {
			temp = sb.toString();
		}
		if (erase) {
			reset();
		}
		return temp;
	}

	public void flush() {
		try {
			if (out != null)
				out.flush();
		}
		catch (IOException e) {
			writeln(e.getMessage());
		}
	}

	public void close() {
		try {
			if (out != null)
				out.close();
		}
		catch (IOException e) {
			writeln(e.getMessage());
		}
	}
}
