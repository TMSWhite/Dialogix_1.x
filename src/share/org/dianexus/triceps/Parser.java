import java.io.*;
import java.lang.*;

/* Wrapper to support re-entrancy for Qss - needs to take a pipe as input */
public class Parser {
    private PipedWriter pipeOut;
    private PipedReader pipeIn;
    private PrintWriter writer;
    private Qss qss;
    
	public Parser() {
		pipeIn = new PipedReader();
   		pipeOut = new PipedWriter();
   		writer = new PrintWriter(pipeOut);
     	
     	try {
     		pipeIn.connect(pipeOut);
     	} catch(IOException e) {
     		System.out.println("Unable to connect to PipedWriter");
     	}
     	qss = new Qss(pipeIn);
	}
	
	public boolean booleanVal(Evidence ev, String exp) {
		return parse(ev, exp).booleanVal();
	}
	
	public String StringVal(Evidence ev, String exp) {
		return parse(ev, exp).StringVal();
	}
	
	public double doubleVal(Evidence ev, String exp) {
		return parse(ev, exp).doubleVal();
	}
	
	public long longVal(Evidence ev, String exp) {
		return parse(ev, exp).longVal();
	}
	
	public Datum parse(Evidence ev, String exp) {
		qss.ReInit(pipeIn);
		writer.print(exp + "\n");
		writer.flush();
		
		return qss.parse(ev);
	}
	
	public String parseJSP(Evidence ev, String msg) {
		java.util.StringTokenizer st = new java.util.StringTokenizer(msg,"`",true);
		StringBuffer sb = new StringBuffer();
		String s;
		boolean inside = false;
		
		while(st.hasMoreTokens()) {
			s = st.nextToken();
			if ("`".equals(s)) {
				inside = (inside) ? false : true;
				continue;
			}
			else {
				if (inside) {
					sb.append(StringVal(ev,s));
				}
				else {
					sb.append(s);
				}
			}
		}
		return sb.toString();
	}
}
