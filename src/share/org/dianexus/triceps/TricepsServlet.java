import java.util.*;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 *   This is the central engine that iterates through the nodes 
 *	in a schedule producing, e.g., an interview. It also organizes 
 *	the connection to the display. In the first version, this is 
 *	an http response as defined in the JSDK.
 */
public class TricepsServlet extends HttpServlet {
	private Qss parser = new Qss();
	private Schedule nodes;
	private String infoMessage = null;
	private int step;
	private Node node;
	private Evidence evidence;
	private boolean forward;
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
		loadSchedule();
	}

	public void destroy() {
		super.destroy();
	}

	/**
	 * This method is invoked when a simple URL request is made to the servlet.
	 * It initializes a session and prepares a response to the client that will
	 * invoke the POST method on further requests.
	 */
	public void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		doPost(req, res);

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
		out.println("<form method='POST' action='http://localhost/triceps/servlet/TricepsServlet'>");
		out.println("<pre>");
		out.println("The system currently supports one schedule.");
		out.println("Select a schedule:			<select name='schedule'>");
		out.println("									<option selected>navigation.txt");
//		out.println("									<option navigation2.txt");
		out.println("									</select>");
		out.println("Select an interview:		<select name='interview'>");
		out.println("									<option selected>new");
//		out.println("									<option> test-completed");
		out.println("									<option> test-suspended");
		out.println("									</select>");
		out.println("<hr>");
		out.println("<input type='SUBMIT' name='directive' value='START'>		<input type='RESET'>");
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

		node = (Node)session.getValue("currentNode");			// retrieve the node
		evidence = (Evidence)session.getValue("evidence");		// retrieve the evidence

		res.setContentType("text/html");
		out = res.getWriter();
		out.println("<html>");
		out.println("<body bgcolor='white'>");
		out.println("<head>");
		out.println("<title>TRICEPS SYSTEM -- Diagnostic Interview Schedule for Children</title>");
 		out.println("</head>");
		out.println("<body>");
		doit();
		out.println("</body>");
		out.println("</html>");
		if (node != null)
			session.putValue("currentNode", node);
		if (evidence != null)
			session.putValue("evidence", evidence);
	}
	/**
	 * This method basically gets the next node in the schedule, checks the activator
	 * dependencies to see if it should be executed, then, if it's a question it
	 * invokes queryUser(), otherwise, it evaluates the evidence and moves to
	 * the next node.
	 */
	private void doit() {
		try {
			String answer = null;	// reset to nothing each time
			infoMessage = null; 		// reset to nothing each time


			/* check what the user selected and handle it */

			// get the posted directive (back, forward, help, suspend)
			String directive = req.getParameter("directive");
			if (directive.equals("START")) {
				// very first question -- set everything up
				forward = true;
				directive = "forward"; // to avoid null pointer exception
				step = -1; // so that increments back to 0 - allows bypassing of first question, if necessary
				
				/* prepare the Evidence */
				if ("test-suspended".equals(req.getParameter("interview"))) {
					evidence = new Evidence("/tmp/test-suspended");
				}
				else if ("new".equals(req.getParameter("interview"))) {
					evidence = new Evidence(nodes.size());	//  initialize the Evidence object
				}
			}
			if (directive.equals("jump-to")) {
				answer = req.getParameter("jump-to");
				Node next = evidence.getNode(answer);
				if (next == null) {
					infoMessage = "Unable to jump to Node " + answer + ": not found";
					queryUser();
					return;
				}
				else {
					node = next;
					queryUser();
					return;
					//  forward = true; // fall through to skipping eval elements
				}
			}
			else if (directive.equals("clear evidence")) {
				evidence = new Evidence(nodes.size());
				step = -1;
				forward = true;
			}
			else if (directive.equals("reload questions")) {
				loadSchedule();
				queryUser();
				return;
			}
			else if (directive.equals("suspend")) {
				infoMessage = suspendInterview(evidence);
				queryUser();
				return;
			}
			else if (directive.equals("help")) {
				infoMessage = getHelp();
				queryUser();
				return;
			}
			else if (directive.equals("forward")) {
				forward = true;
			}
			else if (directive.equals("backward")) {
				forward = false;
			}
			if (forward) {
				if (node != null) {	// check to make sure the node exists
					try {
						answer = req.getParameter(node.getName());
						if (answer == null) {
							if ("check".equals(node.getAnswerType())) {
								answer = "0";
							}
						}
					}
					catch(NullPointerException e) {
						e.printStackTrace();
					}
				}
				if (answer == null && step >= 0) {
					infoMessage = "<bold>You cannot proceed without answering.</bold>";
				}
				else {	// got a proper answer -- handle it
					if (step >= 0 && node != null) {
						Datum d = new Datum(answer);
						evidence.set(node, d);
					}
					while (true) {
						if (++step >= nodes.size()) {
							infoMessage = "Interview Completed...";
							break;
						}
						if ((node = nodes.getNode(step)) == null)
							break;
						if (parser.booleanVal(evidence, node.getDependencies())) { // the node is active and requires action

							/* if meets the criteria to ask this question ... */

							if (node.getActionType().equals("q")) {	// then break down to queryUser()
								break;	
							}
							else if (node.getActionType().equals("e")) {	// evaluate the action string, set the evidence, and loop to next node
								evidence.set(node, new Datum(parser.StringVal(evidence, node.getAction())));
							}
						}
						else {	// the node is inactive and the datum value is "not applicable"

							/* store in evidence a not applicable Datum for this node*/
							evidence.set(node, new Datum(Datum.NA));
						}
					} // end while loop
				}	// end handling of proper answer
			}	// end forward directive

			else {
				/* backwards */

				// evidence.unset(node);
				while (true) {
					if (--step < 0) {
						infoMessage = "You can't back up any further";
						step = 0;
						break;
					}
					if ((node = nodes.getNode(step)) == null)
						break;
					//              evidence.unset(node);
					if (node.getActionType().equals("e")) {

						/* then can skip this going backwards */
						continue;
					}
					if (parser.booleanVal(evidence, node.getDependencies())) {

						/* if meets the criteria to ask this question ... */
						if (node.getActionType().equals("q")) {
							break;
						}
					}
				}
			}

			/* this is where the break above falls to */			
			queryUser();

		} catch(Exception e) { System.out.println(e.getMessage()); e.printStackTrace(); }
	}

	/**
	 * For diagnostics -- dumps the evidence to stdout and to the infoMessage variable for display
	 */
	private String getHelp() {
		System.out.println(evidence.toString());
		return node.toString();
	}

	/**
	 * This method loads all the nodes that comprise a Schedule. Currently,
	 * these are represented as tuples in a tab-delimited
	 * spreadsheet file called "navigation.txt".
	 */
	public void loadSchedule() {
		nodes = new Schedule("http://localhost/navigation.txt");
	}

	/**
	 * This method assembles the displayed question and answer options
	 * and formats them in HTML for return to the client browser.
	 */
	private void queryUser() {
		out.println("<form method='POST' action='http://localhost/triceps/servlet/TricepsServlet'>");
		out.println("<H4>QUESTION AREA</H4><BR>");
		out.println("<B>Question " + node.getQuestionRef() + "</B>: " + parser.parseJSP(evidence, node.getAction()) + "<br>");
		// display the answer options
		StringTokenizer ans;
		Datum datum = evidence.getDatum(node);
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

					/* Add the CHECKED attribute to indicate a default choice */

					String v = ans.nextToken();
					String msg = ans.nextToken();
					out.println("<input type='checkbox'" + "name='" + node.getName() + "' " + "value=" + v + (DatumMath.eq(datum,
						new Datum(v)).booleanVal() ? " CHECKED" : "") + ">" + msg + "<br>");
				}
			}
			if (answerType.equals("combo")) {
				out.println("<select name='" + node.getName() + "'>");
				while (ans.hasMoreTokens()) { // for however many check boxes there are

					/* Add the CHECKED attribute to indicate a default choice */

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
		if (infoMessage != null)
			out.println("<B>" + infoMessage + "</B><br>");

		// Navigation buttons
		out.println("<hr>");
		out.println("<H4>NAVIGATION AREA</H4><BR>");
		out.println("<input type='SUBMIT' name='directive' value='backward'>");
		out.println("<input type='SUBMIT' name='directive' value='forward'>");
		out.println("<input type='SUBMIT' name='directive' value='help'>");
		out.println("<input type='SUBMIT' name='directive' value='suspend'>");
		out.println("<BR>");
		out.println("<input type='SUBMIT' name='directive' value='jump-to'>");
		out.println("<input type='text' name='jump-to'>");
		out.println("<input type='SUBMIT' name='directive' value='clear evidence'>");
		out.println("<input type='SUBMIT' name='directive' value='reload questions'>");
		out.println("</form>");

		// Node info area
		out.println("<hr>");
		out.println("<H4>NODE INFORMATION AREA</H4><BR>" + node.toString());

		// Complete printout of what's been collected per node
		out.println("<hr>");
		out.println("<H4>EVIDENCE AREA</H4> <BR>");
		for (int i = 0; i < nodes.size(); i++) {
			Node n = nodes.getNode(i);
			if (evidence.toString(n) == "null")
				continue;
			out.println("" + (i + 1) + "(" + n.getName() + "): " + n.getConcept() + ": <B>" +
				evidence.toString(n) + "</B><BR>");
		}
	}

	/**
	 * This method assembles the evidence accumulated and stores it with
	 * a marker indicating it is an incomplete collection of data.
	 * To be implemented.....
	 */
	private String suspendInterview(Evidence ev) throws IOException {
		ev.saveSuspended();
		return "Suspending Interview....";
	}
}
