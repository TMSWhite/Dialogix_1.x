package org.dianexus.triceps;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpUtils;

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

			tricepsEngine = (TricepsEngine) session.getValue(TRICEPS_ENGINE);
			if (tricepsEngine == null) {
				tricepsEngine = new TricepsEngine(config);
			}
			
			tricepsEngine.doPost(req,res);
			
			session.putValue(TRICEPS_ENGINE, tricepsEngine);
		}
		catch (Throwable t) {
if (DEBUG) Logger.writeln("##Throwable @ Servlet.doPost()" + t.getMessage());
			Logger.writeln("##unexpected_error" + t.getMessage());
			Logger.printStackTrace(t);
		}
	}
}
