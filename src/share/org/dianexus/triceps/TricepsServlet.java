package org.dianexus.triceps;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpUtils;

import java.util.Date;

public class TricepsServlet extends HttpServlet implements VersionIF {
	static final String TRICEPS_ENGINE = "TricepsEngine";
	static final String USER_AGENT = "User-Agent";
	static final String ACCEPT_LANGUAGE = "Accept-Language";
	static final String ACCEPT_CHARSET = "Accept-Charset";
	
	private ServletConfig config = null;
	
	public void init(ServletConfig config) throws ServletException {
		super.init(config);
		this.config = config;
	}

	public void destroy() {
		super.destroy();
	}
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) {
		doPost(req,res);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res)  {
		try {
			HttpSession session = req.getSession(true);
			TricepsEngine tricepsEngine = null;
			
			String sessionID = TRICEPS_ENGINE + "." + session.getId();
			
if (DEBUG && WEB_SERVER) {	
	/* standard Apache log format (after the #@# prefix for easier extraction) */
	Logger.writeln("#@#" + req.getRemoteAddr() + " - [" + new Date(System.currentTimeMillis()) + "] \"" +
		req.getMethod() + " " + req.getRequestURI() + " " + req.getProtocol() + "\" \"" +
		req.getHeader(USER_AGENT) + "\" \"" + req.getHeader(ACCEPT_LANGUAGE) + "\" \"" + req.getHeader(ACCEPT_CHARSET) + "\" " + 
		req.getParameter("DIRECTIVE"));
		
// User-Agent = Mozilla/4.73 [en] (Win98; U)
// Accept-Language = en
// Accept-Charset = iso-8859-1,*,utf-8

// User-Agent = Mozilla/4.0 (compatible; MSIE 5.5; Windows 98)
// Accept-Language = en-us
}
if (DEBUG) {
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

			tricepsEngine = (TricepsEngine) session.getAttribute(sessionID);
			if (tricepsEngine == null) {
				tricepsEngine = new TricepsEngine(config);
			}
			
			tricepsEngine.doPost(req,res);
			
			session.setAttribute(sessionID, tricepsEngine);
		}
		catch (Throwable t) {
if (DEBUG) Logger.writeln("##Throwable @ Servlet.doPost()" + t.getMessage());
if (DEBUG) Logger.printStackTrace(t);
		}
	}
}
