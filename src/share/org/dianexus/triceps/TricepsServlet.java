/* ******************************************************** 
** Copyright (c) 2000-2001, Thomas Maxwell White, all rights reserved. 
** $Header$
******************************************************** */ 

package org.dianexus.triceps;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpUtils;

import java.io.PrintWriter;
import java.util.Date;

public class TricepsServlet extends HttpServlet implements VersionIF {
	static final String TRICEPS_ENGINE = "TricepsEngine";
	static final String USER_AGENT = "User-Agent";
	static final String ACCEPT_LANGUAGE = "Accept-Language";
	static final String ACCEPT_CHARSET = "Accept-Charset";
	
	ServletConfig config = null;
	TricepsEngine tricepsEngine = null;
	String sessionID = null;

	
	public void init(ServletConfig config) throws ServletException {
		super.init(config);
		this.config = config;
		Logger.init(config.getInitParameter("dialogix.dir"));
	}

	public void destroy() {
		super.destroy();
	}
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) {
		doPost(req,res);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res)  {
		tricepsEngine = null;	// reset it in case of error page
		try {
			if (isSupportedBrowser(req)) {
				okPage(req,res);
			}
			else {
				errorPage(req,res);
			}
		}
		catch (Throwable t) {
if (DEBUG) Logger.writeln("##Throwable @ Servlet.doPost()" + t.getMessage());
if (DEBUG) Logger.printStackTrace(t);
			errorPage(req,res);
		}
	}
	
	boolean isSupportedBrowser(HttpServletRequest req) {
		String userAgent = req.getHeader(USER_AGENT);
		
		if (userAgent == null) {
			return false;
		}
		
		if ((userAgent.indexOf("Mozilla/4") != -1)) {
			if (userAgent.indexOf("MSIE") != -1) {
				return true;	// IE masquerading as Netscape - finally fixed so that works OK
			}
			else if (userAgent.indexOf("Opera") != -1) {
				return true;	// false;	// Opera masquerading as Netscape - problem with the event model
			}
			else {
				return true;	// true for Netscape 4.x
			}
		}
		else if (userAgent.indexOf("Netscape6") != -1) {
			return true;	// false;	// does not work with Netscape6 - lousy layout, repeat calls to GET (not POST), so re-starts on each screen.  Why?
		}
		else if (userAgent.indexOf("Opera") != -1) {
			return true;	// false;	// Opera - problem with the event model
		}
		else {
			return true;	// false;
		}
	}

	private void okPage(HttpServletRequest req, HttpServletResponse res) {
		HttpSession session = req.getSession();
		
		if ((session == null || session.isNew()) && "POST".equals(req.getMethod())) {
			shutdown(req,"post-expired session",false);
			expiredSessionErrorPage(req,res);
			return;
		}
		
		sessionID = session.getId();
		
		tricepsEngine = (TricepsEngine) session.getAttribute(TRICEPS_ENGINE);
		if (tricepsEngine == null) {
			tricepsEngine = new TricepsEngine(config);
		}
		
		logAccess(req, " OK");
		
		try {
			res.setContentType("text/html");
			PrintWriter out = res.getWriter();
			
			tricepsEngine.doPost(req,res,out,null,null);
						
			out.close();
			out.flush();
			
			session.setAttribute(TRICEPS_ENGINE, tricepsEngine);
			
			/* disable session if completed */
			if (tricepsEngine.isFinished()) {
				logAccess(req, " FINISHED");
				shutdown(req,"post-FINISHED",false);	// if don't remove the session, can't login as someone new
			}			
		}
		catch (Throwable t) {
if (DEBUG) Logger.printStackTrace(t);
		}			
	}
	
	void logAccess(HttpServletRequest req, String msg) {
if (DEBUG) {	
	/* standard Apache log format (after the #@# prefix for easier extraction) */
	Logger.writeln("#@#(" + req.getParameter("DIRECTIVE") + ") [" + new Date(System.currentTimeMillis()) + "] " + 
		sessionID + 
		((WEB_SERVER) ? (" " + req.getRemoteAddr() + " \"" +
		req.getHeader(USER_AGENT) + "\" \"" + req.getHeader(ACCEPT_LANGUAGE) + "\" \"" + req.getHeader(ACCEPT_CHARSET) + "\"") : "") +
		((tricepsEngine != null) ? tricepsEngine.getScheduleStatus() : "") + msg + " " + (req.isSecure() ? "HTTPS" : "HTTP"));
		
// User-Agent = Mozilla/4.73 [en] (Win98; U)
// Accept-Language = en
// Accept-Charset = iso-8859-1,*,utf-8

// User-Agent = Mozilla/4.0 (compatible; MSIE 5.5; Windows 98)
// Accept-Language = en-us
// User-Agent = Mozilla/5.0 (Windows; U; Win98; en-US; m18) Gecko/20001108 Netscape6/6.0
}
if (DEBUG && false) {
	/* catch all sent parameters */
	Logger.writeln("##########");
	java.util.Enumeration params = req.getParameterNames();
	
	while(params.hasMoreElements()) {
		String param = (String) params.nextElement();
		String vals[] = req.getParameterValues(param);
		for (int i=0;i<vals.length;++i) {
			Logger.writeln(param + "=" + vals[i]);
		}
	}
	Logger.writeln("##########");
}
	}
	

	void errorPage(HttpServletRequest req, HttpServletResponse res) {
		logAccess(req, " UNSUPPORTED BROWSER");
		try {
			res.setContentType("text/html");
			PrintWriter out = res.getWriter();
			
			out.println("<!DOCTYPE html PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>");
			out.println("<html>");
			out.println("<head>");
			out.println("<META HTTP-EQUIV='Content-Type' CONTENT='text/html;CHARSET=iso-8859-1'>");
			out.println("<title>Triceps Error-Unsupported Browser</title>");
			out.println("</head>");
			out.println("<body bgcolor='white'>");
			out.println("   <table border='0' cellpadding='0' cellspacing='3' width='100%'>");
			out.println("      <tr>");
			out.println("         <td width='1%'><img name='icon' src='/images/trilogo.jpg' align='top' border='0' alt='Logo' /> </td>");
			out.println("         <td align='left'><font SIZE='4'>Sorry for the inconvenience, but Triceps currently only works with Netscape 4.xx. and Internet Explorer 5.x<br />Please email <a href='mailto:tw176@columbia.edu'>me</a> to be notified when other browsers are supported.<br />In the meantime, Netscape 4.75 can be downloaded <a href='http://home.netscape.com/download/archive/client_archive47x.html'>here</a></font></td>");
			out.println("      </tr>");
			out.println("   </table>");
			out.println("</body>");
			out.println("</html>");
	
			out.flush();
			out.close();
		}
		catch (Throwable t) {
if (DEBUG) Logger.printStackTrace(t);
		}		
	}
	
	void expiredSessionErrorPage(HttpServletRequest req, HttpServletResponse res) {
		logAccess(req, " EXPIRED SESSION");
		try {
			res.setContentType("text/html");
			PrintWriter out = res.getWriter();
			
			out.println("<!DOCTYPE html PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>");
			out.println("<html>");
			out.println("<head>");
			out.println("<META HTTP-EQUIV='Content-Type' CONTENT='text/html;CHARSET=iso-8859-1'>");
			out.println("<title>Triceps Error-Expired Session</title>");
			out.println("</head>");
			out.println("<body bgcolor='white'>");
			out.println("   <table border='0' cellpadding='0' cellspacing='3' width='100%'>");
			out.println("      <tr>");
			out.println("         <td width='1%'><img name='icon' src='/images/dialogo.jpg' align='top' border='0' alt='Logo' /> </td>");
			out.println("         <td align='left'><font SIZE='4'>Sorry for the inconvenience, but web session you were using is no longer valid.  Either you finished an instrument, the session ran out of time, or the server was restarted.");
			if (!WEB_SERVER) {
				out.print("  You can resume the instrument from where you left off by clicking <a href=\"JavaScript:void;\"");
				out.print(" onclick=\"JavaScript:window.top.open('");
				out.print(res.encodeURL(HttpUtils.getRequestURL(req).toString()));
				out.print("','_blank','resizable=yes,scrollbars=yes');JavaScript:top.close();\">here</a>");
				out.print(" and selecting it from the RESTORE list.");
			}
			out.println("</font></td>");
			out.println("      </tr>");
			out.println("   </table>");
			out.println("</body>");
			out.println("</html>");
	
			out.flush();
			out.close();
		}
		catch (Throwable t) {
if (DEBUG) Logger.printStackTrace(t);
		}		
	}
	
	void shutdown(HttpServletRequest req, String msg, boolean createNewSession) {
		/* want to invalidate sessions -- even though this confuses the log issue on who is accessing from where, multiple sessions can indicate problems with user interface */
		
		Logger.writeln("...discarding session: " + sessionID + ":  " + msg);
		
		if (tricepsEngine != null) {
			tricepsEngine.getTriceps().shutdown();
		}
		tricepsEngine = null;
		
		try {
			HttpSession session = req.getSession();
			if (session != null) {
				session.invalidate();	// so that retrying same session gives same message
			}
			
			sessionID = null;
			
			if (createNewSession) {
				/* Finally, create a new session so that session so that it is available, and so that session time-outs can be detected */
				/* this cannot be done after the page is sent? */
				session = req.getSession(true);	// the only place to create new sessions
				session.setMaxInactiveInterval(SESSION_TIMEOUT);	// so expires after 12 hours
			}
		}
		catch (java.lang.IllegalStateException e) {
			Logger.writeln(e.getMessage());
		}
	}
}
