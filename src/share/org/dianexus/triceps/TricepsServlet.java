import java.util.*;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.net.*;

/**
 *	 This is the central engine that iterates through the nodes 
 *	in a schedule producing, e.g., an interview. It also organizes 
 *	the connection to the display. In the first version, this is 
 *	an http response as defined in the JSDK.
 */
public class TricepsServlet extends HttpServlet {
	private static final String SUSPENDED = "suspendedInterviews";
	private Triceps triceps;
	private HttpServletRequest req;
	private HttpServletResponse res;
	private PrintWriter out;

	/**
	 * This method runs only when the servlet is first loaded by the
	 * webserver.  It calls the loadSchedule method to input all the
	 * nodes into memory.  The Schedule is then available to all
	 * sessions that might be running.
	 */
	public void init(ServletConfig config) throws ServletException {
		super.init(config);
	}

	public void destroy() {
		super.destroy();
	}

	/**
	 * This method is invoked when an initial URL request is made to the servlet.
	 * It initializes a session and prepares a response to the client that will
	 * invoke the POST method on further requests.
	 */
	public void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		HttpSession session = req.getSession(true);
		res.setContentType("text/html");
		out = res.getWriter();
		
		out.println("<html>");
		out.println("<body bgcolor='white'>");
		out.println("<head>");
		out.println("<title>TRICEPS SYSTEM</title>");
		out.println("</head>");
		out.println("<body>");
		out.println("<H2>TRICEPS SYSTEM</H2>");
		out.println("<hr>Please provide the following information to proceed. <br>");
		out.println("<form method='POST' action='" + HttpUtils.getRequestURL(req) + "'>");
		out.println("<pre>");
		out.println("Start a new interview:		<select name='schedule'>");
		out.println("							  <option value='ADHD.txt' selected>ADHD");
		out.println("							  <option value='EatDis.txt'>Eating Disorders");
		out.println("                             <option value='fake.txt'>fake");
		out.println("							</select>");
		out.println("<BR><input type='SUBMIT' name='directive' value='START'>\n");
		out.println("<BR>OR<BR>");
		out.println("Restore an old interview:	");
		
