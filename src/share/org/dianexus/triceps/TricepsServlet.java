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
	private boolean okToShowAdminModeIcons = false;	// allows AdminModeIcons to be visible
	private boolean okPasswordForTempAdminMode = false;	// allows AdminModeIcon values to be accepted
	private boolean showQuestionNum = false;
	private boolean showAdminModeIcons = false;
	private boolean autogenOptionNums = true;	// default is to make reading options easy
	private boolean isSplashScreen = false;
	private boolean allowEasyBypass = false;	// means that a special value is present, so enable the possibility of okPasswordForTempAdminMode
	private boolean allowComments = false;

	private String directive = null;	// the default
	private StringBuffer errors = new StringBuffer();
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
			StringBuffer sb = new StringBuffer();


			triceps = (Triceps) session.getValue("triceps");

			res.setContentType("text/html");

			directive = req.getParameter("directive");	// XXX: directive must be set before calling processHidden
			
			processPreFormDirectives();

			getGlobalVariables();
			
			hiddenStr = processHidden();

			form = processDirective();

			sb.append(getCustomHeader());

			if (errors.length() > 0) {
				sb.append(errors.toString());
				errors =  new StringBuffer();
			}

			if (form != null) {
				sb.append("<FORM method='POST' name='myForm' action='" + HttpUtils.getRequestURL(req) + "'>\n");
				/* language switching section */
				if (triceps != null && !isSplashScreen) {
					Vector languages = triceps.nodes.getLanguages();
					if (languages.size() > 1) {
						sb.append("<TABLE WIDTH='100%' BORDER='0'>\n	<TR><TD ALIGN='center'>");
						for (int i=0;i<languages.size();++i) {
							String language = (String) languages.elementAt(i);
							boolean selected = (i == triceps.getLanguage());
							sb.append(((selected) ? "<U>" : "") +
								"<INPUT TYPE='button' onClick='javascript:setLanguage(\"" + language + "\");' VALUE='" + language + "'>" +
								((selected) ? "</U>" : ""));
						}
						sb.append("	<TD></TR>\n</TABLE>");
					}
				}

				sb.append(hiddenStr);
				sb.append(form);
				sb.append("</FORM>\n");
			}

			if (!isSplashScreen) {
				debugInfo = generateDebugInfo();
				sb.append(debugInfo);
			}
			
			out = res.getWriter();
			out.println(header());
			out.println((new XmlString(sb.toString())).toString());
			out.println(footer());
			out.flush();
			out.close();

			/* Store appropriate stuff in the session */
			if (triceps != null)
				session.putValue("triceps", triceps);

			if ("next".equals(directive)) {
				triceps.toTSV(workingFilesDir);
			}
		}
		catch (Throwable t) {
			System.err.println("Unexpected error: " + t.getMessage());
			t.printStackTrace(System.err);
		}
	}
	
	private void processPreFormDirectives() {
		/* setting language doesn't use directive parameter */
		if (triceps != null) {
			String language = req.getParameter("LANGUAGE");
			if (language != null && language.trim().length() > 0) {
				triceps.setLanguage(language.trim());
				directive = "refresh current";
			}
		}
		
		if (triceps == null)
			return;

			
		/* Want to evaluate expression before doing rest so can see results of changing global variable values */
		if ("evaluate expr:".equals(directive)) {
			String expr = req.getParameter("evaluate expr:");
			if (expr != null && triceps != null) {
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
	}	
	
	private void getGlobalVariables() {
		if (triceps != null) {
			debugMode = triceps.isDebugMode();
			developerMode = triceps.isDeveloperMode();
			showQuestionNum = triceps.isShowQuestionRef();
			showAdminModeIcons = triceps.isShowAdminModeIcons();
			autogenOptionNums = triceps.isAutoGenOptionNum();
			allowComments = triceps.isAllowComments();
		}
		else {
			debugMode = false;
			developerMode = false;
			showQuestionNum = false;
			showAdminModeIcons = false;
			autogenOptionNums = true;
			allowComments = false;
		}
		allowEasyBypass = false;
		okPasswordForTempAdminMode = false;	
		okToShowAdminModeIcons = false;
		isSplashScreen = false;
	}

	private String processHidden() {
		StringBuffer sb = new StringBuffer();

		if (triceps != null) {
			/* Refusals only aply once Triceps has been initialized */
			String settingAdminMode = req.getParameter("PASSWORD_FOR_ADMIN_MODE");
			if (settingAdminMode != null && !settingAdminMode.trim().equals("")) {
				/* if try to enter a password, make sure that doesn't reset the form if password fails */
				String passwd = triceps.getPasswordForAdminMode();
				if (passwd != null) {
					if (passwd.trim().equals(settingAdminMode.trim())) {
						okToShowAdminModeIcons = true;	// so allow AdminModeIcons to be displayed
					}
					else {
						sb.append("Incorrect password to enter Administrative Mode<BR>");
					}
				}
				directive = "refresh current";	// so that will set the admin mode password
			}
			
			if (triceps.isTempPassword(req.getParameter("TEMP_ADMIN_MODE_PASSWORD"))) {
				// enables the password for this session only
				okPasswordForTempAdminMode = true;	// allow AdminModeIcon values to be accepted
			}
		}

		sb.append("<input type='HIDDEN' name='PASSWORD_FOR_ADMIN_MODE' value=''>\n");	// must manually bypass each time
		sb.append("<input type='HIDDEN' name='LANGUAGE' value=''>\n");	// must manually bypass each time


		/** Process requests to change developerMode-type status **/
		if (triceps != null && directive != null) {
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

		return sb.toString();
	}

	private String getCustomHeader() {
		StringBuffer sb = new StringBuffer();

		sb.append("<TABLE BORDER='0' CELLPADDING='0' CELLSPACING='3' WIDTH='100%'>\n");
		sb.append("<TR>\n");
		sb.append("	<TD WIDTH='1%'>\n");

		String logo = (triceps != null && !isSplashScreen) ? triceps.getIcon() : logoIcon;
		if (logo.trim().equals("")) {
			sb.append("&nbsp;");
		}
		else {
			sb.append("			<IMG NAME='icon' SRC='" + Node.encodeHTML(imageFilesDir + logo) + "' ALIGN='top' BORDER='0'" +
				((!isSplashScreen) ? " onMouseDown='javascript:setAdminModePassword();'":"") + " ALT='Logo'>\n");
		}
		sb.append("	</TD>\n");
		sb.append("	<TD ALIGN='left'><FONT SIZE='5'><B>" + Node.encodeHTML((triceps != null && !isSplashScreen) ? triceps.getHeaderMsg() : "Triceps System") + "</B></FONT></TD>\n");
		sb.append("	<TD WIDTH='1%'><IMG SRC='" + HELP_T_ICON + "' ALIGN='top' BORDER='0' ALT='Help' onMouseDown='javascript:help(\"" + Node.encodeHTML(helpURL) + "\");'></TD>\n");
		sb.append("</TR>\n");
		sb.append("</TABLE>\n");
		sb.append("<HR>\n");

		return sb.toString();
	}
	
	private String footer() {
		StringBuffer sb = new StringBuffer();

		sb.append("</body>\n");
		sb.append("</html>\n");
		return sb.toString();
	}
	
	private TreeMap getSortedNames(String dir, boolean isSuspended) {
		TreeMap names = new TreeMap();
		Schedule sched = null;
		Object prevVal = null;
		String defaultTitle = null;
		String title = null;
		
		try {
			ScheduleList interviews = new ScheduleList(dir);
			
			if (interviews.hasErrors()) {
				errors.append("<B>Error getting list of available interviews:<BR>" + interviews.getErrors() + "</B>");
			}
			else {
				Vector schedules = interviews.getSchedules();
				for (int i=0;i<schedules.size();++i) {
					sched = (Schedule) schedules.elementAt(i);
					
					try {
						defaultTitle = getScheduleInfo(sched,isSuspended);
						title = defaultTitle;
						for (int count=2;true;++count) {
							prevVal = names.put(title,sched.getLoadedFrom());
							if (prevVal != null) {
								names.put(title,prevVal);
								title = defaultTitle + " (copy " + count + ")";
							}
							else {
								break;
							}
						}
					}
					catch (Throwable t) {
						errors.append("Unexpected error: " + t.getMessage());
					}
				}
			}
		}
		catch (Throwable t) {
			errors.append("Unexpected error: " + t.getMessage());
		}
		return names;
	}
	
	private String getScheduleInfo(Schedule sched, boolean isSuspended) {
		if (sched == null)
			return null;
			
		StringBuffer sb = new StringBuffer();
		String s = null;
		
		if (isSuspended) {
			sb.append(sched.getReserved(Schedule.TITLE_FOR_PICKLIST_WHEN_IN_PROGRESS));
		}
		else {
			s = sched.getReserved(Schedule.TITLE);
			if (s != null && s.trim().length() > 0) {
				sb.append(s);
			}
			else {
				sb.append("*NO TITLE*");
			}
			s = sched.getReserved(Schedule.LANGUAGES);
			if (s != null && s.trim().length() > 0 && s.indexOf("|") != -1) {
				sb.append(" [" + s + "]");
			}
		}
		
		return sb.toString();
	}	
	
	private String selectFromInterviewsInDir(String selectTarget, String dir, boolean isSuspended) {	
		StringBuffer sb = new StringBuffer();
		
		try {
			TreeMap names = getSortedNames(dir,isSuspended);

			if (names.size() > 0) {
				sb.append("<select name='" + selectTarget + "'>\n");
				Iterator iterator = names.keySet().iterator();
				while(iterator.hasNext()) {
					String title = (String) iterator.next();
					String target = (String) names.get(title);
					sb.append("	<option value='" + Node.encodeHTML(target) + "'>" + Node.encodeHTML(title) + "</option>\n");
				}
				sb.append("</select>\n");
			}
		}
		catch (Throwable t) {
			errors.append("Error building sorted list of interviews: " + t.getMessage());
		}
		
		if (sb.length() == 0)
			return "&nbsp;";
		else
			return sb.toString();
	}

	private String processDirective() {
		boolean ok = true;
		int gotoMsg = Triceps.OK;
		StringBuffer sb = new StringBuffer();
		Enumeration nodes;

		// get the POSTed directive (start, back, next, help, suspend, etc.)	- default is opening screen
		if (directive == null || "select new interview".equals(directive)) {
			/* Construct splash screen */
			isSplashScreen = true;

			sb.append("<TABLE CELLPADDING='2' CELLSPACING='2' BORDER='1'>\n");
			sb.append("<TR><TD>Please select an interview/questionnaire from the pull-down list:  </TD>\n");
			sb.append("	<TD>\n");
			
			/* Build the list of available interviews */
			sb.append(selectFromInterviewsInDir("schedule",scheduleSrcDir,false));

			sb.append("	</TD>\n");
			sb.append("	<TD><input type='SUBMIT' name='directive' value='START'></TD>\n");
			sb.append("</TR>\n");
			
			/* Build the list of suspended interviews */
			sb.append("<TR><TD>OR, restore an interview/questionnaire in progress:  </TD>\n");
			sb.append("	<TD>\n");
			
			sb.append(selectFromInterviewsInDir("RestoreSuspended",workingFilesDir,true));
			
			if (developerMode) {
				sb.append("<input type='text' name='RESTORE'>");
			}
			sb.append("	</TD>\n");
			sb.append("	<TD><input type='SUBMIT' name='directive' value='RESTORE'></TD>\n");
			sb.append("</TABLE>\n");
			
			return sb.toString();
		}
		else if (directive.equals("START")) {
			// load schedule
			triceps = new Triceps(req.getParameter("schedule"));
			ok = triceps.isValid();

			if (!ok) {
				directive = null;
				return processDirective();
			}
			
			// re-check developerMode options - they aren't set via the hidden options, since a new copy of Triceps created
			getGlobalVariables();

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
			triceps = new Triceps(restore);
			ok = triceps.isValid();

			if (!ok) {
				directive = null;	// so that processDirective() will select new interview

				return "<B>Unable to find or access schedule '" + restore + "'</B><HR>" +
					processDirective();
			}
			// re-check developerMode options - they aren't set via the hidden options, since a new copy of Triceps created
			getGlobalVariables();

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
			triceps.resetEvidence();
			ok = ((gotoMsg = triceps.gotoFirst()) == Triceps.OK);	// don't proceed if prior error
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
			ok = triceps.toTSV(workingFilesDir,name);
			if (ok) {
				sb.append("<B>Interview saved successfully as " + Node.encodeHTML(workingFilesDir + name) + "</B><HR>\n");
			}
		}
		else if (directive.equals("show XML")) {
			sb.append("<B>Use 'Show Source' to see data in Schedule as XML</B><BR>\n");
			sb.append("<!--\n" + triceps.toXML() + "\n-->\n");
			sb.append("<HR>\n");
		}
		else if (directive.equals("show Syntax Errors")) {
			Vector pes = triceps.collectParseErrors();

			if (pes.size() == 0) {
				errors.append("<B>No syntax errors were found</B><HR>");
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

					errors.append("\n<TR><TD>" + n.getSourceLine() + "</TD><TD>" + Node.encodeHTML(n.getLocalName(),true) + "</TD>");
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

				status = triceps.storeValue(q, answer, comment, special, (okPasswordForTempAdminMode || showAdminModeIcons));
				ok = status && ok;

			}
			// goto next
			ok = ok && ((gotoMsg = triceps.gotoNext()) == Triceps.OK);	// don't proceed if prior errors - e.g. unanswered questions

			if (gotoMsg == Triceps.AT_END) {
				// save the file, but still give the option to go back and change answers
				boolean savedOK;
				String filename = triceps.getFilename();

				sb.append("<B>Thank you, the interview is completed</B><BR>\n");
				savedOK = triceps.toTSV(completedFilesDir,filename);
				ok = savedOK && ok;
				if (savedOK) {
					sb.append("<B>Interview saved successfully as " + Node.encodeHTML(completedFilesDir + filename) + "</B><HR>\n");
				}

				savedOK = triceps.toTSV(floppyDir,filename);
				ok = savedOK && ok;
				if (savedOK) {
					sb.append("<B>Interview saved successfully as " + Node.encodeHTML(floppyDir + filename) + "</B><HR>\n");
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

		if (debugMode && developerMode) {
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
			
			boolean isSpecial = (datum.exists() && !datum.isType(Datum.STRING) && !datum.isType(Datum.NA));
			allowEasyBypass = allowEasyBypass || isSpecial;	// if a value has already been refused, make it easy to re-refuse it
			
			String clickableOptions = buildClickableOptions(node,inputName,isSpecial);

			switch(node.getAnswerType()) {
				case Node.NOTHING:
					sb.append("		<TD COLSPAN='3'><FONT" + color + ">" + Node.encodeHTML(triceps.getQuestionStr(node)) + "</FONT></TD>\n");
					break;
				case Node.RADIO_HORIZONTAL:
					sb.append("		<TD COLSPAN='3'>\n");
					sb.append("			<input type='HIDDEN' name='" + Node.encodeHTML(inputName + "_COMMENT") + "' value='" + Node.encodeHTML(node.getComment()) + "'>\n");
					sb.append("			<input type='HIDDEN' name='" + Node.encodeHTML(inputName + "_SPECIAL") + "' value='" +
						((isSpecial) ? Node.encodeHTML(triceps.toString(node,true),true) : "") +
						"'>\n");
					sb.append("			<input type='HIDDEN' name='" + Node.encodeHTML(inputName + "_HELP") + "' value='" + Node.encodeHTML(node.getHelpURL()) + "'>\n");
					sb.append("		<FONT" + color + ">" + Node.encodeHTML(triceps.getQuestionStr(node)) + "</FONT></TD>\n");
					sb.append("</TR>\n<TR>\n");
					if (showQuestionNum) {
						sb.append("<TD>&nbsp;</TD>");
					}
					sb.append("	<TD WIDTH='1%' NOWRAP>" + clickableOptions + "</TD>\n");
					sb.append(node.prepareChoicesAsHTML(triceps.parser,triceps.evidence,datum,errMsg,autogenOptionNums));
					break;
				default:
					sb.append("		<TD>\n");
					sb.append("			<input type='HIDDEN' name='" + Node.encodeHTML(inputName + "_COMMENT") + "' value='" + Node.encodeHTML(node.getComment()) + "'>\n");
					sb.append("			<input type='HIDDEN' name='" + Node.encodeHTML(inputName + "_SPECIAL") + "' value='" +
						((isSpecial) ? Node.encodeHTML(triceps.toString(node,true),true) : "") +
						"'>\n");
					sb.append("			<input type='HIDDEN' name='" + Node.encodeHTML(inputName + "_HELP") + "' value='" + Node.encodeHTML(node.getHelpURL()) + "'>\n");
					sb.append("		<FONT" + color + ">" + Node.encodeHTML(triceps.getQuestionStr(node)) + "</FONT></TD>\n");
					sb.append("	<TD WIDTH='1%' NOWRAP>\n" + clickableOptions + "\n</TD>\n");
					sb.append("		<TD>" + node.prepareChoicesAsHTML(triceps.parser,triceps.evidence,datum,autogenOptionNums) + errMsg + "</TD>\n");
					break;
			}

			sb.append("	</TR>\n");
		}
		sb.append("	<TR><TD COLSPAN='" + ((showQuestionNum) ? 4 : 3) + "' ALIGN='center'>\n");
		sb.append("<input type='SUBMIT' name='directive' value='next'>\n");
		sb.append("<input type='SUBMIT' name='directive' value='previous'>");
		
		if (allowEasyBypass || okToShowAdminModeIcons) {
			/* enables TEMP_ADMIN_MODE going forward for one screen */
			sb.append("<input type='HIDDEN' name='TEMP_ADMIN_MODE_PASSWORD' value='" + triceps.createTempPassword() + "'>\n");
		}

		sb.append("	</TD></TR>\n");

		if (developerMode) {
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

	private String buildClickableOptions(Node node, String inputName, boolean isSpecial) {
		StringBuffer sb = new StringBuffer();

		Datum datum = triceps.getDatum(node);
		
		if (datum == null) {
			return "&nbsp;";
		}

		boolean isRefused = false;
		boolean isUnknown = false;
		boolean isNotUnderstood = false;

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
			// don't show help icon if no help is available?
//			sb.append("<IMG SRC='" + HELP_F_ICON + "' ALIGN='top' BORDER='0' ALT='Help not available for this question'>\n");
		}

		String comment = Node.encodeHTML(node.getComment());
		if (showAdminModeIcons || okToShowAdminModeIcons || allowComments) {
			if (comment != null && comment.trim().length() != 0) {
				sb.append("<IMG NAME='" + inputName + "_COMMENT_ICON" + "' SRC='" + COMMENT_T_ICON +
					"' ALIGN='top' BORDER='0' ALT='Add a Comment' onMouseDown='javascript:comment(\"" + inputName + "\");'>\n");
			}
			else  {
				sb.append("<IMG NAME='" + inputName + "_COMMENT_ICON" + "' SRC='" + COMMENT_F_ICON +
					"' ALIGN='top' BORDER='0' ALT='Add a Comment' onMouseDown='javascript:comment(\"" + inputName + "\");'>\n");
			}
		}
		
		/* If something has been set as Refused, Unknown, etc, allow going forward without additional headache */

		if (showAdminModeIcons || okToShowAdminModeIcons || isSpecial) {
			sb.append("<IMG NAME='" + inputName + "_REFUSED_ICON" + "' SRC='" + ((isRefused) ? REFUSED_T_ICON : REFUSED_F_ICON) +
				"' ALIGN='top' BORDER='0' ALT='Set as Refused' onMouseDown='javascript:markAsRefused(\"" + inputName + "\");'>\n");
			sb.append("<IMG NAME='" + inputName + "_UNKNOWN_ICON" + "' SRC='" + ((isUnknown) ? UNKNOWN_T_ICON : UNKNOWN_F_ICON) +
				"' ALIGN='top' BORDER='0' ALT='Set as Unknown' onMouseDown='javascript:markAsUnknown(\"" + inputName + "\");'>\n");
			sb.append("<IMG NAME='" + inputName + "_NOT_UNDERSTOOD_ICON" + "' SRC='" + ((isNotUnderstood) ? NOT_UNDERSTOOD_T_ICON : NOT_UNDERSTOOD_F_ICON) +
				"' ALIGN='top' BORDER='0' ALT='Set as Not Understood' onMouseDown='javascript:markAsNotUnderstood(\"" + inputName + "\");'>\n");
		}
		
		if (sb.length() == 0) {
			return "&nbsp;";
		}
		else {
			return sb.toString();
		}
	}

	private String generateDebugInfo() {
		StringBuffer sb = new StringBuffer();
		// Complete printout of what's been collected per node

		if (developerMode && debugMode) {
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
		if (developerMode) {
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
		sb.append("<title>" + ((triceps == null || isSplashScreen) ? "TRICEPS SYSTEM" : triceps.getTitle()) + "</title>\n");

		sb.append("<SCRIPT  type=\"text/javascript\"> <!--\n");
		sb.append("var actionName = null;\n");
		sb.append("\n");
		sb.append("function init() {\n");

		if (firstFocus != null) {
			sb.append("	document.myForm." + firstFocus + ".focus();\n");
		}

		sb.append("}\n");
		sb.append("function setAdminModePassword(name) {\n");
		sb.append("	var ans = prompt('Enter password to enter Administrative Mode','');\n");
		sb.append("	if (ans == null || ans == '') return;\n");
		sb.append("	document.myForm.PASSWORD_FOR_ADMIN_MODE.value = ans;\n");
		sb.append("	document.myForm.submit();\n");
		sb.append("}\n");
		sb.append("function markAsRefused(name) {\n");
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
		sb.append("function markAsUnknown(name) {\n");
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
		sb.append("function markAsNotUnderstood(name) {\n");
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

		return sb.toString();
	}
}
