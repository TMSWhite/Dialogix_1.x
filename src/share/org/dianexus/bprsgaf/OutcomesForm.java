package org.dianexus.bprsgaf;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.*;
import java.text.*;

public class OutcomesForm
{
	public static final String BGCOLOR = " BGCOLOR=\"#FFFF66\"";
	private HttpServletRequest req = null;
	private HttpServletResponse resp = null;
	private PrintWriter out = null;
	private Vector questions = null;
	private Vector scales = null;
	private StringBuffer answers = null;

	private String title;
	private String facility;
	private String ptWard;
	private String dateCompleted;
	private String ptSex;
	private String ptCaseID;
	private String ptStateID;
	private String ptFirst;
	private String ptLast;
	private String ptMiddle;
	private String ptDOB;
	private String raterFirst;
	private String raterLast;
	private String raterTitle;
	private String raterOrionID;

	private static final SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy.MM.dd..hh.mm.ss");



	public OutcomesForm(String title, Vector questions, Vector scales, HttpServletRequest req, HttpServletResponse resp) {
		this.req = req;
		this.title = title;
		this.questions = questions;
		this.scales = scales;
		this.req = req;
		this.resp = resp;
		resetAnswers();
		resp.setContentType("text/html");
		try {
			out = new PrintWriter(resp.getOutputStream());
		}
		catch (IOException e)
		{
			System.out.println(e.getMessage());
			e.printStackTrace();
		}
	}

	public void process(String outFile, String extraMsg, String extraToOutFile) {
		parseHeader();
		printHeader();
		out.println("<TABLE BORDER=\"1\" CELLPADDING=\"0\" CELLSPACING=\"0\" WIDTH=\"100%\">");
		printBody();
		printScales();
		out.println(extraMsg);
		out.println("</TABLE>");
		out.println("<HR>" + storeAnswers(outFile, extraToOutFile));
		printFooter();
		out.close();
		resetScales();
	}

	public void parseHeader() {
		facility = getString("facility");
		ptWard = getString("ptWard");
		dateCompleted = getDate("dateCompleted");
		ptSex = getString("ptSex");
		ptCaseID = getString("ptCaseID");
		ptStateID = getString("ptStateID");
		ptFirst = getString("ptFirst");
		ptLast = getString("ptLast");
		ptMiddle = getString("ptMiddle");
		ptDOB = getDate("ptDOB");
		raterFirst = getString("raterFirst");
		raterLast = getString("raterLast");
		raterTitle = getString("raterTitle");
		raterOrionID = getString("raterOrionID");
	}

