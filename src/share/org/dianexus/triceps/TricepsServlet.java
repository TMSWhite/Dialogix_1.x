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
	private String firstFocus = null;

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
		doPost(req,res);
	}

	/**
	 * This method is invoked when the servlet is requested with POST variables.  This is
	 * the case after the first request, handled by doGet(), and all further requests.
	 */
	public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		this.req = req;
		this.res = res;
		HttpSession session = req.getSession(true);
		String form = null;

		triceps = (Triceps) session.getValue("triceps");

		res.setContentType("text/html");

		/* This is the meat. */
		try {
			form = processDirective(req.getParameter("directive"));
		}
		catch (Exception e) {
			System.out.println(e.getMessage());
			e.printStackTrace();
		}

		out = res.getWriter();
		out.println(header());
		if (form != null) {
			out.println("<FORM method='POST' name='myForm' action='" + HttpUtils.getRequestURL(req) + "'>\n");
			out.println(form);
			out.println("</FORM>\n");
		}
		out.println(footer());

		/* Store appropriate stuff in the session */
		if (triceps != null)
			session.putValue("triceps", triceps);
	}

	private String header() {
		StringBuffer sb = new StringBuffer();

		sb.append("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 3.2//EN\">\n");
		sb.append("<html>\n");
		sb.append("<body bgcolor='white' onload='javascript:document.myForm.mrn.focus()'>\n");
		sb.append("<head>\n");
		sb.append("<META HTTP-EQUIV='Content-Type' CONTENT='text/html;CHARSET=iso-8859-1'>\n");
		sb.append("<title>TRICEPS SYSTEM</title>\n");
		sb.append("</head>\n");
		sb.append("<body>\n");

		return sb.toString();
	}


	private String footer() {
		StringBuffer sb = new StringBuffer();

		sb.append("</body>\n");
		sb.append("</html>\n");
		return sb.toString();
	}

	/**
	 * This method basically gets the next node in the schedule, checks the activation
	 * dependencies to see if it should be executed, then, if it's a question it
	 * invokes queryUser(), otherwise, it evaluates the evidence and moves to
	 * the next node.
	 */
	private String processDirective(String directive) {
		boolean ok = true;
		StringBuffer sb = new StringBuffer();

		// get the POSTed directive (start, back, forward, help, suspend, etc.)	- default is opening screen
		if (directive == null || "select new interview".equals(directive)) {
			sb.append("<H2>Triceps Interview/Questionnaire System</H2><HR>\n");
			sb.append("<TABLE CELLPADDING='2' CELLSPACING='2' BORDER='1'>\n");
			sb.append("<TR><TD>Please select an interview/questionnaire from the pull-down list:  </TD>\n");
			sb.append("	<TD><select name='schedule'>\n");
			sb.append("		<option value='ADHD.txt' selected>ADHD\n");
			sb.append("		<option value='EatDis.txt'>Eating Disorders\n");
			sb.append("		<option value='MiHeart.txt'>MiHeart-combo\n");
			sb.append("		<option value='MiHeart2.txt'>MiHeart-radio\n");
//			sb.append("		<option value='GAFTree.txt'>GAFTree\n");
			sb.append("		<option value='MoodDis.txt'>Major Depression/Dysthymic Disorder\n");
			sb.append("		<option value='AUDIT.txt'>AUDIT Alcohol Abuse Test\n");
			sb.append("		<option value='HAM-D.txt'>Hamilton Rating Scale for Depression\n");
			sb.append("	</select></TD>\n");
			sb.append("	<TD><input type='SUBMIT' name='directive' value='START'></TD>\n");
			sb.append("</TR>\n");
			sb.append("<TR><TD>OR, restore an interview/questionnaire in progress:  </TD>\n");
			sb.append("	<TD><input type='text' name='RESTORE'></TD>\n");
			sb.append("	<TD><input type='SUBMIT' name='directive' value='RESTORE'></TD>\n");
			sb.append("</TR><TR><TD>&nbsp;</TD><TD COLSPAN='2' ALIGN='center'><input type='checkbox' name='DEBUG' value='1'>Show debugging information</input></TD></TR>\n");
			sb.append("</TABLE>\n");
			return sb.toString();
		}
		else if (directive.equals("START")) {
			// load schedule
			triceps = new Triceps();
			ok = triceps.setSchedule("http://" + req.getServerName() + "/" + req.getParameter("schedule"));
			if (!ok) {
				ok = triceps.setSchedule(new File("c:/cvs/triceps/docs/" + req.getParameter("schedule")));
			}

			if (!ok) {
				try {
					this.doGet(req,res);
				}
				catch (ServletException e) {
				}
				catch (IOException e) {
				}
				return sb.toString();
			}

			ok = ok && triceps.gotoFirst();

			// ask question
		}
/*
		else if (directive.equals("restore-from-object")) {
			String restore = req.getParameter("restore-from-object");
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
				return sb.toString();
			}
			else {
				triceps = temp;
				sb.append("<B>Successfully restored interview from " + restore + "</B><HR>\n");
				// check for errors (should probably throw them)
				// ask question
			}
		}
*/
		else if (directive.equals("RESTORE")) {
			String restore = req.getParameter("RESTORE");
			restore = restore + "." + req.getRemoteUser() + "." + req.getRemoteHost() + ".tsv";

			// load schedule
			triceps = new Triceps();
			ok = triceps.setSchedule("http://" + req.getServerName() + "/" + restore);
			if (!ok) {
				ok = triceps.setSchedule(new File(restore));
			}

			if (!ok) {
				processDirective(null);	// select new interview
				return sb.toString();
			}

			ok = ok && triceps.gotoFirst();

			// ask question
		}

		else if (directive.equals("jump to:")) {
			ok = triceps.gotoNode(req.getParameter("jump to:"));
			// ask this question
		}
		else if (directive.equals("clear all and re-start")) { // restart from scratch
			ok = triceps.resetEvidence();
			ok = ok && triceps.gotoFirst();
			// ask first question
		}
		else if (directive.equals("reload questions")) { // debugging option
			ok = triceps.reloadSchedule();
			if (ok) {
				sb.append("<B>Schedule restored successfully</B><HR>\n");
			}
			// re-ask current question
		}
		/*
		else if (directive.equals("suspend-as-object-to")) {
			String name = req.getParameter("suspend-as-object-to");
			String file = name + "." + req.getRemoteUser() + "." + req.getRemoteHost() + ".suspend";
			ok = triceps.save(file);
			if (ok) {
				sb.append("<B>Interview saved successfully as " + name + " (" + file + ")</B><HR>\n");
			}
			// re-ask same question
		}
		*/
		else if (directive.equals("save to:")) {
			String name = req.getParameter("save to:");
			String file = name + "." + req.getRemoteUser() + "." + req.getRemoteHost() + ".tsv";

			ok = triceps.toTSV(file);
			if (ok) {
				sb.append("<B>Interview saved successfully as " + Node.encodeHTML(name) + " (" + Node.encodeHTML(file) + ")</B><HR>\n");
			}
		}
		else if (directive.equals("evaluate expr:")) {
			String expr = req.getParameter("evaluate expr:");
			if (expr != null) {
				Datum datum = triceps.parser.parse(triceps.evidence, expr);

				sb.append("<TABLE WIDTH='100%' CELLPADDING='2' CELLSPACING='1' BORDER=1>\n");
				sb.append("<TR><TD>Equation</TD><TD><B>" + Node.encodeHTML(expr) + "</B></TD><TD>Type</TD><TD><B>" + Datum.TYPES[datum.type()] + "</B></TD></TR>\n");
				sb.append("<TR><TD>String</TD><TD><B>" + Node.encodeHTML(datum.stringVal()) + "</B></TD><TD>boolean</TD><TD><B>" + datum.booleanVal() + "</B></TD></TR>\n");
				sb.append("<TR><TD>double</TD><TD><B>" + datum.doubleVal() + "</B></TD><TD>long</TD><TD><B>" + datum.longVal() + "</B></TD></TR>\n");
				sb.append("<TR><TD>date</TD><TD><B>" + datum.dateVal() + "</B></TD><TD>month</TD><TD><B>" + datum.monthVal() + "</B></TD></TR>\n");
				sb.append("</TABLE>\n");
			}
		}
/*
		else if (directive.equals("help")) {	// FIXME
			sb.append("<B>No help currently available</B><HR>\n");
			// re-ask same question
		}
*/
/*
		else if (directive.equals("show evidence as XML (unordered, duplicated)")) {
			sb.append("<B>Use 'Show Source' to see data in Evidence as XML</B><BR>\n");
			sb.append("<!--\n" + triceps.evidenceToXML() + "\n-->\n");
			sb.append("<HR>\n");
			// re-ask same question
		}
*/
		else if (directive.equals("show XML")) {
			sb.append("<B>Use 'Show Source' to see data in Schedule as XML</B><BR>\n");
			sb.append("<!--\n" + triceps.toXML() + "\n-->\n");
			sb.append("<HR>\n");
		}
		else if (directive.equals("forward")) {
			// store current answer(s)
			Enumeration questionNames = triceps.getQuestions();

			while(questionNames.hasMoreElements()) {
				Node q = (Node) questionNames.nextElement();
				boolean status;

				status = triceps.storeValue(q, req.getParameter(q.getName()));
				ok = status && ok;

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
				while (errs.hasMoreElements()) {
					sb.append("<B>" + (String) errs.nextElement() + "</B><BR>\n");
				}
			}

			Enumeration nodes = triceps.getQuestions();
			while (nodes.hasMoreElements()) {
				Node n = (Node) nodes.nextElement();
				if (n.hasError()) {
					sb.append("<B>Please answer the question(s) listed in <FONT color='red'>RED</FONT> before proceeding</B><BR>\n");
					firstFocus = Node.encodeHTML(n.getName());
					break;
				}
			}

			sb.append("<HR>\n");
		}

		if (firstFocus == null) {
			Enumeration nodes = triceps.getQuestions();
			if (nodes.hasMoreElements()) {
				Node n = (Node) nodes.nextElement();
				firstFocus = Node.encodeHTML(n.getName());
			}
		}

		sb.append(queryUser());
		return sb.toString();
	}

	/**
	 * This method assembles the displayed question and answer options
	 * and formats them in HTML for return to the client browser.
	 */
	private String queryUser() {
		// if parser internal to Schedule, should have method access it, not directly
		StringBuffer sb = new StringBuffer();

		boolean debug = false;
		if ("1".equals(req.getParameter("DEBUG"))) {
			debug = true;
			sb.append("<input type='HIDDEN' name='DEBUG' value='1'>\n");
		}

		sb.append("<H4>QUESTION AREA</H4>\n");

		Enumeration questionNames = triceps.getQuestions();
		String color;
		String errMsg;

		sb.append("<TABLE CELLPADDING='2' CELLSPACING='1' WIDTH='100%' border='1'>\n");
		for(int count=0;questionNames.hasMoreElements();++count) {
			Node node = (Node) questionNames.nextElement();
			Datum datum = triceps.getDatum(node);

			if (node.hasError()) {
				color = " color='red'";
				errMsg = "<FONT color='red'>" + node.getError() + "</FONT>";
			}
			else {
				color = "";
				errMsg = "";
			}

			sb.append("	<TR>\n");
			sb.append("		<TD><FONT" + color + "><B>" + Node.encodeHTML(node.getQuestionRef()) + "</FONT></B></TD>\n");
			sb.append("		<TD><FONT" + color + ">" + Node.encodeHTML(triceps.getQuestionStr(node)) + "</FONT></TD>\n");
			sb.append("		<TD>" + node.prepareChoicesAsHTML(datum) + errMsg + "</TD>\n");
			sb.append("	</TR>\n");
		}
		sb.append("	<TR><TD COLSPAN='3' ALIGN='center'>\n");
		sb.append("<input type='SUBMIT' name='directive' value='forward'>\n");
		sb.append("<input type='SUBMIT' name='directive' value='backward'>");
		sb.append("<input type='SUBMIT' name='directive' value='clear all and re-start'>\n");
		sb.append("<input type='SUBMIT' name='directive' value='select new interview'>\n");
		sb.append("	</TD></TR>\n");

		if (debug) {
			sb.append("	<TR><TD COLSPAN='3' ALIGN='center'>\n");
			sb.append("<input type='SUBMIT' name='directive' value='jump to:'>\n");
			sb.append("<input type='text' name='jump to:'>\n");
			sb.append("<input type='SUBMIT' name='directive' value='save to:'>\n");
			sb.append("<input type='text' name='save to:'>\n");
			sb.append("	</TD></TR>\n");
			sb.append("	<TR><TD COLSPAN='3' ALIGN='center'>\n");
			sb.append("<input type='SUBMIT' name='directive' value='reload questions'>\n");
			sb.append("<input type='SUBMIT' name='directive' value='show XML'>\n");
			sb.append("<input type='SUBMIT' name='directive' value='evaluate expr:'>\n");
			sb.append("<input type='text' name='evaluate expr:'>\n");
			sb.append("	</TD></TR>\n");
		}

		sb.append("</TABLE>\n");

/*
		// Node info area
		sb.append("<hr>\n");

		questionNames = triceps.getQuestions();

		for(int count=0;questionNames.hasMoreElements();++count) {
			Node node = (Node) questionNames.nextElement();

			sb.append("<H4>NODE INFORMATION AREA</H4>" + node.toString() + "\n");
		}
*/
		// Complete printout of what's been collected per node

		if (debug) {
			sb.append("<hr>\n");
			sb.append("<H4>CURRENT QUESTION(s)</H4>\n");
			sb.append("<TABLE CELLPADDING='2' CELLSPACING='1'  WIDTH='100%' BORDER='1'>\n");
			questionNames = triceps.getQuestions();

			while(questionNames.hasMoreElements()) {
				Node n = (Node) questionNames.nextElement();
				sb.append("<TR>" +
					"<TD>" + Node.encodeHTML(n.getQuestionRef()) + "</TD>" +
					"<TD><B>" + Node.encodeHTML(triceps.toString(n)) + "</B></TD>" +
					"<TD>" + Datum.TYPES[n.getDatumType()] + "</TD>" +
					"<TD>" + Node.encodeHTML(n.getName()) + "</TD>" +
					"<TD>" + Node.encodeHTML(n.getConcept()) + "</TD>" +
					"<TD>" + Node.encodeHTML(n.getDependencies()) + "</TD>" +
					"<TD>" + Node.encodeHTML(n.getAction()) + "</TD>" +
					"</TR>\n");
			}
			sb.append("</TABLE>\n");


			sb.append("<hr>\n");
			sb.append("<H4>EVIDENCE AREA</H4>\n");
			sb.append("<TABLE CELLPADDING='2' CELLSPACING='1'  WIDTH='100%' BORDER='1'>\n");
			for (int i = triceps.size()-1; i >= 0; i--) {
				Node n = triceps.getNode(i);
				if (!triceps.isSet(n))
					continue;
				sb.append("<TR>" +
					"<TD>" + (i + 1) + "</TD>" +
					"<TD>" + Node.encodeHTML(n.getQuestionRef()) + "</TD>" +
					"<TD><B>" + Node.encodeHTML(triceps.toString(n)) + "</B></TD>" +
					"<TD>" + Datum.TYPES[n.getDatumType()] + "</TD>" +
					"<TD>" + Node.encodeHTML(n.getName()) + "</TD>" +
					"<TD>" + Node.encodeHTML(n.getConcept()) + "</TD>" +
					"<TD>" + Node.encodeHTML(n.getDependencies()) + "</TD>" +
					"<TD>" + Node.encodeHTML(n.getAction()) + "</TD>" +
					"</TR>\n");
			}
			sb.append("</TABLE>\n");
		}
		return sb.toString();
	}
}
