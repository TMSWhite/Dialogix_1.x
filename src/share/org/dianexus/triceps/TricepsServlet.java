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
	public static String HELP_T_ICON = null;
	public static String HELP_F_ICON = null;
	public static String COMMENT_T_ICON = null;
	public static String COMMENT_F_ICON = null;
	public static String REFUSED_T_ICON = null;
	public static String REFUSED_F_ICON = null;
	public static String UNKNOWN_T_ICON = null;
	public static String UNKNOWN_F_ICON = null;
	public static String NOT_UNDERSTOOD_T_ICON = null;
	public static String NOT_UNDERSTOOD_F_ICON = null;

	private static int cycle = 0;

	private Triceps triceps;
	private HttpServletRequest req;
	private HttpServletResponse res;
	private PrintWriter out;
	private String firstFocus = null;

	private String scheduleList = "";
	private String scheduleSrcDir = "";
	private String workingFilesDir = "";
	private String completedFilesDir = "";
	private String imageFilesDir = "";
	private String logoIcon = "";
	private String floppyDir = "";
	private String helpURL = "";

	/* hidden variables */
	private boolean debugMode = false;
	private boolean developerMode = false;
	private boolean okPasswordForRefused = false;
	private boolean okPasswordForUnknown = false;
	private boolean okPasswordForNotUnderstood = false;
	private boolean showQuestionNum = false;

	private String directive = null;	// the default
	private String urlPrefix = null;
	private StringBuffer errors = null;
	private int currentLanguage = 0;

	/**
	 * This method runs only when the servlet is first loaded by the
	 * webserver.  It calls the loadSchedule method to input all the
	 * nodes into memory.  The Schedule is then available to all
	 * sessions that might be running.
	 */
	public void init(ServletConfig config) throws ServletException {
		super.init(config);
		String s;

		s = config.getInitParameter("scheduleList");
		if (s != null)
			scheduleList = s.trim();
		s = config.getInitParameter("scheduleSrcDir");
		if (s != null)
			scheduleSrcDir = s.trim();
		s = config.getInitParameter("workingFilesDir");
		if (s != null)
			workingFilesDir = s.trim();
		s = config.getInitParameter("completedFilesDir");
		if (s != null)
			completedFilesDir = s.trim();
		s = config.getInitParameter("imageFilesDir");
		if (s != null)
			imageFilesDir = s.trim();
		s = config.getInitParameter("logoIcon");
		if (s != null)
			logoIcon = s.trim();
		s = config.getInitParameter("floppyDir");
		if (s != null)
			floppyDir = s.trim();
		s = config.getInitParameter("helpURL");
		if (s != null)
			helpURL = s.trim();

		HELP_T_ICON = Node.encodeHTML(imageFilesDir + "help_true.gif");
		HELP_F_ICON = Node.encodeHTML(imageFilesDir + "help_false.gif");
		COMMENT_T_ICON = Node.encodeHTML(imageFilesDir + "comment_true.gif");
		COMMENT_F_ICON = Node.encodeHTML(imageFilesDir + "comment_false.gif");
		REFUSED_T_ICON = Node.encodeHTML(imageFilesDir + "refused_true.gif");
		REFUSED_F_ICON = Node.encodeHTML(imageFilesDir + "refused_false.gif");
		UNKNOWN_T_ICON = Node.encodeHTML(imageFilesDir + "unknown_true.gif");
		UNKNOWN_F_ICON = Node.encodeHTML(imageFilesDir + "unknown_false.gif");
		NOT_UNDERSTOOD_T_ICON = Node.encodeHTML(imageFilesDir + "not_understood_true.gif");
		NOT_UNDERSTOOD_F_ICON = Node.encodeHTML(imageFilesDir + "not_understood_false.gif");

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
	public void doPost(HttpServletRequest req, HttpServletResponse res)  {
		try {
			this.req = req;
			this.res = res;
			HttpSession session = req.getSession(true);
			String form = null;
			String debugInfo = null;
			String hiddenStr = "";
			firstFocus = null; // reset it each time
			urlPrefix = "http://" + req.getServerName() + "/";


			triceps = (Triceps) session.getValue("triceps");

			res.setContentType("text/html");

			directive = req.getParameter("directive");	// XXX: directive must be set before calling processHidden

			hiddenStr = processHidden();

			form = processDirective();
			debugInfo = generateDebugInfo();

			out = res.getWriter();

			out.println(header());

			out.println(getCustomHeader());
//System.err.println("Sending header");
//out.flush();

			if (errors != null) {
				out.println(errors.toString());
				errors =  null;
//System.err.println("Sending errors");
//out.flush();
			}

//System.err.println("Sending form");

			if (form != null) {
				out.println("<FORM method='POST' name='myForm' action='" + HttpUtils.getRequestURL(req) + "'>\n");
				/* language switching section */
				if (triceps != null) {
					Vector languages = triceps.nodes.getLanguages();
					if (languages.size() > 1) {
						out.println("<TABLE WIDTH='100%' BORDER='0'>\n	<TR><TD ALIGN='center'>");
						for (int i=0;i<languages.size();++i) {
							String language = (String) languages.elementAt(i);
							boolean selected = (i == triceps.getLanguage());
							out.println(((selected) ? "<U>" : "") +
								"<INPUT TYPE='button' onClick='javascript:setLanguage(\"" + language + "\");' VALUE='" + language + "'>" +
								((selected) ? "</U>" : ""));
						}
						out.println("	<TD></TR>\n</TABLE>");
					}
				}


				out.println(hiddenStr);
				out.println(form);
				out.println("</FORM>\n");
			}
//out.flush();
//System.err.println("Sending debugInfo");
			out.println(debugInfo);
//out.flush();
//System.err.println("Sending footer");

			out.println(footer());

//System.err.println("Closing writer\n----Cycle# " + ++TricepsServlet.cycle + "-----\n");
			out.close();	// XXX:  causes "Network Connection reset by peer" with Ham-D.txt - WHY?  Without close, dangling resources?

			/* Store appropriate stuff in the session */
			if (triceps != null)
				session.putValue("triceps", triceps);

			if ("next".equals(directive)) {
				triceps.toTSV();
			}
		}
		catch (Throwable t) {
			System.err.println("Unexpected error: " + t.getMessage());
			t.printStackTrace(System.err);
		}
	}

	private String processHidden() {
		StringBuffer sb = new StringBuffer();

		String settingAsRefused = null;
		String settingAsUnknown = null;
		String settingAsNotUnderstood = null;
		String language = null;
		okPasswordForRefused = false;	// the default value
		okPasswordForUnknown = false;	// the default value
		okPasswordForNotUnderstood = false;

		if (triceps != null) {
			/* Refusals only aply once Triceps has been initialized */
			settingAsRefused = req.getParameter("PASSWORD_FOR_REFUSED");
			if (settingAsRefused != null && !settingAsRefused.equals("")) {
				/* if try to enter a password, make sure that doesn't reset the form if password fails */
//				directive = "next";	// XXX - since JavaScript can't set a SUBMIT value in the answerRefused() function

				if (triceps.getPasswordForRefused() == null) {
					sb.append("You are not allowed to *REFUSE* to answer any questions<BR>");
				}
				else {
					if (triceps.getPasswordForRefused().equals(settingAsRefused)) {
						okPasswordForRefused = true;
					}
					else {
						sb.append("Incorrect password to *REFUSE* to answer these questions<BR>");
					}
				}
			}
			settingAsUnknown = req.getParameter("PASSWORD_FOR_UNKNOWN");
			if (settingAsUnknown != null && !settingAsUnknown.equals("")) {
				/* if try to enter a password, make sure that doesn't reset the form if password fails */
//				directive = "next";	// XXX - since JavaScript can't set a SUBMIT value in the answerRefused() function

				if (triceps.getPasswordForUnknown() == null) {
					sb.append("You are not allowed to set any answers as *UNKNOWN*<BR>");
				}
				else {
					if (triceps.getPasswordForUnknown().equals(settingAsUnknown)) {
						okPasswordForUnknown = true;
					}
					else {
						sb.append("Incorrect password to set these answers as *UNKNOWN*<BR>");
					}
				}
			}
			settingAsNotUnderstood = req.getParameter("PASSWORD_FOR_NOT_UNDERSTOOD");
			if (settingAsNotUnderstood != null && !settingAsNotUnderstood.equals("")) {
				/* if try to enter a password, make sure that doesn't reset the form if password fails */
//				directive = "next";	// XXX - since JavaScript can't set a SUBMIT value in the answerRefused() function

				if (triceps.getPasswordForNotUnderstood() == null) {
					sb.append("You are not allowed to set any answers as *NOT UNDERSTOOD*<BR>");
				}
				else {
					if (triceps.getPasswordForNotUnderstood().equals(settingAsNotUnderstood)) {
						okPasswordForNotUnderstood = true;
					}
					else {
						sb.append("Incorrect password to set these answers as *NOT UNDERSTOOD*<BR>");
					}
				}
			}
			language = req.getParameter("LANGUAGE");
			if (language != null && language.trim().length() > 0) {
				System.err.println("Setting language to " + language);
				triceps.setLanguage(language.trim());
				directive = "refresh current";
			}
		}

		sb.append("<input type='HIDDEN' name='PASSWORD_FOR_REFUSED' value=''>\n");	// must manually bypass each time
		sb.append("<input type='HIDDEN' name='PASSWORD_FOR_UNKNOWN' value=''>\n");	// must manually bypass each time
		sb.append("<input type='HIDDEN' name='PASSWORD_FOR_NOT_UNDERSTOOD' value=''>\n");	// must manually bypass each time
		sb.append("<input type='HIDDEN' name='LANGUAGE' value=''>\n");	// must manually bypass each time


		/** Process requests to change developerMode-type status **/
		if (triceps != null && directive != null) {
			/* Get current values */
			debugMode = triceps.nodes.isDebugMode();
			developerMode = triceps.nodes.isDeveloperMode();
			showQuestionNum = triceps.nodes.isShowQuestionRef();

			/* Toggle these values, as requested */
			if (directive.startsWith("turn developerMode")) {
				developerMode = !developerMode;
				triceps.nodes.setReserved(Schedule.DEVELOPER_MODE, String.valueOf(developerMode));
				directive = "refresh current";
			}
			else if (directive.startsWith("turn debugMode")) {
				debugMode = !debugMode;
				triceps.nodes.setReserved(Schedule.DEBUG_MODE, String.valueOf(debugMode));
				directive = "refresh current";
			}
			else if (directive.startsWith("turn showQuestionNum")) {
				showQuestionNum = !showQuestionNum;
				triceps.nodes.setReserved(Schedule.SHOW_QUESTION_REF, String.valueOf(showQuestionNum));
				directive = "refresh current";
			}
		}
		else {
			debugMode = false;
			developerMode = false;
			showQuestionNum = false;
		}

		return sb.toString();
	}

	private String getCustomHeader() {
		StringBuffer sb = new StringBuffer();

		sb.append("<TABLE BORDER='0' CELLPADDING='0' CELLSPACING='3' WIDTH='100%'>\n");
		sb.append("<TR>\n");
		sb.append("	<TD WIDTH='1%'>\n");

		String logo = (triceps != null) ? triceps.getIcon() : logoIcon;
		if (logo.trim().equals("")) {
			sb.append("&nbsp;");
		}
		else {
			sb.append("			<IMG NAME='icon' SRC='" + Node.encodeHTML(imageFilesDir + logo) + "' ALIGN='top' BORDER='0' onMouseDown='javascript:showMain(event);' ALT='Logo'>\n");
		}
		sb.append("	</TD>\n");
		sb.append("	<TD ALIGN='left'><FONT SIZE='5'><B>" + Node.encodeHTML((triceps != null) ? triceps.getHeaderMsg() : "Triceps System") + "</B></FONT></TD>\n");
		sb.append("	<TD WIDTH='1%'><IMG SRC='" + HELP_T_ICON + "' ALIGN='top' BORDER='0' ALT='Help' onMouseDown='javascript:help(\"" + Node.encodeHTML(helpURL) + "\");'></TD>\n");
		sb.append("</TR>\n");
		sb.append("</TABLE>\n");
		sb.append("<HR>\n");

		return sb.toString();
	}

	private String getCustomFooter() {
		return "";
	}

	private String footer() {
		StringBuffer sb = new StringBuffer();

		sb.append(getCustomFooter());

		sb.append("</body>\n");
		sb.append("</html>\n");
		return sb.toString();
	}

	private String processDirective() {
		boolean ok = true;
		int gotoMsg = Triceps.OK;
		StringBuffer sb = new StringBuffer();
		StringBuffer schedules = new StringBuffer();
		StringBuffer suspendedInterviews = new StringBuffer();
		Enumeration nodes;

		// get the POSTed directive (start, back, next, help, suspend, etc.)	- default is opening screen
		if (directive == null || "select new interview".equals(directive)) {
			/* read list of available schedules from file */

			BufferedReader br = Triceps.getReader(scheduleList, urlPrefix, scheduleSrcDir);
			if (br == null) {
				sb.append("<B>" + Triceps.getReaderError() + "</B><HR>");
			}
			else {
				try {
					int count = 0;
					int line=0;
					String fileLine;
					String src;
					while ((fileLine = br.readLine()) != null) {
						++line;

						if (fileLine.startsWith("COMMENT"))
							continue;

						try {
							StringTokenizer schedule = new StringTokenizer(fileLine,"\t");
							String title = schedule.nextToken();
							String fileLoc = schedule.nextToken();

							if (title == null || fileLoc == null)
								continue;

							/* Test whether these files exist */
							Reader target = Triceps.getReader(fileLoc,urlPrefix, scheduleSrcDir);
							if (target == null) {
								sb.append("<B>" + Triceps.getReaderError() + "</B><HR>");
							}
							else {
								try { target.close(); } catch (Throwable t) { System.err.println("Error closing reader: " + t.getMessage()); }

								++count;
								schedules.append("	<option value='" + Node.encodeHTML(fileLoc) + "'>" + Node.encodeHTML(title) + "</option>\n");
							}
						}
						catch (Throwable t) {
							String msg = "Error tokenizing schedule list '" + scheduleList + "' on line " + line + ": " + t.getMessage();
							sb.append(msg);
							System.err.println(msg);
						}
					}
				}
				catch(Throwable t) {
					String msg = "Error reading from " + scheduleList + ": " + t.getMessage();
					sb.append(msg);
					System.err.println(msg);
				}
				if (br != null) {
					try { br.close(); } catch (Throwable t) {
						System.err.println("Error closing reader: " + t.getMessage());
					}
				}

				/* Now build the list of uncompleted interviews */

				try {
					File dir = new File(workingFilesDir);

					if (dir.isDirectory() && dir.canRead()) {
						String[] files = dir.list();

						int count=0;
						for (int i=0;i<files.length;++i) {
							try {
								File f = new File(files[i]);
								if (!f.isDirectory()) {
									if (count == 0) {
										suspendedInterviews.append("<select name='RestoreSuspended'>\n	<option value=''></option>\n");
									}
									suspendedInterviews.append("	<option value='" + files[i] + "'>" + files[i] + "</option>\n");
									++count;
								}
							}
							catch (Throwable t) {
								System.err.println("Error reading from file " + dir + ": " + t.getMessage());
							}
						}
						if (count > 0) {
							suspendedInterviews.append("</select><BR>");
						}
						else {
							suspendedInterviews.append("&nbsp;");
						}
					}
					else {
						System.err.println("can't read from dir " + dir.toString());
					}
				}
				catch(Throwable t) {
					System.err.println("Error reading from file: "  + t.getMessage());
				}
			}

			/* Now construct splash screen */

			sb.append("<TABLE CELLPADDING='2' CELLSPACING='2' BORDER='1'>\n");
			sb.append("<TR><TD>Please select an interview/questionnaire from the pull-down list:  </TD>\n");
			sb.append("	<TD><select name='schedule'>\n");
			sb.append(schedules);
			sb.append("	</select></TD>\n");
			sb.append("	<TD><input type='SUBMIT' name='directive' value='START'></TD>\n");
			sb.append("</TR>\n");

			sb.append("<TR><TD>OR, restore an interview/questionnaire in progress:  </TD>\n");
			sb.append("	<TD>" + suspendedInterviews +
				((developerMode) ? "<input type='text' name='RESTORE'>" : "") +
				"</TD>\n");
			sb.append("	<TD><input type='SUBMIT' name='directive' value='RESTORE'></TD>\n");

//			sb.append(showOptions());

			sb.append("</TABLE>\n");
			return sb.toString();
		}
		else if (directive.equals("START")) {
			// load schedule
			triceps = new Triceps(scheduleSrcDir, workingFilesDir, completedFilesDir);
			ok = triceps.setSchedule(req.getParameter("schedule"),urlPrefix,scheduleSrcDir);

			if (!ok) {
				directive = null;
				return processDirective();
			}
			// re-check developerMode options - they aren't set via the hidden options, since a new copy of Triceps created
			debugMode = triceps.nodes.isDebugMode();
			developerMode = triceps.nodes.isDeveloperMode();
			showQuestionNum = triceps.nodes.isShowQuestionRef();

			ok = ok && ((gotoMsg = triceps.gotoStarting()) == Triceps.OK);	// don't proceed if prior error
			// ask question
		}
		else if (directive.equals("RESTORE")) {
			String restore;

			restore = req.getParameter("RESTORE");
			if (restore == null || restore.trim().equals("")) {
				restore = req.getParameter("RestoreSuspended");
			}

			// load schedule
			triceps = new Triceps(scheduleSrcDir, workingFilesDir, completedFilesDir);
			ok = triceps.setSchedule(restore,urlPrefix,workingFilesDir);

			if (!ok) {
				directive = null;	// so that processDirective() will select new interview

				return "<B>Unable to find or access schedule '" + restore + "'</B><HR>" +
					processDirective();
			}
			// re-check developerMode options - they aren't set via the hidden options, since a new copy of Triceps created
			debugMode = triceps.nodes.isDebugMode();
			developerMode = triceps.nodes.isDeveloperMode();
			showQuestionNum = triceps.nodes.isShowQuestionRef();

			ok = ok && ((gotoMsg = triceps.gotoStarting()) == Triceps.OK);	// don't proceed if prior error

			// ask question
		}
		else if (directive.equals("jump to:")) {
			gotoMsg = triceps.gotoNode(req.getParameter("jump to:"));
			ok = (gotoMsg == Triceps.OK);
			// ask this question
		}
		else if (directive.equals("refresh current")) {
			ok = true;
			// re-ask the current question
		}
		else if (directive.equals("restart (clean)")) { // restart from scratch
			ok = triceps.resetEvidence();
			ok = ok && ((gotoMsg = triceps.gotoFirst()) == Triceps.OK);	// don't proceed if prior error
			// ask first question
		}
		else if (directive.equals("reload questions")) { // debugging option
			ok = triceps.reloadSchedule();
			if (ok) {
				sb.append("<B>Schedule restored successfully</B><HR>\n");
			}
			// re-ask current question
		}
		else if (directive.equals("save to:")) {
			String name = req.getParameter("save to:");
			String file = workingFilesDir + name;
			ok = triceps.toTSV(file);
			if (ok) {
				sb.append("<B>Interview saved successfully as " + Node.encodeHTML(name) + " (" + Node.encodeHTML(file) + ")</B><HR>\n");
			}
		}
		else if (directive.equals("evaluate expr:")) {
			String expr = req.getParameter("evaluate expr:");
			errors = new StringBuffer();
			if (expr != null) {
				Datum datum = triceps.evaluateExpr(expr);

				errors.append("<TABLE WIDTH='100%' CELLPADDING='2' CELLSPACING='1' BORDER=1>\n");
				errors.append("<TR><TD>Equation</TD><TD><B>" + Node.encodeHTML(expr) + "</B></TD><TD>Type</TD><TD><B>" + Datum.TYPES[datum.type()] + "</B></TD></TR>\n");
				errors.append("<TR><TD>String</TD><TD><B>" + Node.encodeHTML(datum.stringVal(true)) + "</B></TD><TD>boolean</TD><TD><B>" + datum.booleanVal() + "</B></TD></TR>\n");
				errors.append("<TR><TD>double</TD><TD><B>" + datum.doubleVal() + "</B></TD><TD>long</TD><TD><B>" + datum.longVal() + "</B></TD></TR>\n");
				errors.append("<TR><TD>date</TD><TD><B>" + datum.dateVal() + "</B></TD><TD>month</TD><TD><B>" + datum.monthVal() + "</B></TD></TR>\n");
				errors.append("</TABLE>\n");

				Enumeration errs = triceps.getErrors();
				if (errs.hasMoreElements()) {
					errors.append("<B>There were errors parsing that equation:</B><BR>");
					while (errs.hasMoreElements()) {
						errors.append("<B>" + Node.encodeHTML((String) errs.nextElement()) + "</B><BR>\n");
					}
				}
			}
		}
		else if (directive.equals("show XML")) {
			sb.append("<B>Use 'Show Source' to see data in Schedule as XML</B><BR>\n");
			sb.append("<!--\n" + triceps.toXML() + "\n-->\n");
			sb.append("<HR>\n");
		}
		else if (directive.equals("show Syntax Errors")) {
			errors = new StringBuffer();
			Vector pes = triceps.collectParseErrors();

			if (pes.size() == 0) {
				errors.append("<B>No fatal syntax errors were found</B><HR>");
			}
			else {
				Vector errs;

				for (int i=0;i<pes.size();++i) {
					ParseError pe = (ParseError) pes.elementAt(i);
					Node n = pe.getNode();

					if (i == 0) {
						errors.append("<FONT color='red'>The following errors were found in file <B>" + Node.encodeHTML(n.getSourceFile()) + "</B></FONT><BR>\n");
						errors.append("<TABLE CELLPADDING='2' CELLSPACING='1' WIDTH='100%' border='1'>\n");
						errors.append("<TR><TD>line#</TD><TD>name</TD><TD>Dependencies</TD><TD><B>Dependency Errors</B></TD><TD>Action Type</TD><TD>Action</TD><TD><B>Action Errors</B></TD><TD><B>Other Errors</B></TD></TR>\n");
					}

					errors.append("\n<TR><TD>" + n.getSourceLine() + "</TD><TD>" + Node.encodeHTML(n.getExternalName(),true) + "</TD>");
					errors.append("\n<TD>" + Node.encodeHTML(pe.getDependencies(),true) + "</TD>\n<TD>");

					errs = pe.getDependenciesErrors();
					if (errs.size() == 0) {
						errors.append("&nbsp;");
					}
					else {
						for (int j=0;j<errs.size();++j) {
							if (j > 0)
								errors.append("<BR>");
							errors.append("" + (j+1) + ")&nbsp;" + Node.encodeHTML((String) errs.elementAt(j),true));
						}
					}

					errors.append("</TD>\n<TD>" + Node.ACTION_TYPES[n.getQuestionOrEvalType()] + "</TD><TD>" + Node.encodeHTML(pe.getQuestionOrEval(),true) + "</TD><TD>");

					errs = pe.getQuestionOrEvalErrors();
					if (errs.size() == 0) {
						errors.append("&nbsp;");
					}
					else {
						for (int j=0;j<errs.size();++j) {
							if (j > 0)
								errors.append("<BR>");
							errors.append("" + (j+1) + ")&nbsp;" + Node.encodeHTML((String) errs.elementAt(j),true));
						}
					}

					errors.append("</TD>\n<TD>");

					errs = pe.getNodeErrors();
					if (errs.size() == 0) {
						errors.append("&nbsp;");
					}
					else {
						for (int j=0;j<errs.size();++j) {
							if (j > 0)
								errors.append("<BR>");
							errors.append("" + (j+1) + ")&nbsp;" + (String) errs.elementAt(j));	// XXX: don't Node.encodeHTML() these, since pre-processed within Node
						}
					}
					errors.append("</TD></TR>");
				}
				errors.append("</TABLE><HR>\n");
			}
		}
		else if (directive.equals("next")) {
			// store current answer(s)
			Enumeration questionNames = triceps.getQuestions();

			while(questionNames.hasMoreElements()) {
				Node q = (Node) questionNames.nextElement();
				boolean status;

				String answer = req.getParameter(q.getLocalName());
				String comment = req.getParameter(q.getLocalName() + "_COMMENT");
				String special = req.getParameter(q.getLocalName() + "_SPECIAL");

				status = triceps.storeValue(q, answer, comment, special, okPasswordForRefused, okPasswordForUnknown, okPasswordForNotUnderstood);
				ok = status && ok;

			}
			// goto next
			ok = ok && ((gotoMsg = triceps.gotoNext()) == Triceps.OK);	// don't proceed if prior errors - e.g. unanswered questions

			if (gotoMsg == Triceps.AT_END) {
				// save the file, but still give the option to go back and change answers
				boolean savedOK;
				String file = completedFilesDir + triceps.getFilename();

				sb.append("<B>Thank you, the interview is completed</B><BR>\n");
				savedOK = triceps.toTSV(file);
				ok = savedOK && ok;
				if (savedOK) {
					sb.append("<B>Interview saved successfully as " + Node.encodeHTML(file) + "</B><HR>\n");
				}

				file = floppyDir + triceps.getFilename();
				savedOK = false;	// reset; then try to save to floppy

				savedOK = triceps.toTSV(file);
				ok = savedOK && ok;
				if (savedOK) {
					sb.append("<B>Interview saved successfully as " + Node.encodeHTML(file) + "</B><HR>\n");
				}
			}

			// don't goto next if errors
			// ask question
		}
		else if (directive.equals("previous")) {
			// don't store current
			// goto previous
			gotoMsg = triceps.gotoPrevious();
			ok = ok && (gotoMsg == Triceps.OK);
			// ask question
		}


		/* Show any accumulated errors */
		int errCount = 0;
		Enumeration errs = triceps.getErrors();
		if (errs.hasMoreElements()) {
			while (errs.hasMoreElements()) {
				++errCount;
				sb.append("<B>" + Node.encodeHTML((String) errs.nextElement()) + "</B><BR>\n");
			}
		}

		nodes = triceps.getQuestions();
		while (nodes.hasMoreElements()) {
			Node n = (Node) nodes.nextElement();
			if (n.hasRuntimeErrors()) {
				if (++errCount == 1) {
					sb.append("<B>Please answer the question(s) listed in <FONT color='red'>RED</FONT> before proceeding</B><BR>\n");
				}
				if (n.focusableArray()) {
					firstFocus = Node.encodeHTML(n.getLocalName()) + "[0]";
					break;
				}
				else if (n.focusable()) {
					firstFocus = Node.encodeHTML(n.getLocalName());
					break;
				}
			}
		}

		if (errCount > 0) {
			sb.append("<HR>\n");
		}

		if (firstFocus == null) {
			nodes = triceps.getQuestions();
			while (nodes.hasMoreElements()) {
				Node n = (Node) nodes.nextElement();
				if (n.focusableArray()) {
					firstFocus = Node.encodeHTML(n.getLocalName()) + "[0]";
					break;
				}
				else if (n.focusable()) {
					firstFocus = Node.encodeHTML(n.getLocalName());
					break;
				}
			}
		}
		if (firstFocus == null) {
			firstFocus = "directive[0]";	// try to focus on Next button if nothing else available
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

		if (debugMode) {
			sb.append("<H4>QUESTION AREA</H4>\n");
		}

		Enumeration questionNames = triceps.getQuestions();
		String color;
		String errMsg;

		sb.append("<TABLE CELLPADDING='2' CELLSPACING='1' WIDTH='100%' border='1'>\n");
		for(int count=0;questionNames.hasMoreElements();++count) {
			Node node = (Node) questionNames.nextElement();
			Datum datum = triceps.getDatum(node);

			node.setAnswerLanguageNum(triceps.getLanguage());	// must do this first

			if (node.hasRuntimeErrors()) {
				color = " color='red'";
				StringBuffer errStr = new StringBuffer("<FONT color='red'>");

				Vector errs = node.getRuntimeErrors();

				for (int j=0;j<errs.size();++j) {
					if (j > 0) {
						errStr.append("<BR>\n");
					}
					errStr.append(Node.encodeHTML((String) errs.elementAt(j)));
				}
				errStr.append("</FONT>");
				errMsg = errStr.toString();
			}
			else {
				color = "";
				errMsg = "";
			}

			sb.append("	<TR>\n");

			if (showQuestionNum) {
				sb.append("<TD><FONT" + color + "><B>" + Node.encodeHTML(node.getExternalName()) + "</B></FONT></TD>\n");
			}

			String inputName = Node.encodeHTML(node.getLocalName());

			String clickableOptions = buildClickableOptions(node,inputName);

			switch(node.getAnswerType()) {
				case Node.NOTHING:
					sb.append("		<TD COLSPAN='3'><FONT" + color + ">" + Node.encodeHTML(triceps.getQuestionStr(node)) + "</FONT></TD>\n");
					break;
				case Node.RADIO_HORIZONTAL:
					sb.append("		<TD COLSPAN='3'>\n");
					sb.append("			<input type='HIDDEN' name='" + Node.encodeHTML(inputName + "_COMMENT") + "' value='" + Node.encodeHTML(node.getComment()) + "'>\n");
					sb.append("			<input type='HIDDEN' name='" + Node.encodeHTML(inputName + "_SPECIAL") + "' value='" +
						((!datum.isType(Datum.STRING)) ? Node.encodeHTML(triceps.toString(node,true),true) : "") +
						"'>\n");
					sb.append("			<input type='HIDDEN' name='" + Node.encodeHTML(inputName + "_HELP") + "' value='" + Node.encodeHTML(node.getHelpURL()) + "'>\n");
					sb.append("		<FONT" + color + ">" + Node.encodeHTML(triceps.getQuestionStr(node)) + "</FONT></TD>\n");
					sb.append("</TR>\n<TR>\n");
					if (showQuestionNum) {
						sb.append("<TD>&nbsp;</TD>");
					}
					sb.append("	<TD WIDTH='1%' NOWRAP>\n" + clickableOptions + "\n</TD>\n");
					sb.append(node.prepareChoicesAsHTML(triceps.parser,triceps.evidence,datum,errMsg,triceps.nodes.isAutoGenOptionNum()));
					break;
				default:
					sb.append("		<TD>\n");
					sb.append("			<input type='HIDDEN' name='" + Node.encodeHTML(inputName + "_COMMENT") + "' value='" + Node.encodeHTML(node.getComment()) + "'>\n");
					sb.append("			<input type='HIDDEN' name='" + Node.encodeHTML(inputName + "_SPECIAL") + "' value='" +
						((!datum.isType(Datum.STRING)) ? Node.encodeHTML(triceps.toString(node,true),true) : "") +
						"'>\n");
					sb.append("			<input type='HIDDEN' name='" + Node.encodeHTML(inputName + "_HELP") + "' value='" + Node.encodeHTML(node.getHelpURL()) + "'>\n");
					sb.append("		<FONT" + color + ">" + Node.encodeHTML(triceps.getQuestionStr(node)) + "</FONT></TD>\n");
					sb.append("	<TD WIDTH='1%' NOWRAP>\n" + clickableOptions + "\n</TD>\n");
					sb.append("		<TD>" + node.prepareChoicesAsHTML(triceps.parser,triceps.evidence,datum,triceps.nodes.isAutoGenOptionNum()) + errMsg + "</TD>\n");
					break;
			}

			sb.append("	</TR>\n");
		}
		sb.append("	<TR><TD COLSPAN='" + ((showQuestionNum) ? 4 : 3) + "' ALIGN='center'>\n");
		sb.append("<input type='SUBMIT' name='directive' value='next'>\n");
		sb.append("<input type='SUBMIT' name='directive' value='previous'>");

		sb.append("	</TD></TR>\n");

		if (developerMode || debugMode) {
			sb.append("	<TR><TD COLSPAN='" + ((showQuestionNum) ? 4 : 3 ) + "' ALIGN='center'>\n");
			sb.append("<input type='SUBMIT' name='directive' value='select new interview'>\n");
			sb.append("<input type='SUBMIT' name='directive' value='restart (clean)'>\n");
			sb.append("<input type='SUBMIT' name='directive' value='jump to:' size='10'>\n");
			sb.append("<input type='text' name='jump to:'>\n");
			sb.append("<input type='SUBMIT' name='directive' value='save to:'>\n");
			sb.append("<input type='text' name='save to:'>\n");
			sb.append("	</TD></TR>\n");
			sb.append("	<TR><TD COLSPAN='" + ((showQuestionNum) ? 4 : 3 ) + "' ALIGN='center'>\n");
			sb.append("<input type='SUBMIT' name='directive' value='reload questions'>\n");
			sb.append("<input type='SUBMIT' name='directive' value='show Syntax Errors'>\n");
			sb.append("<input type='SUBMIT' name='directive' value='show XML'>\n");
			sb.append("<input type='SUBMIT' name='directive' value='evaluate expr:'>\n");
			sb.append("<input type='text' name='evaluate expr:'>\n");
			sb.append("	</TD></TR>\n");
		}

		sb.append(showOptions());

		sb.append("</TABLE>\n");

		return sb.toString();
	}

	private String buildClickableOptions(Node node, String inputName) {
		StringBuffer sb = new StringBuffer();

		Datum datum = triceps.getDatum(node);

		boolean isRefused = false;
		boolean isUnknown = false;
		boolean isNotUnderstood = false;
		boolean showInvisibles = triceps.isShowInvisibleOptions();

		if (datum.isType(Datum.REFUSED))
			isRefused = true;
		else if (datum.isType(Datum.UNKNOWN))
			isUnknown = true;
		else if (datum.isType(Datum.NOT_UNDERSTOOD))
			isNotUnderstood = true;

		String helpURL = Node.encodeHTML(node.getHelpURL());
		if (helpURL != null && helpURL.trim().length() != 0) {
			sb.append("<IMG SRC='" + HELP_T_ICON +
				"' ALIGN='top' BORDER='0' ALT='Help' onMouseDown='javascript:help(\"" + helpURL + "\");'>\n");
		}
		else {
			sb.append("<IMG SRC='" + HELP_F_ICON +
				"' ALIGN='top' BORDER='0' ALT='Help not available for this question'>\n");
		}

		String comment = Node.encodeHTML(node.getComment());
		if (comment != null && comment.trim().length() != 0) {
			sb.append("<IMG NAME='" + inputName + "_COMMENT_ICON" + "' SRC='" + COMMENT_T_ICON +
				"' ALIGN='top' BORDER='0' ALT='Add a Comment' onMouseDown='javascript:comment(\"" + inputName + "\");'>\n");
		}
		else if (showInvisibles) {
			sb.append("<IMG NAME='" + inputName + "_COMMENT_ICON" + "' SRC='" + COMMENT_F_ICON +
				"' ALIGN='top' BORDER='0' ALT='Add a Comment' onMouseDown='javascript:comment(\"" + inputName + "\");'>\n");
		}

		if (showInvisibles) {
			sb.append("<IMG NAME='" + inputName + "_REFUSED_ICON" + "' SRC='" + ((isRefused) ? REFUSED_T_ICON : REFUSED_F_ICON) +
				"' ALIGN='top' BORDER='0' ALT='Set as Refused' onMouseDown='javascript:setRefusedPassword(\"" + inputName + "\");'>\n");
			sb.append("<IMG NAME='" + inputName + "_UNKNOWN_ICON" + "' SRC='" + ((isUnknown) ? UNKNOWN_T_ICON : UNKNOWN_F_ICON) +
				"' ALIGN='top' BORDER='0' ALT='Set as Unknown' onMouseDown='javascript:setUnknownPassword(\"" + inputName + "\");'>\n");
			sb.append("<IMG NAME='" + inputName + "_NOT_UNDERSTOOD_ICON" + "' SRC='" + ((isNotUnderstood) ? NOT_UNDERSTOOD_T_ICON : NOT_UNDERSTOOD_F_ICON) +
				"' ALIGN='top' BORDER='0' ALT='Set as Not Understood' onMouseDown='javascript:setNotUnderstoodPassword(\"" + inputName + "\");'>\n");
		}

		return sb.toString();
	}

	private String generateDebugInfo() {
		StringBuffer sb = new StringBuffer();
		// Complete printout of what's been collected per node

		if (debugMode) {
			sb.append("<hr>\n");
			sb.append("<H4>CURRENT QUESTION(s)</H4>\n");
			sb.append("<TABLE CELLPADDING='2' CELLSPACING='1'  WIDTH='100%' BORDER='1'>\n");
			Enumeration questionNames = triceps.getQuestions();

			while(questionNames.hasMoreElements()) {
				Node n = (Node) questionNames.nextElement();
				sb.append("<TR>");
				sb.append("<TD>" + Node.encodeHTML(n.getExternalName(),true) + "</TD>");
				sb.append("<TD><B>" + Node.encodeHTML(triceps.toString(n,true),true) + "</B></TD>");
				sb.append("<TD>" + Node.encodeHTML(Datum.TYPES[n.getDatumType()]) + "</TD>");
				sb.append("<TD>" + Node.encodeHTML(n.getLocalName(),true) + "</TD>");
				sb.append("<TD>" + Node.encodeHTML(n.getConcept(),true) + "</TD>");
				sb.append("<TD>" + Node.encodeHTML(n.getDependencies(),true) + "</TD>");
				sb.append("<TD>" + Node.encodeHTML(n.getQuestionOrEvalTypeField(),true) + "</TD>");
				sb.append("<TD>" + Node.encodeHTML(n.getQuestionOrEval(),true) + "</TD>");
				sb.append("</TR>\n");
			}
			sb.append("</TABLE>\n");


			sb.append("<hr>\n");
			sb.append("<H4>EVIDENCE AREA</H4>\n");
			sb.append("<TABLE CELLPADDING='2' CELLSPACING='1'  WIDTH='100%' BORDER='1'>\n");
			for (int i = triceps.size()-1; i >= 0; i--) {
				Node n = triceps.getNode(i);
				Datum d = triceps.getDatum(n);
				if (!triceps.isSet(n))
					continue;
				sb.append("<TR>");
				sb.append("<TD>" + (i + 1) + "</TD>");
				sb.append("<TD>" + Node.encodeHTML(n.getExternalName(),true) + "</TD>");
				if (!d.isType(Datum.STRING)) {
					sb.append("<TD><B><I>" + Node.encodeHTML(triceps.toString(n,true),true) + "</I></B></TD>");
				}
				else {
					sb.append("<TD><B>" + Node.encodeHTML(triceps.toString(n,true),true) + "</B></TD>");
				}
				sb.append("<TD>" +  Node.encodeHTML(Datum.TYPES[n.getDatumType()]) + "</TD>");
				sb.append("<TD>" + Node.encodeHTML(n.getLocalName(),true) + "</TD>");
				sb.append("<TD>" + Node.encodeHTML(n.getConcept(),true) + "</TD>");
				sb.append("<TD>" + Node.encodeHTML(n.getDependencies(),true) + "</TD>");
				sb.append("<TD>" + Node.encodeHTML(n.getQuestionOrEvalTypeField(),true) + "</TD>");
				sb.append("<TD>" + Node.encodeHTML(n.getQuestionOrEval(),true) + "</TD>");
				sb.append("</TR>\n");
			}
			sb.append("</TABLE>\n");
		}
		return sb.toString();
	}

	private String showOptions() {
		if (developerMode || debugMode) {
			StringBuffer sb = new StringBuffer();

			sb.append("	<TR><TD COLSPAN='" + ((showQuestionNum) ? 4 : 3 ) + "' ALIGN='center'>\n");
			sb.append("	<input type='SUBMIT' name='directive' value='turn developerMode " + ((developerMode) ? "OFF" : "ON") + "'>\n");
			sb.append("	<input type='SUBMIT' name='directive' value='turn debugMode " + ((debugMode) ? "OFF" : "ON" )+ "'>\n");
			sb.append("	<input type='SUBMIT' name='directive' value='turn showQuestionNum " + ((showQuestionNum) ? "OFF" : "ON") + "'>\n");
			sb.append("</TD></TR>\n");
			return sb.toString();
		}
		else
			return "";
	}

	private String header() {
		StringBuffer sb = new StringBuffer();

		sb.append("<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">\n");
		sb.append("<html>\n");
		sb.append("<head>\n");
		sb.append("<META HTTP-EQUIV='Content-Type' CONTENT='text/html;CHARSET=iso-8859-1'>\n");
		sb.append("<title>" + ((triceps == null) ? "TRICEPS SYSTEM" : triceps.getTitle()) + "</title>\n");

		/* JavaScript for popup menus */
		sb.append("<SCRIPT  type=\"text/javascript\"> <!--\n");
//			sb.append("var xNow, yNow, popup, main, n, ie;\n");
//		sb.append("var helpTarget, actionTarget, commentTarget;\n");
		sb.append("var actionName = null;\n");
		sb.append("\n");
		sb.append("function init() {\n");
//		sb.append("	n = (document.layers) ? 1:0;\n");
//		sb.append("	ie = (document.all) ? 1:0;\n");
//		sb.append("	if (n) { popup = document.layers['POPUPDIV'];\n	main = document.layers['MAINDIV']; }\n");
//		sb.append("	if (ie) { popup = document.all['POPUPDIV'].style;\n	main = document.layers['MAINDIV'].style; }\n");
//		sb.append("	popup.onmouseout = hidePopup;\n");
//		sb.append("	main.onmouseout = hideMain;\n");

		if (firstFocus != null) {
			sb.append("	document.myForm." + firstFocus + ".focus();\n");
		}

		sb.append("}\n");
		sb.append("function showPopup(name,e) {\n");
		sb.append("	actionName = name;\n");
//		sb.append("	actionTarget = document.myForm.elements[name];\n");
//		sb.append(" if (actionTarget.length && actionTarget.length > 0) { actionTarget = actionTarget[0]; }\n");
//		sb.append("	commentTarget = document.myForm.elements[name + '_COMMENT'];\n");
//		sb.append("	helpTarget = document.myForm.elements[name + '_HELP'];\n");
//		sb.append("	specialTarget = document.myForm.elements[name + '_SPECIAL'];\n");
//		sb.append("	if (n) {xNow=e.pageX; yNow=e.pageY}\n");
//		sb.append("	if (ie) {xNow=event.x; yNow=event.y}\n");
//		sb.append("	popup.left = xNow+3-popup.clip.width\n");
//		sb.append("	popup.top = yNow-3;\n");
//		sb.append("	if (n) { popup.visibility = 'show'; }\n");
//		sb.append("	else if (ie) { popup.visibility = 'showing'; }\n");
		sb.append("}\n");
		sb.append("function hidePopup(name) {\n");
		sb.append("	if (!name) name = actionName;\n");
//		sb.append("	if (n) { popup.visibility = 'hide'; }\n");
//		sb.append("	else if (ie) { popup.visibility = 'hidden'; }\n");
		sb.append("	document.myForm.elements[name].focus();\n");
		sb.append("}\n");
		sb.append("function showMain(e) {\n");
		sb.append("	actionName = null;\n");
//		sb.append("	actionTarget = null;\n");
//		sb.append("	helpTarget = null;\n");
//		sb.append("	specialTarget = null;\n");
//		sb.append("	if (n) {xNow=e.pageX; yNow=e.pageY}\n");
//		sb.append("	if (ie) {xNow=event.x; yNow=event.y}\n");
//		sb.append("	main.left = xNow-3;\n");
//		sb.append("	main.top = yNow-3;\n");
//		sb.append("	if (n) { main.visibility = 'show'; }\n");
//		sb.append("	else if (ie) { main.visibility = 'showing'; }\n");
		sb.append("}\n");
		sb.append("function hideMain() {\n");
//		sb.append("	if (n) { main.visibility = 'hide'; }\n");
//		sb.append("	else if (ie) { main.visibility = 'hidden'; }\n");
		sb.append("}\n");
		sb.append("function setRefusedPassword(name) {\n");
		sb.append("	var ans = prompt('Enter password to *REFUSE* to answer this question',document.myForm.PASSWORD_FOR_REFUSED.value);\n");
		sb.append("	if (ans == null) return;\n");
		sb.append("	document.myForm.PASSWORD_FOR_REFUSED.value = ans;\n");
		sb.append("	answerRefused(name);\n");
		sb.append("}\n");
		sb.append("function setUnknownPassword(name) {\n");
		sb.append("	var ans = prompt('Enter password to indicate that the answer is *UNKNOWN*',document.myForm.PASSWORD_FOR_UNKNOWN.value);\n");
		sb.append("	if (ans == null) return;\n");
		sb.append("	document.myForm.PASSWORD_FOR_UNKNOWN.value = ans;\n");
		sb.append("	answerUnknown(name);\n");
		sb.append("}\n");
		sb.append("function setNotUnderstoodPassword(name) {\n");
		sb.append("	var ans = prompt('Enter password to indicate that the answer is *NOT UNDERSTOOD*',document.myForm.PASSWORD_FOR_NOT_UNDERSTOOD.value);\n");
		sb.append("	if (ans == null) return;\n");
		sb.append("	document.myForm.PASSWORD_FOR_NOT_UNDERSTOOD.value = ans;\n");
		sb.append("	questionNotUnderstood(name);\n");
		sb.append("}\n");
		sb.append("function answerRefused(name) {\n");
		sb.append("	if (!name) name = actionName;\n");
		sb.append("	if (!name) return;\n");
		sb.append("	var val = document.myForm.elements[name + '_SPECIAL'];\n");
		sb.append("	if (val.value == '*REFUSED*') {\n");
		sb.append("		val.value = '';\n");
		sb.append("		document.myForm.elements[name + '_REFUSED_ICON'].src = '" + REFUSED_F_ICON + "';\n");
		sb.append("	} else {\n");
		sb.append("		val.value = '*REFUSED*';\n");
		sb.append("		document.myForm.elements[name + '_REFUSED_ICON'].src = '" + REFUSED_T_ICON + "';\n");
		sb.append("		document.myForm.elements[name + '_UNKNOWN_ICON'].src = '" + UNKNOWN_F_ICON + "';\n");
		sb.append("		document.myForm.elements[name + '_NOT_UNDERSTOOD_ICON'].src = '" + NOT_UNDERSTOOD_F_ICON + "';\n");
		sb.append("	}\n}\n");
		sb.append("function answerUnknown(name) {\n");
		sb.append("	if (!name) name = actionName;\n");
		sb.append("	if (!name) return;\n");
		sb.append("	var val = document.myForm.elements[name + '_SPECIAL'];\n");
		sb.append("	if (val.value == '*UNKNOWN*') {\n");
		sb.append("		val.value = '';\n");
		sb.append("		document.myForm.elements[name + '_UNKNOWN_ICON'].src = '" + UNKNOWN_F_ICON + "';\n");
		sb.append("	} else {\n");
		sb.append("		val.value = '*UNKNOWN*';\n");
		sb.append("		document.myForm.elements[name + '_REFUSED_ICON'].src = '" + REFUSED_F_ICON + "';\n");
		sb.append("		document.myForm.elements[name + '_UNKNOWN_ICON'].src = '" + UNKNOWN_T_ICON + "';\n");
		sb.append("		document.myForm.elements[name + '_NOT_UNDERSTOOD_ICON'].src = '" + NOT_UNDERSTOOD_F_ICON + "';\n");
		sb.append("	}\n}\n");
		sb.append("function questionNotUnderstood(name) {\n");
		sb.append("	if (!name) name = actionName;\n");
		sb.append("	if (!name) return;\n");
		sb.append("	var val = document.myForm.elements[name + '_SPECIAL'];\n");
		sb.append("	if (val.value == '*NOT UNDERSTOOD*') {\n");
		sb.append("		val.value = '';\n");
		sb.append("		document.myForm.elements[name + '_NOT_UNDERSTOOD_ICON'].src = '" + NOT_UNDERSTOOD_F_ICON + "';\n");
		sb.append("	} else {\n");
		sb.append("		val.value = '*NOT UNDERSTOOD*';\n");
		sb.append("		document.myForm.elements[name + '_REFUSED_ICON'].src = '" + REFUSED_F_ICON + "';\n");
		sb.append("		document.myForm.elements[name + '_UNKNOWN_ICON'].src = '" + UNKNOWN_F_ICON + "';\n");
		sb.append("		document.myForm.elements[name + '_NOT_UNDERSTOOD_ICON'].src = '" + NOT_UNDERSTOOD_T_ICON + "';\n");
		sb.append("	}\n}\n");
		sb.append("function help(target) {\n");
		sb.append("	if (target != null && target.length != 0) {	window.open(target,'__HELP__'); }\n");
//		sb.append("	else if (helpTarget && helpTarget.value.length != 0) {	window.open(helpTarget.value,'__HELP__'); }\n");
		sb.append("}\n");
		sb.append("function comment(name) {\n");
		sb.append("	if (!name) name = actionName;\n");
		sb.append("	if (!name) return;\n");
		sb.append("	var ans = prompt('Enter a comment for this question',document.myForm.elements[name + '_COMMENT'].value);\n");
		sb.append("	if (ans == null) return;\n");
		sb.append("	document.myForm.elements[name + '_COMMENT'].value = ans;\n");
		sb.append("	if (ans != null && ans.length > 0) {\n");
		sb.append("		document.myForm.elements[name + '_COMMENT_ICON'].src = '" + COMMENT_T_ICON + "';\n");
		sb.append("	} else { document.myForm.elements[name + '_COMMENT_ICON'].src = '" + COMMENT_F_ICON + "'; }\n");
		sb.append("}\n");
		sb.append("function setLanguage(lang) {\n");
		sb.append("	document.myForm.LANGUAGE.value = lang;\n");
		sb.append("	document.myForm.submit();\n");
		sb.append("}\n");
		sb.append("// --> </SCRIPT>\n");

		sb.append("</head>\n");
		sb.append("<body bgcolor='white' onload='javascript:init();'>\n");

/*
		sb.append("<DIV NAME=\"POPUPDIV\" STYLE=\"Layer-Background-Color : silver; position : absolute; visibility : hidden\">\n");
		sb.append("	<A HREF=\"javascript:help();hidePopup();\">Help</A><BR>\n");
		sb.append("	<A HREF=\"javascript:comment();hidePopup();\">Add&nbsp;Comment</A><BR>\n");
		sb.append("	<A HREF=\"javascript:answerUnknown();hidePopup();\">Mark&nbsp;as&nbsp;Unknown</A><BR>\n");
		sb.append("	<A HREF=\"javascript:answerNotUnderstood();hidePopup();\">Mark&nbsp;as&nbsp;Not&nbsp;Understood</A><BR>\n");
		sb.append("	<A HREF=\"javascript:answerRefused();hidePopup();\">Mark&nbsp;as&nbsp;Refused</A>\n");
		sb.append("</DIV>\n");

		sb.append("<DIV NAME=\"MAINDIV\" STYLE=\"Layer-Background-Color : silver; position : absolute; visibility : hidden\">\n");

		if (triceps != null) {

			Vector languages = triceps.nodes.getLanguages();
			if (languages.size() > 1) {
				sb.append("<TABLE WIDTH='100%' BORDER='0'><TR>\n");
				for (int i=0;i<languages.size();++i) {
					String language = (String) languages.elementAt(i);
					sb.append("	<A HREF=\"javascript:setLanguage('" + language + "');hideMain();\">Language:&nbsp;" + language + "</A><BR>\n");
				}
				sb.append("</TR></TABLE>\n");
			}
			sb.append("	<A HREF=\"javascript:setUnknownPassword();hideMain();\">Enter&nbsp;password&nbsp;for&nbsp;Unknown</A><BR>\n");
			sb.append("	<A HREF=\"javascript:setNotUnderstoodPassword();hideMain();\">Mark&nbsp;as&nbsp;Not&nbsp;Understood</A><BR>\n");
			sb.append("	<A HREF=\"javascript:setRefusedPassword();hideMain();\">Enter&nbsp;password&nbsp;for&nbsp;Refused</A>\n");
		}
		sb.append("</DIV>\n");
*/

		return sb.toString();
	}
}