		out.println("<input type='text' name='restoreFrom'>");
		// FIXME - query/iterate for list of stored schedules
/*
		out.println("<select name='restoreFrom'>");
		Cookie cookies[] = req.getCookies();
		
		boolean found = false;
		for (int i=0;i<cookies.length;++i) {
			System.out.println(cookies[i].getName() + "->" + cookies[i].getValue());
			if (cookies[i].getName().equalsIgnoreCase(SUSPENDED)) {
				out.println(cookies[i].getValue());	// adds the option list
				found = true;
				break;
			}
		}
		if (!found) {
			out.println("<option value=''>*none available*");
		}		
		out.println("							 </select>");
*/
		out.println("<BR><input type='SUBMIT' name='directive' value='RESTORE'>");
		out.println("</pre>");
		out.println("</body>");
		out.println("</html>");
	}

	/**
	 * This method is invoked when the servlet is requested with POST variables.  This is
	 * the case after the first request, handled by doGet(), and all further requests.
	 */
	public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		this.req = req;
		this.res = res;
		HttpSession session = req.getSession(true);
		
		triceps = (Triceps) session.getValue("triceps");

		res.setContentType("text/html");
		out = res.getWriter();
		out.println("<html>");
		out.println("<body bgcolor='white'>");
		out.println("<head>");
		out.println("<title>TRICEPS SYSTEM -- Diagnostic Interview Schedule for Children</title>");
		out.println("</head>");
		out.println("<body>");
		
		/* This is the meat. */
		try {
			processDirective(req.getParameter("directive"));
		}
		catch (Exception e) {
			System.out.println(e.getMessage());
			e.printStackTrace();
		}
		
		out.println("</body>");
		out.println("</html>");
		
		/* Store appropriate stuff in the session */
		if (triceps != null)
			session.putValue("triceps", triceps);
	}
	/**
	 * This method basically gets the next node in the schedule, checks the activation
	 * dependencies to see if it should be executed, then, if it's a question it
	 * invokes queryUser(), otherwise, it evaluates the evidence and moves to
	 * the next node.
	 */
	private void processDirective(String directive) {
		boolean ok = true;
		
		// get the POSTed directive (start, back, forward, help, suspend, etc.)
		if (directive == null) {
			out.println("Invalid directive");
			return;
		} 
		else if (directive.equals("START")) {
			// load schedule
			triceps = new Triceps();
			ok = triceps.setSchedule("http://" + req.getServerName() + "/" + req.getParameter("schedule"));
			if (!ok) {
				ok = triceps.setSchedule(new File("c:/cvs2/triceps/docs/" + req.getParameter("schedule")));
			}
			
			if (!ok) {
				try {
					this.doGet(req,res);
				}
				catch (ServletException e) {
				}
				catch (IOException e) {
				}
				return;
			}
				
			ok = ok && triceps.gotoFirst();

			// ask question
		} 
		else if (directive.equals("RESTORE")) {
			String restore = req.getParameter("restoreFrom");
			restore = restore + "." + req.getRemoteUser() + "." + req.getRemoteHost() + ".suspend";
			
			Triceps temp;
			if (restore == null || restore.trim().equals("") || ((temp = Triceps.restore(restore)) == null)) {
				try {
					this.doGet(req,res);
				}
				catch (ServletException e) {
				}
				catch (IOException e) {
				}
				return;				
			}
			else {
				triceps = temp;
				out.println("<B>Successfully restored interview from " + restore + "</B><HR>");
				// check for errors (should probably throw them)
				// ask question
			}
		} 
		else if (directive.equals("jump-to")) {	
			ok = triceps.gotoNode(req.getParameter("jump-to"));
			// ask this question
		}
		else if (directive.equals("clear evidence")) { // restart from scratch
			ok = triceps.resetEvidence();
			ok = ok && triceps.gotoFirst();
			// ask first question
		}
		else if (directive.equals("reload questions")) { // debugging option
			ok = triceps.reloadSchedule();
			if (ok) {
				out.println("<B>Schedule restored successfully</B><HR>");
			}
			// re-ask current question
		}
		else if (directive.equals("suspend-as")) {		// XXX gotta go -- be back later :-)
			String name = req.getParameter("suspend-as");
			String file = name + "." + req.getRemoteUser() + "." + req.getRemoteHost() + ".suspend";
			ok = triceps.save(file);
			if (ok) {
				out.println("<B>Interview saved successfully as " + name + " (" + file + ")</B><HR>");
				/*
				try {
					String restore = "<option value='" + file + "'>" + name + "\n";
					
					Cookie cookies[] = req.getCookies();
					
					boolean found = false;
					if (cookies == null) {
						res.addCookie(new Cookie(SUSPENDED,restore));
					}
					else {					
						for (int i=0;i<cookies.length;++i) {
							if (cookies[i].getName().equalsIgnoreCase(SUSPENDED)) {
								String previous = cookies[i].getValue();
								cookies[i].setMaxAge(0);	// deletes current cookie
								res.addCookie(new Cookie(SUSPENDED,previous + restore));
								found = true;
								break;
							}
						}
					}
					if (!found) {
						System.out.println("creating new cookie to store filenames");
						res.addCookie(new Cookie(SUSPENDED,restore));
					}
					out.println("Saved filenames to cookie<BR>");
				}
				catch (IllegalArgumentException e) {
					out.println("Unable to save list of filenames to cookie");
				}
				*/
			}
			// re-ask same question
		}
		else if (directive.equals("help")) {	// FIXME
			out.println("<B>No help currently available</B><HR>");
			// re-ask same question
		}
		else if (directive.equals("show evidence as XML (unordered, duplicated)")) {
			out.println("<B>Use 'Show Source' to see data in Evidence as XML</B><BR>");
			out.println("<!--\n" + triceps.evidenceToXML() + "\n-->");
			out.println("<HR>");
			// re-ask same question
		}
		else if (directive.equals("show schedule as XML (ordered)")) {
			out.println("<B>Use 'Show Source' to see data in Schedule as XML</B><BR>");
			out.println("<!--\n" + triceps.toXML() + "\n-->");
			out.println("<HR>");			
		}
		else if (directive.equals("forward")) {
			// store current answer(s)
			Enumeration questionNames = triceps.getQuestions();
			
			while(questionNames.hasMoreElements()) {
				Node q = (Node) questionNames.nextElement();
				
				ok = triceps.storeValue(q, req.getParameter(q.getName())) && ok;	// parse all possible errors
			}
			// goto next
			ok = ok && triceps.gotoNext();	// don't goto next if errors
			// ask question
		}
		else if (directive.equals("backward")) {
			// don't store current
			// goto previous
			ok = triceps.gotoPrevious();
			// ask question
		}
		if (!ok) {
			Enumeration errs = triceps.getErrors();
			if (errs.hasMoreElements()) {
//				out.println("ERROR(S):<BR>");
				while (errs.hasMoreElements()) {
					out.println("<B>" + (String) errs.nextElement() + "</B><BR>");
				}
			}
			out.println("<HR>");
		}
		queryUser();
	}

	/**
	 * This method assembles the displayed question and answer options
	 * and formats them in HTML for return to the client browser.
	 * XXX - parsing should not be done here - await re-write for better modularization
	 */
	private void queryUser() {
		// if parser internal to Schedule, should have method access it, not directly
		out.println("<form method='POST' action='" + HttpUtils.getRequestURL(req) + "'");
		out.println("<H4>QUESTION AREA</H4>");
		
		Enumeration questionNames = triceps.getQuestions();
			
		for(int count=0;questionNames.hasMoreElements();++count) {
			Node node = (Node) questionNames.nextElement();
			
			if (count == 0) {
				out.println("<B>Question " + node.getQuestionRef() + "</B>: " + triceps.getQuestionStr(node) + "<br>\n");
			}
			
			// display the answer options
			StringTokenizer ans;
			// separate display from servlet
			// IO parser
			// HTML formatting for a question or collection of questions
			Datum datum = triceps.getDatum(node);
			try {
				String defaultValue = "";
				try {
					defaultValue = datum.StringVal();
					if (null == defaultValue)
						defaultValue = "";
				}
				catch(Exception e) {}
				ans = new StringTokenizer(node.getAnswerOptions(), ";");
				String answerType = ans.nextToken();
				if (answerType.equals("radio")) {
					while (ans.hasMoreTokens()) { // for however many radio buttons there are
						String v = ans.nextToken();
						String msg = ans.nextToken();
						out.println("<input type='radio'" + "name='" + node.getName() + "' " + "value=" + v + (DatumMath.eq(datum,
							new Datum(v)).booleanVal() ? " CHECKED" : "") + ">" + msg + "<br>");
					}
				}
				if (answerType.equals("check")) {
					while (ans.hasMoreTokens()) { // for however many check boxes there are

						// Add the CHECKED attribute to indicate a default choice 

						String v = ans.nextToken();
						String msg = ans.nextToken();
						out.println("<input type='checkbox'" + "name='" + node.getName() + "' " + "value=" + v + (DatumMath.eq(datum,
							new Datum(v)).booleanVal() ? " CHECKED" : "") + ">" + msg + "<br>");
					}
				}
				if (answerType.equals("combo")) {
					out.println("<select name='" + node.getName() + "'>");
					while (ans.hasMoreTokens()) { // for however many check boxes there are

						// Add the CHECKED attribute to indicate a default choice 

						String v = ans.nextToken();
						String msg = ans.nextToken();
						out.println("<option value='" + v + "'" + (DatumMath.eq(datum,
							new Datum(v)).booleanVal() ? " SELECTED" : "") + ">" + msg + "</option>");
					}
					out.println("</select>");
				}
				if (answerType.equals("date")) {
					out.println("Date: <input type='text' name='" + node.getName() + "' value='" + defaultValue + "'>");
				}
				if (answerType.equals("age")) {
					out.println("Age: <input type='text' name='" + node.getName() + "' value='" + defaultValue + "'>");
				}
				if (answerType.equals("grade")) {
					out.println("Grade: <input type='text' name='" + node.getName() + "' value='" + defaultValue + "'>");
				}
				if (answerType.equals("text")) {
					out.println("Type your answer: <input type='text' name='" + node.getName() + "' value='" + defaultValue + "'>");
				}
			}
			catch(Exception e) {
				System.out.println("Error tokenizing answer options...." + e.getMessage());
			}
		}

		// Navigation buttons
		out.println("<hr>");
		out.println("<H4>NAVIGATION AREA</H4>");
		out.println("<input type='SUBMIT' name='directive' value='backward'>");
		out.println("<input type='SUBMIT' name='directive' value='forward'>");
		out.println("<input type='SUBMIT' name='directive' value='help'>");
		out.println("<input type='SUBMIT' name='directive' value='suspend-as'>");
		out.println("<input type='text' name='suspend-as'>");
		out.println("<BR>");
		// the following buttons are for debugging
		out.println("<input type='SUBMIT' name='directive' value='jump-to'>");
		out.println("<input type='text' name='jump-to'>");
		out.println("<input type='SUBMIT' name='directive' value='clear evidence'>");
		out.println("<input type='SUBMIT' name='directive' value='reload questions'>");
		out.println("<BR>");
		out.println("<input type='SUBMIT' name='directive' value='show evidence as XML (unordered, duplicated)'>");
		out.println("<input type='SUBMIT' name='directive' value='show schedule as XML (ordered)'>");		
		out.println("</form>");

		// Node info area
		out.println("<hr>");
		
		questionNames = triceps.getQuestions();
			
		for(int count=0;questionNames.hasMoreElements();++count) {
			Node node = (Node) questionNames.nextElement();
		
			out.println("<H4>NODE INFORMATION AREA</H4>" + node.toString());
		}

		// Complete printout of what's been collected per node
		out.println("<hr>");
		out.println("<H4>EVIDENCE AREA</H4>");
		out.println("<TABLE CELLPADDING='0' CELLSPACING='0' BORDER='1'>");
		for (int i = triceps.size()-1; i >= 0; i--) {
			Node n = triceps.getNode(i);
			if (triceps.toString(n) == "null")	// XXX 
				continue;
			out.println("<TR>" + 
				"<TD>" + (i + 1) + "</TD>" + 
				"<TD>" + n.getQuestionRef() + "</TD>" +
				"<TD><B>" + triceps.toString(n) + "</B></TD>" +
				"<TD>" + n.getName() + "</TD>" +
				"<TD>" + n.getConcept() + "</TD>" +
				"<TD>" + n.getDependencies() + "</TD>" +
				"<TD>" + n.getAction() + "</TD>" +
				"</TR>\n");
		}
		out.println("</TABLE>");
	}
}