	public void printHeader() {
	   out.println("<HTML>");
		out.println("<HEAD><TITLE>" + title + " Output</TITLE></HEAD>");
		out.println("<BODY>");

		out.println("<TABLE BORDER=\"1\" CELLPADDING=\"0\" CELLSPACING=\"0\" WIDTH=\"100%\">");
		out.println("	<TR>");
		out.println("		<TD ROWSPAN=\"2\" COLSPAN=\"2\"" + BGCOLOR + ">");
		out.println("			<P ALIGN=\"CENTER\"><B><FONT SIZE=\"4\" FACE=\"Arial, Helvetica\">" + title + "</FONT></B>");
		out.println("		</TD>");
		out.println("		<TD><B><FONT FACE=\"Arial, Helvetica\">Location</FONT></B></TD>");
		out.println("		<TD><FONT FACE=\"Arial, Helvetica\">Facility</FONT></TD>");
		out.println("		<TD><FONT FACE=\"Arial, Helvetica\"><B>" + facility + "</B></FONT></TD>");
		out.println("		<TD><FONT FACE=\"Arial, Helvetica\">Unit/Ward#</FONT></TD>");
		out.println("		<TD><FONT FACE=\"Arial, Helvetica\"><B>" + ptWard + "</B></FONT></TD>");
		out.println("		<TD><FONT FACE=\"Arial, Helvetica\">Date Completed</FONT></TD>");
		out.println("		<TD><FONT FACE=\"Arial, Helvetica\"><B>" + dateCompleted + "</B></FONT></TD>");
		out.println("	</TR>");
		out.println("	<TR>");
		out.println("		<TD><B><FONT FACE=\"Arial, Helvetica\">Patient Info</FONT></B></TD>");
		out.println("		<TD><FONT FACE=\"Arial, Helvetica\">Sex</FONT></TD>");
		out.println("		<TD><FONT FACE=\"Arial, Helvetica\"><B>" + ptSex + "</B></FONT></TD>");
		out.println("		<TD><FONT FACE=\"Arial, Helvetica\">C#</FONT></TD>");
		out.println("		<TD><FONT FACE=\"Arial, Helvetica\"><B>" + ptCaseID + "</B></FONT></TD>");
		out.println("		<TD><FONT FACE=\"Arial, Helvetica\">State ID#</FONT></TD>");
		out.println("		<TD><FONT FACE=\"Arial, Helvetica\"><B>" + ptStateID + "</B></FONT></TD>");
		out.println("	</TR>");
		out.println("	<TR>");
		out.println("		<TD><B><FONT FACE=\"Arial, Helvetica\">Patient Info</FONT></B></TD>");
		out.println("		<TD><FONT FACE=\"Arial, Helvetica\">First</FONT></TD>");
		out.println("		<TD><FONT FACE=\"Arial, Helvetica\"><B>" + ptFirst + "</B></FONT></TD>");
		out.println("		<TD><FONT FACE=\"Arial, Helvetica\">Last</FONT></TD>");
		out.println("		<TD><FONT FACE=\"Arial, Helvetica\"><B>" + ptLast + "</B></FONT></TD>");
		out.println("		<TD><FONT FACE=\"Arial, Helvetica\">Middle</FONT></TD>");
		out.println("		<TD><FONT FACE=\"Arial, Helvetica\"><B>" + ptMiddle + "</B></FONT></TD>");
		out.println("		<TD><FONT FACE=\"Arial, Helvetica\">DOB</FONT></TD>");
		out.println("		<TD><FONT FACE=\"Arial, Helvetica\"><B>" + ptDOB + "</B></FONT></TD>");
		out.println("	</TR>");
		out.println("	<TR>");
		out.println("		<TD><B><FONT FACE=\"Arial, Helvetica\">Clinician Info</FONT></B></TD>");
		out.println("		<TD><FONT FACE=\"Arial, Helvetica\">First</FONT></TD>");
		out.println("		<TD><FONT FACE=\"Arial, Helvetica\"><B>" + raterFirst + "</B></FONT></TD>");
		out.println("		<TD><FONT FACE=\"Arial, Helvetica\">Last</FONT></TD>");
		out.println("		<TD><FONT FACE=\"Arial, Helvetica\"><B>" + raterLast + "</B></FONT></TD>");
		out.println("		<TD><FONT FACE=\"Arial, Helvetica\">Title</FONT></TD>");
		out.println("		<TD><FONT FACE=\"Arial, Helvetica\"><B>" + raterTitle + "</B></FONT></TD>");
		out.println("		<TD><FONT FACE=\"Arial, Helvetica\">Orion ID</FONT></TD>");
		out.println("		<TD><FONT FACE=\"Arial, Helvetica\"><B>" + raterOrionID + "</B></FONT></TD>");
		out.println("	</TR>");
		out.println("</TABLE>");
	}

	public void printBody() {
	    // print the outcomes questions
	    Enumeration enum = questions.elements();
	    while (enum.hasMoreElements()) {
	        OutcomesQuestion oq = (OutcomesQuestion) enum.nextElement();
	        oq.setValue(getString(oq.getFormIndex()));  // sets oq's value for form

	        out.println("<TR>" + oq.getPrefix());
	        out.println("<TD" + BGCOLOR + " WIDTH=\"20%\">" + oq.getName() + "</TD>");
	        out.println("<TD>" + oq.getAnchor() + "</TD></TR>");
	    }
	}

	public void printScales() {
		// to do: code goes here.
		Enumeration enum = scales.elements();
		while (enum.hasMoreElements()) {
		    Scale scale = (Scale) enum.nextElement();

		    out.print("<TR><TD COLSPAN=\"2\"" + BGCOLOR + ">");
		    out.print("<P ALIGN=\"CENTER\"><FONT FACE=\"Arial\">");
		    out.print("<B>" + scale.getName() + "</B>");
		    out.println("</FONT></P></TD>");
		    out.print("<TD" + BGCOLOR + "><P ALIGN=\"CENTER\"><FONT FACE=\"Arial\">");
		    out.print(scale.getScore() + " / " + scale.getMax() + " = <B>" + scale.getPercent() + "</B>");
		    out.println("</FONT></P></TD></TR>");
		}
	}

