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
			
if (WEB_SERVER && DEBUG) {
	/* standard Apache log format (after the #@# prefix for easier extraction) */
	Logger.writeln("#@#" + req.getRemoteAddr() + " - " + req.getRemoteHost() + " - [" + new Date(System.currentTimeMillis()) + "] \"" +
		req.getMethod() + " " + req.getRequestURI() + " " + req.getProtocol() + "\" " + req.getParameter("DIRECTIVE"));
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
