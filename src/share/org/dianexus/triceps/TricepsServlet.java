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
	private Logger errors = new Logger();
	private Logger info = new Logger();	
	
	public static String HELP_T_ICON = null;
	public static String COMMENT_T_ICON = null;
	public static String COMMENT_F_ICON = null;
	public static String REFUSED_T_ICON = null;
	public static String REFUSED_F_ICON = null;
	public static String UNKNOWN_T_ICON = null;
	public static String UNKNOWN_F_ICON = null;
	public static String NOT_UNDERSTOOD_T_ICON = null;
	public static String NOT_UNDERSTOOD_F_ICON = null;

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
	private Lingua lingua = null;
	private Triceps triceps = null;
	private boolean isloaded = getNewTricepsInstance(null);	// this must come last - sets Triceps and Lingua values
	

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

		HELP_T_ICON = imageFilesDir + "help_true.gif";
		COMMENT_T_ICON = imageFilesDir + "comment_true.gif";
		COMMENT_F_ICON = imageFilesDir + "comment_false.gif";
		REFUSED_T_ICON = imageFilesDir + "refused_true.gif";
		REFUSED_F_ICON = imageFilesDir + "refused_false.gif";
		UNKNOWN_T_ICON = imageFilesDir + "unknown_true.gif";
		UNKNOWN_F_ICON = imageFilesDir + "unknown_false.gif";
		NOT_UNDERSTOOD_T_ICON = imageFilesDir + "not_understood_true.gif";
		NOT_UNDERSTOOD_F_ICON = imageFilesDir + "not_understood_false.gif";

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
			XmlString form = null;
			firstFocus = null; // reset it each time

			triceps = (Triceps) session.getValue("triceps");
			if (triceps == null) {
				isloaded = getNewTricepsInstance(null);
			}

			res.setContentType("text/html");
			out = res.getWriter();

			directive = req.getParameter("directive");	// XXX: directive must be set before calling processHidden

			setGlobalVariables();

			processPreFormDirectives();
			processHidden();

			form = new XmlString(lingua, createForm());

			out.println(header());	// must be processed AFTER createForm, otherwise setFocus() doesn't work
			new XmlString(lingua, getCustomHeader(),out);

			if (info.size() > 0) {
				out.println("<B>");
				new XmlString(lingua, info.toString(),out);
				out.println("</B><HR>");
			}			
			if (errors.size() > 0) {
				out.println("<B>");
				new XmlString(lingua, errors.toString(),out);
				out.println("</B><HR>");
			}
			
			if (form.hasErrors() && developerMode) {
				new XmlString(lingua, "<b>" + form.getErrors() + "</b>",out);
			}

			out.println(form.toString());

			if (!isSplashScreen) {
				new XmlString(lingua, generateDebugInfo(),out);
			}

			out.println(footer());	// should not be parsed
			out.flush();
			out.close();

			/* Store appropriate stuff in the session */
			session.putValue("triceps", triceps);

			if (lingua.get("next").equals(directive)) {
				triceps.toTSV(workingFilesDir);
			}
		}
		catch (Throwable t) {
			Logger.writeln(lingua.get("unexpected_error") + t.getMessage());
			Logger.printStackTrace(t);
		}
	}

	private void processPreFormDirectives() {
		/* setting language doesn't use directive parameter */
		if (triceps.isValid()) {
			String language = req.getParameter("LANGUAGE");
			if (language != null && language.trim().length() > 0) {
				triceps.setLanguage(language.trim());
				directive = "refresh current";
			}
		}
		else {
			return;
		}


		/* Want to evaluate expression before doing rest so can see results of changing global variable values */
		if (lingua.get("evaluate_expr").equals(directive)) {
			String expr = req.getParameter(lingua.get("evaluate_expr"));
			if (expr != null) {
				Datum datum = triceps.evaluateExpr(expr);

				errors.print("<TABLE WIDTH='100%' CELLPADDING='2' CELLSPACING='1' BORDER='1'>");
				errors.print("<TR><TD>Equation</TD><TD><B>" + expr + "</B></TD><TD>Type</TD><TD><B>" + datum.getTypeName() + "</B></TD></TR>");
				errors.print("<TR><TD>String</TD><TD><B>" + datum.stringVal(true) +
					"</B></TD><TD>boolean</TD><TD><B>" + datum.booleanVal() +
					"</B></TD></TR>" + "<TR><TD>double</TD><TD><B>" +
					datum.doubleVal() + "</B></TD><TD>&nbsp;</TD><TD>&nbsp;</TD></TR>");
				errors.print("<TR><TD>date</TD><TD><B>" + datum.dateVal() + "</B></TD><TD>month</TD><TD><B>" + datum.monthVal() + "</B></TD></TR>");
				errors.print("</TABLE>");

				errors.print(triceps.getParser().getErrors());
			}
			else {
				errors.println("empty expression");
			}
		}
	}

	private void setGlobalVariables() {
		if (triceps.isValid()) {
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

	private void processHidden() {
		/* Has side-effects - so must occur before createForm() */
		if (!triceps.isValid())
			return;

		String settingAdminMode = req.getParameter("PASSWORD_FOR_ADMIN_MODE");
		if (settingAdminMode != null && !settingAdminMode.trim().equals("")) {
			/* if try to enter a password, make sure that doesn't reset the form if password fails */
			String passwd = triceps.getPasswordForAdminMode();
			if (passwd != null) {
				if (passwd.trim().equals(settingAdminMode.trim())) {
					okToShowAdminModeIcons = true;	// so allow AdminModeIcons to be displayed
				}
				else {
					info.println(lingua.get("incorrect_password_for_admin_mode"));
				}
			}
			directive = "refresh current";	// so that will set the admin mode password
		}

		if (triceps.isTempPassword(req.getParameter("TEMP_ADMIN_MODE_PASSWORD"))) {
			// enables the password for this session only
			okPasswordForTempAdminMode = true;	// allow AdminModeIcon values to be accepted
		}

		/** Process requests to change developerMode-type status **/
		if (directive != null) {
			/* Toggle these values, as requested */
			if (directive.startsWith(lingua.get("turn_developerMode"))) {
				developerMode = !developerMode;
				triceps.getSchedule().setReserved(Schedule.DEVELOPER_MODE, String.valueOf(developerMode));
				directive = "refresh current";
			}
			else if (directive.startsWith(lingua.get("turn_debugMode"))) {
				debugMode = !debugMode;
				triceps.getSchedule().setReserved(Schedule.DEBUG_MODE, String.valueOf(debugMode));
				directive = "refresh current";
			}
			else if (directive.startsWith(lingua.get("turn_showQuestionNum"))) {
				showQuestionNum = !showQuestionNum;
				triceps.getSchedule().setReserved(Schedule.SHOW_QUESTION_REF, String.valueOf(showQuestionNum));
				directive = "refresh current";
			}
		}
	}

	private String getCustomHeader() {
		StringBuffer sb = new StringBuffer();

		sb.append("<TABLE BORDER='0' CELLPADDING='0' CELLSPACING='3' WIDTH='100%'>");
		sb.append("<TR>");
		sb.append("<TD WIDTH='1%'>");

		String logo = (!isSplashScreen && triceps.isValid()) ? triceps.getIcon() : logoIcon;
		if (logo.trim().equals("")) {
			sb.append("&nbsp;");
		}
		else {
			sb.append("<IMG NAME='icon' SRC='" + (imageFilesDir + logo) + "' ALIGN='top' BORDER='0'" +
				((!isSplashScreen) ? " onMouseDown='javascript:setAdminModePassword();'":"") + 
				((!isSplashScreen) ? (" ALT='" + lingua.get("LogoMessage") + "'") : "") +
				">");
		}
		sb.append("	</TD>");
		sb.append("	<TD ALIGN='left'><FONT SIZE='5'><B>" + ((triceps.isValid() && !isSplashScreen) ? triceps.getHeaderMsg() : "Triceps") + "</B></FONT></TD>");
		sb.append("	<TD WIDTH='1%'><IMG SRC='" + HELP_T_ICON + "' ALT='" + lingua.get("Help") + "' ALIGN='top' BORDER='0' onMouseDown='javascript:help(\"" + helpURL + "\");'></TD>");
		sb.append("</TR>");
		sb.append("</TABLE>");
		sb.append("<HR>");

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
			ScheduleList interviews = new ScheduleList(lingua, dir);

			if (interviews.hasErrors()) {
				errors.println(lingua.get("error_getting_list_of_available_interviews"));
				errors.print(interviews.getErrors());
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
								title = defaultTitle + " (# " + count + ")";
							}
							else {
								break;
							}
						}
					}
					catch (Throwable t) {
						errors.println(lingua.get("unexpected_error") + t.getMessage());
						Logger.printStackTrace(t);
					}
				}
			}
		}
		catch (Throwable t) {
			errors.println(lingua.get("unexpected_error") + t.getMessage());
			Logger.printStackTrace(t);
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
				sb.append("NO_TITLE");
			}
			Vector v = sched.getLanguages();
			if (v.size() > 1) {
				sb.append("[");
				for (int i=0;i<v.size();++i) {
					sb.append((String) v.elementAt(i));
					if (i != v.size()-1) {
						sb.append("|");
					}
				}
				sb.append("]");
			}
		}

		return sb.toString();
	}

	private String selectFromInterviewsInDir(String selectTarget, String dir, boolean isSuspended) {
		StringBuffer sb = new StringBuffer();

		try {
			TreeMap names = getSortedNames(dir,isSuspended);

			if (names.size() > 0) {
				sb.append("<select name='" + selectTarget + "'>");
				if (isSuspended) {
					/* add a blank line so don't accidentally resume a file instead of starting one */
					sb.append("<option value=''>&nbsp;</option>");
				}
				Iterator iterator = names.keySet().iterator();
				while(iterator.hasNext()) {
					String title = (String) iterator.next();
					String target = (String) names.get(title);
					sb.append("	<option value='" + target + "'>" + title + "</option>");
				}
				sb.append("</select>");
			}
		}
		catch (Throwable t) {
			errors.println(lingua.get("error_building_sorted_list_of_interviews") + t.getMessage());
			Logger.printStackTrace(t);
		}

		if (sb.length() == 0)
			return "&nbsp;";
		else
			return sb.toString();
	}

	private String createForm() {
		StringBuffer sb = new StringBuffer();
		String formStr = null;

		sb.append("<FORM method='POST' name='myForm' action='" + HttpUtils.getRequestURL(req) + "'>");

		formStr = processDirective();	// since this sets isSplashScreen, which is needed to decide whether to display language buttons

		sb.append(languageButtons());

		sb.append(formStr);

		sb.append("<input type='HIDDEN' name='PASSWORD_FOR_ADMIN_MODE' value=''>");	// must manually bypass each time
		sb.append("<input type='HIDDEN' name='LANGUAGE' value=''>");	// must manually bypass each time

		sb.append("</FORM>");

		return sb.toString();
	}

	private String languageButtons() {
		if (isSplashScreen || !triceps.isValid() || !triceps.isAllowLanguageSwitching())
			return "";

		StringBuffer sb = new StringBuffer();

		/* language switching section */
		if (!isSplashScreen && triceps.isValid()) {
			Vector languages = triceps.getSchedule().getLanguages();
			if (languages.size() > 1) {
				sb.append("<TABLE WIDTH='100%' BORDER='0'><TR><TD ALIGN='center'>");
				for (int i=0;i<languages.size();++i) {
					String language = (String) languages.elementAt(i);
					boolean selected = (i == triceps.getLanguage());
					sb.append(((selected) ? "<U>" : "") +
						"<INPUT TYPE='button' onClick='javascript:setLanguage(\"" + language + "\");' VALUE='" + language + "'>" +
						((selected) ? "</U>" : ""));
				}
				sb.append("</TD></TR></TABLE>");
			}
		}
		return sb.toString();
	}

	private String processDirective() {
		boolean ok = true;
		int gotoMsg = Triceps.OK;
		StringBuffer sb = new StringBuffer();
		Enumeration nodes;

		// get the POSTed directive (start, back, next, help, suspend, etc.)	- default is opening screen
		if (directive == null || lingua.get("select_new_interview").equals(directive)) {
			/* Construct splash screen */
			isSplashScreen = true;
			triceps.setLanguage(null);	// the default

			sb.append("<TABLE CELLPADDING='2' CELLSPACING='2' BORDER='1'>");
			sb.append("<TR><TD>" + lingua.get("please_select_an_interview") + "</TD>");
			sb.append("<TD>");

			/* Build the list of available interviews */
			sb.append(selectFromInterviewsInDir("schedule",scheduleSrcDir,false));

			sb.append("</TD>");
			sb.append("<TD><input type='SUBMIT' name='directive' value='" + lingua.get("START") + "'></TD>");
			sb.append("</TR>");

			/* Build the list of suspended interviews */
			sb.append("<TR><TD>" + lingua.get("or_restore_an_interview_in_progress") + "</TD>");
			sb.append("<TD>");

			sb.append(selectFromInterviewsInDir("RestoreSuspended",workingFilesDir,true));

			sb.append("</TD>");
			sb.append("<TD><input type='SUBMIT' name='directive' value='" + lingua.get("RESTORE") + "'></TD>");
			sb.append("</TR></TABLE>");

			return sb.toString();
		}
		else if (directive.equals(lingua.get("START"))) {
			// load schedule
			ok = getNewTricepsInstance(req.getParameter("schedule"));

			if (!ok) {
				directive = null;
				return processDirective();
			}

			// re-check developerMode options - they aren't set via the hidden options, since a new copy of Triceps created
			setGlobalVariables();

			ok = ok && ((gotoMsg = triceps.gotoStarting()) == Triceps.OK);	// don't proceed if prior error
			// ask question
		}
		else if (directive.equals(lingua.get("RESTORE"))) {
			String restore;

			restore = req.getParameter("RestoreSuspended");
			if (restore == null || restore.trim().equals("")) {
				directive = null;
				return processDirective();
			}


			// load schedule
			ok = getNewTricepsInstance(restore);

			if (!ok) {
				directive = null;

				errors.println(lingua.get("unable_to_find_or_access_schedule") + " '" + restore + "'");
				return processDirective();
			}
			// re-check developerMode options - they aren't set via the hidden options, since a new copy of Triceps created
			setGlobalVariables();

			ok = ok && ((gotoMsg = triceps.gotoStarting()) == Triceps.OK);	// don't proceed if prior error

			// ask question
		}
		else if (directive.equals(lingua.get("jump_to"))) {
			gotoMsg = triceps.gotoNode(req.getParameter(lingua.get("jump_to")));
			ok = (gotoMsg == Triceps.OK);
			// ask this question
		}
		else if (directive.equals("refresh current")) {
			ok = true;
			// re-ask the current question
		}
		else if (directive.equals(lingua.get("restart_clean"))) { // restart from scratch
			triceps.resetEvidence();
			ok = ((gotoMsg = triceps.gotoFirst()) == Triceps.OK);	// don't proceed if prior error
			// ask first question
		}
		else if (directive.equals(lingua.get("reload_questions"))) { // debugging option
			ok = triceps.reloadSchedule();
			if (ok) {
				info.println(lingua.get("schedule_restored_successfully"));
			}
			// re-ask current question
		}
		else if (directive.equals(lingua.get("save_to"))) {
			String name = req.getParameter(lingua.get("save_to"));
			ok = triceps.toTSV(workingFilesDir,name);
			if (ok) {
				info.println(lingua.get("interview_saved_successfully_as") + (workingFilesDir + name));
			}
		}
		else if (directive.equals(lingua.get("show_Syntax_Errors"))) {
			Vector pes = triceps.collectParseErrors();

			if (pes == null || pes.size() == 0) {
				info.println(lingua.get("no_syntax_errors_found"));
			}
			else {
				Vector syntaxErrors = new Vector();

				int numToBeShown = 0;

				for (int i=0;i<pes.size();++i) {
					ParseError pe = (ParseError) pes.elementAt(i);

					/* switch over available diplay options */
				}
				syntaxErrors = pes;
				for (int i=0;i<syntaxErrors.size();++i) {
					ParseError pe = (ParseError) syntaxErrors.elementAt(i);
					Node n = pe.getNode();

					if (i == 0) {
						errors.print("<FONT color='red'>" +
							lingua.get("The_following_syntax_errors_were_found") + (n.getSourceFile()) + "</FONT>");
						errors.print("<TABLE CELLPADDING='2' CELLSPACING='1' WIDTH='100%' border='1'>");
						errors.print("<TR><TD>line#</TD><TD>name</TD><TD>Dependencies</TD><TD><B>Dependency Errors</B></TD><TD>Action Type</TD><TD>Action</TD><TD><B>Action Errors</B></TD><TD><B>Node Errors</B></TD><TD><B>Naming Errors</B></TD><TD><B>AnswerChoices Errors</B></TD><TD><B>Readback Errors</B></TD></TR>");
					}

					errors.print("<TR><TD>" + n.getSourceLine() + "</TD><TD>" + (n.getLocalName()) + "</TD>");
					errors.print("<TD>" + n.getDependencies() + "</TD><TD>");

					errors.print(pe.hasDependenciesErrors() ? pe.getDependenciesErrors() : "&nbsp;");
					errors.print("</TD><TD>" + Node.ACTION_TYPES[n.getQuestionOrEvalType()] + "</TD><TD>" + n.getQuestionOrEval() + "</TD><TD>");

					errors.print(pe.hasQuestionOrEvalErrors() ? pe.getQuestionOrEvalErrors() : "&nbsp;");
					errors.print("</TD><TD>");

					if (!pe.hasNodeParseErrors()) {
						errors.print("&nbsp;");
					}
					else {
						errors.print(pe.getNodeParseErrors());
					}
					errors.print("</TD><TD>");

					if (!pe.hasNodeNamingErrors()) {
						errors.print("&nbsp;");
					}
					else {
						errors.print(pe.getNodeNamingErrors());
					}

					errors.print("<TD>" + ((pe.hasAnswerChoicesErrors()) ? pe.getAnswerChoicesErrors() : "&nbsp;") + "</TD>");
					errors.print("<TD>" + ((pe.hasReadbackErrors()) ? pe.getReadbackErrors() : "&nbsp;") + "</TD>");

					errors.print("</TR>");
				}
				errors.print("</TABLE><HR>");
			}
			if (triceps.getSchedule().hasErrors()) {
				errors.print("<FONT color='red'>" +
					lingua.get("The_following_flow_errors_were_found") + "</FONT>");
				errors.print("<TABLE CELLPADDING='2' CELLSPACING='1' WIDTH='100%' border='1'><TR><TD>");
				errors.print(triceps.getSchedule().getErrors());
				errors.print("</TD></TR></TABLE>");
			}
			if (triceps.getEvidence().hasErrors()) {
				errors.print("<FONT color='red'>" +
					lingua.get("The_following_data_access_errors_were") + "</FONT>");
				errors.print("<TABLE CELLPADDING='2' CELLSPACING='1' WIDTH='100%' border='1'><TR><TD>");
				errors.print(triceps.getEvidence().getErrors());
				errors.print("</TD></TR></TABLE>");
			}
		}
		else if (directive.equals(lingua.get("next"))) {
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

				info.println(lingua.get("the_interview_is_completed"));
				triceps.toTSV(workingFilesDir,filename);
				savedOK = triceps.toTSV(completedFilesDir,filename);
				ok = savedOK && ok;
				if (savedOK) {
					info.println(lingua.get("interview_saved_successfully_as") + (completedFilesDir + filename));
				}

				savedOK = triceps.toTSV(floppyDir,filename);
				ok = savedOK && ok;
				if (savedOK) {
					info.println(lingua.get("interview_saved_successfully_as") + (floppyDir + filename));
				}
			}

			// don't goto next if errors
			// ask question
		}
		else if (directive.equals(lingua.get("previous"))) {
			// don't store current
			// goto previous
			gotoMsg = triceps.gotoPrevious();
			ok = ok && (gotoMsg == Triceps.OK);
			// ask question
		}


		/* Show any accumulated errors */
		errors.print(triceps.getErrors());

		nodes = triceps.getQuestions();
		int errCount = 0;
		while (nodes.hasMoreElements()) {
			Node n = (Node) nodes.nextElement();
			if (n.hasRuntimeErrors()) {
				if (++errCount == 1) {
					info.println(lingua.get("please_answer_the_questions_listed_in") + "<FONT color='red'>" + lingua.get("RED") + "</FONT>" + lingua.get("before_proceeding"));
				}
				if (n.focusableArray()) {
					firstFocus = n.getLocalName() + "[0]";
					break;
				}
				else if (n.focusable()) {
					firstFocus = n.getLocalName();
					break;
				}
			}
		}

		if (firstFocus == null) {
			nodes = triceps.getQuestions();
			while (nodes.hasMoreElements()) {
				Node n = (Node) nodes.nextElement();
				if (n.focusableArray()) {
					firstFocus = n.getLocalName() + "[0]";
					break;
				}
				else if (n.focusable()) {
					firstFocus = n.getLocalName();
					break;
				}
			}
		}
		if (firstFocus == null) {
			firstFocus = "directive[0]";	// try to focus on Next button if nothing else available
		}

		firstFocus = (new XmlString(lingua, firstFocus)).toString();	// make sure properly formatted

		sb.append(queryUser());

		return sb.toString();
	}
	
	private boolean getNewTricepsInstance(String name) {
		triceps = new Triceps(name);
		lingua = triceps.getLingua();
		return triceps.isValid();
	}

	/**
	 * This method assembles the displayed question and answer options
	 * and formats them in HTML for return to the client browser.
	 */
	private String queryUser() {
		// if parser internal to Schedule, should have method access it, not directly
		StringBuffer sb = new StringBuffer();

		if (!triceps.isValid())
			return "";

		if (debugMode && developerMode) {
			sb.append(lingua.get("QUESTION_AREA"));
		}

		Enumeration questionNames = triceps.getQuestions();
		String color;
		String errMsg;

		sb.append("<TABLE CELLPADDING='2' CELLSPACING='1' WIDTH='100%' border='1'>");
		for(int count=0;questionNames.hasMoreElements();++count) {
			Node node = (Node) questionNames.nextElement();
			Datum datum = triceps.getDatum(node);

			if (node.hasRuntimeErrors()) {
				color = " color='red'";
				StringBuffer errStr = new StringBuffer("<FONT color='red'>");
				errStr.append(node.getRuntimeErrors());
				errStr.append("</FONT>");
				errMsg = errStr.toString();
			}
			else {
				color = null;
				errMsg = "";
			}

			sb.append("<TR>");

			if (showQuestionNum) {
				if (color != null) {
					sb.append("<TD><FONT" + color + "><B>" + node.getExternalName() + "</B></FONT></TD>");
				}
				else {
					sb.append("<TD>" + node.getExternalName() + "</TD>");
				}
			}

			String inputName = node.getLocalName();

			boolean isSpecial = (datum.isType(Datum.REFUSED) || datum.isType(Datum.UNKNOWN) || datum.isType(Datum.NOT_UNDERSTOOD));
			allowEasyBypass = allowEasyBypass || isSpecial;	// if a value has already been refused, make it easy to re-refuse it

			String clickableOptions = buildClickableOptions(node,inputName,isSpecial);

			switch(node.getAnswerType()) {
				case Node.NOTHING:
					if (color != null) {
						sb.append("<TD COLSPAN='3'><FONT" + color + ">" + triceps.getQuestionStr(node) + "</FONT></TD>");
					}
					else {
						sb.append("<TD COLSPAN='3'>" + triceps.getQuestionStr(node) + "</TD>");
					}
					break;
				case Node.RADIO_HORIZONTAL:
					sb.append("<TD COLSPAN='3'>");
					sb.append("<input type='HIDDEN' name='" + (inputName + "_COMMENT") + "' value='" + (node.getComment()) + "'>");
					sb.append("<input type='HIDDEN' name='" + (inputName + "_SPECIAL") + "' value='" +
						((isSpecial) ? (triceps.toString(node,true)) : "") +
						"'>");
					sb.append("<input type='HIDDEN' name='" + (inputName + "_HELP") + "' value='" + (node.getHelpURL()) + "'>");
					if (color != null) {
						sb.append("<FONT" + color + ">" + triceps.getQuestionStr(node) + "</FONT>");
					}
					else {
						sb.append(triceps.getQuestionStr(node));
					}
					sb.append("</TD></TR><TR>");
					if (showQuestionNum) {
						sb.append("<TD>&nbsp;</TD>");
					}
					sb.append("<TD WIDTH='1%' NOWRAP>" + clickableOptions + "</TD>");
					sb.append(node.prepareChoicesAsHTML(triceps.getParser(),triceps.getEvidence(),datum,errMsg,autogenOptionNums));
					break;
				default:
					sb.append("<TD>");
					sb.append("<input type='HIDDEN' name='" + (inputName + "_COMMENT") + "' value='" + node.getComment() + "'>");
					sb.append("<input type='HIDDEN' name='" + (inputName + "_SPECIAL") + "' value='" +
						((isSpecial) ? (triceps.toString(node,true)) : "") +
						"'>");
					sb.append("<input type='HIDDEN' name='" + (inputName + "_HELP") + "' value='" + node.getHelpURL() + "'>");
					if (color != null) {
						sb.append("<FONT" + color + ">" + triceps.getQuestionStr(node) + "</FONT>");
					}
					else {
						sb.append(triceps.getQuestionStr(node));
					}
					sb.append("</TD><TD WIDTH='1%' NOWRAP>" + clickableOptions + "</TD>");
					sb.append("<TD>" + node.prepareChoicesAsHTML(triceps.getParser(),triceps.getEvidence(),datum,autogenOptionNums) + errMsg + "</TD>");
					break;
			}

			sb.append("</TR>");
		}
		sb.append("<TR><TD COLSPAN='" + ((showQuestionNum) ? 4 : 3) + "' ALIGN='center'>");
		sb.append("<input type='SUBMIT' name='directive' value='" + lingua.get("next") + "'>");
		sb.append("<input type='SUBMIT' name='directive' value='" + lingua.get("previous") + "'>");

		if (allowEasyBypass || okToShowAdminModeIcons) {
			/* enables TEMP_ADMIN_MODE going forward for one screen */
			sb.append("<input type='HIDDEN' name='TEMP_ADMIN_MODE_PASSWORD' value='" + triceps.createTempPassword() + "'>");
		}

		sb.append("</TD></TR>");

		if (developerMode) {
			sb.append("<TR><TD COLSPAN='" + ((showQuestionNum) ? 4 : 3 ) + "' ALIGN='center'>");
			sb.append("<input type='SUBMIT' name='directive' value='" + lingua.get("select_new_interview") + "'>");
			sb.append("<input type='SUBMIT' name='directive' value='" + lingua.get("restart_clean") + "'>");
			sb.append("<input type='SUBMIT' name='directive' value='" + lingua.get("jump_to") + "' size='10'>");
			sb.append("<input type='text' name='" + lingua.get("jump_to") + "'>");
			sb.append("<input type='SUBMIT' name='directive' value='" + lingua.get("save_to") + "'>");
			sb.append("<input type='text' name='" + lingua.get("save_to") + "'>");
			sb.append("</TD></TR>");
			sb.append("<TR><TD COLSPAN='" + ((showQuestionNum) ? 4 : 3 ) + "' ALIGN='center'>");
			sb.append("<input type='SUBMIT' name='directive' value='" + lingua.get("reload_questions") + "'>");
			sb.append("<input type='SUBMIT' name='directive' value='" + lingua.get("show_Syntax_Errors") + "'>");
			sb.append("<input type='SUBMIT' name='directive' value='" + lingua.get("evaluate_expr") + "'>");
			sb.append("<input type='text' name='" + lingua.get("evaluate_expr") + "'>");
			sb.append("</TD></TR>");
		}

		sb.append(showOptions());

		sb.append("</TABLE>");

		return sb.toString();
	}

	private String buildClickableOptions(Node node, String inputName, boolean isSpecial) {
		StringBuffer sb = new StringBuffer();

		if (!triceps.isValid())
			return "";

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

		String helpURL = node.getHelpURL();
		if (helpURL != null && helpURL.trim().length() != 0) {
			sb.append("<IMG SRC='" + HELP_T_ICON +
				"' ALIGN='top' BORDER='0' ALT='" + lingua.get("Help") + "' onMouseDown='javascript:help(\"" + helpURL + "\");'>");
		}
		else {
			// don't show help icon if no help is available?
		}

		String comment = node.getComment();
		if (showAdminModeIcons || okToShowAdminModeIcons || allowComments) {
			if (comment != null && comment.trim().length() != 0) {
				sb.append("<IMG NAME='" + inputName + "_COMMENT_ICON" + "' SRC='" + COMMENT_T_ICON +
					"' ALIGN='top' BORDER='0' ALT='" + lingua.get("Add_a_Comment") + "' onMouseDown='javascript:comment(\"" + inputName + "\");'>");
			}
			else  {
				sb.append("<IMG NAME='" + inputName + "_COMMENT_ICON" + "' SRC='" + COMMENT_F_ICON +
					"' ALIGN='top' BORDER='0' ALT='" + lingua.get("Add_a_Comment") + "' onMouseDown='javascript:comment(\"" + inputName + "\");'>");
			}
		}

		/* If something has been set as Refused, Unknown, etc, allow going forward without additional headache */

		if (showAdminModeIcons || okToShowAdminModeIcons || isSpecial) {
			sb.append("<IMG NAME='" + inputName + "_REFUSED_ICON" + "' SRC='" + ((isRefused) ? REFUSED_T_ICON : REFUSED_F_ICON) +
				"' ALIGN='top' BORDER='0' ALT='" + lingua.get("Set_as_Refused") + "' onMouseDown='javascript:markAsRefused(\"" + inputName + "\");'>");
			sb.append("<IMG NAME='" + inputName + "_UNKNOWN_ICON" + "' SRC='" + ((isUnknown) ? UNKNOWN_T_ICON : UNKNOWN_F_ICON) +
				"' ALIGN='top' BORDER='0' ALT='" + lingua.get("Set_as_Unknown") + "' onMouseDown='javascript:markAsUnknown(\"" + inputName + "\");'>");
			sb.append("<IMG NAME='" + inputName + "_NOT_UNDERSTOOD_ICON" + "' SRC='" + ((isNotUnderstood) ? NOT_UNDERSTOOD_T_ICON : NOT_UNDERSTOOD_F_ICON) +
				"' ALIGN='top' BORDER='0' ALT='" + lingua.get("Set_as_Not_Understood") + "' onMouseDown='javascript:markAsNotUnderstood(\"" + inputName + "\");'>");
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
		if (!triceps.isValid())
			return "";

		if (developerMode && debugMode) {
			sb.append("<hr>");
			sb.append(lingua.get("CURRENT_QUESTIONS"));
			sb.append("<TABLE CELLPADDING='2' CELLSPACING='1'  WIDTH='100%' BORDER='1'>");
			Enumeration questionNames = triceps.getQuestions();
			Evidence evidence = triceps.getEvidence();

			while(questionNames.hasMoreElements()) {
				Node n = (Node) questionNames.nextElement();
				Datum d = evidence.getDatum(n);
				sb.append("<TR>");
				sb.append("<TD>" + n.getExternalName() + "</TD>");
				if (d.isSpecial()) {
					sb.append("<TD><B><I>" + triceps.toString(n,true) + "</I></B></TD>");
				}
				else {
					sb.append("<TD><B>" + triceps.toString(n,true) + "</B></TD>");
				}
				sb.append("<TD>" + Datum.getTypeName(lingua,n.getDatumType()) + "</TD>");
				sb.append("<TD>" + n.getLocalName() + "</TD>");
				sb.append("<TD>" + n.getConcept() + "</TD>");
				sb.append("<TD>" + n.getDependencies() + "</TD>");
				sb.append("<TD>" + n.getQuestionOrEvalTypeField() + "</TD>");
				sb.append("<TD>" + n.getQuestionOrEval() + "</TD>");
				sb.append("</TR>");
			}
			sb.append("</TABLE>");


			sb.append("<hr>");
			sb.append(lingua.get("EVIDENCE_AREA"));
			sb.append("<TABLE CELLPADDING='2' CELLSPACING='1'  WIDTH='100%' BORDER='1'>");
			for (int i = triceps.size()-1; i >= 0; i--) {
				Node n = triceps.getNode(i);
				Datum d = triceps.getDatum(n);
				if (!triceps.isSet(n))
					continue;
				sb.append("<TR>");
				sb.append("<TD>" + (i + 1) + "</TD>");
				sb.append("<TD>" + n.getExternalName() + "</TD>");
				if (d.isSpecial()) {
					sb.append("<TD><B><I>" + triceps.toString(n,true) + "</I></B></TD>");
				}
				else {
					sb.append("<TD><B>" + triceps.toString(n,true) + "</B></TD>");
				}
				sb.append("<TD>" +  Datum.getTypeName(lingua,n.getDatumType()) + "</TD>");
				sb.append("<TD>" + n.getLocalName() + "</TD>");
				sb.append("<TD>" + n.getConcept() + "</TD>");
				sb.append("<TD>" + n.getDependencies() + "</TD>");
				sb.append("<TD>" + n.getQuestionOrEvalTypeField() + "</TD>");
				sb.append("<TD>" + n.getQuestionOrEval(triceps.getLanguage()) + "</TD>");
				sb.append("</TR>");
			}
			sb.append("</TABLE>");
		}
		return sb.toString();
	}

	private String showOptions() {
		if (developerMode) {
			StringBuffer sb = new StringBuffer();

			sb.append("<TR><TD COLSPAN='" + ((showQuestionNum) ? 4 : 3 ) + "' ALIGN='center'>");
			sb.append("<input type='SUBMIT' name='directive' value='" + lingua.get("turn_developerMode") + ((developerMode) ? lingua.get("OFF") : lingua.get("ON")) + "'>");
			sb.append("<input type='SUBMIT' name='directive' value='" + lingua.get("turn_debugMode") + ((debugMode) ? lingua.get("OFF") : lingua.get("ON") )+ "'>");
			sb.append("<input type='SUBMIT' name='directive' value='" + lingua.get("turn_showQuestionNum") + ((showQuestionNum) ? lingua.get("OFF") : lingua.get("ON")) + "'>");
			sb.append("</TD></TR>");
			return sb.toString();
		}
		else
			return "";
	}

	private String createJavaScript() {
		StringBuffer sb = new StringBuffer();
		sb.append("<SCRIPT  type=\"text/javascript\"> <!--\n");
		sb.append("var actionName = null;\n");
		sb.append("\n");
		sb.append("function init() {\n");
		sb.append("window.top.focus();\n");

		if (firstFocus != null) {
			sb.append("	document.myForm." + firstFocus + ".focus();\n");
		}

		sb.append("}\n");
		sb.append("function setAdminModePassword(name) {\n");
		sb.append("	var ans = prompt('" +
			lingua.get("Enter_password_for_Administrative_Mode") +
				"','');\n");
		sb.append("	if (ans == null || ans == '') return;\n");
		sb.append("	document.myForm.PASSWORD_FOR_ADMIN_MODE.value = ans;\n");
		sb.append("	document.myForm.submit();\n\n");
		sb.append("}\n");
		sb.append("function markAsRefused(name) {\n");
		sb.append("	if (!name) name = actionName;\n");
		sb.append("	if (!name) return;\n");
		sb.append("	var val = document.myForm.elements[name + '_SPECIAL'];\n");
		sb.append("	if (val.value == '" + Datum.getSpecialName(Datum.REFUSED) + "') {\n");
		sb.append("		val.value = '';\n");
		sb.append("		document.myForm.elements[name + '_REFUSED_ICON'].src = '" + REFUSED_F_ICON + "';\n");
		sb.append("	} else {\n");
		sb.append("		val.value = '" + Datum.getSpecialName(Datum.REFUSED) + "';\n");
		sb.append("		document.myForm.elements[name + '_REFUSED_ICON'].src = '" + REFUSED_T_ICON + "';\n");
		sb.append("		document.myForm.elements[name + '_UNKNOWN_ICON'].src = '" + UNKNOWN_F_ICON + "';\n");
		sb.append("		document.myForm.elements[name + '_NOT_UNDERSTOOD_ICON'].src = '" + NOT_UNDERSTOOD_F_ICON + "';\n");
		sb.append("	}\n}\n");
		sb.append("function markAsUnknown(name) {\n");
		sb.append("	if (!name) name = actionName;\n");
		sb.append("	if (!name) return;\n");
		sb.append("	var val = document.myForm.elements[name + '_SPECIAL'];\n");
		sb.append("	if (val.value == '" + Datum.getSpecialName(Datum.UNKNOWN) + "') {\n");
		sb.append("		val.value = '';\n");
		sb.append("		document.myForm.elements[name + '_UNKNOWN_ICON'].src = '" + UNKNOWN_F_ICON + "';\n");
		sb.append("	} else {\n");
		sb.append("		val.value = '" + Datum.getSpecialName(Datum.UNKNOWN) + "';\n");
		sb.append("		document.myForm.elements[name + '_REFUSED_ICON'].src = '" + REFUSED_F_ICON + "';\n");
		sb.append("		document.myForm.elements[name + '_UNKNOWN_ICON'].src = '" + UNKNOWN_T_ICON + "';\n");
		sb.append("		document.myForm.elements[name + '_NOT_UNDERSTOOD_ICON'].src = '" + NOT_UNDERSTOOD_F_ICON + "';\n");
		sb.append("	}\n}\n");
		sb.append("function markAsNotUnderstood(name) {\n");
		sb.append("	if (!name) name = actionName;\n");
		sb.append("	if (!name) return;\n");
		sb.append("	var val = document.myForm.elements[name + '_SPECIAL'];\n");
		sb.append("	if (val.value == '" + Datum.getSpecialName(Datum.NOT_UNDERSTOOD) + "') {\n");
		sb.append("		val.value = '';\n");
		sb.append("		document.myForm.elements[name + '_NOT_UNDERSTOOD_ICON'].src = '" + NOT_UNDERSTOOD_F_ICON + "';\n");
		sb.append("	} else {\n");
		sb.append("		val.value = '" + Datum.getSpecialName(Datum.NOT_UNDERSTOOD) + "';\n");
		sb.append("		document.myForm.elements[name + '_REFUSED_ICON'].src = '" + REFUSED_F_ICON + "';\n");
		sb.append("		document.myForm.elements[name + '_UNKNOWN_ICON'].src = '" + UNKNOWN_F_ICON + "';\n");
		sb.append("		document.myForm.elements[name + '_NOT_UNDERSTOOD_ICON'].src = '" + NOT_UNDERSTOOD_T_ICON + "';\n");
		sb.append("	}\n}\n");
		sb.append("function help(target) {\n");
		sb.append("	if (target != null && target.length != 0) { window.open(target,'__HELP__'); }\n");
		sb.append("}\n");
		sb.append("function comment(name) {\n");
		sb.append("	if (!name) name = actionName;\n");
		sb.append("	if (!name) return;\n");
		sb.append("	var ans = prompt('" +
			lingua.get("Enter_a_comment_for_this_question") +
				"',document.myForm.elements[name + '_COMMENT'].value);\n");
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

		return sb.toString();
	}

	private String header() {
		StringBuffer sb = new StringBuffer();
		String title = null;

		if (isSplashScreen || !triceps.isValid()) {
			title = "Triceps";
		}
		else {
			title = triceps.getTitle();
		}

		sb.append("<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">\n");
		sb.append("<html>\n");
		sb.append("<head>\n");
		sb.append("<META HTTP-EQUIV='Content-Type' CONTENT='text/html;CHARSET=iso-8859-1'>\n");
		sb.append("<title>" + title + "</title>\n");

		sb.append(createJavaScript());

		sb.append("</head>\n");
		sb.append("<body bgcolor='white' onload='javascript:init();'>");

		return sb.toString();
	}
}