	public void resetScales() {
		Enumeration enum = scales.elements();
		while (enum.hasMoreElements()) {
		    ((Scale) enum.nextElement()).reset();
		}
	}

	public String storeAnswers(String filename, String extra) {
		StringBuffer answers = new StringBuffer();

	    Enumeration enum = scales.elements();
	    while (enum.hasMoreElements()) {
	        Scale sc = (Scale) enum.nextElement();
	        answers.append("|" + sc.getScore() + "|" + sc.getMax() + "|" + sc.getPercent());
	    }
	    answers.append("|" + extra);

	    return writeAnswersToFile(filename);
	}

	private synchronized String writeAnswersToFile(String filename) {
	    BufferedWriter bfile = null;
	    boolean deletedLockFile=false;
		final String lockMessage = "Someone else is currently saving data (there is a lock on the data file).<BR>\n";
		final String retryMessage = "You can try again by pressing the Back button on your browser and re-submittng the form.<BR>\n";
		final String unlockMessage = "If you have repeated problems saving the data, contact your system administrator to remove the lock file<BR>\n";
		File file = new File(filename);

		if (file == null || !file.exists() || !file.isFile() || !file.canWrite()) {
			return "Data not saved:  unable to access data file '" + file + "'<BR>" + retryMessage;
		}

		File lockfile = new File(filename + ".lock");
		if (lockfile.exists()) {
			return lockMessage + retryMessage + unlockMessage;
		}
		else {
			/* create lock file */
			try {
				bfile = new BufferedWriter(new FileWriter(lockfile));
				bfile.write("locked");
			}
			catch (IOException e) {
				return "Error creating lock file: " + e.getMessage();
			}
			finally {
				if (bfile != null) try { bfile.close(); } catch (Exception e) { }
			}

			/* write data */
			try {
				bfile = new BufferedWriter(new FileWriter(filename,true));	// append
				bfile.write(answers.toString());
				bfile.newLine();
				bfile.flush();
			}
			catch (IOException e) {
				return "Data not saved:  error writing to file '" + file + "': " + e.getMessage() + "<BR>\n" + retryMessage;
			}
			finally {
				if (bfile != null) try { bfile.close(); } catch (Exception e) { }
			}
			/* remove lock file */

			try {
				deletedLockFile = lockfile.delete();
			}
			catch (SecurityException e) {}
			finally {
				if (!deletedLockFile) {
					return "Unable to delete lock file <B>" + filename + ".lock</B><BR>" +
					"This will prevent you or anyone else from saving data until the lock file is removed.<BR>" +
					"Please contact your system administrator immediately so that they can manually remove this lock file.<BR>";
				}
			}
		}
		return "Successfully saved data";
	}


	public void printFooter() {
  	    out.println("</BODY>");
		out.println("</HTML>");
    }

	public String getString(String name)
	{
		String temp = req.getParameter(name).trim();
		if (temp == null || temp.length() == 0) {
			answers.append("|");
			return "&nbsp;";
		}
		else {
			answers.append("|" + temp);
			return temp;
		}
	}

	public int getInt(String name) {
		String temp = req.getParameter(name).trim();
		if (temp == null || temp.length() == 0) {
			answers.append("|");
			return 0;
		}
		else {
			answers.append("|" + temp);
			return Integer.parseInt(temp);
		}
	}


	public String getDate(String name)
	{
		String temp = req.getParameter(name).trim();
		try {
		    DateFormat df = DateFormat.getDateInstance(DateFormat.SHORT);
		    temp = df.format(df.parse(temp));
		    answers.append("|" + temp);
		    return temp;
		}
		catch (Exception e) {
			answers.append("|");
			return "<B>Invalid Date</B>";
		}
	}

	public void print(String name)
	{
		out.print(name);
	}

	public void println(String name)
	{
		out.println(name);
	}

	public void close() {
		out.close();
	}

	public void resetAnswers() {
		answers = new StringBuffer(dateTimeFormat.format(new Date()) + "|" + req.getRemoteUser() + "|" + req.getRemoteAddr());
	}
}

